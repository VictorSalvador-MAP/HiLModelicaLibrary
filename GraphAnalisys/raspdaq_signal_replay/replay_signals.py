#!/usr/bin/env python3
"""Replay Modelica time/value tables into the active RaspDAQ ROS 2 inputs."""

import argparse
from bisect import bisect_right
from dataclasses import dataclass
import math
from pathlib import Path
import re
import time
from typing import Sequence


# Commands are published every 20 ms (50 Hz).
PUBLISH_PERIOD_SECONDS = 0.02
PUBLISH_PERIOD_NS = 20_000_000
FLOAT32_MAX = 3.4028234663852886e38

SCRIPT_DIRECTORY = Path(__file__).resolve().parent
DATA = SCRIPT_DIRECTORY / "data"
DEFAULT_PROPELLER_FILE = DATA / "propellerFeedback.txt"
DEFAULT_RUDDER_FILE = DATA / "rudderFeedback.txt"
MAIN_ENGINE_TOPIC = "/main_engine_input"
RUDDER_TOPIC = "/rudder_input"

# Backward-compatible name used by the existing tests.
PERIOD_NS = PUBLISH_PERIOD_NS


@dataclass(frozen=True)
class Signal:
    """One ordered signal loaded from a two-column Modelica table."""

    times: tuple[float, ...]
    values: tuple[float, ...]

    @classmethod
    def read(cls, path: Path) -> "Signal":
        """Read and validate a `double table(N,2)` Modelica text file."""
        path = Path(path)
        lines = path.read_text(encoding="utf-8-sig").splitlines()

        # Preserve source line numbers so malformed input produces useful errors.
        content_lines = [
            (line_number, line.strip())
            for line_number, line in enumerate(lines, start=1)
            if line.strip() and not line.lstrip().startswith("#")
        ]
        if not content_lines:
            raise ValueError(f"{path}: empty table")

        header_match = re.fullmatch(
            r"double\s+\w+\s*\(\s*(\d+)\s*,\s*2\s*\)",
            content_lines[0][1],
        )
        if not header_match:
            raise ValueError(f"{path}: expected Modelica double table(N,2)")

        data_lines = content_lines[1:]
        if len(data_lines) != int(header_match.group(1)):
            raise ValueError(f"{path}: row count differs from header")

        times: list[float] = []
        values: list[float] = []
        for line_number, line in data_lines:
            try:
                timestamp, value = map(float, line.split())
            except ValueError as error:
                raise ValueError(
                    f"{path}:{line_number}: expected time and value"
                ) from error

            cls._validate_sample(path, line_number, timestamp, value, times)

            # The supplied tables repeat identical samples. Keeping one avoids
            # a zero-duration interval during interpolation.
            if times and timestamp == times[-1]:
                if value != values[-1]:
                    raise ValueError(
                        f"{path}:{line_number}: ambiguous values at duplicate timestamp"
                    )
                continue

            times.append(timestamp)
            values.append(value)

        if len(times) < 2 or times[0] != 0.0:
            raise ValueError(
                f"{path}: need at least two distinct times, starting at zero"
            )
        return cls(tuple(times), tuple(values))

    @staticmethod
    def _validate_sample(
        path: Path,
        line_number: int,
        timestamp: float,
        value: float,
        previous_times: Sequence[float],
    ) -> None:
        """Reject samples that cannot be safely published as Float32."""
        if (
            not math.isfinite(timestamp)
            or not math.isfinite(value)
            or abs(value) > FLOAT32_MAX
        ):
            raise ValueError(
                f"{path}:{line_number}: nonfinite time or invalid Float32 value"
            )
        if timestamp < 0.0 or (
            previous_times and timestamp < previous_times[-1]
        ):
            raise ValueError(
                f"{path}:{line_number}: times must be nonnegative and ordered"
            )

    def value_at(self, timestamp: float, interpolation: str = "linear") -> float:
        """Return the value at a time using linear or hold interpolation."""
        lower_index = bisect_right(self.times, timestamp) - 1
        if lower_index < 0:
            return self.values[0]
        if lower_index >= len(self.times) - 1 or interpolation == "hold":
            return self.values[lower_index]

        lower_time = self.times[lower_index]
        upper_time = self.times[lower_index + 1]
        fraction = (timestamp - lower_time) / (upper_time - lower_time)
        lower_value = self.values[lower_index]
        upper_value = self.values[lower_index + 1]
        return lower_value + fraction * (upper_value - lower_value)

    # Retain the original method name for existing callers and tests.
    def at(self, timestamp: float, mode: str = "linear") -> float:
        return self.value_at(timestamp, mode)


@dataclass
class ReplayState:
    """Timing state and publisher-side statistics."""

    start_time_ns: int = 0
    previous_sample_index: int = -1
    published_pairs: int = 0
    skipped_samples: int = 0
    maximum_lateness_ns: int = 0
    complete: bool = False


def sample_index(elapsed_ns: int, previous_index: int) -> int:
    """Select the current slot, skipping any slots that have already expired."""
    return max(previous_index + 1, elapsed_ns // PUBLISH_PERIOD_NS)


def create_argument_parser() -> argparse.ArgumentParser:
    """Define command-line options separately from execution logic."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--propeller", type=Path, default=DEFAULT_PROPELLER_FILE)
    parser.add_argument("--rudder", type=Path, default=DEFAULT_RUDDER_FILE)
    parser.add_argument(
        "--interpolation", choices=("linear", "hold"), default="linear"
    )
    parser.add_argument(
        "--start-delay", type=float, default=3.0,
        help="Seconds after subscriber discovery",
    )
    parser.add_argument(
        "--wait-timeout", type=float, default=30.0,
        help="Subscriber discovery timeout in seconds",
    )
    parser.add_argument(
        "--check", action="store_true",
        help="Validate tables without importing ROS or publishing",
    )
    return parser


def load_signal_pair(propeller_path: Path, rudder_path: Path) -> tuple[Signal, Signal]:
    """Load both command signals and verify that they end together."""
    propeller_signal = Signal.read(propeller_path)
    rudder_signal = Signal.read(rudder_path)
    if propeller_signal.times[-1] != rudder_signal.times[-1]:
        raise ValueError("Both signals must have the same final timestamp")
    return propeller_signal, rudder_signal


def wait_for_subscribers(node, publishers, timeout_seconds: float, rclpy) -> bool:
    """Wait until the bridge is discovered on both command topics."""
    deadline = time.monotonic() + timeout_seconds
    node.get_logger().info("Waiting for subscribers on both command topics...")
    while rclpy.ok() and not all(
        publisher.get_subscription_count() for publisher in publishers
    ):
        if time.monotonic() >= deadline:
            raise RuntimeError(
                "Subscriber discovery timed out; check bridge and ROS_DOMAIN_ID"
            )
        rclpy.spin_once(node, timeout_sec=0.1)
    return rclpy.ok()


def wait_before_start(node, delay_seconds: float, rclpy) -> bool:
    """Allow the operator a short interval after DDS discovery."""
    node.get_logger().info(
        f"Starting in {delay_seconds:g} s. USB streaming must already be active."
    )
    deadline = time.monotonic() + delay_seconds
    while rclpy.ok() and time.monotonic() < deadline:
        remaining = max(0.0, deadline - time.monotonic())
        rclpy.spin_once(node, timeout_sec=min(0.1, remaining))
    return rclpy.ok()


def print_replay_statistics(state: ReplayState) -> None:
    """Report publisher-side timing information at shutdown."""
    print(
        f"Published pairs: {state.published_pairs}; "
        f"skipped slots: {state.skipped_samples}; "
        f"max slot lateness: {state.maximum_lateness_ns / 1e6:.3f} ms"
    )


def run_ros_replay(
    args: argparse.Namespace,
    ros_args: list[str],
    propeller_signal: Signal,
    rudder_signal: Signal,
    last_sample_index: int,
) -> int:
    """Initialize ROS, wait for the bridge, and publish both signals."""

    # These imports are intentionally delayed. `--check` validates the input
    # without requiring ROS 2 to be installed on the current computer.
    import rclpy
    from rclpy.clock import Clock, ClockType
    from rclpy.node import Node
    from rclpy.qos import (
        DurabilityPolicy,
        HistoryPolicy,
        QoSProfile,
        ReliabilityPolicy,
    )
    from std_msgs.msg import Float32

    rclpy.init(args=ros_args)
    node = Node("raspdaq_signal_replay")
    timer = None
    state = ReplayState()

    # Depth 1 prevents an expired command from building a DDS backlog.
    qos = QoSProfile(
        history=HistoryPolicy.KEEP_LAST,
        depth=1,
        reliability=ReliabilityPolicy.RELIABLE,
        durability=DurabilityPolicy.VOLATILE,
    )
    main_engine_publisher = node.create_publisher(Float32, MAIN_ENGINE_TOPIC, qos)
    rudder_publisher = node.create_publisher(Float32, RUDDER_TOPIC, qos)
    publishers = (main_engine_publisher, rudder_publisher)
    main_engine_message = Float32()
    rudder_message = Float32()

    try:
        if not wait_for_subscribers(node, publishers, args.wait_timeout, rclpy):
            return 1
        if not wait_before_start(node, args.start_delay, rclpy):
            return 1

        def publish_current_sample() -> None:
            """Publish values associated with the current 20 ms time slot."""
            elapsed_ns = time.monotonic_ns() - state.start_time_ns
            current_index = min(
                sample_index(elapsed_ns, state.previous_sample_index),
                last_sample_index,
            )
            state.skipped_samples += (
                current_index - state.previous_sample_index - 1
            )
            selected_slot_ns = current_index * PUBLISH_PERIOD_NS
            state.maximum_lateness_ns = max(
                state.maximum_lateness_ns, elapsed_ns - selected_slot_ns
            )

            signal_time = min(
                current_index * PUBLISH_PERIOD_SECONDS,
                propeller_signal.times[-1],
            )
            main_engine_message.data = float(
                propeller_signal.value_at(signal_time, args.interpolation)
            )
            rudder_message.data = float(
                rudder_signal.value_at(signal_time, args.interpolation)
            )

            # DDS treats these as two messages, although the same callback sends both.
            main_engine_publisher.publish(main_engine_message)
            rudder_publisher.publish(rudder_message)
            state.previous_sample_index = current_index
            state.published_pairs += 1
            state.complete = current_index == last_sample_index

        # A steady clock prevents /clock or use_sim_time from pacing the replay.
        timer = node.create_timer(
            PUBLISH_PERIOD_SECONDS,
            publish_current_sample,
            clock=Clock(clock_type=ClockType.STEADY_TIME),
        )
        state.start_time_ns = time.monotonic_ns()

        # Send t=0 immediately; the timer handles all subsequent slots.
        publish_current_sample()
        while rclpy.ok() and not state.complete:
            rclpy.spin_once(node, timeout_sec=0.1)

        timer.cancel()
        node.get_logger().info(
            "Replay complete. No additional commands will be sent."
        )
    except KeyboardInterrupt:
        print("Replay interrupted; no stop/zero command sent.")
    except RuntimeError as error:
        print(f"Error: {error}")
        return 1
    finally:
        if timer is not None:
            timer.cancel()
        print_replay_statistics(state)
        node.destroy_node()
        rclpy.try_shutdown()
    return 0


def main(argv: list[str] | None = None) -> int:
    """Validate arguments and signals, then optionally start the ROS replay."""
    parser = create_argument_parser()
    args, ros_args = parser.parse_known_args(argv)

    for option_name in ("start_delay", "wait_timeout"):
        option_value = getattr(args, option_name)
        if not math.isfinite(option_value) or option_value < 0.0:
            parser.error(f"{option_name} must be finite and nonnegative")

    try:
        propeller_signal, rudder_signal = load_signal_pair(
            args.propeller, args.rudder
        )
    except (OSError, ValueError) as error:
        parser.error(str(error))

    duration_seconds = propeller_signal.times[-1]
    last_sample_index = math.ceil(
        duration_seconds * 1_000_000_000 / PUBLISH_PERIOD_NS
    )
    print(
        f"Duration: {duration_seconds:.6f} s; 50 Hz; "
        f"{last_sample_index + 1} scheduled pairs; "
        f"interpolation={args.interpolation}",
        flush=True,
    )
    if args.check:
        return 0

    return run_ros_replay(
        args,
        ros_args,
        propeller_signal,
        rudder_signal,
        last_sample_index,
    )


if __name__ == "__main__":
    raise SystemExit(main())

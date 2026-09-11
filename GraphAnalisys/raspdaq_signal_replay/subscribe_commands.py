#!/usr/bin/env python3
"""Monitor the two command topics published by replay_signals.py."""

import argparse
from dataclasses import dataclass
import math
import time

import rclpy
from rclpy.node import Node
from rclpy.qos import (
    DurabilityPolicy,
    HistoryPolicy,
    QoSProfile,
    ReliabilityPolicy,
)
from std_msgs.msg import Float32


MAIN_ENGINE_TOPIC = "/main_engine_input"
RUDDER_TOPIC = "/rudder_input"


@dataclass
class TopicState:
    """Latest value and reception statistics for one topic."""

    value: float = 0.0
    message_count: int = 0
    first_message_time_ns: int | None = None
    last_message_time_ns: int | None = None
    updated_since_print: bool = False

    def record(self, value: float, reception_time_ns: int) -> None:
        """Store a sample and update the time range used for rate calculation."""
        self.value = value
        self.message_count += 1
        if self.first_message_time_ns is None:
            self.first_message_time_ns = reception_time_ns
        self.last_message_time_ns = reception_time_ns
        self.updated_since_print = True

    def average_rate_hz(self) -> float:
        """Calculate the average reception rate between first and last sample."""
        if (
            self.message_count < 2
            or self.first_message_time_ns is None
            or self.last_message_time_ns is None
        ):
            return 0.0
        elapsed_seconds = (
            self.last_message_time_ns - self.first_message_time_ns
        ) / 1_000_000_000
        return (self.message_count - 1) / elapsed_seconds if elapsed_seconds else 0.0


class CommandSubscriber(Node):
    """Subscribe to both RaspDAQ inputs and print complete command pairs."""

    def __init__(self, print_every: int) -> None:
        super().__init__("raspdaq_command_subscriber")
        self.print_every = print_every
        self.start_time_ns = time.monotonic_ns()
        self.printed_pairs = 0
        self.engine = TopicState()
        self.rudder = TopicState()

        qos = QoSProfile(
            history=HistoryPolicy.KEEP_LAST,
            depth=10,
            reliability=ReliabilityPolicy.RELIABLE,
            durability=DurabilityPolicy.VOLATILE,
        )
        self.engine_subscription = self.create_subscription(
            Float32, MAIN_ENGINE_TOPIC, self._on_engine_command, qos
        )
        self.rudder_subscription = self.create_subscription(
            Float32, RUDDER_TOPIC, self._on_rudder_command, qos
        )

        self.get_logger().info(
            f"Listening on {MAIN_ENGINE_TOPIC} and {RUDDER_TOPIC}"
        )

    def _on_engine_command(self, message: Float32) -> None:
        self.engine.record(float(message.data), time.monotonic_ns())
        self._print_pair_when_complete()

    def _on_rudder_command(self, message: Float32) -> None:
        self.rudder.record(float(message.data), time.monotonic_ns())
        self._print_pair_when_complete()

    def _print_pair_when_complete(self) -> None:
        # Wait until each topic has supplied a new value. The two ROS messages
        # are independent, so this is observation pairing rather than DDS sync.
        if not (
            self.engine.updated_since_print and self.rudder.updated_since_print
        ):
            return

        self.printed_pairs += 1
        if self.printed_pairs % self.print_every == 0:
            elapsed_seconds = (time.monotonic_ns() - self.start_time_ns) / 1e9
            print(
                f"t={elapsed_seconds:9.3f} s | "
                f"pair={self.printed_pairs:6d} | "
                f"main_engine={self.engine.value:12.6f} | "
                f"rudder={self.rudder.value:12.6f}",
                flush=True,
            )

        self.engine.updated_since_print = False
        self.rudder.updated_since_print = False

    def print_summary(self) -> None:
        """Show message counts and average rates measured by this subscriber."""
        print("\nReception summary:")
        print(
            f"  {MAIN_ENGINE_TOPIC}: {self.engine.message_count} messages, "
            f"average {self.engine.average_rate_hz():.2f} Hz"
        )
        print(
            f"  {RUDDER_TOPIC}: {self.rudder.message_count} messages, "
            f"average {self.rudder.average_rate_hz():.2f} Hz"
        )
        print(f"  complete observed pairs: {self.printed_pairs}")


def create_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--duration",
        type=float,
        default=0.0,
        help="Stop after this many seconds; zero waits until Ctrl+C",
    )
    parser.add_argument(
        "--print-every",
        type=int,
        default=1,
        help="Print one line for every N complete pairs",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = create_argument_parser()
    args, ros_args = parser.parse_known_args(argv)
    if not math.isfinite(args.duration) or args.duration < 0.0:
        parser.error("duration must be finite and nonnegative")
    if args.print_every < 1:
        parser.error("print-every must be at least 1")

    rclpy.init(args=ros_args)
    node = CommandSubscriber(args.print_every)
    deadline = (
        time.monotonic() + args.duration if args.duration > 0.0 else None
    )
    try:
        while rclpy.ok() and (deadline is None or time.monotonic() < deadline):
            timeout = 0.1
            if deadline is not None:
                timeout = min(timeout, max(0.0, deadline - time.monotonic()))
            rclpy.spin_once(node, timeout_sec=timeout)
    except KeyboardInterrupt:
        pass
    finally:
        node.print_summary()
        node.destroy_node()
        rclpy.try_shutdown()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

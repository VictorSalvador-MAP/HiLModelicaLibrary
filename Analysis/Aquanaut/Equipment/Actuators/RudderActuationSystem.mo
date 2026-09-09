within Aquanaut.Equipment.Actuators;

block RudderActuationSystem
  extends Modelica.Blocks.Icons.Block;
  parameter Real Kv = 0.2 "rad/s per Volt";
  parameter Modelica.Units.SI.Angle phi_start = 0 "Initial rudder angle";
  parameter Modelica.Units.SI.Angle phi_max = 0.7853981633974483 "Maximum rudder angle (+)";
  parameter Modelica.Units.SI.Angle phi_min = -phi_max "Minimum rudder angle (-)";
  // Interfaces
  Modelica.Blocks.Interfaces.RealInput u(unit = "V") annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y(unit = "rad") annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
protected
  Modelica.Blocks.Math.Gain voltageToSpeed(k = Kv);
  Modelica.Blocks.Continuous.Integrator integrator(y_start = phi_start);
  Modelica.Blocks.Nonlinear.Limiter angleLimiter(uMin = phi_min, uMax = phi_max);
equation
  connect(u, voltageToSpeed.u);
  connect(voltageToSpeed.y, integrator.u);
  connect(integrator.y, angleLimiter.u);
  connect(angleLimiter.y, y);
  annotation(
    Icon(graphics = {Rectangle(fillColor = {200, 200, 200}, extent = {{-60, 60}, {60, -60}}), Text(extent = {{-50, 20}, {50, -20}}, textString = "V → θ")}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Rudder Actuation System Model</h1>

<p>
  The <em>RudderActuationSystem</em> model acts as an electromechanical interface for the ship's steering. 
  It simulates the behavior of the steering gear, converting a control voltage signal into a physical rudder angle by acting effectively as a velocity-limited integrator with position stops.
</p>

<h2>Description</h2>

<p>
  This block represents the servo-mechanism dynamics that drive the rudder. Unlike the <em>MarineRudder</em> component (which models the hydrodynamic interaction with water), this component models the <strong>actuation machinery</strong>. 
  It interprets the input signal as a velocity command (rudder rate), integrates it to obtain the angular position, and applies mechanical stops (saturation) to restrict the movement within valid physical limits.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the RudderActuationSystem block</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Kv</strong></td>
      <td>Real</td>
      <td>rad/s/V</td>
      <td>Actuator gain: Rudder angular velocity per unit of input voltage (default: 0.2).</td>
    </tr>
    <tr>
      <td><strong>phi_start</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Initial rudder angle at the start of the simulation.</td>
    </tr>
    <tr>
      <td><strong>phi_max</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Maximum positive rudder angle (mechanical stop).</td>
    </tr>
    <tr>
      <td><strong>phi_min</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Minimum negative rudder angle (mechanical stop).</td>
    </tr>
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Inputs and Outputs</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>u</strong></td>
      <td>RealInput</td>
      <td>V</td>
      <td>Control voltage input (commands rudder angular rate).</td>
    </tr>
    <tr>
      <td><strong>y</strong></td>
      <td>RealOutput</td>
      <td>rad</td>
      <td>Output signal reporting the actual rudder angle.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Variables</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 3:</strong> Internal calculation blocks</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><em>voltageToSpeed</em></td>
      <td>Gain</td>
      <td>Scales the input voltage to an angular velocity command.</td>
    </tr>
    <tr>
      <td><em>integrator</em></td>
      <td>Integrator</td>
      <td>Integrates the velocity over time to calculate position.</td>
    </tr>
    <tr>
      <td><em>angleLimiter</em></td>
      <td>Limiter</td>
      <td>Saturates the position output between <em>phi_min</em> and <em>phi_max</em>.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The system operates as a rate-controlled actuator, defined by the chain of signal processing blocks:
</p>

<ul>
  <li><strong>Rate Generation:</strong> The input voltage <em>u</em> determines the speed at which the rudder moves, scaled by the gain <em>K<sub>v</sub></em>: 
    <br><em>ω<sub>rudder</sub> = K<sub>v</sub> · u</em>.
  </li>
  <li><strong>Position Integration:</strong> The angle is the time integral of this rate, starting from the initial condition:
    <br><em>δ<sub>raw</sub> = ∫ ω<sub>rudder</sub> dt + δ<sub>start</sub></em>.
  </li>
  <li><strong>Mechanical Limits:</strong> The final output is restricted to the vessel's physical design range:
    <br><em>y = max(phi_min, min(phi_max, δ<sub>raw</sub>))</em>.
  </li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Equipment.Actuators package within the Aquanaut library.</em>
</p>


</body></html>"));
end RudderActuationSystem;

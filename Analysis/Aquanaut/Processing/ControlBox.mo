within Aquanaut.Processing;

block ControlBox
  extends Modelica.Blocks.Icons.Block;
  // Parameters
  // Control Settings
  parameter Modelica.Blocks.Types.SimpleController controllerType = Modelica.Blocks.Types.SimpleController.PI "Selected control action" annotation(
    Dialog(group = "Control Configuration"));
  parameter Real Kp = 1 "Proportional gain" annotation(
    Dialog(group = "Control Configuration"));
  parameter Modelica.Units.SI.Time Ti = 0.5 "Integral time constant" annotation(
    Dialog(group = "Control Configuration", enable = (controllerType == Modelica.Blocks.Types.SimpleController.PI or controllerType == Modelica.Blocks.Types.SimpleController.PID)));
  parameter Modelica.Units.SI.Time Td = 0.1 "Derivative time constant" annotation(
    Dialog(group = "Control Configuration", enable = (controllerType == Modelica.Blocks.Types.SimpleController.PD or controllerType == Modelica.Blocks.Types.SimpleController.PID)));
  parameter Modelica.Units.SI.Voltage cmdVmax = 5 "Maximum control command voltage" annotation(
    Dialog(group = "Control Configuration"));
  // Physical Limits & Sensor Config
  parameter Modelica.Units.SI.Angle maxRudderAngle = 0.7853981633974483 "Maximum allowed rudder angle" annotation(
    Dialog(group = "Physical Limits"));
  parameter Modelica.Units.SI.Voltage sensorVmin = 0.5 "Minimum sensor voltage" annotation(
    Dialog(group = "Sensor Hardware"));
  parameter Modelica.Units.SI.Voltage sensorVmax = 4.5 "Maximum sensor voltage" annotation(
    Dialog(group = "Sensor Hardware"));
  parameter Modelica.Units.SI.Angle sensorMinAngle = -0.7853981633974483 "Angle corresponding to Vmin" annotation(
    Dialog(group = "Sensor Hardware"));
  parameter Modelica.Units.SI.Angle sensorMaxAngle = 0.7853981633974483 "Angle corresponding to Vmax" annotation(
    Dialog(group = "Sensor Hardware"));
  // Interfaces
  Modelica.Blocks.Interfaces.RealInput rudderAngleRef(unit = "rad") annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput rudderAngleSensorV(unit = "V") annotation(
    Placement(transformation(origin = {-88, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput rudderCmdV(unit = "V") annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  // Reference path
  Modelica.Blocks.Nonlinear.Limiter refAngleLimiter(uMax = maxRudderAngle, uMin = -maxRudderAngle) annotation(
    Placement(transformation(origin = {-78, 0}, extent = {{-10, -10}, {10, 10}})));
  // Feedback path
  Modelica.Blocks.Nonlinear.Limiter sensorVoltLimiter(uMin = sensorVmin, uMax = sensorVmax) annotation(
    Placement(transformation(origin = {-68, -76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds sensorVoltToAngle(table = {{sensorVmin, sensorMinAngle}, {sensorVmax, sensorMaxAngle}}) annotation(
    Placement(transformation(origin = {-34, -76}, extent = {{-10, -10}, {10, 10}})));
  // PI Controller
  Modelica.Blocks.Continuous.LimPID piController(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = Kp, Ti = Ti, yMax = cmdVmax, Td = Td) annotation(
    Placement(transformation(origin = {-6, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(rudderAngleRef, refAngleLimiter.u) annotation(
    Line(points = {{-120, 0}, {-90, 0}}, color = {0, 0, 127}));
  connect(rudderAngleSensorV, sensorVoltLimiter.u) annotation(
    Line(points = {{-88, -120}, {-88, -76}, {-80, -76}}, color = {0, 0, 127}));
  connect(sensorVoltLimiter.y, sensorVoltToAngle.u) annotation(
    Line(points = {{-56, -76}, {-46, -76}}, color = {0, 0, 127}));
  connect(piController.y, rudderCmdV) annotation(
    Line(points = {{5, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(refAngleLimiter.y, piController.u_s) annotation(
    Line(points = {{-66, 0}, {-18, 0}}, color = {0, 0, 127}));
  connect(sensorVoltToAngle.y[1], piController.u_m) annotation(
    Line(points = {{-23, -76}, {-6, -76}, {-6, -12}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(origin = {-30, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-10, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {10, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {30, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-30, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-10, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {10, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {30, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, 30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, 10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, -10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, -30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, 30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, 10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, -10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, -30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(fillColor = {88, 88, 88}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}), Rectangle(fillColor = {168, 168, 168}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Text(origin = {-1, 3}, extent = {{-35, -33}, {35, 33}}, textString = "CB", textStyle = {TextStyle.Bold})}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Control Box Model</h1>

<p>
  The <em>ControlBox</em> model acts as the central electronic control unit (ECU) for the vessel's steering system. 
  It implements a feedback control loop, processing reference setpoints and sensor data to generate actuation commands for maneuvering.
</p>

<h2>Description</h2>

<p>
  This component manages the closed-loop control of the rudder. It accepts a desired heading or rudder angle command and compares it with the actual position measured by sensors.
  The model includes signal conditioning stages (limiters and lookup tables) to normalize sensor voltages into physical angles before feeding them into a PID controller, which generates the correction voltage for the actuators.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the ControlBox block</caption>
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
      <td><strong>controllerType</strong></td>
      <td>SimpleController</td>
      <td>-</td>
      <td>Type of control action (PI, PD, PID). Default: PI.</td>
    </tr>
    <tr>
      <td><strong>Kp</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Proportional gain of the controller.</td>
    </tr>
    <tr>
      <td><strong>Ti</strong></td>
      <td>Time</td>
      <td>s</td>
      <td>Integral time constant (active for PI/PID).</td>
    </tr>
    <tr>
      <td><strong>Td</strong></td>
      <td>Time</td>
      <td>s</td>
      <td>Derivative time constant (active for PD/PID).</td>
    </tr>
    <tr>
      <td><strong>cmdVmax</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Maximum control command voltage output (saturation limit).</td>
    </tr>
    <tr>
      <td><strong>maxRudderAngle</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Physical limit for the rudder reference command.</td>
    </tr>
    <tr>
      <td><strong>sensorVmin</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Minimum expected voltage from the feedback sensor.</td>
    </tr>
    <tr>
      <td><strong>sensorVmax</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Maximum expected voltage from the feedback sensor.</td>
    </tr>
    <tr>
      <td><strong>sensorMinAngle</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Angle corresponding to <em>sensorVmin</em>.</td>
    </tr>
    <tr>
      <td><strong>sensorMaxAngle</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Angle corresponding to <em>sensorVmax</em>.</td>
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
      <td><strong>rudderAngleRef</strong></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>Desired rudder angle setpoint (Reference).</td>
    </tr>
    <tr>
      <td><strong>rudderAngleSensorV</strong></td>
      <td>RealInput</td>
      <td>V</td>
      <td>Feedback signal from the angle sensor (Measurement).</td>
    </tr>
    <tr>
      <td><strong>rudderCmdV</strong></td>
      <td>RealOutput</td>
      <td>V</td>
      <td>Control actuation signal sent to the steering system.</td>
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
      <td><em>refAngleLimiter</em></td>
      <td>Limiter</td>
      <td>Limits the input reference to +/- <em>maxRudderAngle</em>.</td>
    </tr>
    <tr>
      <td><em>sensorVoltLimiter</em></td>
      <td>Limiter</td>
      <td>Clamps the sensor input voltage within [<em>sensorVmin</em>, <em>sensorVmax</em>].</td>
    </tr>
    <tr>
      <td><em>sensorVoltToAngle</em></td>
      <td>CombiTable1Ds</td>
      <td>Converts the clamped sensor voltage to a physical angle (rad).</td>
    </tr>
    <tr>
      <td><em>piController</em></td>
      <td>LimPID</td>
      <td>The PID controller block computing the error and output.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model executes a three-stage signal processing sequence to close the control loop:
</p>

<ul>
  <li><strong>Reference Conditioning:</strong> The incoming setpoint <code>rudderAngleRef</code> is passed through a limiter to ensure the controller never attempts to drive the rudder beyond its physical stops (<code>maxRudderAngle</code>).</li>
  <li><strong>Feedback Normalization:</strong> The raw voltage from the sensor is first saturated (to filter out signal spikes) and then mapped back to an angular value using a linear look-up table defined by the calibration parameters (<code>sensorVmin</code>/<code>Angle</code> pairs).</li>
  <li><strong>PID Algorithm:</strong> The <code>piController</code> calculates the error <em>e = Ref - Meas</em>. It computes the Proportional, Integral, and Derivative terms to generate a corrective voltage <code>rudderCmdV</code>, which is strictly limited by <code>cmdVmax</code> to protect the actuator driver.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Processing package within the Aquanaut library.</em>
</p>


</body></html>"));
end ControlBox;

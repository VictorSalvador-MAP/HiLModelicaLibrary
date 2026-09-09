within Aquanaut.Examples;

model RudderSystem
  extends Modelica.Icons.Example;
  Processing.ControlBox controlBox(maxRudderAngle(displayUnit = "deg"), Kp = 50, Ti = 10) annotation(
    Placement(transformation(origin = {-50, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Position position annotation(
    Placement(transformation(origin = {22, 12}, extent = {{-10, -10}, {10, 10}})));
  ShipParts.MarineRudder marineRudder1 annotation(
    Placement(transformation(origin = {86, 12}, extent = {{-10, -10}, {10, 10}})));
  Equipment.Sensors.AngleSensorSignal angleSensorSignal1 annotation(
    Placement(transformation(origin = {54, 12}, extent = {{-10, -10}, {10, 10}})));
  Utils.AngleOutput angleOutput1(angle(displayUnit = "deg") = 0.6981317007977318) annotation(
    Placement(transformation(origin = {-80, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Pulse pulse(offset = -1, period = 4, amplitude = 2) annotation(
    Placement(transformation(origin = {-52, 72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 40) annotation(
    Placement(transformation(origin = {-20, 72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.UnitConversions.From_deg from_deg annotation(
    Placement(transformation(origin = {10, 72}, extent = {{-10, -10}, {10, 10}})));
  Equipment.Actuators.RudderActuationSystem simplifiedSystem1 annotation(
    Placement(transformation(origin = {-14, 12}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(position.flange, angleSensorSignal1.flange) annotation(
    Line(points = {{32, 12}, {44, 12}}));
  connect(angleSensorSignal1.phi, marineRudder1.u) annotation(
    Line(points = {{66, 12}, {74, 12}}, color = {0, 0, 127}));
  connect(angleSensorSignal1.v, controlBox.rudderAngleSensorV) annotation(
    Line(points = {{54, 2}, {54, -20}, {-50, -20}, {-50, 0}}, color = {0, 0, 127}));
  connect(pulse.y, gain.u) annotation(
    Line(points = {{-41, 72}, {-32, 72}}, color = {0, 0, 127}));
  connect(gain.y, from_deg.u) annotation(
    Line(points = {{-9, 72}, {-2, 72}}, color = {0, 0, 127}));
  connect(angleOutput1.phi, controlBox.rudderAngleRef) annotation(
    Line(points = {{-68, 12}, {-62, 12}}, color = {0, 0, 127}));
  connect(controlBox.rudderCmdV, simplifiedSystem1.u) annotation(
    Line(points = {{-38, 12}, {-26, 12}}, color = {0, 0, 127}));
  connect(simplifiedSystem1.y, position.phi_ref) annotation(
    Line(points = {{-2, 12}, {10, 12}}, color = {0, 0, 127}));
  annotation(Documentation(info = "<html><head>
</head>
<body>
<h1>Rudder Control System Example</h1>

<p>
  The <em>RudderSystem</em> example demonstrates a complete closed-loop steering system. 
  It integrates the electronic control unit (ECU), the actuation machinery, and the feedback sensors to control the position of a hydrodynamic rudder surface.
</p>

<h2>Description</h2>

<p>
  This model connects the individual components from the <em>Equipment</em> and <em>Processing</em> packages to form a functional servo loop. 
  It illustrates how a voltage command from the controller is converted into physical mechanical movement, measured by sensors, and fed back to correct the error. 
  The example isolates the steering dynamics from the rest of the vessel, focusing on the actuator response and controller tuning.
</p>

<h2>System Topology</h2>

<p>
  The control loop is constructed as follows:
</p>
<ul>
  <li><strong>Reference:</strong> A fixed setpoint is provided by the <code>AngleOutput</code> block (set to approx. 40°).</li>
  <li><strong>Controller:</strong> The <code>ControlBox</code> compares the reference with the feedback and generates a command voltage.</li>
  <li><strong>Actuation:</strong> The <code>RudderActuationSystem</code> simulates the steering gear, converting the voltage into a rudder angle (including rate limits).</li>
  <li><strong>Mechanics:</strong> An ideal <code>Position</code> source imposes this angle on the mechanical flange.</li>
  <li><strong>Feedback:</strong> The <code>AngleSensorSignal</code> measures the flange position and converts it back to a voltage for the controller.</li>
  <li><strong>Hydrodynamics:</strong> The measured angle is passed to the <code>MarineRudder</code> component to calculate the resulting fluid forces (Lift/Drag).</li>
</ul>

<h2>Key Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Components used in the example</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>controlBox</strong></td>
      <td>ControlBox</td>
      <td>PID Controller configured with Kp=50 and Ti=10.</td>
    </tr>
    <tr>
      <td><strong>simplifiedSystem1</strong></td>
      <td>RudderActuationSystem</td>
      <td>Models the steering gear dynamics and limits.</td>
    </tr>
    <tr>
      <td><strong>angleSensorSignal1</strong></td>
      <td>AngleSensorSignal</td>
      <td>Provides both voltage feedback and physical angle output.</td>
    </tr>
    <tr>
      <td><strong>marineRudder1</strong></td>
      <td>MarineRudder</td>
      <td>Calculates hydrodynamic forces based on the input angle.</td>
    </tr>
    <tr>
      <td><strong>position</strong></td>
      <td>Rotational.Sources.Position</td>
      <td>Drives the mechanical flange based on the actuator output.</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  When simulated, the system performs a step response test:
</p>
<ul>
  <li>The <strong>ControlBox</strong> receives a step reference from <code>angleOutput1</code>.</li>
  <li>It drives the <strong>Actuator</strong> with a positive voltage to reduce the error.</li>
  <li>The <strong>Actuator</strong> integrates this signal to change the rudder angle at a finite rate (limited by <em>Kv</em>).</li>
  <li>The <strong>Sensor</strong> detects the movement and increases the feedback voltage.</li>
  <li>As the error approaches zero, the controller reduces the command, holding the rudder steady at the desired angle.</li>
</ul>

<hr>
<p>
  <em>Note: This model also includes an unconnected Pulse generator chain (Pulse -&gt; Gain -&gt; From_deg) which can be connected to the reference input for dynamic frequency response testing.</em>
</p>


</body></html>"),
  experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
  Diagram(coordinateSystem(extent = {{-100, -50}, {100, 100}})),
  Icon(coordinateSystem(extent = {{-100, -50}, {100, 100}})));
end RudderSystem;

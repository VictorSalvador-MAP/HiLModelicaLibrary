within Aquanaut.Examples;

model ThrustSystem
  extends Modelica.Icons.Example;
  Equipment.Sensors.LeverSensor leverSensor annotation(
    Placement(transformation(origin = {-96, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Position position annotation(
    Placement(transformation(origin = {-26, -6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor annotation(
    Placement(transformation(origin = {6, -6}, extent = {{-10, -10}, {10, 10}})));
  Equipment.Actuators.DieselEngine dieselEngine annotation(
    Placement(transformation(origin = {42, -6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant clutch(k = 1) annotation(
    Placement(transformation(origin = {80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant Va(k = 5) annotation(
    Placement(transformation(origin = {78, 24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant lever(k = 4) annotation(
    Placement(transformation(origin = {-132, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor propSpeedSensor annotation(
    Placement(transformation(origin = {118, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor motorSpeedSensor annotation(
    Placement(transformation(origin = {60, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Processing.MicroCommander microCommander annotation(
    Placement(transformation(origin = {-62, -2}, extent = {{-10, -10}, {10, 10}})));
  ShipParts.MarinePropeller marinePropeller annotation(
    Placement(transformation(origin = {116, -6}, extent = {{-10, -10}, {10, 10}})));
  Equipment.Actuators.Transmission transmission annotation(
    Placement(transformation(origin = {80, -6}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(lever.y, leverSensor.u) annotation(
    Line(points = {{-120, -2}, {-108, -2}}, color = {0, 0, 127}));
  connect(leverSensor.v, microCommander.vLever) annotation(
    Line(points = {{-85, -2}, {-74, -2}}, color = {0, 0, 127}));
  connect(microCommander.leverAngle, position.phi_ref) annotation(
    Line(points = {{-51, -6}, {-38, -6}}, color = {0, 0, 127}));
  connect(position.flange, angleSensor.flange) annotation(
    Line(points = {{-16, -6}, {-4, -6}}));
  connect(angleSensor.phi, dieselEngine.throttleAnglePosition) annotation(
    Line(points = {{18, -6}, {30, -6}}, color = {0, 0, 127}));
  connect(dieselEngine.flange, motorSpeedSensor.flange) annotation(
    Line(points = {{52, -6}, {60, -6}, {60, 22}}));
  connect(transmission.clutchMode, clutch.y) annotation(
    Line(points = {{80, -18}, {80, -29}}, color = {0, 0, 127}));
  connect(dieselEngine.flange, transmission.flange_a) annotation(
    Line(points = {{52, -6}, {70, -6}}));
  connect(transmission.flange_b, marinePropeller.flange) annotation(
    Line(points = {{90, -6}, {106, -6}}));
  connect(propSpeedSensor.flange, marinePropeller.flange) annotation(
    Line(points = {{108, -34}, {98, -34}, {98, -6}, {106, -6}}));
  connect(Va.y, marinePropeller.Va) annotation(
    Line(points = {{90, 24}, {98, 24}, {98, 0}, {104, 0}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -60}, {140, 60}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Thrust System Example</h1>

<p>
  The <em>ThrustSystem</em> example demonstrates a complete marine propulsion chain simulation. 
  It models the flow of power from the bridge control lever, through the electronic control unit (ECU) and engine, down to the propeller, establishing the relationship between throttle command and generated thrust.
</p>

<h2>Description</h2>

<p>
  This model integrates the mechanical and signal components of the propulsion system. 
  Unlike the <em>RudderSystem</em> (which focuses on positioning), this example focuses on <strong>rotational dynamics and load balancing</strong>. 
  It shows how the diesel engine acts as a torque source, driving a propeller load through a reduction gearbox, while the propeller's resistance is determined by its rotational speed and the water flow velocity (Advance Speed).
</p>

<h2>System Topology</h2>

<p>
  The power and signal flow is constructed as follows:
</p>
<ul>
  <li><strong>Command Chain:</strong> A fixed lever command is read by the <code>LeverSensor</code> and processed by the <code>MicroCommander</code> ECU to calculate the required physical throttle angle.</li>
  <li><strong>Throttle Actuation:</strong> An ideal <code>Position</code> source mechanically drives the engine's throttle lever to the calculated angle, measured by an <code>AngleSensor</code>.</li>
  <li><strong>Power Generation:</strong> The <code>DieselEngine</code> reads the throttle angle and generates torque, accelerating the crankshaft inertia.</li>
  <li><strong>Transmission:</strong> The <code>Transmission</code> reduces the shaft speed (RPM) and amplifies the torque, transmitting power to the propeller shaft (assuming the clutch is engaged).</li>
  <li><strong>Hydrodynamics:</strong> The <code>MarinePropeller</code> absorbs torque and generates axial thrust based on the shaft speed and the external water velocity <em>V<sub>a</sub></em>.</li>
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
      <td><strong>lever</strong></td>
      <td>Constant</td>
      <td>Simulates a fixed position of the bridge control lever (Input).</td>
    </tr>
    <tr>
      <td><strong>microCommander</strong></td>
      <td>MicroCommander</td>
      <td>ECU that converts the lever signal into a physical throttle angle demand.</td>
    </tr>
    <tr>
      <td><strong>dieselEngine</strong></td>
      <td>DieselEngine</td>
      <td>The prime mover generating torque based on throttle position.</td>
    </tr>
    <tr>
      <td><strong>transmission</strong></td>
      <td>Transmission</td>
      <td>Gearbox connecting the engine to the propeller (Ratio 2.67:1).</td>
    </tr>
    <tr>
      <td><strong>marinePropeller</strong></td>
      <td>MarinePropeller</td>
      <td>Converts rotational energy into thrust (Wageningen B-Series).</td>
    </tr>
    <tr>
      <td><strong>Va</strong></td>
      <td>Constant</td>
      <td>Represents the speed of water flow entering the propeller (5 m/s).</td>
    </tr>
    <tr>
      <td><strong>clutch</strong></td>
      <td>Constant</td>
      <td>Control signal to keep the transmission clutch fully engaged (1).</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment simulates a steady-state operation scenario:
</p>
<ul>
  <li><strong>Input:</strong> The <code>lever</code> is set to a constant value (k=4), representing a specific forward power demand.</li>
  <li><strong>Equilibrium:</strong> The engine accelerates the shaft until the generated engine torque matches the hydrodynamic load torque of the propeller (reflected through the gearbox).</li>
  <li><strong>Result:</strong> The system settles at a constant RPM (measured by <code>propSpeedSensor</code>) and produces a constant Thrust force. This allows the user to verify if the engine power is sufficient for the hull's design speed (represented by <code>Va</code>).</li>
</ul>

<hr>
<p>
  <em>Note: This model assumes a fixed Advance Velocity (Va), effectively simulating a tow-tank test at constant speed rather than a free-running vessel.</em>
</p>


</body></html>"),
  experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"));
  end ThrustSystem;

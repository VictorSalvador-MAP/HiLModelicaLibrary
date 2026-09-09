within Aquanaut.Examples.AbstractControl;

model SurgeVelocityControl
  extends Modelica.Icons.Example;
  Utils.forceMomentSource forceMomentSource annotation(
    Placement(transformation(origin = {48, 40}, extent = {{-10, -10}, {10, 10}})));
  IMU imu annotation(
    Placement(transformation(origin = {50, -38}, extent = {{10, -10}, {-10, 10}})));
  ShipAndEnvironment shipAndEnvironment annotation(
    Placement(transformation(origin = {84, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0.6) annotation(
    Placement(transformation(origin = {-82, 50}, extent = {{-10, -10}, {10, 10}})));
  simplePI simplePI1 annotation(
    Placement(transformation(origin = {-50, 44}, extent = {{-10, -10}, {10, 10}})));
  simplePI simplePI11(Kp = 6000, Ki = 2000) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Exponentials exponentials(outMax = 0.2, riseTime = 2, riseTimeConst = 2, fallTimeConst = 0.2, startTime = 1) annotation(
    Placement(transformation(origin = {-40, 6}, extent = {{-10, -10}, {10, 10}})));
equation
  imu.uncertaintyIn = zeros(24);
  connect(forceMomentSource.frame_b, shipAndEnvironment.frame_a) annotation(
    Line(points = {{58, 40}, {74, 40}}, color = {95, 95, 95}));
  connect(imu.frame_a, shipAndEnvironment.frame_a) annotation(
    Line(points = {{50, -40}, {69, -40}, {69, 40}, {74, 40}}, color = {95, 95, 95}));
  connect(simplePI1.controlSignal, forceMomentSource.forceInput) annotation(
    Line(points = {{-39, 44}, {36, 44}}, color = {0, 0, 127}));
  connect(const.y, simplePI1.speedReference) annotation(
    Line(points = {{-71, 50}, {-62, 50}}, color = {0, 0, 127}));
  connect(imu.y[1], simplePI1.feedbackSignals[1]) annotation(
    Line(points = {{39, -31.4643}, {-62, -31.4643}, {-62, 38}}, color = {0, 0, 127}, thickness = 0.5));
  connect(imu.y[4], simplePI1.feedbackSignals[2]) annotation(
    Line(points = {{39, -31.4643}, {-62, -31.4643}, {-62, 38}}, color = {0, 0, 127}, thickness = 0.5));
  connect(simplePI11.controlSignal, forceMomentSource.momentInput) annotation(
    Line(points = {{21, 0}, {24, 0}, {24, 36}, {36, 36}}, color = {0, 0, 127}));
  connect(imu.y[9], simplePI11.feedbackSignals[1]) annotation(
    Line(points = {{39, -31.4643}, {-22, -31.4643}, {-22, -6.4643}, {-2, -6.4643}}, color = {0, 0, 127}, thickness = 0.5));
  connect(imu.y[12], simplePI11.feedbackSignals[2]) annotation(
    Line(points = {{39, -31.4643}, {-22, -31.4643}, {-22, -6.4643}, {-2, -6.4643}}, color = {0, 0, 127}, thickness = 0.5));
  connect(exponentials.y, simplePI11.speedReference) annotation(
    Line(points = {{-29, 6}, {-2, 6}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram,
    Documentation(info = "<html><head>
</head>
<body>
<h1>Surge Velocity and Heading Control Example</h1>

<p>
  The <em>SurgeVelocityControl</em> example demonstrates a closed-loop control architecture for a marine vessel. 
  It utilizes idealized actuation and custom Proportional-Integral (PI) controllers to automatically regulate the ship's forward speed (surge) and rotational trajectory (yaw/heading) against hydrodynamic disturbances.
</p>

<h2>Description</h2>

<p>
  Unlike open-loop experiments, this model introduces feedback control. It measures the vessel's current states using an Inertial Measurement Unit (IMU) and compares them to desired reference signals. 
  The control errors are processed by two independent PI controllers (one for surge velocity, one for yaw), which then command the <em>forceMomentSource</em> to apply the exact physical thrust and steering torque needed to achieve the reference trajectories while overcoming viscous and radiation drag.
</p>

<h2>System Topology</h2>

<p>
  To maintain a clean and readable control diagram, the physical components are encapsulated, creating a classic Plant-Controller-Feedback loop:
</p>
<ul>
  <li><strong>Plant (ShipAndEnvironment):</strong> A custom sub-model that packages the vessel's hull, complex buoyancy, radiation damping, viscous drag, and the fluid environment into a single block with a mechanical interface.</li>
  <li><strong>Sensors (IMU):</strong> An ideal IMU measures the vessel's 6-DOF kinematics.</li>
  <li><strong>Controllers (simplePI):</strong> Custom PI control blocks. <code>simplePI1</code> controls the surge tracking, while <code>simplePI11</code> controls the yaw dynamics.</li>
  <li><strong>Actuation (forceMomentSource):</strong> Converts the abstract numerical outputs from the PI controllers into physical 3D force (Surge) and torque (Yaw) vectors applied to the plant.</li>
</ul>

<h2>Key Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Main components in the control loop</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>shipAndEnvironment</strong></td>
      <td>ShipAndEnvironment</td>
      <td>The physical vessel and hydrodynamic environment subsystem.</td>
    </tr>
    <tr>
      <td><strong>imu</strong></td>
      <td>IMU</td>
      <td>Provides real-time feedback of velocity and position/attitude to the controllers.</td>
    </tr>
    <tr>
      <td><strong>simplePI1</strong></td>
      <td>simplePI</td>
      <td>Surge controller. Regulates forward velocity and longitudinal position.</td>
    </tr>
    <tr>
      <td><strong>simplePI11</strong></td>
      <td>simplePI</td>
      <td>Heading/Yaw controller. Tuned with Kp = 6000 and Ki = 2000.</td>
    </tr>
    <tr>
      <td><strong>forceMomentSource</strong></td>
      <td>forceMomentSource</td>
      <td>Applies the control efforts (Force and Moment) to the ship's hull.</td>
    </tr>
    <tr>
      <td><strong>const</strong></td>
      <td>Constant</td>
      <td>Surge velocity reference signal (setpoint = 0.6 m/s).</td>
    </tr>
    <tr>
      <td><strong>exponentials</strong></td>
      <td>Exponentials</td>
      <td>Dynamic reference signal for the yaw/heading maneuver.</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  During the 10-second simulation, two distinct control tasks are performed simultaneously:
</p>
<ol>
  <li><strong>Surge Control:</strong> The constant reference commands the vessel to reach and maintain 0.6 m/s. <code>simplePI1</code> compares this reference to the IMU's X-axis velocity (y[4]) and position (y[1]) feedback. It generates a positive surge force to accelerate the vessel. As the vessel accelerates and drag increases, the integral term adjusts to perfectly match the steady-state drag.</li>
  <li><strong>Heading Control:</strong> At <em>t = 1s</em>, the <code>exponentials</code> block commands a smooth, transient yaw maneuver. <code>simplePI11</code> reads this command and compares it to the IMU's Z-axis rotation rate (y[12]) and heading angle (y[9]). It generates a steering torque to track this rotational profile precisely.</li>
  <li><strong>Coupled Dynamics:</strong> The physical interaction (e.g., turning induces extra drag and sway) is automatically handled by the feedback loops, demonstrating the robustness of closed-loop control over the complex 3D hydrodynamics computed inside the plant.</li>
</ol>

<hr>
<p>
  <em>Note: The simulation utilizes specific solver flags (e.g., Euler, dynamicStateSelection) optimized for the differential-algebraic equations (DAEs) generated by the multi-body and control loop interactions.</em>
</p>


</body></html>"));
end SurgeVelocityControl;

within Aquanaut.Examples.AbstractControl;

model ShipAndEnvironment
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-72, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-38, -34}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(sphereRadius = 2, useComplexShape = true, shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", output_folder = "modelica://Aquanaut/Resources/STL/", dist_keel_cg = 1.758417010307312, time_step = 3, outputEnable = false, Cb = 0, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {66, 18}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Radiation radiation(useStream = false) annotation(
    Placement(transformation(origin = {66, -22}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(psiCurr = 0, velocityMean = 1) annotation(
    Placement(transformation(origin = {-52, -68}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Viscous viscous(Kp = 5000, Mq = 15000, Nr = 10000, Xu = 1000, Yv = 5000, Zw = 5000) annotation(
    Placement(transformation(origin = {66, -58}, extent = {{-10, -10}, {10, 10}})));
  ShipParts.Hull hull(initPos = true, sphereViewer = false, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", vesselZ0 = -0.57, Ixx = 4749.54, Iyy = 28293.74, Izz = 27690.71, Iyx = 213.75, Izx = -3411.63, Izy = 15.59, vesselMass = 4484.75) annotation(
    Placement(transformation(origin = {66, 58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(origin = {-12, 58}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-62, -34}, {-48, -34}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{56, 18}, {28, 18}, {28, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(radiation.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -22}, {28, -22}, {28, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(viscous.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -58}, {28, -58}, {28, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(frame_a, hull.frame_a) annotation(
    Line(points = {{-12, 58}, {56, 58}}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Ship and Environment Plant Model</h1>

<p>
  The <em>ShipAndEnvironment</em> model is a packaged subsystem that encapsulates the complete physical vessel, its hydrodynamic interactions, and the surrounding environment. 
  It serves as the dynamic \"Plant\" for closed-loop control simulations, exposing only a single mechanical interface for sensors and actuators.
</p>

<h2>Description</h2>

<p>
  In complex control diagrams, visualizing all physical forces (buoyancy, drag, gravity) alongside the control logic can become cluttered. 
  This model solves that by grouping the <em>Hull</em>, the <em>World</em>, the fluid <em>Stream</em>, and all <em>HydroForces</em> components into a single block. 
  It calculates the 6-DOF rigid-body dynamics internally and provides a single mechanical flange (<code>frame_a</code>) to the outside. 
  This allows control designers to easily attach idealized thrusters or IMU sensors without worrying about the underlying hydrodynamic plumbing.
</p>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Connectors of the ShipAndEnvironment block</caption>
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
      <td><strong>frame_a</strong></td>
      <td>Frame_a</td>
      <td>-</td>
      <td>3D mechanical connector physically attached to the vessel's center of mass. Used to apply control forces and read kinematic states.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Packaged subsystems and physical models</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>hull</strong></td>
      <td>Hull</td>
      <td>The central rigid body. Configured with a mass of 4110 kg and explicit moments of inertia (Ixx, Iyy, Izz).</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Calculates exact hydrostatic restoring forces utilizing the 3D STL intersection method.</td>
    </tr>
    <tr>
      <td><strong>radiation</strong></td>
      <td>Radiation</td>
      <td>Simulates potential damping and fluid memory effects for surge, heave, and pitch.</td>
    </tr>
    <tr>
      <td><strong>viscous</strong></td>
      <td>Viscous</td>
      <td>Simulates skin friction and form drag for surge, heave, and sway (using Xu, Xuu, Yv, Yvv, Zw, Zww).</td>
    </tr>
    <tr>
      <td><strong>Stream</strong></td>
      <td>Stream (inner)</td>
      <td>Provides ambient fluid properties, including a steady current with a mean velocity of 1 m/s.</td>
    </tr>
    <tr>
      <td><strong>world</strong></td>
      <td>World (inner)</td>
      <td>Defines the global inertial frame and the downward gravity vector.</td>
    </tr>
  </tbody>
</table>

<h2>System Integration Logic</h2>

<p>
  This block acts as a force aggregator and kinematic broadcaster:
</p>

<ul>
  <li><strong>Internal Aggregation:</strong> Inside the block, the <code>frame_a</code> connectors of the <em>Buoyancy</em>, <em>Radiation</em>, and <em>Viscous</em> models are all routed directly to the <em>Hull</em>'s <code>frame_a</code>. The Modelica engine automatically sums these environmental forces and torques.</li>
  <li><strong>External Exposure:</strong> The internal <em>Hull</em>'s <code>frame_a</code> is then directly connected to the block's external <code>frame_a</code> boundary.</li>
  <li><strong>Control Interface:</strong> When an external component (like an actuator or a <code>forceMomentSource</code>) connects to this block, its control forces are added directly to the environmental forces already acting on the hull. Similarly, sensors (like an <code>IMU</code>) attached to this port will correctly read the resulting accelerations, velocities, and positions of the hull.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the AbstractControl package, designed specifically to modularize and simplify the development of auto-pilot and maneuvering algorithms.</em>
</p>


</body></html>"),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(origin = {2, 10}, lineColor = {85, 170, 127}, fillColor = {85, 170, 0}, fillPattern = FillPattern.HorizontalCylinder, points = {{-80, 30}, {-80, -30}, {30, -30}, {80, 30}, {-80, 30}}), Line(origin = {2.03, -30.3}, points = {{-90.0305, -9.70056}, {-56.0305, 8.29944}, {-30.0305, -9.70056}, {3.96953, 8.29944}, {39.9695, -9.70056}, {67.9695, 10.2994}, {89.9695, -9.70056}}, color = {85, 170, 0}, thickness = 4.25, smooth = Smooth.Bezier)}));
end ShipAndEnvironment;

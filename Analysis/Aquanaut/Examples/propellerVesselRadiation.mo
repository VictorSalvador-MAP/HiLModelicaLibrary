within Aquanaut.Examples;

model propellerVesselRadiation
  extends Modelica.Icons.Example;
  ShipParts.Hull hull(initPos = true, sphereViewer = false, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", vesselZ0 = -0.57, Ixx = 4749.54, Iyy = 28293.74, Izz = 27690.71, Iyx = 213.75, Izx = -3411.63, Izy = 15.59, vesselMass = 4484.75) annotation(
    Placement(transformation(origin = {66, 58}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-72, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-38, -34}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(sphereRadius = 2, useComplexShape = true, shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", output_folder = "modelica://Aquanaut/Resources/STL/", dist_keel_cg = 1.758417010307312, time_step = 3, outputEnable = false, Cb = 10000, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {66, 18}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(psiCurr = 0, velocityMean = 1) annotation(
    Placement(transformation(origin = {-52, -68}, extent = {{-10, -10}, {10, 10}})));
  ShipParts.MarinePropeller marinePropeller(eta_R = 1, useStream = false, Fa = +2) annotation(
    Placement(transformation(origin = {-18, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact = true, phi(displayUnit = "rad"), useSupport = false) annotation(
    Placement(transformation(origin = {-48, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 600) annotation(
    Placement(transformation(origin = {-108, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 2*Modelica.Constants.pi/60) annotation(
    Placement(transformation(origin = {-80, 22}, extent = {{-6, -6}, {6, 6}})));
  HydroForces.Radiation radiation annotation(
    Placement(transformation(origin = {66, -18}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.HydroForces.Viscous viscous(Kp = 5000, Mq = 15000, Nr = 10000, Xu = 1000, Yv = 5000, Zw = 5000) annotation(
    Placement(transformation(origin = {66, -54}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-62, -34}, {-48, -34}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{56, 18}, {36, 18}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(speed.flange, marinePropeller.flange) annotation(
    Line(points = {{-38, 22}, {-28, 22}}));
  connect(marinePropeller.frame_a, hull.frame_a) annotation(
    Line(points = {{-28, 27}, {-32, 27}, {-32, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(gain.y, speed.w_ref) annotation(
    Line(points = {{-74, 22}, {-60, 22}}, color = {0, 0, 127}));
  connect(const.y, gain.u) annotation(
    Line(points = {{-97, 22}, {-88, 22}}, color = {0, 0, 127}));
  connect(radiation.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -18}, {36, -18}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(viscous.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -54}, {36, -54}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics = {Rectangle(origin = {43, 5}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-47, 89}, {47, -89}}), Text(origin = {41, 83}, textColor = {85, 85, 255}, extent = {{-45, 3}, {45, -3}}, textString = "Hydrodynamic
Forces and Torques", fontSize = 14, textStyle = {TextStyle.Bold})}, coordinateSystem(extent = {{-130, -100}, {100, 100}})),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Propeller Vessel with Radiation and Viscous Damping Example</h1>

<p>
  The <em>propellerVesselRadiation</em> example demonstrates a free-running marine craft simulation in 6 Degrees of Freedom (6-DOF). 
  It integrates rigid-body hull dynamics, exact 3D hydrostatics, an active marine propeller, and a combination of <em>Radiation</em> and <em>Viscous</em> hydrodynamic damping models.
</p>

<h2>Description</h2>

<p>
  This model serves as a system test to validate the integration of physical propulsion with multiple sources of hydrodynamic drag. 
  This simulation divides the resistance into two distinct components: the <em>Radiation</em> block handles potential damping (wave-making resistance and fluid memory), while the <em>Viscous</em> block applies empirical linear and quadratic skin friction and form drag. As the 600 RPM propeller drives the vessel forward, these blocks work together to compute the total realistic resistance acting on the hull.
</p>

<h2>System Topology</h2>

<p>
  The simulation setup consists of the following interacting domains:
</p>
<ul>
  <li><strong>Environment:</strong> A <code>World</code> model defines gravity, while a <code>Stream</code> object provides ambient fluid properties with a steady current of 1 m/s.</li>
  <li><strong>Vessel Body:</strong> The <code>Hull</code> block represents the ship's mass (4484.75 kg) and specific moments of inertia, initialized with a slight forward velocity and a specific draft.</li>
  <li><strong>Hydrostatics:</strong> The <code>Buoyancy</code> block computes restoring forces using the exact 3D STL mesh intersection with a flat wave surface.</li>
  <li><strong>Hydrodynamics:</strong> The <code>Radiation</code> block applies potential damping forces, while the <code>Viscous</code> block adds 6-DOF linear and quadratic drag (configured with specific coefficients like Kp, Mq, Nr, Xu, Yv, Zw).</li>
  <li><strong>Propulsion:</strong> A constant signal of 600 RPM is converted to rad/s to drive an ideal rotational <code>Speed</code> source, spinning the <code>MarinePropeller</code> to generate axial thrust.</li>
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
      <td><strong>hull</strong></td>
      <td>Hull</td>
      <td>The central rigid body accumulating all forces, configured with explicit mass and inertia.</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Calculates exact hydrostatic forces using boolean mesh intersections.</td>
    </tr>
    <tr>
      <td><strong>radiation</strong></td>
      <td>Radiation</td>
      <td>Calculates potential damping and wave-making resistance.</td>
    </tr>
    <tr>
      <td><strong>viscous</strong></td>
      <td>Viscous</td>
      <td>Applies empirical viscous drag coefficients to oppose vessel motion.</td>
    </tr>
    <tr>
      <td><strong>marinePropeller</strong></td>
      <td>MarinePropeller</td>
      <td>Converts shaft rotation into axial thrust to push the hull forward.</td>
    </tr>
    <tr>
      <td><strong>speed</strong></td>
      <td>Speed (Rotational)</td>
      <td>Ideal speed source enforcing the prescribed rotational velocity (600 RPM) on the propeller.</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment runs for 10 seconds and follows this dynamic sequence:
</p>
<ul>
  <li><strong>Initialization:</strong> The hull starts at its specified draft. The buoyancy solver establishes the initial hydrostatic equilibrium.</li>
  <li><strong>Propulsion Phase:</strong> The rotational speed source instantly drives the propeller. The propeller calculates the advance ratio based on the hull's speed and the fluid stream, generating forward thrust.</li>
  <li><strong>Dynamic Response:</strong> As the hull accelerates in surge, the <em>Radiation</em> and <em>Viscous</em> blocks react. The viscous block applies immediate opposing drag proportional to velocity, while the radiation block simulates the wave generation effects.</li>
  <li><strong>Equilibrium:</strong> The acceleration naturally decreases as the combined damping forces build up, driving the system towards a steady-state velocity where the propeller thrust matches the total hydrodynamic resistance.</li>
</ul>

<hr>
<p>
  <em>Note: The simulation utilizes specific solver flags (e.g., Euler, dynamicStateSelection) optimized for the differential-algebraic equations (DAEs) generated by the multi-body interactions.</em>
</p>


</body></html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end propellerVesselRadiation;

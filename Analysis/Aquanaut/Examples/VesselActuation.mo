within Aquanaut.Examples;

model VesselActuation
  extends Modelica.Icons.Example;
  ShipParts.Hull hull(initPos = true, sphereViewer = false, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", vesselZ0 = -0.57, Ixx = 4749.54, Iyy = 28293.74, Izz = 27690.71, Iyx = 213.75, Izx = -3411.63, Izy = 15.59, vesselMass = 4484.75) annotation(
    Placement(transformation(origin = {66, 58}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-72, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-38, -34}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(sphereRadius = 2, useComplexShape = true, shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", output_folder = "modelica://Aquanaut/Resources/STL/", dist_keel_cg = 1.758417010307312, time_step = 3, outputEnable = false, Cb = 0) annotation(
    Placement(transformation(origin = {66, 18}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Radiation radiation(useStream = false) annotation(
    Placement(transformation(origin = {66, -22}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(psiCurr = 0, velocityMean = 1) annotation(
    Placement(transformation(origin = {-52, -68}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Viscous viscous(Xuu = 5035, Yvv = 14916, Nrr = 221062, Zww = 21269, Kpp = 22719, Mqq = 401668) annotation(
    Placement(transformation(origin = {66, -58}, extent = {{-10, -10}, {10, 10}})));
  Utils.forceMomentSource forceMomentSource annotation(
    Placement(transformation(origin = {-28, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant force(k = 1000)  annotation(
    Placement(transformation(origin = {-78, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant moment(k = 0) annotation(
    Placement(transformation(origin = {-78, 24}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-62, -34}, {-48, -34}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{56, 18}, {36, 18}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(radiation.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -22}, {36, -22}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(viscous.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -58}, {36, -58}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(forceMomentSource.frame_b, hull.frame_a) annotation(
    Line(points = {{-18, 40}, {36, 40}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(moment.y, forceMomentSource.momentInput) annotation(
    Line(points = {{-66, 24}, {-52, 24}, {-52, 36}, {-40, 36}}, color = {0, 0, 127}));
  connect(force.y, forceMomentSource.forceInput) annotation(
    Line(points = {{-66, 56}, {-52, 56}, {-52, 44}, {-40, 44}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics = {Rectangle(origin = {42, 6}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-46, 88}, {46, -88}}), Text(origin = {41, 83}, textColor = {85, 85, 255}, extent = {{-45, 3}, {45, -3}}, textString = "Hydrodynamic
Forces and Torques", fontSize = 14, textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Vessel Actuation Example</h1>

<p>
  The <em>VesselActuation</em> example demonstrates a complete, free-running marine craft simulation in 6 Degrees of Freedom (6-DOF). 
  This model utilizes a <strong>Force and Moment Source</strong> to drive the vessel, providing a clean environment to study fundamental hull dynamics, resistance, and stability.
</p>

<h2>Description</h2>

<p>
  This model serves as a comprehensive system test for longitudinal actuation and hydrodynamic drag equilibrium. 
  It places a 3D-modeled hull in the water and pushes it forward using a constant 1000 N surge force. 
  As the vessel accelerates, the applied force is gradually counteracted by hydrodynamic resistance (modeled via the <em>Viscous</em> and <em>Radiation</em> components), eventually leading the vessel to a steady-state advance speed. 
  Simultaneously, the <em>Buoyancy</em> component ensures the vessel maintains its proper draft and trim using exact mesh-water intersection calculations.
</p>

<h2>System Topology</h2>

<p>
  The simulation setup consists of the following interacting domains:
</p>
<ul>
  <li><strong>Environment:</strong> A <code>World</code> model defines gravity, while a <code>Stream</code> object provides ambient fluid properties (with a mean velocity of 1 m/s). A <code>FixedFrame</code> provides a visual reference.</li>
  <li><strong>Vessel Body:</strong> The <code>Hull</code> block represents the ship's mass (4837.59 kg) and inertia, initialized with a slight forward velocity (0.01 m/s) and a specific draft (Z = -0.62 m).</li>
  <li><strong>Hydrodynamics (Forces &amp; Torques):</strong>
    <ul>
      <li><code>Buoyancy</code>: Computes restoring forces using the <strong>Complex Shape Mode</strong> with the hull's STL file and a flat wave surface.</li>
      <li><code>Radiation</code>: Applies potential damping and fluid memory effects (tuned for heave, surge, and pitch).</li>
      <li><code>Viscous</code>: Applies linear and quadratic drag (surge and heave resistance).</li>
    </ul>
  </li>
  <li><strong>Actuation:</strong> Two constant signal blocks (Force and Moment) feed into a <code>forceMomentSource</code>. This utility block converts the raw scalar signals into localized 3D spatial vectors applied directly to the hull's mechanical frame.</li>
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
      <td>The rigid body of the vessel, integrating all external forces. Uses an STL file for shape visualization.</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Calculates exact hydrostatic forces using boolean mesh intersections (STL vs flat wave).</td>
    </tr>
    <tr>
      <td><strong>radiation</strong></td>
      <td>Radiation</td>
      <td>Simulates wave-making resistance (potential damping) in surge, heave, and pitch.</td>
    </tr>
    <tr>
      <td><strong>viscous</strong></td>
      <td>Viscous</td>
      <td>Simulates skin friction and form drag using user-defined coefficients (Xu, Xuu).</td>
    </tr>
    <tr>
      <td><strong>forceMomentSource</strong></td>
      <td>forceMomentSource</td>
      <td>Applies the 1D signals as 3D forces and torques to the hull.</td>
    </tr>
    <tr>
      <td><strong>force, moment</strong></td>
      <td>Constant (Signal)</td>
      <td>Command signals. Force is set to 1000 N (Surge), and Moment is set to 0 N.m (Yaw).</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment runs for 10 seconds and follows this dynamic sequence:
</p>
<ul>
  <li><strong>Initialization:</strong> The hull starts at its specified draft and a minimal forward speed. The buoyancy solver immediately calculates the restoring forces to keep it afloat.</li>
  <li><strong>Force Application:</strong> The <code>forceMomentSource</code> instantly applies a steady 1000 N pushing force along the vessel's local X-axis (forward).</li>
  <li><strong>Acceleration &amp; Resistance:</strong> The force accelerates the hull. As the hull gains speed, the <em>Viscous</em> and <em>Radiation</em> damping forces increase proportionally to the velocity and its square.</li>
  <li><strong>Equilibrium:</strong> The acceleration naturally decreases as the drag forces build up. The system tends towards a steady-state velocity where the 1000 N input perfectly matches the total hydrodynamic resistance of the hull in the fluid stream.</li>
</ul>

<hr>
<p>
  <em>Note: The simulation utilizes specific solver flags (e.g., Euler, dynamicStateSelection) optimized for the differential-algebraic equations (DAEs) generated by the 3D multi-body and hydrodynamic interactions. The required STL files must be present in the designated Resources folder.</em>
</p>


</body></html>"));
end VesselActuation;

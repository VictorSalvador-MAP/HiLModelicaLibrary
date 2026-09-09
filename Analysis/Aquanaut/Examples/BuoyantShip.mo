within Aquanaut.Examples;

model BuoyantShip
  extends Modelica.Icons.Example;
  ShipParts.Hull hull(initPos = true, sphereViewer = false, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", vesselZ0 = -0.57, Ixx = 4749.54, Iyy = 28293.74, Izz = 27690.71, Iyx = 213.75, Izx = -3411.63, Izy = 15.59, vesselMass = 4484.75) annotation(
    Placement(transformation(origin = {46, 0}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-62, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-22, 20}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", output_folder = "modelica://Aquanaut/Resources/STL/", useComplexShape = true, time_step = 3, outputEnable = false, dist_keel_cg = 1.758417010307312, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {46, 36}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(velocityMean = 0, velocitySigma = 0) annotation(
    Placement(transformation(origin = {-44, -18}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.HydroForces.Viscous viscous(Kp = 5000, Mq = 15000, Nr = 10000, Xu = 1000, Yv = 5000, Zw = 5000) annotation(
    Placement(transformation(origin = {46, -36}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-52, 20}, {-32, 20}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{36, 36}, {16, 36}, {16, 0}, {36, 0}}, color = {95, 95, 95}));
  connect(viscous.frame_a, hull.frame_a) annotation(
    Line(points = {{36, -36}, {16, -36}, {16, 0}, {36, 0}}, color = {95, 95, 95}));
  annotation(
    Documentation(info = "<html><head>
</head>
<body>
<h1>Buoyant Complex Vessel Example</h1>

<p>
  The <em>BuoyantComplexVessel</em> example demonstrates the advanced hydrostatic capabilities of the <em>Aquanaut</em> library. 
  It simulates a vessel utilizing a complex 3D mesh (STL file) to compute precise buoyancy forces and restoring moments while interacting with a dynamic wave environment.
</p>

<h2>Description</h2>

<p>
  This model isolates and tests the <strong>Complex Shape Mode</strong> of the <em>Buoyancy</em> component. 
  Instead of using analytical spherical approximations, it loads a physical STL mesh of the hull (<code>UpperHull.stl</code>) and evaluates its boolean intersection with time-varying wave meshes (<code>wave_frame_*.stl</code>). 
  This setup is essential for accurately simulating the 6-DOF dynamic stability of non-standard hull forms in rough seas.
</p>

<h2>System Topology</h2>

<p>
  The simulation setup consists of the following structure:
</p>
<ul>
  <li><strong>Environment:</strong> A standard <code>World</code> model establishes the global inertial frame and gravity (Z-axis). An inner <code>Stream</code> object is also present to provide global fluid properties (like density and mean velocity) to the hydrodynamic components.</li>
  <li><strong>Vessel:</strong> A rigid-body <code>Hull</code> represents the physical mass and inertia of the vessel. It is configured to use the same 3D STL mesh for visualization.</li>
  <li><strong>Hydrodynamics:</strong> The <code>Buoyancy</code> block is attached directly to the hull's mechanical flange. It is configured to use the external C-function to calculate exact submerged volumes based on the instantaneous wave elevation.</li>
  <li><strong>Visualization:</strong> A <code>FixedFrame</code> is connected to the world to provide a visual reference coordinate system during the 3D animation.</li>
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
      <td>Rigid body of the vessel. Configured with <code>initPos = true</code> and uses <code>UpperHull.stl</code> for its visual shape model.</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Calculates restoring forces. Configured with <code>useComplexShape = true</code>, using <code>UpperHull.stl</code> and dynamic wave files (<code>wave_frame_</code>) with a step of 2s. The KG distance (<code>dist_keel_cg</code>) is set to 0.643049m.</td>
    </tr>
    <tr>
      <td><strong>Stream</strong></td>
      <td>Stream (inner)</td>
      <td>Global object providing fluid environment data. Configured with a mean velocity of 0 m/s.</td>
    </tr>
    <tr>
      <td><strong>world</strong></td>
      <td>World (inner)</td>
      <td>Defines the global gravity vector (Z-down).</td>
    </tr>
    <tr>
      <td><strong>fixedFrame</strong></td>
      <td>FixedFrame</td>
      <td>Visualizer for the world coordinate system (length = 10m).</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment is configured to run for 10 seconds (Tolerance = 1e-06, Interval = 0.01s):
</p>
<ul>
  <li><strong>Initialization:</strong> The <code>Hull</code> starts at its strictly enforced initial position (<code>initPos = true</code>).</li>
  <li><strong>Wave Interaction:</strong> At each <code>time_step</code> interval (every 2 seconds), the <em>Buoyancy</em> component calls the external C-library to calculate the intersection between the hull's current orientation and the corresponding wave STL file.</li>
  <li><strong>Force Application:</strong> The calculated exact submerged volume and Center of Buoyancy are used to generate the <em>fBuoy</em> and <em>tauBuoy</em> vectors, which are applied to the <em>Hull</em> to simulate pitch, roll, and heave responses to the waves.</li>
</ul>

<hr>
<p>
  <em>Note: This model requires the referenced STL files (UpperHull.stl and wave_frame_*.stl) to be present in the specified <code>modelica://Aquanaut/Resources/STL/</code> directory to run successfully.</em>
</p>


</body></html>"),
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"));
end BuoyantShip;

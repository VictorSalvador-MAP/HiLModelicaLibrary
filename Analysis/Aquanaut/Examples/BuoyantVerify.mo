within Aquanaut.Examples;

model BuoyantVerify
  extends Modelica.Icons.Example;
  ShipParts.Hull hull(initPos = true) annotation(
    Placement(transformation(origin = {54, 34}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-64, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-24, 46}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy annotation(
    Placement(transformation(origin = {54, 62}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(velocityMean = 0) annotation(
    Placement(transformation(origin = {-44, 12}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy1mm(useComplexShape = true, shapePath = "modelica://Aquanaut/Resources/STL/sphereRef1mm.stl", wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", output_folder = "modelica://Aquanaut/Resources/STL/", dist_keel_cg = 5, time_step = 3, outputEnable = false, noForcesAndTorques = true, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {54, 4}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.HydroForces.Buoyancy buoyancy1cm(dist_keel_cg = 5, outputEnable = false, output_folder = "modelica://Aquanaut/Resources/STL/", shapePath = "modelica://Aquanaut/Resources/STL/sphereRef1cm.stl", time_step = 3, useComplexShape = true, wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", noForcesAndTorques = true, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {54, -22}, extent = {{-10, -10}, {10, 10}})));
    Aquanaut.HydroForces.Buoyancy buoyancy10cm(dist_keel_cg = 5, outputEnable = false, output_folder = "modelica://Aquanaut/Resources/STL/", shapePath = "modelica://Aquanaut/Resources/STL/sphereRef10cm.stl", time_step = 3, useComplexShape = true, wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", noForcesAndTorques = true, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {54, -48}, extent = {{-10, -10}, {10, 10}})));

  Real error_rBuoy[3, 3] = {buoyancy1mm.rBuoy, buoyancy1cm.rBuoy, buoyancy10cm.rBuoy} - fill(buoyancy.rBuoy, 3);
  Real error_totalVolume[3] = {buoyancy1mm.totalVolume, buoyancy1cm.totalVolume, buoyancy10cm.totalVolume} - fill(buoyancy.totalVolume, 3);
  Real error_displacedVolume[3] = {buoyancy1mm.displacedVolume, buoyancy1cm.displacedVolume, buoyancy10cm.displacedVolume} - fill(buoyancy.displacedVolume, 3);
  Real error_tauBuoy[3, 3] = {buoyancy1mm.tauBuoy, buoyancy1cm.tauBuoy, buoyancy10cm.tauBuoy} - fill(buoyancy.tauBuoy, 3);

equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-54, 46}, {-34, 46}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{44, 62}, {26, 62}, {26, 34}, {44, 34}}, color = {95, 95, 95}));
  connect(buoyancy1mm.frame_a, hull.frame_a) annotation(
    Line(points = {{44, 4}, {26, 4}, {26, 34}, {44, 34}}, color = {95, 95, 95}));
  connect(buoyancy1cm.frame_a, hull.frame_a) annotation(
    Line(points = {{44, -22}, {26, -22}, {26, 34}, {44, 34}}, color = {95, 95, 95}));
  connect(buoyancy10cm.frame_a, hull.frame_a) annotation(
    Line(points = {{44, -48}, {26, -48}, {26, 34}, {44, 34}}, color = {95, 95, 95}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Buoyancy Verification Example</h1>

<p>
  The <em>BuoyantVerify</em> example serves as a validation and verification test for the <strong>Complex Shape Mode</strong> of the <em>Buoyancy</em> component. 
  It compares the precise analytical calculation of a spherical hull's buoyancy against the numerical results obtained from 3D STL meshes of the same sphere at different grid resolutions.
</p>

<h2>Description</h2>

<p>
  To ensure the accuracy of the external C-based boolean intersection solver, this model runs a side-by-side comparison. 
  It calculates the hydrostatic properties of a perfect sphere using the standard analytical formula (<code>buoyancy</code>) and simultaneously evaluates three STL representations of the same sphere with varying mesh densities: 1mm, 1cm, and 10cm. 
  By observing the error variables, users can analyze the trade-off between mesh resolution (computational cost) and volumetric accuracy.
</p>

<h2>System Topology</h2>

<p>
  The setup isolates the hydrostatic calculations to prevent dynamic feedback loops during verification:
</p>
<ul>
  <li><strong>Hull:</strong> A single static <code>Hull</code> serves as the mechanical reference point.</li>
  <li><strong>Analytical Baseline:</strong> The standard <code>buoyancy</code> block computes the exact total volume, displaced volume, and center of buoyancy.</li>
  <li><strong>Mesh Evaluators:</strong> Three modified <em>Buoyancy</em> blocks load the STL files. They are configured with <code>noForcesAndTorques = true</code>, meaning they act as \"ghost\" sensors that compute the hydrostatic properties without actually applying redundant forces to the hull, preventing physical instability.</li>
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
      <td>Static rigid body used as the reference frame (<code>initPos = true</code>).</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Analytical solver for the sphere (Baseline/Ground Truth).</td>
    </tr>
    <tr>
      <td><strong>buoyancy1mm, 1cm, 10cm</strong></td>
      <td>Buoyancy</td>
      <td>Numerical solvers using <code>sphereRef*.stl</code> files. Configured to track properties without applying forces.</td>
    </tr>
    <tr>
      <td><strong>Stream</strong></td>
      <td>Stream (inner)</td>
      <td>Provides the fluid environment density and zero velocity.</td>
    </tr>
  </tbody>
</table>

<h2>Verification Metrics (Error Variables)</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Calculated Error Variables</caption>
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
      <td><em>error_totalVolume</em></td>
      <td>Real[3]</td>
      <td>m³</td>
      <td>Difference in the calculated total volume between the 3 meshes and the analytical baseline.</td>
    </tr>
    <tr>
      <td><em>error_displacedVolume</em></td>
      <td>Real[3]</td>
      <td>m³</td>
      <td>Difference in the calculated submerged (displaced) volume.</td>
    </tr>
    <tr>
      <td><em>error_rBuoy</em></td>
      <td>Real[3, 3]</td>
      <td>m</td>
      <td>Difference vectors for the Center of Buoyancy (X, Y, Z) for each mesh.</td>
    </tr>
    <tr>
      <td><em>error_tauBuoy</em></td>
      <td>Real[3, 3]</td>
      <td>N.m</td>
      <td>Difference vectors for the calculated restoring moments.</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  When the 10-second simulation runs:
</p>
<ul>
  <li>All four buoyancy models continuously evaluate the static hull's position relative to the flat wave surface.</li>
  <li>The continuous error arrays (<code>error_*</code>) subtract the analytical \"true\" values from the numerical mesh approximations.</li>
  <li>The user can plot these error variables to verify that the 1mm mesh yields the smallest deviation from the exact mathematical solution, validating the external solver's volumetric integration algorithms.</li>
</ul>

<hr>
<p>
  <em>Note: This model uses custom solver flags (e.g., PFPlusExt, dynamicStateSelection) and requires the high-resolution reference STL files to be present in the Resources folder.</em>
</p>


</body></html>"));
end BuoyantVerify;

within Aquanaut.Examples;

model BuoyantVessel
  extends Modelica.Icons.Example;
  ShipParts.Hull hull(initPos = true) annotation(
    Placement(transformation(origin = {52, -22}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-58, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-18, 18}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy annotation(
    Placement(transformation(origin = {52, 18}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(velocityMean = 0) annotation(
    Placement(transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-48, 18}, {-28, 18}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{42, 18}, {22, 18}, {22, -22}, {42, -22}}, color = {95, 95, 95}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Buoyant Vessel Example</h1>

<p>
  The <i>BuoyantVessel</i> model is a fundamental demonstration of the <i>Aquanaut</i> library's ability to simulate <strong>hydrostatic equilibrium</strong>. 
  It showcases the passive interaction between a rigid hull and the fluid environment, determining how the vessel floats and stabilizes in a <strong>6 Degrees of Freedom (6-DOF)</strong> space.
</p>



<h2>Model Structure</h2>

<p>
  The example is built by connecting the following key components:
</p>

<ul>
  <li><strong>Hull (ShipParts.Hull):</strong> Defines the physical properties of the vessel, including mass, moments of inertia, and the geometric center. It acts as the primary rigid body.</li>
  <li><strong>Buoyancy (HydroForces.Buoyancy):</strong> Calculates the upward force based on Archimedes' principle. It is connected to the <code>hull.frame_a</code> to apply the resulting <i>moment</i> and vertical force directly to the body.</li>
  <li><strong>World (MultiBody.World):</strong> Establishes the global coordinate system and the gravity vector (defined as <i>n = {0, 0, 1}</i> for the Z-axis).</li>
</ul>



<h2>Physical Principles</h2>

<p>
  The simulation focuses on the balance of the <strong>generalized force vector</strong>:
</p>

<ul>
  <li><strong>Hydrostatic Balance:</strong> The vessel displaces a volume of water, generating a buoyancy force that opposes gravity. The equilibrium depth (draft) is reached when these forces are equal.</li>
  <li><strong>Stability and Restoration:</strong> As the vessel rotates in roll or pitch, the Center of Buoyancy (CB) shifts. This creates a restoring <i>moment</i> that acts to return the hull to its upright position, provided the Center of Gravity (CG) is properly aligned.</li>
  <li><strong>Coordinate Alignment:</strong> The use of a <code>FixedFrame</code> and the <code>World</code> object ensures that the buoyancy force is always aligned with the global vertical axis, regardless of the vessel's orientation.</li>
</ul>

<h2>Key Simulation Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"5\">
  <tbody><tr bgcolor=\"#f2f2f2\">
    <th>Component</th>
    <th>Parameter</th>
    <th>Role in Simulation</th>
  </tr>
  <tr>
    <td><strong>Hull</strong></td>
    <td>Mass / Inertia</td>
    <td>Determines the gravitational pull and the resistance to angular acceleration.</td>
  </tr>
  <tr>
    <td><strong>Buoyancy</strong></td>
    <td>Fluid Density (ρ)</td>
    <td>Calculates the magnitude of the buoyant force based on the displaced volume.</td>
  </tr>
  <tr>
    <td><strong>World</strong></td>
    <td>Gravity (g)</td>
    <td>Sets the acceleration constant for the weight calculation.</td>
  </tr>
</tbody></table>

<h2>Expected Behavior</h2>

<p>
  When the simulation starts:
</p>
<ol>
  <li>The vessel may exhibit damped oscillations in the heave (vertical) axis as it settles into the water.</li>
  <li>The final steady-state position represents the point where the <b>buoyancy force</b> perfectly cancels the <b>vessel weight</b>.</li>
  <li>Users can modify the hull's mass or volume to observe immediate changes in the resulting draft.</li></ol>


</body></html>"));
end BuoyantVessel;

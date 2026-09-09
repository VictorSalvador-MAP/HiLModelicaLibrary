within Aquanaut.Examples;

model DriftVessel
  extends Modelica.Icons.Example;

  ShipParts.Hull hull(initPos = true, sphereRadius = 5, vesselZ0 = -5, Ixx = 47000, Iyy = 47000, Izz = 47000) annotation(
    Placement(transformation(origin = {66, 58}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-68, -82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-26, -82}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(sphereRadius = 5) annotation(
    Placement(transformation(origin = {66, 18}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Radiation radiation(mAdded = [455.494413955984, -0, 0, 0, -0.00864434642110109, 0; -0, 453.682481028105, 0, 0.00742942530533942, -0, 0; 0, 0, 13748.9896712142, -0, -0, 0; 0, 0.00691001233104344, -0, 0.0016971358733183, -0, 0; -0.00812379927826578, -0, -0, -0, 0.00169794567206213, -0; 0, 0, 0, 0, -0, 0], A_Surge = [-0, -0, -0, -1.12860808521148; 1, 0, -0, -0.430264328831242; 0, 10, -0, -1.55104379162881; 0, 0, 100, -13.2396676311759], B_Surge = [0; 2.78728752851724; 7.98889877004811; 49.81326389782], C_Surge = [0, 0, 0, 112.860808521148], A_PitchOnSurge = [-0, -0, 0.966728131816355; 10, 0, 5.05058407357629; 0, -10, -13.726088984243], B_PitchOnSurge = [0; -0.17129622944361; 0.838284435414208], C_PitchOnSurge = [0, 0, -9.66728131816357], A_Sway = [-0, -0, 0, 0.977556868857122; 1, -0, 0, 0.475160441141621; 0, -10, -0, -1.76672851202708; 0, 0, 100, -18.250266483422], B_Sway = [-0; -2.66525742290095; 12.8484862924022; 73.4402882813751], C_Sway = [0, 0, 0, 97.755686885712], A_RollOnSway = [-0, -0, 8.10978872919685; -1, 0, -4.70377090698373; 0, 10, -13.652399632939], B_RollOnSway = [0; 0.0160824403620926; 0.103326042715481], C_RollOnSway = [0, 0, 81.0978872919685], A_Heave = [-0, -0, -0, 0.865223882437081; 0.999999999999998, -0, 0, 0.703363125226059; 0, -10, 0, -2.53409692949756; 0, 0, 100, -24.8540725118011], B_Heave = [0; -15.8045970197491; 46.1457796835816; 119.125442841311], C_Heave = [0, 0, 0, 865.223882437079], A_SwayOnRoll = [-0, -0, 7.7757522862456; -1, -0, -4.64931244730949; 0, 10, -13.9135830504123], B_SwayOnRoll = [0; 0.0155482327314337; 0.110415110059048], C_SwayOnRoll = [0, 0, 77.7575228624559], A_Roll = [-0, 0, 1.08233180100564; -10, 0, -6.13741455918629; 0, 10, -15.2132411463296], B_Roll = [0; 0.000102245163422647; 0.000611085296852233], C_Roll = [0, 0, 10.8233180100564], A_SurgeOnPitch = [-0, 0, 8.49719642282624; 0.999999999999999, -0, 4.78743567874144; 0, -10, -13.5242009981611], B_SurgeOnPitch = [-0; -0.0164291841139963; 0.096182062221426], C_SurgeOnPitch = [0, 0, -84.9719642282624], A_Pitch = [0, 0, 1.33726134997329; -10, 0, -6.60960314784301; 0, 10, -15.4203383828089], B_Pitch = [-0; 0.000107704091843465; 0.000477262319601613], C_Pitch = [0, 0, 13.3726134997329], useStream = true) annotation(
    Placement(transformation(origin = {66, -22}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(psiCurr = 0.7853981633974483)  annotation(
    Placement(transformation(origin = {-68, -52}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-58, -82}, {-36, -82}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{56, 18}, {36, 18}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(radiation.frame_a, buoyancy.frame_a) annotation(
    Line(points = {{56, -22}, {36, -22}, {36, 18}, {56, 18}}, color = {95, 95, 95}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics = {Rectangle(origin = {33, 27}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-53, 67}, {53, -67}}), Text(origin = {33, 85}, textColor = {85, 85, 255}, extent = {{-45, 3}, {45, -3}}, textString = "Ocean Current at 45º", fontSize = 14, textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html>
<head>
</head>
<body>
<h1>Drift Vessel Example</h1>

<p>
  The <em>DriftVessel</em> example demonstrates the configuration of a passive marine vessel subject to environmental interactions, specifically a global ocean current. 
  It illustrates how to connect the fundamental hydrodynamic components and configure the global <strong>Stream</strong> object to introduce fluid velocity into the simulation.
</p>

<h2>Description</h2>

<p>
  This simulation places a floating vessel (modeled as a sphere) into a fluid field with a defined current direction. 
  The system is composed of a rigid hull, a buoyancy model for hydrostatic equilibrium, and a radiation model for added mass effects.
  A key feature of this example is the activation of the <code>useStream</code> parameter, which links the vessel's hydrodynamics to the global fluid velocity defined in the <code>Stream</code> component.
</p>

<h2>System Topology</h2>

<p>
  The simulation setup consists of:
</p>
<ul>
  <li><strong>Environment:</strong> Includes a standard <code>World</code> model and a global <code>Stream</code> object defining a current flowing at 45&deg; (North-East).</li>
  <li><strong>Vessel:</strong> A spherical <code>Hull</code> initialized at a depth of 2 meters (<code>vesselZ0 = -2</code>).</li>
  <li><strong>Hydrodynamics:</strong>
    <ul>
      <li><code>Buoyancy</code>: Provides hydrostatic restoring forces to keep the vessel afloat.</li>
      <li><code>Radiation</code>: Configured with <code>useStream=true</code> to account for relative fluid motion. Potential damping coefficients (K) are set to zero in this scenario to isolate inertial effects.</li>
    </ul>
  </li>
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
      <td>The rigid body representing the vessel (Sphere, Radius: 2m).</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Maintains the vertical equilibrium of the sphere.</td>
    </tr>
    <tr>
      <td><strong>radiation</strong></td>
      <td>Radiation</td>
      <td>Handles added mass interactions. Configured with <em>useStream=true</em> and zero damping (K=0).</td>
    </tr>
    <tr>
      <td><strong>Stream</strong></td>
      <td>Stream</td>
      <td>Defines the ocean current velocity and heading (approx. 0.78 rad or 45&deg;).</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment follows this timeline (0 to 10 seconds):
</p>
<ul>
  <li><strong>Initialization:</strong> The vessel starts at equilibrium depth. The stream is active with a heading of 45&deg;.</li>
  <li><strong>Dynamics:</strong> The <em>Radiation</em> block computes added mass forces based on the relative acceleration between the vessel and the fluid. Since the fluid (Stream) may have stochastic variations, the vessel experiences inertial forces.</li>
  <li><strong>Observation:</strong> As the damping is zero in this specific setup, the simulation focuses on verifying the correct connection and transformation of current velocities into the body frame without the masking effect of heavy viscous drag.</li>
</ul>

<hr>
<p>
  <em>Note: This model serves as a base verification for environmental setup. For realistic drifting behavior including drag, a Viscous component should be added.</em>
</p>

</body>
</html>"));
end DriftVessel;

within Aquanaut.Examples;

model FreeFloating
  extends Modelica.Icons.Example;

  ShipParts.Hull hull(initPos = true, sphereRadius = 5, vesselZ0 = -5, Ixx = 47000, Iyy = 47000, Izz = 47000)  annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1})  annotation(
    Placement(transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10)  annotation(
    Placement(transformation(origin = {-28, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Forces.WorldForce force annotation(
    Placement(transformation(origin = {2, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(startTime = 2, height = 1000)  annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = -1000, startTime = 10)  annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(transformation(origin = {-30, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Forces.WorldTorque torque(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b)  annotation(
    Placement(transformation(origin = {2, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step2(height = 5000, startTime = 2) annotation(
    Placement(transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step11(height = -5000, startTime = 2.01) annotation(
    Placement(transformation(origin = {-70, 38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(Cb = 10000, sphereRadius = 5)  annotation(
    Placement(transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Radiation radiation(mAdded = [455.494413955984, -0, 0, 0, -0.00864434642110109, 0; -0, 453.682481028105, 0, 0.00742942530533942, -0, 0; 0, 0, 13748.9896712142, -0, -0, 0; 0, 0.00691001233104344, -0, 0.0016971358733183, -0, 0; -0.00812379927826578, -0, -0, -0, 0.00169794567206213, -0; 0, 0, 0, 0, -0, 0], A_Surge = [-0, -0, -0, -1.12860808521148; 1, 0, -0, -0.430264328831242; 0, 10, -0, -1.55104379162881; 0, 0, 100, -13.2396676311759], B_Surge = [0; 2.78728752851724; 7.98889877004811; 49.81326389782], C_Surge = [0, 0, 0, 112.860808521148], A_PitchOnSurge = [-0, -0, 0.966728131816355; 10, 0, 5.05058407357629; 0, -10, -13.726088984243], B_PitchOnSurge = [0; -0.17129622944361; 0.838284435414208], C_PitchOnSurge = [0, 0, -9.66728131816357], A_Sway = [-0, -0, 0, 0.977556868857122; 1, -0, 0, 0.475160441141621; 0, -10, -0, -1.76672851202708; 0, 0, 100, -18.250266483422], B_Sway = [-0; -2.66525742290095; 12.8484862924022; 73.4402882813751], C_Sway = [0, 0, 0, 97.755686885712], A_RollOnSway = [-0, -0, 8.10978872919685; -1, 0, -4.70377090698373; 0, 10, -13.652399632939], B_RollOnSway = [0; 0.0160824403620926; 0.103326042715481], C_RollOnSway = [0, 0, 81.0978872919685], A_Heave = [-0, -0, -0, 0.865223882437081; 0.999999999999998, -0, 0, 0.703363125226059; 0, -10, 0, -2.53409692949756; 0, 0, 100, -24.8540725118011], B_Heave = [0; -15.8045970197491; 46.1457796835816; 119.125442841311], C_Heave = [0, 0, 0, 865.223882437079], A_SwayOnRoll = [-0, -0, 7.7757522862456; -1, -0, -4.64931244730949; 0, 10, -13.9135830504123], B_SwayOnRoll = [0; 0.0155482327314337; 0.110415110059048], C_SwayOnRoll = [0, 0, 77.7575228624559], A_Roll = [-0, 0, 1.08233180100564; -10, 0, -6.13741455918629; 0, 10, -15.2132411463296], B_Roll = [0; 0.000102245163422647; 0.000611085296852233], C_Roll = [0, 0, 10.8233180100564], A_SurgeOnPitch = [-0, 0, 8.49719642282624; 0.999999999999999, -0, 4.78743567874144; 0, -10, -13.5242009981611], B_SurgeOnPitch = [-0; -0.0164291841139963; 0.096182062221426], C_SurgeOnPitch = [0, 0, -84.9719642282624], A_Pitch = [0, 0, 1.33726134997329; -10, 0, -6.60960314784301; 0, 10, -15.4203383828089], B_Pitch = [-0; 0.000107704091843465; 0.000477262319601613], C_Pitch = [0, 0, 13.3726134997329])  annotation(
    Placement(transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream annotation(
    Placement(transformation(origin = {4, -80}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-60, -80}, {-38, -80}}, color = {95, 95, 95}));
  connect(step1.y, add.u2) annotation(
    Line(points = {{-59, -40}, {-43, -40}, {-43, -26}}, color = {0, 0, 127}));
  connect(step.y, add.u1) annotation(
    Line(points = {{-59, 0}, {-43, 0}, {-43, -14}}, color = {0, 0, 127}));
  connect(add.y, force.force[1]) annotation(
    Line(points = {{-19, -20}, {-10, -20}}, color = {0, 0, 127}));
  connect(step2.y, add1.u1) annotation(
    Line(points = {{-59, 80}, {-43, 80}, {-43, 66}}, color = {0, 0, 127}));
  connect(step11.y, add1.u2) annotation(
    Line(points = {{-59, 38}, {-43, 38}, {-43, 54}}, color = {0, 0, 127}));
  connect(add1.y, torque.torque[2]) annotation(
    Line(points = {{-19, 60}, {-11, 60}}, color = {0, 0, 127}));
  connect(const.y, torque.torque[1]) annotation(
    Line(points = {{-19, 20}, {-11, 20}, {-11, 60}}, color = {0, 0, 127}));
  connect(const.y, torque.torque[3]) annotation(
    Line(points = {{-19, 20}, {-11, 20}, {-11, 60}}, color = {0, 0, 127}));
  connect(const.y, force.force[2]) annotation(
    Line(points = {{-19, 20}, {-11, 20}, {-11, -20}}, color = {0, 0, 127}));
  connect(const.y, force.force[3]) annotation(
    Line(points = {{-19, 20}, {-11, 20}, {-11, -20}}, color = {0, 0, 127}));
  connect(force.frame_b, hull.frame_a) annotation(
    Line(points = {{12, -20}, {26, -20}, {26, 20}, {60, 20}}, color = {95, 95, 95}));
  connect(torque.frame_b, hull.frame_a) annotation(
    Line(points = {{12, 60}, {26, 60}, {26, 20}, {60, 20}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{60, -20}, {40, -20}, {40, 20}, {60, 20}}, color = {95, 95, 95}));
  connect(radiation.frame_a, hull.frame_a) annotation(
    Line(points = {{60, -60}, {40, -60}, {40, 20}, {60, 20}}, color = {95, 95, 95}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics = {Rectangle(origin = {72, -5}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-28, 77}, {28, -77}}), Rectangle(origin = {-31, 19}, lineColor = {85, 0, 255}, lineThickness = 0.75, extent = {{-61, 79}, {61, -79}}), Text(origin = {0, 90}, textColor = {85, 0, 255}, extent = {{-24, 4}, {24, -4}}, textString = "External Forces
and Torques", fontSize = 14, textStyle = {TextStyle.Bold}), Text(origin = {72, 55}, textColor = {85, 85, 255}, extent = {{-22, 3}, {22, -3}}, textString = "Hydrodynamic
Forces and
Torques", fontSize = 14, textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Free Floating Vessel Dynamics</h1>

<p>
  The <i>FreeFloating</i> model is an advanced simulation environment designed to test the dynamic response of a vessel's hull to external perturbations. 
  Unlike purely hydrostatic models, this example incorporates <strong>active external forces</strong> and <strong>hydrodynamic radiation</strong> to analyze how the vessel recovers its equilibrium in a <strong>6 Degrees of Freedom (6-DOF)</strong> space.
</p>



<h2>Model Composition</h2>

<p>
  The simulation is divided into two main logical groups, as highlighted in the model's diagram:
</p>

<ul>
  <li><strong>External Forces and Torques:</strong> A combination of <code>Step</code> sources, <code>Math.Add</code> blocks, and <code>Constant</code> values that drive a <code>WorldForce</code> and a <code>WorldTorque</code>. This setup simulates environmental impacts or docking pulses.</li>
  <li><strong>Hydrodynamic Forces:</strong> This includes the <code>Buoyancy</code> block for static lift and the <code>Radiation</code> block, which accounts for the energy dissipated by the vessel as it moves and creates waves (added mass and damping).</li>
  <li><strong>The Hull:</strong> A spherical hull (<code>sphereRadius = 2</code>) initialized at a specific depth (<code>vesselZ0 = -2</code>) to study the transition to stability.</li>
</ul>

<h2>Physical Principles and Perturbations</h2>

<p>
  This model is specifically designed to observe the vessel's <b>Step Response</b>. The <strong>generalized force vector</strong> is influenced by:
</p>



<ul>
  <li><strong>Surge Perturbation:</strong> A constant force of 1000 N is applied in the X-axis (surge) at <i>t = 2s</i> and removed at <i>t = 10s</i> via two opposing step functions.</li>
  <li><strong>Pitch Impulse:</strong> A momentary torque pulse of 0.1 Nm is applied at <i>t = 2s</i> to the Y-axis (pitch) to observe the vessel's longitudinal stability.</li>
  <li><strong>Radiation Damping:</strong> The <code>Radiation</code> block applies restorative damping (e.g., <code>KHeave = 10000</code>, <code>KPitch = 0.1</code>). Without this, the vessel would oscillate indefinitely; with it, the energy from the external pulses is dissipated into the \"fluid.\"</li>
</ul>



<h2>Key Simulation Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"5\">
  <tbody><tr bgcolor=\"#f2f2f2\">
    <th>Component</th>
    <th>Parameter</th>
    <th>Value / Description</th>
  </tr>
  <tr>
    <td><strong>Hull</strong></td>
    <td>sphereRadius</td>
    <td>2.0 m (Defines the displaced volume and inertia).</td>
  </tr>
  <tr>
    <td><strong>Radiation</strong></td>
    <td>KHeave / KSurge</td>
    <td>10000 / 100 (Damping coefficients for vertical and longitudinal motion).</td>
  </tr>
  <tr>
    <td><strong>Step Sources</strong></td>
    <td>startTime</td>
    <td>Forces are triggered at 2.0s to allow the solver to settle the initial buoyancy.</td>
  </tr>
</tbody></table>

<h2>Expected Results</h2>

<p>
  When running this simulation, the user should monitor:
</p>
<ol>
  <li>The <b>Surge Velocity</b>: Notice how the vessel accelerates when the 1000 N force is applied and how the radiation damping eventually limits the top speed.</li>
  <li>The <b>Pitch Angle</b>: The small 0.1 Nm pulse will cause a dip, followed by a damped return to the horizontal plane.</li>
  <li>The <b>Heave Stabilization</b>: Since the vessel starts at <i>Z = -2</i>, it will \"pop\" or sink slightly to find its natural flotation line before the external forces even begin.</li>
</ol>

<p>
  This example was developed by <strong>MWF Mechatronics</strong> under the direction of <strong>Prof. Dr. Alexandre Carvalho Leite</strong>.
</p>

<hr>
<p>
  <i>Note: This model is critical for verifying the coupling between control inputs and hydrodynamic damping.</i>
</p>


</body></html>"));
end FreeFloating;

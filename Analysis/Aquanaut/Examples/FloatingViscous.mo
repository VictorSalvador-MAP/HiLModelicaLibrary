within Aquanaut.Examples;

model FloatingViscous
  extends Modelica.Icons.Example;

  ShipParts.Hull hull(initPos = true, sphereRadius = 5, vesselZ0 = -5, Ixx = 47000, Iyy = 47000, Izz = 47000) annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-28, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Forces.WorldForce force annotation(
    Placement(transformation(origin = {8, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(startTime = 2, height = 10000) annotation(
    Placement(transformation(origin = {-72, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step1(height = -10000, startTime = 7) annotation(
    Placement(transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k1 = 1, k2 = 1) annotation(
    Placement(transformation(origin = {-32, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-32, 60}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(Cb = 10000, sphereRadius = 5) annotation(
    Placement(transformation(origin = {70, -20}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Viscous viscous(Xu = 0, Xuu = 0, Yv = 2000, Yvv = 2000) annotation(
    Placement(transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream annotation(
    Placement(transformation(origin = {6, -80}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-60, -80}, {-38, -80}}, color = {95, 95, 95}));
  connect(step1.y, add.u2) annotation(
    Line(points = {{-61, 0}, {-45, 0}, {-45, 14}}, color = {0, 0, 127}));
  connect(step.y, add.u1) annotation(
    Line(points = {{-61, 40}, {-45, 40}, {-45, 26}}, color = {0, 0, 127}));
  connect(force.frame_b, hull.frame_a) annotation(
    Line(points = {{18, 20}, {60, 20}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{60, -20}, {40, -20}, {40, 20}, {60, 20}}, color = {95, 95, 95}));
  connect(viscous.frame_a, hull.frame_a) annotation(
    Line(points = {{60, -60}, {40, -60}, {40, 20}, {60, 20}}, color = {95, 95, 95}));
  connect(const.y, force.force[1]) annotation(
    Line(points = {{-21, 60}, {-13, 60}, {-13, 20}, {-5, 20}}, color = {0, 0, 127}));
  connect(add.y, force.force[2]) annotation(
    Line(points = {{-21, 20}, {-5, 20}}, color = {0, 0, 127}));
  connect(const.y, force.force[3]) annotation(
    Line(points = {{-21, 60}, {-13, 60}, {-13, 20}, {-5, 20}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics = {Rectangle(origin = {70, -5}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-24, 77}, {24, -77}}), Rectangle(origin = {-31, 19}, lineColor = {85, 0, 255}, lineThickness = 0.75, extent = {{-61, 79}, {61, -79}}), Text(origin = {0, 90}, textColor = {85, 0, 255}, extent = {{-24, 4}, {24, -4}}, textString = "External Forces
and Torques", fontSize = 14, textStyle = {TextStyle.Bold}), Text(origin = {70, 56}, textColor = {85, 85, 255}, extent = {{-24, 4}, {24, -4}}, textString = "Hydrodynamic
Forces and
Torques", fontSize = 14, textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Floating Viscous Damping Example</h1>

<p>
  The <em>FloatingViscous</em> example demonstrates the effect of hydrodynamic damping on a floating vessel. 
  It simulates a simple hull subjected to a lateral external force pulse, allowing the observation of how linear and quadratic viscous friction (drag) dissipates kinetic energy and limits the drift velocity.
</p>

<h2>Description</h2>

<p>
  This model isolates the damping characteristics of the <em>HydroForces</em> package. 
  A spherical hull is placed in the water and subjected to a defined step force in the sway (Y) direction. 
  By equipping the hull with the <em>Viscous</em> component, the simulation shows the resistance to motion caused by the fluid, contrasting the acceleration phase with the terminal velocity or deceleration phase.
</p>

<h2>System Topology</h2>

<p>
  The simulation setup consists of:
</p>
<ul>
  <li><strong>Environment:</strong> A standard <code>World</code> model with gravity acting in the -Z direction.</li>
  <li><strong>Vessel:</strong> A spherical <code>Hull</code> initialized at a depth of 2 meters (<code>vesselZ0 = -2</code>).</li>
  <li><strong>Hydrodynamics:</strong>
    <ul>
      <li><code>Buoyancy</code>: Provides the hydrostatic restoring force to keep the vessel afloat (Heave stiffness).</li>
      <li><code>Viscous</code>: Applies resistance forces based on velocity. Configured here with significant Sway damping (<em>Y<sub>v</sub></em> and <em>Y<sub>vv</sub></em>).</li>
    </ul>
  </li>
  <li><strong>Disturbance:</strong> A <code>WorldForce</code> block applies a programmable force vector directly to the hull's center of mass, driven by signal blocks.</li>
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
      <td>The rigid body representing the vessel (Mass: 4700kg).</td>
    </tr>
    <tr>
      <td><strong>viscous</strong></td>
      <td>Viscous</td>
      <td>Damping model. Configured with <em>Yv=2000</em> (Linear) and <em>Yvv=2000</em> (Quadratic).</td>
    </tr>
    <tr>
      <td><strong>buoyancy</strong></td>
      <td>Buoyancy</td>
      <td>Maintains the vertical equilibrium of the sphere.</td>
    </tr>
    <tr>
      <td><strong>force</strong></td>
      <td>WorldForce</td>
      <td>Applies the external lateral push.</td>
    </tr>
    <tr>
      <td><strong>step / step1</strong></td>
      <td>Step</td>
      <td>Signal generators creating a rectangular force pulse (1000 N from t=2s to t=7s).</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment follows this timeline (0 to 10 seconds):
</p>
<ul>
  <li><strong>0s - 2s:</strong> The vessel sits at equilibrium. Buoyancy counteracts gravity.</li>
  <li><strong>2s:</strong> A lateral force of 1000 N is applied in the Y-axis. The vessel accelerates.</li>
  <li><strong>2s - 7s:</strong> As velocity increases, the <em>Viscous</em> component generates an opposing force (<em>F<sub>d</sub> = Y<sub>v</sub>v + Y<sub>vv</sub>|v|v</em>). The vessel eventually reaches a terminal velocity where the drag matches the input force.</li>
  <li><strong>7s:</strong> The external force is removed (Step1 cancels Step).</li>
  <li><strong>&gt; 7s:</strong> The vessel coasts and decelerates purely due to the hydrodynamic damping until it stops.</li>
</ul>

<hr>
<p>
  <em>Note: This model is useful for tuning drag coefficients (Yv, Yvv) by comparing the simulated velocity profile against real-world decay tests or sea trial data.</em>
</p>


</body></html>"));
end FloatingViscous;

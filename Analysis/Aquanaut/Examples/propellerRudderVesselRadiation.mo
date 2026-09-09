within Aquanaut.Examples;

model propellerRudderVesselRadiation
  extends Modelica.Icons.Example;
  ShipParts.Hull hull(initPos = true, sphereViewer = false, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", vesselZ0 = -0.57, Ixx = 4749.54, Iyy = 28293.74, Izz = 27690.71, Iyx = 213.75, Izx = -3411.63, Izy = 15.59, vesselMass = 4484.75) annotation(
    Placement(transformation(origin = {66, 58}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-72, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-38, -34}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Buoyancy buoyancy(sphereRadius = 2, useComplexShape = true, shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_", output_folder = "modelica://Aquanaut/Resources/STL/", dist_keel_cg = 1.758417010307312, time_step = 10, outputEnable = false, Cb = 10000, useSTLPositionXY = true) annotation(
    Placement(transformation(origin = {66, 18}, extent = {{-10, -10}, {10, 10}})));
  inner HydroForces.Stream Stream(psiCurr = 0, velocityMean = 1) annotation(
    Placement(transformation(origin = {-52, -68}, extent = {{-10, -10}, {10, 10}})));
  HydroForces.Radiation radiation(useStream = false) annotation(
    Placement(transformation(origin = {66, -18}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.ShipParts.MarinePropeller marinePropeller(eta_R = 1, useStream = false, Fa = +2) annotation(
    Placement(transformation(origin = {-68, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact = true, phi(displayUnit = "rad"), useSupport = false) annotation(
    Placement(transformation(origin = {-104, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 800) annotation(
    Placement(transformation(origin = {-166, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 2*Modelica.Constants.pi/60) annotation(
    Placement(transformation(origin = {-136, 18}, extent = {{-6, -6}, {6, 6}})));
  Aquanaut.ShipParts.MarineRudder marineRudder annotation(
    Placement(transformation(origin = {-26, 20}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.Utils.AngleOutput angleOutput(angle = 0.17453292519943295) annotation(
    Placement(transformation(origin = {-70, 42}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.HydroForces.Viscous viscous(Kp = 5000, Mq = 15000, Nr = 10000, Xu = 1000, Yv = 5000, Zw = 5000) annotation(
    Placement(transformation(origin = {66, -58}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-62, -34}, {-48, -34}}, color = {95, 95, 95}));
  connect(buoyancy.frame_a, hull.frame_a) annotation(
    Line(points = {{56, 18}, {36, 18}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(radiation.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -18}, {36, -18}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(const.y, gain.u) annotation(
    Line(points = {{-155, 18}, {-143, 18}}, color = {0, 0, 127}));
  connect(gain.y, speed.w_ref) annotation(
    Line(points = {{-129.4, 18}, {-116.4, 18}}, color = {0, 0, 127}));
  connect(speed.flange, marinePropeller.flange) annotation(
    Line(points = {{-94, 18}, {-78, 18}}));
  connect(angleOutput.phi, marineRudder.angleInput) annotation(
    Line(points = {{-59, 42}, {-44, 42}, {-44, 28}, {-38, 28}}, color = {0, 0, 127}));
  connect(marinePropeller.wakeFraction, marineRudder.wakeFraction) annotation(
    Line(points = {{-57.2, 22.2}, {-47.2, 22.2}, {-47.2, 24.2}, {-37.2, 24.2}}, color = {0, 0, 127}));
  connect(marinePropeller.flowDiameter, marineRudder.flowDiameter) annotation(
    Line(points = {{-57.1, 18}, {-37.1, 18}}, color = {0, 0, 127}));
  connect(marinePropeller.flowSpeed, marineRudder.flowSpeed) annotation(
    Line(points = {{-57.1, 14.2}, {-47.1, 14.2}, {-47.1, 12.2}, {-37.1, 12.2}}, color = {0, 0, 127}));
  connect(marineRudder.frame_a, hull.frame_a) annotation(
    Line(points = {{-16, 20}, {12, 20}, {12, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(marinePropeller.frame_a, hull.frame_a) annotation(
    Line(points = {{-78, 22}, {-88, 22}, {-88, 58}, {56, 58}}, color = {95, 95, 95}));
  connect(viscous.frame_a, hull.frame_a) annotation(
    Line(points = {{56, -58}, {36, -58}, {36, 58}, {56, 58}}, color = {95, 95, 95}));
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(graphics = {Rectangle(origin = {46, 9}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-44, 85}, {44, -85}}), Text(origin = {41, 83}, textColor = {85, 85, 255}, extent = {{-45, 3}, {45, -3}}, textString = "Hydrodynamic
Forces and Torques", fontSize = 14, textStyle = {TextStyle.Bold})}, coordinateSystem(extent = {{-130, -100}, {100, 100}})),
    Documentation(info = "<html>
<head>
</head>
<body>
<h1>Propeller and Rudder Vessel with Radiation and Viscous Damping Example</h1>

<p>
  The <em>propellerRudderVesselRadiation</em> example demonstrates a fully coupled marine propulsion and steering system in 6 Degrees of Freedom (6-DOF). 
  It integrates rigid-body hull dynamics, exact 3D hydrostatics, an active marine propeller, a rudder interacting with the propeller's slipstream, and a combination of <em>Radiation</em> and <em>Viscous</em> hydrodynamic damping models.
</p>

<h2>Description</h2>

<p>
  This model serves as a system test to validate the interaction between physical steering, propulsion, and multiple hydrodynamic drag sources. 
  Resistance is divided into two components: the <em>Radiation</em> block handles wave-making resistance and fluid memory, while the <em>Viscous</em> block applies empirical linear and quadratic skin friction and form drag. 
  As the 600 RPM propeller drives the vessel forward, its accelerated slipstream directly impacts the rudder. The rudder is deflected at a constant angle (approximately 5 degrees, or 0.087 rad), generating lift and causing the vessel to perform a steady turning circle maneuver against the environmental resistance.
</p>

<h2>System Topology</h2>

<p>
  The simulation setup consists of the following interacting domains:
</p>
<ul>
  <li><strong>Environment:</strong> A <code>World</code> model defines gravity, and a <code>Stream</code> object provides ambient fluid properties with a steady current of 1 m/s.</li>
  <li><strong>Vessel Body:</strong> The <code>Hull</code> block represents the ship's mass (4484.75 kg) and explicit moments of inertia, initialized with a slight forward velocity and a specific draft.</li>
  <li><strong>Hydrostatics:</strong> The <code>Buoyancy</code> block computes restoring forces using the exact 3D STL mesh intersection with a flat wave surface.</li>
  <li><strong>Hydrodynamics:</strong> The <code>Radiation</code> block applies potential damping forces, and the <code>Viscous</code> block adds 6-DOF linear and quadratic drag.</li>
  <li><strong>Propulsion & Steering:</strong> A 600 RPM signal drives the <code>MarinePropeller</code> to generate thrust. The propeller's slipstream variables (velocity, diameter, wake fraction) feed directly into the <code>MarineRudder</code>, which is commanded by an <code>AngleOutput</code> block to initiate a turn.</li>
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
      <td>Generates forward thrust and an accelerated slipstream.</td>
    </tr>
    <tr>
      <td><strong>marineRudder</strong></td>
      <td>MarineRudder</td>
      <td>Generates turning forces based on the commanded angle and the propeller's slipstream.</td>
    </tr>
    <tr>
      <td><strong>speed</strong></td>
      <td>Speed (Rotational)</td>
      <td>Ideal speed source enforcing the 600 RPM rotational velocity on the propeller.</td>
    </tr>
    <tr>
      <td><strong>angleOutput</strong></td>
      <td>AngleOutput</td>
      <td>Provides a constant steering command (0.087 rad).</td>
    </tr>
  </tbody>
</table>

<h2>Simulation Logic</h2>

<p>
  The experiment runs for 10 seconds and follows this dynamic sequence:
</p>
<ul>
  <li><strong>Initialization:</strong> The hull starts at its specified draft, establishing initial hydrostatic equilibrium via the buoyancy solver.</li>
  <li><strong>Propulsion & Slipstream:</strong> The propeller spins up, generating forward thrust and an accelerated water stream directed aft.</li>
  <li><strong>Maneuvering:</strong> The rudder, deflected inside this accelerated slipstream, generates significant lift and a yaw moment, causing the vessel to turn.</li>
  <li><strong>Dynamic Resistance & Equilibrium:</strong> As the hull accelerates and rotates, the <em>Radiation</em> and <em>Viscous</em> blocks apply opposing drag and Coriolis effects. The system eventually settles into a steady turning circle where the propeller thrust and rudder forces balance the total hydrodynamic resistance.</li>
</ul>

<hr>
<p>
  <em>Note: The simulation utilizes specific solver flags (e.g., Euler, dynamicStateSelection) optimized for the differential-algebraic equations (DAEs) generated by the multi-body interactions.</em>
</p>

</body>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end propellerRudderVesselRadiation;

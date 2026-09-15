within Aquanaut.ShipParts;

model Hull

  /*************************************/
  /********* Vessel Parameters *********/
  /*************************************/
  parameter Boolean vesselViewer = true "Visualization of Vessel" annotation(Dialog(tab = "Visualization"));
  parameter Boolean sphereViewer = true "Visualization of Sphere" annotation(Dialog(tab = "Visualization"));
  parameter Modelica.Units.SI.Length sphereRadius = if sphereViewer then 5 else 0 annotation(Dialog(tab = "Visualization"));
  parameter Modelica.Mechanics.MultiBody.Types.ShapeType shapeModel = "sphere" "Vessel visualization" annotation(Dialog(tab = "Visualization"));
  parameter Boolean cosViewer = true "Visualization of Coordinate System" annotation(Dialog(tab = "Visualization"));
  parameter Modelica.Units.SI.Length arrowLength = 10 "Length of Coordinate System Arrows" annotation(Dialog(tab = "Visualization"));

  parameter Modelica.Units.SI.MomentOfInertia Ixx = 0.001 "Moment of Inertia about surge axis" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.MomentOfInertia Iyy = 0.001 "Moment of Inertia about sway axis" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.MomentOfInertia Izz = 0.001 "Moment of Inertia about heave axis" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.MomentOfInertia Iyx = 0 "Moment of Inertia about sway-surge axis" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.MomentOfInertia Izx = 0 "Moment of Inertia about heave-surge axis" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.MomentOfInertia Izy = 0 "Moment of Inertia about heave-sway axis" annotation(Dialog(tab = "Body"));

  parameter Modelica.Units.SI.Position vesselX0 = 0 "Initial position of the Wheel's Center of Mass in x-axis resolved in world frame" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.Position vesselY0 = 0 "Initial position of the Wheel's Center of Mass in y-axis resolved in world frame" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.Position vesselZ0 = -5 "Initial position of the Wheel's Center of Mass in z-axis resolved in world frame" annotation(Dialog(tab = "Body"));

  parameter Modelica.Units.SI.Mass vesselMass = 4700 "Vessel Mass" annotation(Dialog(tab = "Body"));
  parameter Boolean initPos = false "Fixed initialization (=true) of vessel CM at (wheelX0, wheelY0, vesselZ0)" annotation(Dialog(tab = "Body"));
  parameter Modelica.Units.SI.Velocity vStart[3] = {0,0,0} "Ship start speed" annotation(
    Dialog(tab = "Body"));
  
  //angles_start = {0, 0, 1.57079633}
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(origin = {10, 40}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Mechanics.MultiBody.Parts.Body vesselBody(animation = vesselViewer, m = vesselMass, r_CM = {0, 0, 0}, angles_fixed=true, angles_start = {0, 0, 1.57079633}, w_a.start = {0, 0, 0}, w_a.fixed = {true, true, true}, v_0.start = {vStart[1], vStart[2], vStart[3]}, v_0.fixed = {true, true, true}, r_0.start = {vesselX0, vesselY0, vesselZ0}, r_0.fixed = {initPos, initPos, initPos}, I_11 = Ixx, I_22 = Iyy, I_33 = Izz, I_21 = Iyx, I_31 = Izx, I_32 = Izy, useQuaternions = false)  annotation(
    Placement(transformation(origin = {32, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape vesselShape( shapeType = shapeModel, animation = vesselViewer, length = 2*sphereRadius, width = sphereRadius, height = sphereRadius, r_shape = {-sphereRadius, 0, 0})  annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));


  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = arrowLength, animation = cosViewer)  annotation(
    Placement(transformation(origin = {32, -48}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(vesselShape.frame_a, vesselBody.frame_a) annotation(
    Line(points = {{-10, 0}, {22, 0}}, color = {95, 95, 95}));
  connect(fixedFrame.frame_a, vesselBody.frame_a) annotation(
    Line(points = {{22, -48}, {10, -48}, {10, 0}, {22, 0}}, color = {95, 95, 95}));
  connect(frame_a, vesselBody.frame_a) annotation(
    Line(points = {{10, 40}, {10, 0}, {22, 0}}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Polygon(origin = {2, 10}, lineColor = {85, 170, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, points = {{-80, 30}, {-80, -30}, {30, -30}, {80, 30}, {-80, 30}}), Line(origin = {2.03, -30.3}, points = {{-90.0305, -9.70056}, {-56.0305, 8.29944}, {-30.0305, -9.70056}, {3.96953, 8.29944}, {39.9695, -9.70056}, {67.9695, 10.2994}, {89.9695, -9.70056}}, color = {85, 85, 255}, thickness = 4.25, smooth = Smooth.Bezier), Polygon(origin = {2, 10}, fillColor = {85, 85, 255}, lineThickness = 0.75, points = {{-80, 30}, {-80, -30}, {30, -30}, {80, 30}, {-80, 30}}), Text(textColor = {85, 85, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name", textStyle = {TextStyle.Bold})}),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
  Diagram(graphics),
  Documentation(info = "<html>
<head>
</head>
<body>
<h1>Rigid Body Hull Model</h1>

<p>
  The <em>Hull</em> model represents the rigid-body dynamics of a marine vessel, serving as the central integration point for all external forces and moments. 
  It computes the resulting <strong>6 Degrees of Freedom (6-DOF)</strong> motion by solving the Newton-Euler equations of motion expressed in the body-fixed frame.
</p>

<h2>Description</h2>

<p>
  This component is the core of the simulation. It defines the vessel's inertial properties (mass and moments of inertia) and determines how the vessel accelerates in response to hydrodynamic, propulsion, and environmental forces.
  The model utilizes the standard <em>Modelica.Mechanics.MultiBody</em> library but is configured specifically to act as the base frame for marine control systems and hydrodynamic force accumulation (Fossen, 2011).
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Hull block</caption>
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
      <td><strong>vesselViewer</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>Enable/Disable 3D visualization of the vessel body.</td>
    </tr>
    <tr>
      <td><strong>sphereViewer</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>Enable/Disable visualization of the bounding sphere.</td>
    </tr>
    <tr>
      <td><strong>sphereRadius</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Radius of the visualization sphere (if enabled).</td>
    </tr>
    <tr>
      <td><strong>shapeModel</strong></td>
      <td>ShapeType</td>
      <td>-</td>
      <td>Type of visual representation (e.g., \"sphere\", \"box\", \"cylinder\").</td>
    </tr>
    <tr>
      <td><strong>cosViewer</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>Enable/Disable visualization of the Coordinate System (frames).</td>
    </tr>
    <tr>
      <td><strong>arrowLength</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Length of the arrows representing the coordinate system axes.</td>
    </tr>
    <tr>
      <td><strong>Ixx</strong></td>
      <td>MomentOfInertia</td>
      <td>kg.m&sup2;</td>
      <td>Moment of Inertia about the surge (x) axis.</td>
    </tr>
    <tr>
      <td><strong>Iyy</strong></td>
      <td>MomentOfInertia</td>
      <td>kg.m&sup2;</td>
      <td>Moment of Inertia about the sway (y) axis.</td>
    </tr>
    <tr>
      <td><strong>Izz</strong></td>
      <td>MomentOfInertia</td>
      <td>kg.m&sup2;</td>
      <td>Moment of Inertia about the heave (z) axis.</td>
    </tr>
    <tr>
      <td><strong>vesselMass</strong></td>
      <td>Mass</td>
      <td>kg</td>
      <td>Total mass of the vessel (default: 4700 kg).</td>
    </tr>
    <tr>
      <td><strong>vesselX0</strong></td>
      <td>Position</td>
      <td>m</td>
      <td>Initial position of the Center of Mass in X (World Frame).</td>
    </tr>
    <tr>
      <td><strong>vesselY0</strong></td>
      <td>Position</td>
      <td>m</td>
      <td>Initial position of the Center of Mass in Y (World Frame).</td>
    </tr>
    <tr>
      <td><strong>vesselZ0</strong></td>
      <td>Position</td>
      <td>m</td>
      <td>Initial position of the Center of Mass in Z (World Frame).</td>
    </tr>
    <tr>
      <td><strong>initPos</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>If true, strictly enforces fixed initialization at (X0, Y0, Z0).</td>
    </tr>
    <tr>
      <td><strong>vStart</strong></td>
      <td>Velocity[3]</td>
      <td>m/s</td>
      <td>Ship start speed (initial linear velocity resolved in world frame).</td>
    </tr>
  </tbody>
</table>

<h2>Connectors</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Connectors of the Hull block</caption>
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
      <td>Primary mechanical flange. Connects HydroForces, Actuators, and Sensors.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Variables</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 3:</strong> Key internal variables (from vesselBody)</caption>
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
      <td><em>vesselBody.r_0</em></td>
      <td>Position[3]</td>
      <td>m</td>
      <td>Absolute position vector of the vessel in the World Frame.</td>
    </tr>
    <tr>
      <td><em>vesselBody.v_0</em></td>
      <td>Velocity[3]</td>
      <td>m/s</td>
      <td>Absolute linear velocity vector resolved in the World Frame.</td>
    </tr>
    <tr>
      <td><em>vesselBody.w_a</em></td>
      <td>AngularVelocity[3]</td>
      <td>rad/s</td>
      <td>Absolute angular velocity resolved in the Body Frame (p, q, r).</td>
    </tr>
    <tr>
      <td><em>vesselBody.R</em></td>
      <td>Orientation</td>
      <td>-</td>
      <td>Rotation matrix describing the vessel's orientation.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The mathematical formulation for the hull dynamics is based on <strong>Chapters 2 and 3</strong> of <strong>Fossen (2011)</strong>, describing the kinetics of marine craft:
</p>

<ul>
  <li><strong>Rigid-Body Kinetics:</strong> The model computes acceleration by equating the sum of all external forces to the inertial response: <em>M<sub>RB</sub> &nu;&#775; + C<sub>RB</sub>(&nu;) &nu; = &tau;<sub>gen</sub></em>. 
  Here, <em>M<sub>RB</sub></em> is the rigid-body mass matrix and <em>C<sub>RB</sub></em> is the Coriolis-centripetal matrix.</li>
  <li><strong>Force Integration:</strong> The connector <code>frame_a</code> acts as a summation point. Forces from <em>Buoyancy</em>, <em>Radiation</em>, <em>Viscous</em>, and propulsion are automatically summed by the Modelica connector semantics to form the generalized force vector <em>&tau;<sub>gen</sub></em>.</li>
  <li><strong>Center of Mass (CM):</strong> The component assumes the mechanical frame origin coincides with the Center of Mass (<em>r<sub>CM</sub> = {0, 0, 0}</em>), simplifying the equations by decoupling linear and angular momentum.</li>
  <li><strong>Initialization:</strong> The model allows for specific placement of the vessel in the world using <code>vesselX0</code>, <code>vesselY0</code>, and <code>vesselZ0</code>, essential for setting up specific simulation scenarios (e.g., surface vs. submerged start). Furthermore, the <code>vStart</code> parameter explicitly sets the initial linear velocities.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the ShipParts package within the Aquanaut library.</em>
</p>

</body>
</html>"));
end Hull;
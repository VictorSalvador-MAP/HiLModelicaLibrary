within Aquanaut.Utils;

model RudderSteeringMechanism
  extends Modelica.Blocks.Icons.Block;
  
  // World
  inner Modelica.Mechanics.MultiBody.World world(gravityType = Modelica.Mechanics.MultiBody.Types.GravityTypes.NoGravity, enableAnimation = true, animateWorld = false)   annotation(
    Placement(transformation(origin = {-72, -50}, extent = {{-10, -10}, {10, 10}})));
  
  // Geometry parameters
  parameter Modelica.Units.SI.Length a = 0.150 "Distance from rudder shaft axis to tiller-arm rod-end pin";
  parameter Modelica.Units.SI.Length c = 0.500 "Actuator length at neutral rudder position";
  parameter Modelica.Units.SI.Length stroke = 0.045 "Total actuator stroke";
  parameter Modelica.Units.SI.Time period = 5 "Actuator motion period";
  parameter Modelica.Units.SI.Angle alpha = -0.2181661564992912 "Approximate actuator base angle with respect to the X axis";
  
  // Derived geometry
  final parameter Modelica.Units.SI.Length xB = c*cos(alpha) "X position of the fixed actuator base";
  final parameter Modelica.Units.SI.Length yB = a + c*sin(alpha) "Y position of the fixed actuator base";
  final parameter Modelica.Units.SI.Angle gamma0 = Modelica.Math.atan2(a - yB, 0 - xB) "Initial actuator body angle from the fixed base toward the tiller-arm pin";
  
  // Actuator command
  Modelica.Blocks.Sources.Sine actuatorCommand(amplitude = stroke/2, f = 1/period, offset = c) annotation(
    Placement(transformation(origin = {-16, -12}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Translational.Sources.Position actuatorDrive(useSupport = false, exact = true) annotation(
    Placement(transformation(origin = {18, -12}, extent = {{-10, -10}, {10, 10}})));
  
  // Rudder shaft and tiller arm
  Modelica.Mechanics.MultiBody.Joints.Revolute rudderShaft(n = {0, 0, 1}, phi(start = 0, fixed = false, displayUnit = "rad"), animation = true) annotation(
    Placement(transformation(origin = {-52, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox tillerArm(r = {0, a, 0}, width = 0.025, height = 0.015, density(displayUnit = "kg/m3") = 7800, animation = true) annotation(
    Placement(transformation(origin = {-52, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  
  // Actuator base and linear actuator
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation actuatorBasePosition(r = {xB, yB, 0}, animation = true) annotation(
    Placement(transformation(origin = {-32, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Joints.Revolute actuatorBasePin(n = {0, 0, 1}, phi(start = gamma0, fixed = false), animation = true) annotation(
    Placement(transformation(origin = {4, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Joints.Prismatic actuator(n = {1, 0, 0}, useAxisFlange = true, s(start = c, fixed = false), animation = true) annotation(
    Placement(transformation(origin = {38, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Joints.RevolutePlanarLoopConstraint rodEndPin(n = {0, 0, 1}, animation = true) annotation(
    Placement(transformation(origin = {72, -50}, extent = {{-10, -10}, {10, 10}})));
  
  // Output variables
  Modelica.Units.SI.Angle rudderAngle = Modelica.Math.atan2(sin(rudderShaft.phi), cos(rudderShaft.phi)) "Normalized rudder angle";  
  Real rudderAngleDeg = rudderAngle*180/Modelica.Constants.pi "Normalized rudder angle in degrees";
  Real rudderAngleRawDeg = rudderShaft.phi*180/Modelica.Constants.pi "Raw rudder shaft angle in degrees";
  Modelica.Units.SI.Length actuatorLength = actuator.s "Instantaneous actuator length";
  Modelica.Units.SI.Length actuatorTravel = actuator.s - c "Actuator displacement from neutral position";

equation
  connect(actuatorCommand.y, actuatorDrive.s_ref) annotation(
  Line(points = {{-5, -12}, {6, -12}}, color = {0, 0, 127}));
  connect(actuator.axis, actuatorDrive.flange) annotation(
  Line(points = {{46, -44}, {46, -12}, {28, -12}}, color = {0, 127, 0}));
  connect(rudderShaft.frame_b, tillerArm.frame_a) annotation(
  Line(points = {{-52, 0}, {-52, 14}}, color = {95, 95, 95}));
  connect(world.frame_b, actuatorBasePosition.frame_a) annotation(
  Line(points = {{-62, -50}, {-42, -50}}, color = {95, 95, 95}));
  connect(actuatorBasePosition.frame_b, actuatorBasePin.frame_a) annotation(
  Line(points = {{-22, -50}, {-6, -50}}, color = {95, 95, 95}));
  connect(rudderShaft.frame_a, actuatorBasePosition.frame_a) annotation(
  Line(points = {{-52, -20}, {-52, -50}, {-42, -50}}, color = {95, 95, 95}));
  connect(actuatorBasePin.frame_b, actuator.frame_a) annotation(
  Line(points = {{14, -50}, {28, -50}}, color = {95, 95, 95}));
  connect(actuator.frame_b, rodEndPin.frame_a) annotation(
  Line(points = {{48, -50}, {62, -50}}, color = {95, 95, 95}));
  connect(tillerArm.frame_b, rodEndPin.frame_b) annotation(
  Line(points = {{-52, 34}, {-52, 54}, {90, 54}, {90, -50}, {82, -50}}, color = {95, 95, 95}));

annotation(
  experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-6, Interval = 0.01),
  Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {0.5, 0.5}), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(textColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Rectangle(lineColor = {90, 90, 90}, fillColor = {190, 190, 190}, fillPattern = FillPattern.Solid, extent = {{-88, -82}, {88, -94}}), Rectangle(lineColor = {90, 90, 90}, fillColor = {165, 165, 165}, fillPattern = FillPattern.Solid, extent = {{-72, -82}, {-58, -34}}), Ellipse(lineColor = {70, 70, 70}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid, extent = {{-82, -42}, {-48, -8}}), Ellipse(lineColor = {40, 40, 40}, fillColor = {70, 70, 70}, fillPattern = FillPattern.Solid, extent = {{-70, -30}, {-60, -20}}), Polygon(lineColor = {40, 110, 180}, fillColor = {115, 170, 225}, fillPattern = FillPattern.Solid, points = {{-69, -23}, {-60, -26}, {-34, 58}, {-48, 62}, {-69, -23}}), Ellipse(lineColor = {70, 70, 70}, fillColor = {225, 225, 225}, fillPattern = FillPattern.Solid, extent = {{-58, 48}, {-24, 82}}), Ellipse(lineColor = {40, 40, 40}, fillColor = {75, 75, 75}, fillPattern = FillPattern.Solid, extent = {{-47, 59}, {-35, 71}}), Rectangle(origin = {4, 0}, lineColor = {60, 60, 60}, fillColor = {206, 206, 206}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-44, 61}, {78, 69}}), Rectangle(origin = {4, 38}, lineColor = {70, 70, 70}, fillColor = {147, 147, 147}, fillPattern = FillPattern.VerticalCylinder, extent = {{0, 20}, {40, 34}}), Rectangle(origin = {44, 27}, lineColor = {70, 70, 70}, fillColor = {130, 130, 130}, fillPattern = FillPattern.Sphere, extent = {{0, 28}, {10, 48}}), Line(origin = {6, -24}, points = {{36, 72}, {74, 72}}, color = {0, 150, 0}, pattern = LinePattern.Dash, thickness = 1.2), Polygon(origin = {4, -24}, lineColor = {0, 150, 0}, fillColor = {0, 150, 0}, fillPattern = FillPattern.Solid, points = {{76, 76}, {86, 72}, {76, 68}, {76, 76}}), Line(points = {{-92, -36}, {-96, -18}, {-86, 2}, {-70, 10}}, color = {220, 85, 0}, thickness = 2.5, smooth = Smooth.Bezier), Polygon(origin = {3, 3}, lineColor = {220, 85, 0}, fillColor = {220, 85, 0}, fillPattern = FillPattern.Solid, points = {{-70, 10}, {-84, 8}, {-76, -4}, {-70, 10}}), Text(origin = {-1, -6}, textColor = {220, 85, 0}, extent = {{-98, 8}, {-66, -12}}, textString = "φ"), Text(origin = {-16, -9}, textColor = {80, 80, 80}, extent = {{-42, -39}, {110, -66}}, textString = "Rudder actuator")}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Rudder Steering Mechanism Model</h1>

<p>
  The <em>RudderSteeringMechanism</em> model provides a 3D multi-body kinematic representation of a marine steering gear. It simulates the mechanical linkage that converts the linear stroke of a steering actuator into the angular rotation of a rudder shaft via a tiller arm.
</p>

<h2>Description</h2>

<p>
  Unlike idealized signal-based steering models, this block captures the non-linear geometric relationship between actuator displacement and rudder angle. It utilizes a closed kinematic loop consisting of a fixed actuator base, a prismatic joint (the actuator ram), a tiller arm, and a revolute joint representing the rudder stock. A planar loop constraint resolves the exact kinematics. The model is driven by an internal sinusoidal position command for testing and validation purposes.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Geometric and actuation parameters</caption>
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
      <td><strong>a</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Distance from the rudder shaft axis to the tiller-arm rod-end pin.</td>
    </tr>
    <tr>
      <td><strong>c</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Actuator length at the neutral rudder position.</td>
    </tr>
    <tr>
      <td><strong>stroke</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Total linear actuator stroke capability.</td>
    </tr>
    <tr>
      <td><strong>period</strong></td>
      <td>Time</td>
      <td>s</td>
      <td>Period of the internal sinusoidal actuator motion.</td>
    </tr>
    <tr>
      <td><strong>alpha</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Approximate actuator base angle with respect to the X-axis.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Multi-body parts and joints</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><em>rudderShaft</em></td>
      <td>Revolute</td>
      <td>The main pivot point for the rudder assembly.</td>
    </tr>
    <tr>
      <td><em>tillerArm</em></td>
      <td>BodyBox</td>
      <td>The rigid lever connecting the rudder shaft to the actuator rod end.</td>
    </tr>
    <tr>
      <td><em>actuator</em></td>
      <td>Prismatic</td>
      <td>The linear actuator expanding and contracting based on the command signal.</td>
    </tr>
    <tr>
      <td><em>actuatorBasePin</em></td>
      <td>Revolute</td>
      <td>The fixed pivot mount for the actuator body.</td>
    </tr>
    <tr>
      <td><em>rodEndPin</em></td>
      <td>RevolutePlanarLoopConstraint</td>
      <td>Closes the kinematic loop, linking the moving actuator rod to the moving tiller arm.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The mechanism establishes a fixed reference frame and evaluates the kinematic loop using standard trigonometry. The fixed base of the actuator is located at coordinates (xB, yB) derived from the neutral length c and base angle α:
</p>

<ul>
  <li><strong>Base X Position:</strong> <em>xB = c · cos(α)</em></li>
  <li><strong>Base Y Position:</strong> <em>yB = a + c · sin(α)</em></li>
  <li><strong>Initial Angle:</strong> <em>γ0 = arctan2(a - yB, -xB)</em></li>
</ul>

<p>
  The internal <code>actuatorCommand</code> block generates a smooth sinusoidal position target: <em>s(t) = c + (stroke / 2) · sin((2π / period) · t)</em>. A 1D translational flange enforces this extension on the 3D prismatic <code>actuator</code> joint. The resulting constraint forces the <code>tillerArm</code> to rotate the <code>rudderShaft</code>. The output variables (e.g., <code>rudderAngle</code>) capture this non-linear angular response.
</p>

<hr>
<p>
  <em>Note: This component is located in the Utils package and serves as a mechanical validation benchmark for steering system design.</em>
</p>


</body></html>"));

end RudderSteeringMechanism;

within Aquanaut.Utils;

model forceMomentSource

  
  Modelica.Blocks.Interfaces.RealInput forceInput annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-122, 38}, extent = {{-20, -20}, {20, 20}})));
  
  Modelica.Blocks.Interfaces.RealInput momentInput annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -36}, extent = {{-20, -20}, {20, 20}})));
  
  
  Modelica.Mechanics.MultiBody.Forces.WorldForce force(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b)  annotation(
    Placement(transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Mechanics.MultiBody.Forces.WorldTorque torque(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b)  annotation(
    Placement(transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}})));
    
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));


equation
  force.force[2] = 0;
  force.force[3] = 0;
  torque.torque[1] = 0;
  torque.torque[2] = 0;
  
  connect(torque.frame_b, frame_b) annotation(
    Line(points = {{20, -20}, {62, -20}, {62, 0}, {100, 0}}, color = {95, 95, 95}));
  connect(force.frame_b, frame_b) annotation(
    Line(points = {{20, 20}, {62, 20}, {62, 0}, {100, 0}}, color = {95, 95, 95}));
  connect(forceInput, force.force[1]) annotation(
    Line(points = {{-120, 20}, {-2, 20}}, color = {0, 0, 127}));
  connect(momentInput, torque.torque[3]) annotation(
    Line(points = {{-120, -20}, {-2, -20}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Line(origin = {-2, -14}, points = {{-92, 64}, {-86, 68}, {-80, 72}, {-70, 78}, {-64, 82}, {-46, 86}, {-34, 88}, {-16, 88}, {-2, 86}, {12, 80}, {24, 74}, {34, 68}, {46, 58}, {52, 54}, {58, 48}}, color = {85, 170, 127}, thickness = 0.5), Polygon(origin = {-2, -14}, fillColor = {85, 170, 127}, fillPattern = FillPattern.Solid, points = {{89, 17}, {64, 76}, {30, 41}, {89, 17}}), Polygon(origin = {-2, -14}, fillColor = {85, 170, 127}, fillPattern = FillPattern.Solid, points = {{-78, -40}, {54, 0}, {46, 20}, {96, 0}, {66, -42}, {60, -22}, {-70, -60}, {-78, -40}}), Text(origin = {-33, 42}, textColor = {0, 170, 0}, extent = {{-57, 24}, {57, -24}}, textString = "about Z"), Text(origin = {11, -76}, textColor = {0, 170, 0}, extent = {{-57, 24}, {57, -24}}, textString = "along X")}),
  Documentation(info = "<html>
<head>
</head>
<body>
<h1>Force and Moment Source Model</h1>

<p>
  The <em>forceMomentSource</em> model is a utility block designed to apply signal-driven forces and torques directly to a mechanical frame. 
  It is specifically configured to apply a longitudinal force (Surge) and a vertical-axis torque (Yaw), making it ideal for simplified maneuvering tests, autopilot development, or idealized thruster representation.
</p>

<h2>Description</h2>

<p>
  This component bridges standard 1D signal libraries with the 3D multi-body mechanical domain. 
  It receives real signals representing desired force and moment magnitudes. Internally, it restricts the force strictly to the local X-axis (forward/backward) and the moment strictly to the local Z-axis (turning left/right). 
  All other directional components are zeroed out, and the resulting spatial vectors are applied to the connected body frame.
</p>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Inputs and Connectors</caption>
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
      <td><strong>forceInput</strong></td>
      <td>RealInput</td>
      <td>N</td>
      <td>Input signal defining the magnitude of the force applied along the local X-axis.</td>
    </tr>
    <tr>
      <td><strong>momentInput</strong></td>
      <td>RealInput</td>
      <td>N.m</td>
      <td>Input signal defining the magnitude of the torque applied about the local Z-axis.</td>
    </tr>
    <tr>
      <td><strong>frame_b</strong></td>
      <td>Frame_b</td>
      <td>-</td>
      <td>3D mechanical connector acting as the target frame for the applied loads.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Internal MultiBody blocks</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><em>force</em></td>
      <td>WorldForce</td>
      <td>Applies the 3D force vector. Configured to resolve its inputs in the attached body frame (<code>frame_b</code>).</td>
    </tr>
    <tr>
      <td><em>torque</em></td>
      <td>WorldTorque</td>
      <td>Applies the 3D torque vector. Configured to resolve its inputs in the attached body frame (<code>frame_b</code>).</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model translates scalar signals into localized 3D spatial vectors using the following logic:
</p>

<ul>
  <li><strong>Resolution Frame:</strong> Both the <code>WorldForce</code> and <code>WorldTorque</code> internal blocks are explicitly set to <code>ResolveInFrameB.frame_b</code>. This ensures the input signals are interpreted as acting directly in the body's local coordinate system (rotating with the vessel), regardless of its global heading.</li>
  <li><strong>Force Vector:</strong> The <code>forceInput</code> signal is mapped exclusively to the X-component. The Y (sway) and Z (heave) forces are forced to zero: <em>F = [forceInput, 0, 0]</em>.</li>
  <li><strong>Torque Vector:</strong> The <code>momentInput</code> signal is mapped exclusively to the Z-component. The X (roll) and Y (pitch) moments are forced to zero: <em>&tau; = [0, 0, momentInput]</em>.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Utils package within the Aquanaut library.</em>
</p>

</body>
</html>"));
end forceMomentSource;

within Aquanaut.PathFollowing;

model PF_Controller
  // Control Parameters
  parameter Real Kp;
  parameter Real Ki;
  parameter Real Kd;
  // Control Inputs
  Modelica.Blocks.Interfaces.RealInput chi_SF annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-112, 78}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput chi_d annotation(
    Placement(transformation(origin = {-102, -30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-112, 24}, extent = {{-12, -12}, {12, 12}})));
  // Control Blocks
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(transformation(origin = {-36, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.PI PI(k =Kp, T = Kp/Ki) annotation(
    Placement(transformation(origin = {4, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Der der1 annotation(
    Placement(transformation(origin = {-18, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k2 = +1, k1 = -1) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain der_gain(k=Kd) annotation(
    Placement(transformation(origin = {14, -30}, extent = {{-10, -10}, {10, 10}})));
  // Control Output
  Modelica.Blocks.Interfaces.RealOutput r_d annotation(
    Placement(transformation(origin = {84, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, 50}, extent = {{-16, -16}, {16, 16}})));
  // Control Law
equation
  connect(chi_SF, add.u1) annotation(
    Line(points = {{-102, 32}, {-48, 32}}, color = {0, 0, 127}));
  connect(chi_d, add.u2) annotation(
    Line(points = {{-102, -30}, {-60, -30}, {-60, 20}, {-48, 20}}, color = {0, 0, 127}));
  connect(add.y, PI.u) annotation(
    Line(points = {{-24, 26}, {-8, 26}}, color = {0, 0, 127}));
  connect(der1.u, chi_d) annotation(
    Line(points = {{-30, -30}, {-102, -30}}, color = {0, 0, 127}));
  connect(PI.y, add1.u1) annotation(
    Line(points = {{16, 26}, {30, 26}, {30, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(add1.y, r_d) annotation(
    Line(points = {{62, 0}, {84, 0}}, color = {0, 0, 127}));
  connect(der1.y, der_gain.u) annotation(
    Line(points = {{-6, -30}, {2, -30}}, color = {0, 0, 127}));
  connect(der_gain.y, add1.u2) annotation(
    Line(points = {{26, -30}, {30, -30}, {30, -6}, {38, -6}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {0, 50}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 50}, {100, -50}}), Text( origin = {0, 50},extent = {{-54, 24}, {54, -24}}, textString = "Path Following
Control Law", textStyle = {TextStyle.Bold, TextStyle.Italic}), Text(origin = {-49, 24}, extent = {{-47, 6}, {47, -6}}, textString = "Chi_d", horizontalAlignment = TextAlignment.Left), Text(origin = {-56, 78}, extent = {{-40, 6}, {40, -6}}, textString = "Chi_sf", horizontalAlignment = TextAlignment.Left), Text(origin = {74, 53}, extent = {{-22, 7}, {22, -7}}, textString = "r_d", horizontalAlignment = TextAlignment.Right)}, coordinateSystem(extent = {{-120, 100}, {140, 0}})),
  Diagram(graphics),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Path Following Control Law</h1>

<p>
  The <em>PF_Controller</em> model implemets the PID control law for the vessel Path Following problem. 
  It calculates the desired angular velocity of the vessel to correct its trajectory based on course erros.
</p>

<h2>Description</h2>

<p>
  It compensates the angle error between the actual course angle error (<code>chi_SF</code>) and the target look-ahead steering angle correction (<code>chi_d</code>) with a proportional and integral action. And compensates the rate of change of the desired course angle error.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the PF_Controller block</caption>
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
      <td><strong>Kp</strong></td>
      <td>Real</td>
      <td>1/s</td>
      <td>Compensates the error proprotionally.</td>
    </tr>
    <tr>
      <td><strong>Ki</strong></td>
      <td>Real</td>
      <td>1/s²</td>
      <td>Compensates the error accumulated in time.</td>
    </tr>
    <tr>
      <td><strong>Kd</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Compensates the rate of change of desired course <code>chi_d</code>.</td>
    </tr>
    
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Inputs, Outputs and Connectors</caption>
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
      <td><strong>chi_SF</strong></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>1D rotational mechanical connector (shaft connection).</td>
    </tr>
    <tr>
      <td><strong>chi_d</strong></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>3D mechanical connector attached to the vessel.</td>
    </tr>
    <tr>
      <td><strong>r_d</strong></td>
      <td>RealOutput</td>
      <td>rad/s</td>
      <td>Global object providing ambient fluid velocity (if <code>useStream</code>=true).</td>
    </tr>
    
  </tbody>
</table>

<h2>Computed Mathematics</h2>

<p>
  The model computes proportional, integrative and derivative actions of the controller as expressed bellow:
</p>

<ul>
  <li><em>&chi;&#771;<sub>SF</sub> = &chi;<sub>SF</sub> - &chi;<sub>d</sub></em>
  <li><em>r<sub>d</sub> = K<sub>d</sub>&middot;&chi;&#775;<sub>d</sub> - K<sub>p</sub>&middot;&chi;&#771;<sub>SF</sub> - K<sub>p</sub>&middot;&int;&chi;&#771;<sub>SF</sub></li>
</ul>

</body></html>"));
end PF_Controller;

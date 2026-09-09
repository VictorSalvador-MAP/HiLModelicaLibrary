within Aquanaut.PathFollowing;

model SerretFrenetModel "Serret-Frenet Frame Look-Ahead Guidance Law"
  // Parameters
  parameter Real Wp[2, 2] = [0, -10; 1000, -10] "Waypoints: [Row1=[x0,y0], Row2=[x1,y1]]";
  parameter Modelica.Units.SI.Distance deltaLOS = 10.0 "Look-ahead distance (Delta)";
  // Inputs
  Modelica.Blocks.Interfaces.RealInput x "Vessel X position" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-111, 77}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput y "Vessel Y position" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-111, 47}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput vx "Vessel X velocity" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-111, -13}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput vy "Vessel Y velocity" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-111, -43}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput psi "Vessel Z orientation" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-111, 17}, extent = {{-11, -11}, {11, 11}})));
    // Outputs (Interfaces to your PF_Controller)
  Modelica.Blocks.Interfaces.RealOutput chi_sf "Path angle to body course error" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {171, 17}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealOutput chi_d "LOS angle error" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {171, -23}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealOutput U "Body velocity" annotation(
    Placement(transformation(origin = {-102, 32}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {171, 55}, extent = {{-11, -11}, {11, 11}})));
//protected
  // Intermediate calculation variables
  Real dx = Wp[2, 1] - Wp[1, 1] "Path delta X";
  Real dy = Wp[2, 2] - Wp[1, 2] "Path delta Y";
  Real psi_p = Modelica.Math.atan2(dy, dx) "Path heading angle";
  Real bx "Vessel distance vector X from Wp0";
  Real by "Vessel distance vector Y from Wp0";
  Real chi "Vessel course angle";
  //Real psi "Vessel heading angle";
//public
  Real e_y "Signed cross-track error";
  Real psi_sf "Heading error";

equation
// Compute body velocity
  U = sqrt(vx^2 + vy^2);
// Compute body heading error for evaluation
  psi_sf = psi_p - psi;
// Compute relative distance from the first waypoint
  bx = x - Wp[1, 1];
  by = y - Wp[1, 2];
// 1. Signed cross-track error calculation
  e_y = -Modelica.Math.sin(psi_p)*bx + Modelica.Math.cos(psi_p)*by;
// Compute current vessel course angle
  chi = Modelica.Math.atan2(vy, vx);
// 2. Control outputs matching your PF_Controller setup
  chi_sf = psi_p - chi;
  chi_d = Modelica.Math.atan2(e_y, deltaLOS);
  annotation(
    Icon(graphics = {Rectangle(origin = {30, 17}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-130, 71}, {130, -71}}), Text(origin = {30, 80}, extent = {{-130, 8}, {130, -8}}, textString = "Serret-Frenèt with LOS"), Line(origin = {40.89, -14.11}, points = {{-90.8927, -25.8927}, {91.1073, 20.1073}}, pattern = LinePattern.Dash, thickness = 1.25), Ellipse(origin = {-50, -40}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {130, 6}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Polygon(origin = {18, 50}, rotation = -90, fillColor = {255, 0, 0}, pattern = LinePattern.Dash, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-10, -30}, {10, -30}, {10, -6}, {0, 8}, {-10, -6}, {-10, -6}, {-10, -30}}), Polygon(origin = {36, -18}, rotation = 270, lineColor = {170, 0, 0}, fillColor = {255, 0, 0}, pattern = LinePattern.Dash, lineThickness = 1, points = {{-1.13632, -29.611}, {17.6575, -24.7706}, {11.449, -2.21795}, {-0.73616, 3.51754}, {-7.34481, -7.05836}, {-7.34481, -7.05836}, {-1.13632, -29.611}}), Ellipse(origin = {4, 50}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Ellipse(origin = {22, -22}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Line(origin = {21.05, 14.4}, points = {{-17.0536, 35.5967}, {0.946364, -36.4033}}, pattern = LinePattern.Dash, thickness = 0.5), Line(origin = {21.05, 14.4}, points = {{-17.0536, 35.5967}, {70.9464, -18.4033}}, color = {170, 0, 127}, pattern = LinePattern.Dash, thickness = 0.5), Text(origin = {62, -22}, rotation = 15, extent = {{-9, -7}, {9, 7}}, textString = "Delta"), Line(origin = {59, -18}, points = {{-35, -10}, {35, 10}}, thickness = 0.5, arrow = {Arrow.Filled, Arrow.Filled}), Text(origin = {-61, -28}, extent = {{-9, 6}, {9, -6}}, textString = "Wp0"), Text(origin = {135, 18}, extent = {{-9, 6}, {9, -6}}, textString = "Wp1")}, coordinateSystem(extent = {{-120, 100}, {180, -60}})),
    Diagram(graphics),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Serret-Frenet Frame Look-Ahead Guidance Law</h1>

<p>
  The <em>SerretFrenetModel</em> block implements a Look-Ahead Line-of-Sight (LOS) guidance law utilizing a path-fixed Serret-Frenet coordinate frame. It tracks a straight-line path defined between two geometric waypoints and provides guidance errors and kinematic metrics to downstream trajectory controllers.
</p>

<h2>Description</h2>

<p>
  The block accepts the current positions, velocities, and orientation of the vessel in the global frame. It projects the vessel's coordinates onto a straight line segment spanning from waypoint <code>Wp[1,:]</code> to <code>Wp[2,:]</code> to dynamically compute the signed cross-track error (<code>e_y</code>). It yields the current total magnitude of body velocity (<code>U</code>), the current course angle error relative to the path (<code>chi_sf</code>), and the target look-ahead steering angle correction (<code>chi_d</code>).
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the SerretFrenetModel block</caption>
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
      <td><strong>Wp[2, 2]</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Waypoint matrix layout: Row 1 specifies starting coordinates [x0, y0]; Row 2 specifies target coordinates [x1, y1].</td>
    </tr>
    <tr>
      <td><strong>deltaLOS</strong></td>
      <td>Distance</td>
      <td>m</td>
      <td>Look-ahead distance parameter (Delta) used to establish target convergence aggressiveness.</td>
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
      <td><strong>x</strong></td>
      <td>RealInput</td>
      <td>m</td>
      <td>Current global translation position of the vessel along the X-axis.</td>
    </tr>
    <tr>
      <td><strong>y</strong></td>
      <td>RealInput</td>
      <td>m</td>
      <td>Current global translation position of the vessel along the Y-axis.</td>
    </tr>
    <tr>
      <td><strong>vx</strong></td>
      <td>RealInput</td>
      <td>m/s</td>
      <td>Global velocity component of the vessel along the X-axis.</td>
    </tr>
    <tr>
      <td><strong>vy</strong></td>
      <td>RealInput</td>
      <td>m/s</td>
      <td>Global velocity component of the vessel along the Y-axis.</td>
    </tr>
    <tr>
      <td><strong>psi</strong></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>Global heading/orientation of the vessel around its Z-axis.</td>
    </tr>
    <tr>
      <td><strong>chi_sf</strong></td>
      <td>RealOutput</td>
      <td>rad</td>
      <td>Course angle deviation error relative to the path tangent line.</td>
    </tr>
    <tr>
      <td><strong>chi_d</strong></td>
      <td>RealOutput</td>
      <td>rad</td>
      <td>Line-of-Sight steering guidance correction command angle.</td>
    </tr>
    <tr>
      <td><strong>U</strong></td>
      <td>RealOutput</td>
      <td>m/s</td>
      <td>Calculated total current magnitude of the vessel's speed.</td>
    </tr>
  </tbody>
</table>

<h2>Computed Mathematics</h2>

<p>
  The model evaluates path-following states and target guidance vectors via the following kinematics expressions:
</p>

<ul>
  <li><em>dx = Wp<sub>2,1</sub> - Wp<sub>1,1</sub></em>, &nbsp; <em>dy = Wp<sub>2,2</sub> - Wp<sub>1,2</sub></em></li>
  <li><em>&psi;<sub>p</sub> = atan2(dy, dx)</em></li>
  <li><em>bx = x - Wp<sub>1,1</sub></em>, &nbsp; <em>by = y - Wp<sub>1,2</sub></em></li>
  <li><em>e<sub>y</sub> = -sin(&psi;<sub>p</sub>)&middot;bx + cos(&psi;<sub>p</sub>)&middot;by</em></li>
  <li><em>&chi; = atan2(vy, vx)</em></li>
  <li><em>&chi;<sub>sf</sub> = &psi;<sub>p</sub> - &chi;</em></li>
  <li><em>&chi;<sub>d</sub> = atan2(e<sub>y</sub>, &Delta;<sub>LOS</sub>)</em></li>
  <li><em>U = &sqrt;[vx<sup>2</sup> + vy<sup>2</sup>]</em></li>
</ul>

</body></html>"));
end SerretFrenetModel;

within Aquanaut.Equipment.Actuators;

model DieselEngine
  extends Modelica.Blocks.Icons.Block;
  //Input and Output interfaces
  Modelica.Blocks.Interfaces.RealInput throttleAnglePosition(unit="rad", displayUnit="deg") annotation(
    Placement(transformation(origin = {-88, 16}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange annotation(
    Placement(transformation(origin = {36, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Inertia J = 2.5 "Engine Inertia";
  parameter Modelica.Units.SI.Torque T_max = 880 "Engine maximum torque";
  parameter Modelica.Units.SI.Angle thetaMin = 0.7853981633974483 "Minimum angle [deg]";
  parameter Modelica.Units.SI.Angle thetaMax = 2.356194490192345 "Maximum angle [deg]";
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation(
    Placement(transformation(origin = {4, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Torque torqueSource annotation(
    Placement(transformation(origin = {-30, 22}, extent = {{-10, -10}, {10, 10}})));
protected
  Real throttlePercent;
equation
  throttlePercent = (throttleAnglePosition - thetaMin)/(thetaMax - thetaMin);
  torqueSource.tau = throttlePercent*T_max;
  connect(inertia.flange_b, flange) annotation(
    Line(points = {{14, 22}, {36, 22}}));
  connect(torqueSource.flange, inertia.flange_a) annotation(
    Line(points = {{-20, 22}, {-6, 22}}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {0, 170, 0}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {80, -60}}), Rectangle(fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {-60, -60}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{80, 10}, {100, -10}}), Rectangle(lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-40, 70}, {40, 50}}), Polygon(fillPattern = FillPattern.Solid, points = {{-50, -90}, {-40, -90}, {-10, -20}, {40, -20}, {70, -90}, {80, -90}, {80, -100}, {-50, -100}, {-50, -90}})}),
    Diagram(graphics),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Marine Diesel Engine Model</h1>

<p>
  The <em>DieselEngine</em> model represents the prime mover of the propulsion system. 
  It simulates a marine diesel engine by generating a driving torque proportional to the angular position of a physical throttle lever, accounting for the engine's rotating mass inertia.
</p>

<h2>Description</h2>

<p>
  This component bridges the control interface (lever position) and the mechanical drivetrain. 
  It implements a simplified linear mapping where the engine's torque output scales linearly between a minimum (idle) and maximum (full power) throttle angle. 
  The model includes an internal inertia component to simulate the rotational dynamics and resistance to acceleration of the engine's crankshaft and flywheel.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the DieselEngine block</caption>
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
      <td><strong>J</strong></td>
      <td>Inertia</td>
      <td>kg.m²</td>
      <td>Rotational inertia of the engine parts (crankshaft, flywheel).</td>
    </tr>
    <tr>
      <td><strong>T_max</strong></td>
      <td>Torque</td>
      <td>N.m</td>
      <td>Maximum torque output at full throttle.</td>
    </tr>
    <tr>
      <td><strong>thetaMin</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Minimum throttle lever angle (Idle position).</td>
    </tr>
    <tr>
      <td><strong>thetaMax</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Maximum throttle lever angle (Full power position).</td>
    </tr>
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Inputs and Connectors</caption>
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
      <td><strong>flange</strong></td>
      <td>Flange_b</td>
      <td>-</td>
      <td>Rotational mechanical flange (Output shaft).</td>
    </tr>
    <tr>
      <td><strong>throttleAnglePosition</strong></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>Input signal representing the physical angle of the throttle lever.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Variables</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 3:</strong> Key internal variables used in calculations</caption>
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
      <td><em>throttlePercent</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Normalized throttle demand (0.0 to 1.0) derived from the input angle.</td>
    </tr>
    <tr>
      <td><em>torqueSource.tau</em></td>
      <td>Torque</td>
      <td>N.m</td>
      <td>Generated internal torque applied to the inertia.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes the output torque based on a linear interpolation of the input angle:
</p>

<ul>
  <li><strong>Normalization:</strong> The input angle <em>θ</em> is converted to a percentage <em>u</em> based on the calibrated range: 
    <br><em>u = (θ - θ<sub>min</sub>) / (θ<sub>max</sub> - θ<sub>min</sub>)</em>.
  </li>
  <li><strong>Torque Generation:</strong> The driving torque is directly proportional to this percentage: 
    <br><em>τ<sub>engine</sub> = u · T<sub>max</sub></em>.
  </li>
  <li><strong>Rotational Dynamics:</strong> The generated torque acts upon the engine inertia <em>J</em>, following Newton's second law for rotation:
    <br><em>J · α = τ<sub>engine</sub> - τ<sub>load</sub></em>
    <br>(Where <em>τ<sub>load</sub></em> is the reactive torque from the connected transmission/propeller).
  </li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Equipment.Actuators package within the Aquanaut library.</em>
</p>


</body></html>"));
end DieselEngine;

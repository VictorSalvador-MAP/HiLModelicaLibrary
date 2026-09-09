within Aquanaut.Equipment.Actuators;

model Transmission
  extends Modelica.Blocks.Icons.Block;
  //Input and Output interfaces
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a annotation(
    Placement(transformation(origin = {-32, 6}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-108, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b annotation(
    Placement(transformation(origin = {56, 6}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput clutchMode "Clutch condition [-1,0,1]" annotation(
    Placement(transformation(origin = {-28, 34}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  parameter Real k = 2.67"Fixed gear ratio";
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio = k) annotation(
    Placement(transformation(origin = {30, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Components.Clutch clutch(fn_max = 1e6) annotation(
    Placement(transformation(origin = {-2, 6}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(flange_a, clutch.flange_a) annotation(
    Line(points = {{-32, 6}, {-12, 6}}));
  connect(clutch.flange_b, idealGear.flange_a) annotation(
    Line(points = {{8, 6}, {20, 6}}));
  connect(idealGear.flange_b, flange_b) annotation(
    Line(points = {{40, 6}, {56, 6}}));
  connect(clutchMode, clutch.f_normalized) annotation(
    Line(points = {{-28, 34}, {-2, 34}, {-2, 18}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(lineColor = {64, 64, 64}, fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -10}, {100, 10}}), Polygon(origin = {-20, 0},fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, points = {{-60, 10}, {-60, 20}, {-40, 40}, {-40, -40}, {-60, -20}, {-60, 10}}), Rectangle(lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, -60}, {60, 60}}, radius = 10), Rectangle(lineColor = {64, 64, 64}, extent = {{-60, -60}, {60, 60}}, radius = 10), Polygon(origin = {20, 0},fillColor = {192, 192, 192}, fillPattern = FillPattern.HorizontalCylinder, points = {{60, 20}, {40, 40}, {40, -40}, {60, -20}, {60, 20}}), Polygon(fillColor = {64, 64, 64}, fillPattern = FillPattern.Solid, points = {{-60, -80}, {-50, -80}, {-20, -40}, {20, -40}, {48, -80}, {60, -80}, {60, -90}, {-60, -90}, {-60, -80}}), Polygon(origin = {18, 10}, rotation = 10, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-3.024, 27.216}, {-6.048, 6.048}, {-27.216, 3.024}, {-27.216, -3.024}, {-6.048, -6.048}, {-3.024, -27.216}, {3.024, -27.216}, {6.048, -6.048}, {27.216, -3.024}, {27.216, 3.024}, {6.048, 6.048}, {3.024, 27.216}, {-3.024, 27.216}}), Polygon(origin = {18, 10}, rotation = 55, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-3.024, 27.216}, {-6.048, 6.048}, {-27.216, 3.024}, {-27.216, -3.024}, {-6.048, -6.048}, {-3.024, -27.216}, {3.024, -27.216}, {6.048, -6.048}, {27.216, -3.024}, {27.216, 3.024}, {6.048, 6.048}, {3.024, 27.216}, {-3.024, 27.216}}), Ellipse(origin = {18, 10}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-18.144, -18.144}, {18.144, 18.144}}), Ellipse(origin = {18, 10}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, extent = {{-6.048, -6.048}, {6.048, 6.048}}), Polygon(origin = {-22, -4}, rotation = 10, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-2.1, 18.9}, {-4.2, 4.2}, {-18.9, 2.1}, {-18.9, -2.1}, {-4.2, -4.2}, {-2.1, -18.9}, {2.1, -18.9}, {4.2, -4.2}, {18.9, -2.1}, {18.9, 2.1}, {4.2, 4.2}, {2.1, 18.9}, {-2.1, 18.9}}), Polygon(origin = {-22, -4}, rotation = 55, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-2.1, 18.9}, {-4.2, 4.2}, {-18.9, 2.1}, {-18.9, -2.1}, {-4.2, -4.2}, {-2.1, -18.9}, {2.1, -18.9}, {4.2, -4.2}, {18.9, -2.1}, {18.9, 2.1}, {4.2, 4.2}, {2.1, 18.9}, {-2.1, 18.9}}), Ellipse(origin = {-22, -4}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-12.6, -12.6}, {12.6, 12.6}}), Ellipse(origin = {-22, -4}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid, extent = {{-4.2, -4.2}, {4.2, 4.2}}), Text(origin = {80, -20},extent = {{-150, -150}, {150, -110}}, textString = "k=%k")}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Marine Transmission Model</h1>

<p>
  The <em>Transmission</em> model represents a mechanical gearbox assembly with an integrated clutch system. 
  It acts as the power coupling between the prime mover (diesel engine) and the propulsor, providing fixed speed reduction and torque amplification.
</p>

<h2>Description</h2>

<p>
  This component is essential for matching the high rotational speed of the engine to the optimal lower speed of the propeller. 
  It integrates an <strong>Ideal Gear</strong> mechanism for the ratio transformation and a friction <strong>Clutch</strong> to manage the engagement of the drivetrain.
  The model allows for dynamic connection and disconnection of the load, simulating neutral and drive states commanded by the control system.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Transmission block</caption>
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
      <td><strong>k</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Fixed gear ratio (Input speed / Output speed). Default: 2.67.</td>
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
      <td><strong>flange_a</strong></td>
      <td>Flange_a</td>
      <td>-</td>
      <td>Rotational mechanical flange (Input / Engine side).</td>
    </tr>
    <tr>
      <td><strong>flange_b</strong></td>
      <td>Flange_b</td>
      <td>-</td>
      <td>Rotational mechanical flange (Output / Propeller side).</td>
    </tr>
    <tr>
      <td><strong>clutchMode</strong></td>
      <td>RealInput</td>
      <td>-</td>
      <td>Control signal for clutch engagement.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model combines standard rotational mechanics components to simulate the transmission behavior:
</p>

<ul>
  <li><strong>Gear Reduction:</strong> The relationship between input (<em>ω<sub>a</sub></em>) and output (<em>ω<sub>b</sub></em>) speeds is defined by the ratio <em>k</em>: <em>ω<sub>a</sub> = k · ω<sub>b</sub></em>. Consequently, the torque is amplified: <em>τ<sub>b</sub> = k · τ<sub>a</sub></em>.</li>
  <li><strong>Clutch Engagement:</strong> The <code>clutchMode</code> input regulates the normal force in the friction clutch.
    <ul>
      <li><strong>Signal = 1:</strong> Fully engaged (Propulsion Active).</li>
      <li><strong>Signal = 0:</strong> Disengaged (Neutral / Idle).</li>
      <li><strong>Signal = -1:</strong> Used in control logic to signify Reverse request (behavior depends on engine direction or gearbox capability).</li>
    </ul>
  </li>
  <li><strong>Power Flow:</strong> Power is transmitted from <code>flange_a</code> through the clutch, then the gear reduction, to <code>flange_b</code>. Lossless transmission is assumed in the gear component.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Equipment package within the Aquanaut library.</em>
</p>


</body></html>"));
end Transmission;

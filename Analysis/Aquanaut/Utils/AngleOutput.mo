within Aquanaut.Utils;

block AngleOutput
  parameter Modelica.Units.SI.Angle angle = 0;
  Modelica.Blocks.Interfaces.RealOutput phi(unit = "rad", displayUnit = "deg") annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  phi = angle;
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid, borderPattern = BorderPattern.Raised, extent = {{-100, 40}, {100, -40}}), Text(textColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(extent = {{-96, 15}, {96, -15}}, textString = "%angle")}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Angle Output Utility</h1>

<p>
  The <i>AngleOutput</i> block is a utility component designed to convert a static user-defined parameter into a dynamic <code>Real</code> output signal. 
  It is primarily used as a reference source or a setpoint generator in&nbsp;marine simulations.
</p>



<h2>Description</h2>

<p>
  In complex simulation environments, it is often necessary to provide a constant angular value to controllers or actuators. 
  This block simplifies that process by allowing the user to define an angle once and propagate it through the system as a signal. 
  A key feature of this block is the automatic handling of unit display, allowing users to input values in degrees while the simulation performs calculations in the SI standard (radians).
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"5\">
  <tbody><tr bgcolor=\"#f2f2f2\">
    <th>Name</th>
    <th>Type</th>
    <th>Unit</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><strong>angle</strong></td>
    <td>Modelica.Units.SI.Angle</td>
    <td>rad</td>
    <td>Value of the angle to be outputted. The user can enter this in degrees (deg).</td>
  </tr>
</tbody></table>

<h2>Connectors</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"5\">
  <tbody><tr bgcolor=\"#f2f2f2\">
    <th>Name</th>
    <th>Type</th>
    <th>Unit</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><strong>phi</strong></td>
    <td>RealOutput</td>
    <td>rad</td>
    <td>Output signal carrying the value of the <code>angle</code> parameter.</td>
  </tr>
</tbody></table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The block performs a direct assignment from the parameter to the output connector:
</p>

<ul>
  <li><strong>Direct Output:</strong> The equation governing the block is simply <em>phi = angle</em>.</li>
  <li><strong>Unit Handling:</strong> Although the signal is transmitted in <strong>radians</strong> (as per SI standards), the <code>displayUnit = \"deg\"</code> attribute ensures that the user interface shows the value in <strong>degrees</strong> (180° instead of 3.14159 rad).</li></ul>

<hr>
<p>
  <i>Note: This utility is part of the Aquanaut library for underwater vehicle modeling and simulation.</i>
</p>


</body></html>"));
end AngleOutput;

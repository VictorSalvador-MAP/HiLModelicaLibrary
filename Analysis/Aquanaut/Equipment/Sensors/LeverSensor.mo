within Aquanaut.Equipment.Sensors;

block LeverSensor
  extends Modelica.Blocks.Icons.Block;
  import Modelica.Blocks.Nonlinear.Limiter;
  Modelica.Blocks.Interfaces.RealInput u "Lever command [0..1]" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput v(unit = "V") "Lever output voltage [V]" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  // Electrical parameters
  parameter Modelica.Units.SI.Voltage Vmin = 0.8 "Minimal Voltage [V]";
  parameter Modelica.Units.SI.Voltage Vmax = 4.1 "Maximum Voltage [V]";
protected
  Real x "Saturated throttle position [0..1]";
  Modelica.Units.SI.Voltage v_si "Voltage in SI units";
equation
// Saturation and position-to-voltage conversion
  x = min(1, max(0, u));
  v_si = Vmin + (x + 1)/2*(Vmax - Vmin);
  v = v_si;
  annotation(
    Icon(graphics = {Rectangle(origin = {43, 3}, rotation = -45, fillColor = {160, 160, 160}, fillPattern = FillPattern.VerticalCylinder, extent = {{-3, -55}, {3, 22}}), Ellipse(origin = {64, 24}, fillColor = {220, 0, 0}, fillPattern = FillPattern.Sphere, extent = {{-13, -12}, {13, 12}}), Line(origin = {-0.93, 43.82}, points = {{-61.0668, 0.1761}, {-23.0668, 14.1761}, {10.9332, 16.1761}, {54.9332, 2.17606}}, thickness = 2, arrow = {Arrow.Filled, Arrow.Filled}, arrowSize = 10, smooth = Smooth.Bezier), Ellipse(origin = {-1, -41}, rotation = -90, fillColor = {200, 200, 200}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-18, 19}, {18, -19}}), Rectangle(origin = {-2, -47}, fillColor = {158, 158, 158}, fillPattern = FillPattern.VerticalCylinder, extent = {{-72, 13}, {72, -13}})}),
    Diagram(graphics),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Lever Sensor Model</h1>

<p>
  The <em>LeverSensor</em> model represents a position transducer used in marine control systems. 
  It acts as a signal interface that converts a normalized mechanical lever command (0 to 1) into a corresponding analog electrical voltage signal, typically used to interface with Electronic Control Units (ECUs).
</p>

<h2>Description</h2>

<p>
  This component models the behavior of a physical throttle or control lever sensor. 
  It reads a dimensionless input signal representing the mechanical position and maps it to a calibrated voltage range. 
  The model includes input saturation to ensure the signal remains within valid bounds before conversion, simulating the mechanical stops of the device.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the LeverSensor block</caption>
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
      <td><strong>Vmin</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Minimal output voltage at 0% lever position (default: 0.8 V).</td>
    </tr>
    <tr>
      <td><strong>Vmax</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Maximum output voltage at 100% lever position (default: 4.1 V).</td>
    </tr>
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Inputs and Outputs</caption>
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
      <td><strong>u</strong></td>
      <td>RealInput</td>
      <td>-</td>
      <td>Normalized lever command input [0..1].</td>
    </tr>
    <tr>
      <td><strong>v</strong></td>
      <td>RealOutput</td>
      <td>V</td>
      <td>Sensor output voltage signal.</td>
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
      <td><em>x</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Saturated throttle position clamped to the [0, 1] range.</td>
    </tr>
    <tr>
      <td><em>v_si</em></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Calculated intermediate voltage value.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The sensor operation is defined by a saturation stage followed by a linear transduction equation:
</p>

<ul>
  <li><strong>Saturation:</strong> The input command <em>u</em> is first clamped to ensure it falls strictly within the mechanical limits: 
    <br><em>x = min(1, max(0, u))</em>.
  </li>
  <li><strong>Voltage Mapping:</strong> The saturated position <em>x</em> is interpolated between the calibrated electrical limits defined by <code>Vmin</code> and <code>Vmax</code>:
    <br><em>v = V<sub>min</sub> + x · (V<sub>max</sub> - V<sub>min</sub>)</em>.
  </li>
  <li><strong>Signal Range:</strong> This ensures that a 0% command outputs exactly <em>V<sub>min</sub></em> and a 100% command outputs <em>V<sub>max</sub></em>, mimicking the behavior of a linear potentiometer or Hall-effect sensor.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Equipment.Sensors package within the Aquanaut library.</em>
</p>


</body></html>"));
end LeverSensor;

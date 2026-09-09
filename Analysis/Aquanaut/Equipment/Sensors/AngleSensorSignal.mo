within Aquanaut.Equipment.Sensors;

model AngleSensorSignal
  import Modelica.Blocks.Nonlinear.Limiter;
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor annotation(
    Placement(transformation(origin = {-34, 26}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit = "rad", displayUnit = "deg") annotation(
    Placement(transformation(origin = {4, 26}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput v(unit = "V") annotation(
    Placement(transformation(origin = {4, 4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
    Placement(transformation(origin = {-64, 26}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  parameter Modelica.Units.SI.Voltage minVoltage = 0.5;
  parameter Modelica.Units.SI.Voltage maxVoltage = 4.5;
  parameter Modelica.Units.SI.Angle minAngle = -0.7853981633974483;
  parameter Modelica.Units.SI.Angle maxAngle = 0.7853981633974483;
protected
  Real x;
  Modelica.Units.SI.Voltage v_si "Voltage in SI units";
equation
  x = min(maxAngle, max(minAngle, angleSensor.phi));
  v_si = (((x - minAngle)/(maxAngle - minAngle))*(maxVoltage - minVoltage)) + minVoltage;
  v = v_si;
  connect(flange, angleSensor.flange) annotation(
    Line(points = {{-64, 26}, {-44, 26}}));
  connect(angleSensor.phi, phi) annotation(
    Line(points = {{-22, 26}, {4, 26}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Ellipse(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-70, -70}, {70, 70}}), Line(points = {{0, 70}, {0, 40}}), Line(points = {{22.9, 32.8}, {40.2, 57.3}}), Line(points = {{-22.9, 32.8}, {-40.2, 57.3}}), Line(points = {{37.6, 13.7}, {65.8, 23.9}}), Line(points = {{-37.6, 13.7}, {-65.8, 23.9}}), Ellipse(lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, extent = {{-12, -12}, {12, 12}}), Polygon(rotation = -17.5, fillColor = {64, 64, 64}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-5, 0}, {-2, 60}, {0, 65}, {2, 60}, {5, 0}, {-5, 0}}), Ellipse(fillColor = {64, 64, 64}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-7, -7}, {7, 7}}), Line(points = {{-70, 0}, {-90, 0}}), Line(points = {{70, 0}, {100, 0}}, color = {0, 0, 127}), Text(textColor = {0, 0, 255}, extent = {{-150, 80}, {150, 120}}, textString = "%name"), Text(textColor = {64, 64, 64}, extent = {{-30, -10}, {30, -70}}, textString = "rad"), Line(rotation = -90, points = {{70, 0}, {100, 0}}, color = {0, 0, 127}), Text(origin = {89, 18}, extent = {{9, 44}, {-9, -44}}, textString = "θ"), Text(origin = {45, -80}, extent = {{37, 58}, {-37, -58}}, textString = "voltage")}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Angle Sensor Signal Model</h1>

<p>
  The <em>AngleSensorSignal</em> model represents a rotational position sensor (e.g., rudder angle indicator). 
  It measures the physical angular displacement of a mechanical flange and provides two outputs: the raw measured angle and a conditioned analog voltage signal suitable for control feedback.
</p>

<h2>Description</h2>

<p>
  This component serves as a bridge between the mechanical domain and the electrical control domain. 
  It utilizes an ideal <code>AngleSensor</code> to detect rotation. The model includes signal conditioning logic that maps the angular range to a linear voltage output (e.g., 0.5V to 4.5V), implementing saturation to simulate the physical limits of the sensor's electrical travel.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the AngleSensorSignal block</caption>
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
      <td><strong>minVoltage</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Minimum output voltage (default: 0.5 V).</td>
    </tr>
    <tr>
      <td><strong>maxVoltage</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Maximum output voltage (default: 4.5 V).</td>
    </tr>
    <tr>
      <td><strong>minAngle</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Angle corresponding to the minimum voltage (default: approx -45°).</td>
    </tr>
    <tr>
      <td><strong>maxAngle</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Angle corresponding to the maximum voltage (default: approx +45°).</td>
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
      <td><strong>flange</strong></td>
      <td>Flange_a</td>
      <td>-</td>
      <td>Rotational mechanical connector (Input shaft).</td>
    </tr>
    <tr>
      <td><strong>phi</strong></td>
      <td>RealOutput</td>
      <td>rad</td>
      <td>Raw measured angle (unbounded output).</td>
    </tr>
    <tr>
      <td><strong>v</strong></td>
      <td>RealOutput</td>
      <td>V</td>
      <td>Conditioned analog voltage signal (saturated output).</td>
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
      <td><em>angleSensor.phi</em></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Raw absolute angle measured by the internal sensor.</td>
    </tr>
    <tr>
      <td><em>x</em></td>
      <td>Real</td>
      <td>rad</td>
      <td>Saturated angle value clamped within [minAngle, maxAngle].</td>
    </tr>
    <tr>
      <td><em>v_si</em></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Calculated voltage value before output assignment.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model processes the mechanical input through two parallel paths:
</p>

<ul>
  <li><strong>Direct Measurement:</strong> The <code>phi</code> output directly reflects the angle of the <code>flange</code> relative to the frame, without saturation.</li>
  <li><strong>Voltage Transduction:</strong> To generate the voltage signal <em>v</em>, the model first saturates the input angle to the sensor's physical limits:
    <br><em>x = min(maxAngle, max(minAngle, φ))</em>.
  </li>
  <li><strong>Linear Mapping:</strong> The saturated angle <em>x</em> is then mapped to the voltage range:
    <br><em>v = V<sub>min</sub> + ( (x - φ<sub>min</sub>) / (φ<sub>max</sub> - φ<sub>min</sub>) ) · (V<sub>max</sub> - V<sub>min</sub>)</em>.
  </li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Equipment.Sensors package within the Aquanaut library.</em>
</p>


</body></html>"));
end AngleSensorSignal;

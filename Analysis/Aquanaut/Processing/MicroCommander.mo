within Aquanaut.Processing;

block MicroCommander
  extends Modelica.Blocks.Icons.Block;
  //Input and Output interfaces
  Modelica.Blocks.Interfaces.RealInput vLever(unit = "V") "Lever Voltage[V]" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput throttle "Normalized throttle [0..1]" annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput leverPos(unit = "m", displayUnit = "mm") "Effective linear position [mm]" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput leverAngle(unit = "rad", displayUnit = "deg") "Engine throttle selector lever angle [rad]" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  // Electrical
  parameter Modelica.Units.SI.Voltage Vmin = 0.8;
  parameter Modelica.Units.SI.Voltage Vmax = 4.1;
  // Geometry
  parameter Modelica.Units.SI.Length armLength = 0.2253 "Engine throttle selector lever length";
  parameter Modelica.Units.SI.Angle thetaMin = 0.7853981633974483 "Minimum angle";
  parameter Modelica.Units.SI.Angle thetaMax = 2.356194490192345 "Maximum angle [deg]";
  parameter Modelica.Units.SI.Length dMin(displayUnit = "mm") = 0.02 "Minimum linear stroke";
  parameter Modelica.Units.SI.Length dMax(displayUnit = "mm") = 0.18 "Maximum linear stroke";
  // Throttle limits
  parameter Real throttleMin = 0.05 "Min throttle [0..1]";
  parameter Real throttleMax = 1.0 "Max throttle [0..1]";
protected
  Real xRaw;
  Real xNorm;
  Real xPos;
  Modelica.Units.SI.Angle theta;
  Modelica.Units.SI.Length d;
equation
  // Electrical normalization
  xRaw = 2*(vLever - Vmin)/(Vmax - Vmin) - 1;
  xNorm = min(1, max(-1, xRaw));
  xPos = max(0, xNorm);
  // Geometric interpolation
  theta = thetaMin + xPos*(thetaMax - thetaMin);
  d = dMin + xPos*(dMax - dMin);
  // Saturations
  leverAngle = min(thetaMax, max(thetaMin, theta));
  leverPos = min(dMax, max(dMin, d));
  throttle = throttleMin + (leverPos - dMin)/(dMax - dMin)*(throttleMax - throttleMin);
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(origin = {-30, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-10, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {10, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {30, 68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-30, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-10, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {10, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {30, -68}, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, 30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, 10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, -10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {-68, -30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, 30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, 10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, -10}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(origin = {68, -30}, rotation = 90, fillColor = {255, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-6, 10}, {6, -10}}), Rectangle(fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}), Rectangle(fillColor = {0, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Text(origin = {-1, 3}, extent = {{-35, -33}, {35, 33}}, textString = "MC", textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>MicroCommander Control Model</h1>

<p>
  The <em>MicroCommander</em> model represents a marine propulsion control unit. 
  It processes the analog voltage signal from a bridge command lever to calculate the physical kinematics (lever angle and stroke) and generates a normalized throttle command signal for the engine governor.
</p>

<h2>Description</h2>

<p>
  This component acts as an interface between the electrical control system and the mechanical actuation of the engine. 
  It normalizes the input voltage into a dimensionless control range, handling signal saturation and dead-zones. 
  Additionally, it computes the physical state of the actuator (position and angle) based on geometric parameters, which is useful for 3D visualization or mechanical linkage simulation.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the MicroCommander block</caption>
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
      <td>Minimum input voltage corresponding to full reverse/idle (default: 0.8 V).</td>
    </tr>
    <tr>
      <td><strong>Vmax</strong></td>
      <td>Voltage</td>
      <td>V</td>
      <td>Maximum input voltage corresponding to full forward (default: 4.1 V).</td>
    </tr>
    <tr>
      <td><strong>armLength</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Physical length of the throttle selector lever arm.</td>
    </tr>
    <tr>
      <td><strong>thetaMin</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Minimum angular position of the lever.</td>
    </tr>
    <tr>
      <td><strong>thetaMax</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Maximum angular position of the lever.</td>
    </tr>
    <tr>
      <td><strong>dMin</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Minimum linear stroke of the actuator.</td>
    </tr>
    <tr>
      <td><strong>dMax</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Maximum linear stroke of the actuator.</td>
    </tr>
    <tr>
      <td><strong>throttleMin</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Minimum normalized throttle output [0..1] (Idle).</td>
    </tr>
    <tr>
      <td><strong>throttleMax</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Maximum normalized throttle output [0..1] (Full Power).</td>
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
      <td><strong>vLever</strong></td>
      <td>RealInput</td>
      <td>V</td>
      <td>Analog voltage input from the physical lever.</td>
    </tr>
    <tr>
      <td><strong>throttle</strong></td>
      <td>RealOutput</td>
      <td>-</td>
      <td>Normalized engine power demand signal [0..1].</td>
    </tr>
    <tr>
      <td><strong>leverPos</strong></td>
      <td>RealOutput</td>
      <td>m</td>
      <td>Calculated effective linear position (stroke).</td>
    </tr>
    <tr>
      <td><strong>leverAngle</strong></td>
      <td>RealOutput</td>
      <td>rad</td>
      <td>Calculated angular position of the lever.</td>
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
      <td><em>xRaw</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Raw normalized input mapped to the range [-1, 1].</td>
    </tr>
    <tr>
      <td><em>xNorm</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Clamped normalized input (saturated).</td>
    </tr>
    <tr>
      <td><em>xPos</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Positive component of the demand (0 to 1), filtering out reverse/negative signals.</td>
    </tr>
    <tr>
      <td><em>theta</em></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Intermediate angular calculation based on geometry.</td>
    </tr>
    <tr>
      <td><em>d</em></td>
      <td>Length</td>
      <td>m</td>
      <td>Intermediate stroke calculation.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model processes the input voltage through a sequence of normalization and geometric interpolation steps:
</p>

<ul>
  <li><strong>Voltage Normalization:</strong> The input voltage <code>vLever</code> is first mapped to a symmetric range [-1, 1] based on the calibrated limits:
    <br><em>x<sub>raw</sub> = 2 · (v<sub>Lever</sub> - V<sub>min</sub>) / (V<sub>max</sub> - V<sub>min</sub>) - 1</em>.
  </li>
  <li><strong>Unidirectional Filtering:</strong> The model isolates the positive command range (Forward) by clamping negative values to zero:
    <br><em>x<sub>pos</sub> = max(0, min(1, x<sub>raw</sub>))</em>.
    <br>(Note: This implies the block treats voltages below the midpoint as neutral/idle for the purpose of these specific outputs).
  </li>
  <li><strong>Geometric Mapping:</strong> The normalized positive demand <em>x<sub>pos</sub></em> is linearly interpolated to determine physical outputs:
    <br><em>θ = θ<sub>min</sub> + x<sub>pos</sub> · (θ<sub>max</sub> - θ<sub>min</sub>)</em>
    <br><em>d = d<sub>min</sub> + x<sub>pos</sub> · (d<sub>max</sub> - d<sub>min</sub>)</em>.
  </li>
  <li><strong>Throttle Output:</strong> The final throttle signal is derived from the calculated stroke, scaled to the engine's operational range:
    <br><em>throttle = throttle<sub>min</sub> + ((d - d<sub>min</sub>) / (d<sub>max</sub> - d<sub>min</sub>)) · (throttle<sub>max</sub> - throttle<sub>min</sub>)</em>.
  </li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Processing package within the Aquanaut library.</em>
</p>


</body></html>"));
end MicroCommander;

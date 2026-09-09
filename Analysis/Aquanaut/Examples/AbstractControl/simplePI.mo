within Aquanaut.Examples.AbstractControl;

model simplePI
  parameter Real Kp = 2000;
  parameter Real Ki = 500;
  Modelica.Blocks.Continuous.Integrator integrator annotation(
    Placement(transformation(origin = {-50, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add rateError(k2 = -1) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain rateGain(k = Kp) annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add integralError(k1 = -1) annotation(
    Placement(transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain integralGain(k = Ki) annotation(
    Placement(transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput speedReference "reference" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput controlSignal "control signal" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput feedbackSignals[2] "1 - position measurement, 2 - speed measurement" annotation(
    Placement(transformation(origin = {-62, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
equation
  connect(rateError.y, rateGain.u) annotation(
    Line(points = {{1, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(integralError.y, integralGain.u) annotation(
    Line(points = {{1, -60}, {18, -60}}, color = {0, 0, 127}));
  connect(add.y, controlSignal) annotation(
    Line(points = {{93, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(integralGain.y, add.u2) annotation(
    Line(points = {{41, -60}, {60, -60}, {60, -6}, {70, -6}}, color = {0, 0, 127}));
  connect(integrator.y, integralError.u2) annotation(
    Line(points = {{-39, -66}, {-22, -66}}, color = {0, 0, 127}));
  connect(rateGain.y, add.u1) annotation(
    Line(points = {{42, 60}, {60, 60}, {60, 6}, {70, 6}}, color = {0, 0, 127}));
  connect(speedReference, rateError.u1) annotation(
    Line(points = {{-120, 0}, {-86, 0}, {-86, 66}, {-22, 66}}, color = {0, 0, 127}));
  connect(speedReference, integrator.u) annotation(
    Line(points = {{-120, 0}, {-86, 0}, {-86, -66}, {-62, -66}}, color = {0, 0, 127}));
  connect(feedbackSignals[1], integralError.u1) annotation(
    Line(points = {{-62, 0}, {-32, 0}, {-32, -54}, {-22, -54}}, color = {0, 0, 127}));
  connect(feedbackSignals[2], rateError.u2) annotation(
    Line(points = {{-62, 0}, {-32, 0}, {-32, 54}, {-22, 54}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Line(origin = {-74, -22}, points = {{0, -62}, {0, 62}}, color = {85, 170, 127}, thickness = 4.25), Line(origin = {-76, -20}, points = {{0, -62}, {150, -62}}, color = {85, 170, 127}, thickness = 4.25), Line(origin = {-74, 16}, points = {{0, -62}, {126, 8}}, color = {85, 170, 0}, thickness = 4.25), Text(origin = {-5, 70}, textColor = {0, 170, 0}, extent = {{-57, 24}, {57, -24}}, textString = "PI")}),
  Documentation(info = "<html><head>
</head>
<body>
<h1>Simple PI Controller Model</h1>

<p>
  The <em>simplePI</em> model is a straightforward Proportional-Integral (PI) controller built from standard Modelica blocks. 
  It utilizes a dual-feedback approach: computing the proportional action from the rate (speed) error and the integral action from the state (position) error.
</p>

<h2>Description</h2>

<p>
  This component is designed for basic trajectory and velocity tracking. Instead of feeding a single error signal into a standard PI block, it integrates the speed reference to generate a continuous position reference. 
  It then compares this generated position directly to the measured position feedback. This structure allows the controller to simultaneously regulate the rate of change and correct any cumulative steady-state position errors.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the simplePI block</caption>
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
      <td>-</td>
      <td>Proportional gain. Tunes the immediate reaction to rate (speed) tracking errors.</td>
    </tr>
    <tr>
      <td><strong>Ki</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Integral gain. Tunes the reaction to cumulative state (position) tracking errors.</td>
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
      <td><strong>speedReference</strong></td>
      <td>RealInput</td>
      <td>-</td>
      <td>The target reference rate/speed setpoint.</td>
    </tr>
    <tr>
      <td><strong>feedbackSignals</strong></td>
      <td>RealInput[2]</td>
      <td>-</td>
      <td>Feedback array containing position measurement (index 1) and speed measurement (index 2).</td>
    </tr>
    <tr>
      <td><strong>controlSignal</strong></td>
      <td>RealOutput</td>
      <td>-</td>
      <td>The computed control effort.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 3:</strong> Internal block structure</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><em>integrator</em></td>
      <td>Integrator</td>
      <td>Integrates the <code>speedReference</code> to create an ideal position reference.</td>
    </tr>
    <tr>
      <td><em>rateError</em></td>
      <td>Add</td>
      <td>Calculates the difference between the target speed and measured speed.</td>
    </tr>
    <tr>
      <td><em>integralError</em></td>
      <td>Add</td>
      <td>Calculates the difference between the ideal integrated position and the measured position.</td>
    </tr>
    <tr>
      <td><em>rateGain, integralGain</em></td>
      <td>Gain</td>
      <td>Multiplies the calculated errors by the tuning parameters <em>Kp</em> and <em>Ki</em>.</td>
    </tr>
  </tbody>
</table>

<h2>Mathematical Logic</h2>

<p>
  The controller computes the final output signal (<em>u</em>) by combining two distinct calculation paths using standard arithmetic blocks:
</p>

<ul>
  <li><strong>Proportional Path (Rate Control):</strong> The rate error is calculated by subtracting the measured speed from the speed reference. This is multiplied by the proportional gain: 
    <br><em>u<sub>P</sub> = Kp * (v<sub>ref</sub> - v<sub>meas</sub>)</em>
  </li>
  <li><strong>Integral Path (Position Control):</strong> The block integrates the speed reference to map the theoretical path. It then subtracts the actual measured position (<code>feedbackSignals[1]</code>). This error is multiplied by the integral gain:
    <br><em>u<sub>I</sub> = Ki * (∫ v<sub>ref</sub> dt - x<sub>meas</sub>)</em>
  </li>
  <li><strong>Final Control Effort:</strong> The outputs of both gain blocks are summed together to form the final command:
    <br><em>u = u<sub>P</sub> + u<sub>I</sub></em>
  </li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the AbstractControl package and can be applied to any generic 1D control loop requiring rate and state tracking.</em>
</p>


</body></html>"));
end simplePI;

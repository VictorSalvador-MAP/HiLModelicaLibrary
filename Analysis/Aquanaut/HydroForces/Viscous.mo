within Aquanaut.HydroForces;

model Viscous
  
/*
  Viscous hydrodynamic force and moment model.

  This model implements linear and nonlinear viscous damping forces and
  moments for a marine craft in 6 DOF, expressed in the BODY frame.

  The formulation follows maneuvering theory as presented in:

    T. I. Fossen (2011),
    "Handbook of Marine Craft Hydrodynamics and Motion Control",
    Chapter 6 (Maneuvering Theory), Equation (6.101).

  The viscous forces are modeled using linear and quadratic velocity-dependent
  damping terms, including cross-coupling effects between sway, yaw, and roll.
*/

  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
  
  // Options
  parameter Boolean useStream = false;
  
  // Linear viscous damping coefficients
  parameter Real Xu = 0 "Surge linear damping coefficient" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Yv = 0 "Sway linear damping coefficient" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Zw = 0 "Heave linear damping coefficient" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Kp = 0 "Roll linear damping coefficient" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Mq = 0 "Pitch linear damping coefficient" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Nr = 0 "Yaw linear damping coefficient" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
 
  // Cross-coupling linear damping terms
  parameter Real Yp = 0 "Sway due to roll rate coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Yr = 0 "Sway due to yaw rate coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Zq = 0 "Heave due to pitch rate coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Kv = 0 "Roll due to sway velocity coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Kr = 0 "Roll due to yaw rate coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Mw = 0 "Pitch due to heave velocity coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Nv = 0 "Yaw due to sway velocity coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  parameter Real Np = 0 "Yaw due to roll rate coupling" annotation(
    Dialog(group = "Linear viscous damping coefficients"));
  
  // Quadratic viscous damping coefficients
  parameter Real Xuu = 0 "Quadratic surge damping" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));  
  
  parameter Real Yvv = 0 "Quadratic sway damping" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Yrv = 0 "Sway damping due to |r|v coupling" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Yvr = 0 "Sway damping due to |v|r coupling" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Yrr = 0 "Sway damping due to |r|r coupling" annotation(
    Dialog(group = "Quadratic viscous damping coefficients")); 
  
  parameter Real Nvv = 0 "Yaw damping due to |v|v coupling" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Nrv = 0 "Yaw damping due to |r|v coupling" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Nvr = 0 "Yaw damping due to |v|r coupling" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Nrr = 0 "Quadratic yaw damping" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));  
  
  parameter Real Zww = 0 "Quadratic heave damping" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));  
  parameter Real Kpp = 0 "Quadratic roll damping" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  parameter Real Mqq = 0 "Quadratic pitch damping" annotation(
    Dialog(group = "Quadratic viscous damping coefficients"));
  
  // Velocities
  Modelica.Units.SI.Velocity v[3] "Velocity in world frame"; 
  Modelica.Units.SI.Velocity vBody[3] "Velocity in body frame (u, v, w)";
  Modelica.Units.SI.AngularVelocity omega[3] "Angular velocity (p, q, r)";
  Real[6] genVel "Generalized velocity vector (u v w p q r)";
  
  // Hydrodynamic viscous forces and moments
  Modelica.Units.SI.Force fViscous[3];
  Modelica.Units.SI.Torque tauViscous[3];

  protected outer Aquanaut.HydroForces.Stream Stream;

equation

  // Generalized velocity vector assembly
  genVel = cat(1, vBody, omega);

  // Translational kinematics
  
  if useStream then
    //v = der(frame_a.r_0) - {Stream.vStream[1], Stream.vStream[2], 0};
    v = der(frame_a.r_0) - {Stream.v[1], Stream.v[2], 0};
  else
    v = der(frame_a.r_0);
  end if;
  
  vBody = Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, v);
  
  // Rotational kinematics
  omega = Modelica.Mechanics.MultiBody.Frames.angularVelocity2(frame_a.R);
  
  // Surge viscous force: linear + quadratic damping
  fViscous[1] = genVel[1]*(Xu + Xuu*abs(genVel[1]));
  
  // Sway viscous force with cross-coupling from roll and yaw
  fViscous[2] = Yp*genVel[4] + genVel[2]*(Yrv*abs(genVel[6]) + Yv + Yvv*abs(genVel[2])) + genVel[6]*(Yr + Yrr*abs(genVel[6]) + Yvr*abs(genVel[2]));
  
  // Heave viscous force
  fViscous[3] = Zq*genVel[5] + genVel[3]*(Zw + Zww*abs(genVel[3]));
  
  // Roll viscous moment
  tauViscous[1] = Kr*genVel[6] + Kv*genVel[2] + genVel[4]*(Kp + Kpp*abs(genVel[4]));
  
  // Pitch viscous moment
  tauViscous[2] = Mw*genVel[3] + genVel[5]*(Mq + Mqq*abs(genVel[5]));
  
  // Yaw viscous moment with sway coupling
  tauViscous[3] = Np*genVel[4] + genVel[2]*(Nrv*abs(genVel[6]) + Nv + Nvv*abs(genVel[2])) + genVel[6]*(Nr + Nrr*abs(genVel[6]) + Nvr*abs(genVel[2]));

  // Apply forces and moments to the multibody frame
  //frame_a.f = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R,fViscous);
  frame_a.f = fViscous;
  frame_a.t = tauViscous;


annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {-34, 0}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 9}, {4, -9}}), Polygon(origin = {-62, 0}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}}), Ellipse(origin = {19, 1}, lineColor = {85, 0, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Sphere, extent = {{-45, 45}, {45, -45}}), Line(origin = {7, -34.89}, points = {{88.9972, 10.8908}, {56.9972, 6.8908}, {16.9972, -31.1092}, {-49.0028, 12.8908}, {-89.0028, 8.89078}}, color = {85, 0, 255}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {7, -62.89}, points = {{88.9972, 10.8908}, {56.9972, 6.8908}, {14.9972, -15.1092}, {-49.0028, 12.8908}, {-89.0028, 8.89078}}, color = {85, 85, 255}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {7, -86.89}, points = {{88.9972, 10.8908}, {56.9972, 6.8908}, {14.9972, -9.1092}, {-49.0028, 12.8908}, {-89.0028, 8.89078}}, color = {85, 170, 255}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {7, 21.11}, points = {{88.9972, 10.8908}, {56.9972, 6.8908}, {22.9972, 42.8908}, {-49.0028, 12.8908}, {-89.0028, 8.89078}}, color = {85, 0, 255}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {7, 51.11}, points = {{88.9972, 10.8908}, {56.9972, 6.8908}, {10.9972, 24.8908}, {-47.0028, 2.8908}, {-89.0028, 4.89078}}, color = {85, 85, 255}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {7, 73.11}, points = {{88.9972, 10.8908}, {56.9972, 6.8908}, {10.9972, 16.8908}, {-47.0028, 2.8908}, {-89.0028, 4.89078}}, color = {85, 170, 255}, thickness = 4.25, smooth = Smooth.Bezier), Text(textColor = {85, 85, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name", textStyle = {TextStyle.Bold})}),
 Documentation(info = "<html><head></head><body>
<h1>Viscous Damping Model</h1>

<p>
  The <em>Viscous</em> model implements linear and nonlinear viscous damping forces and moments for a marine craft in 6 Degrees of Freedom (6-DOF). 
  This component is essential for simulating the energy dissipation caused by skin friction, wave drift, and vortex shedding during maneuvering operations.
</p>

<h2>Description</h2>

<p>
  This model utilizes a semi-empirical approach based on Maneuvering Theory (Fossen, 2011) to calculate hydrodynamic damping. 
  It computes the resistive forces as a function of the vessel's relative velocity, combining linear terms (dominant at low speeds) and quadratic terms (dominant at high speeds or in cross-flow conditions).
  The formulation includes extensive cross-coupling support to capture complex interactions like sway-induced yaw moments.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Viscous block</caption>
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
      <td><strong>useStream</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>If true, damping is calculated based on relative velocity (Vessel - Current). Requires a global <code>Stream</code> object.</td>
    </tr>
    <tr>
      <td><strong>Xu</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Surge linear damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Yv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Sway linear damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Zw</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Heave linear damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Kp</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Roll linear damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Mq</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Pitch linear damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Nr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Yaw linear damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Yp</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Sway force due to roll rate.</td>
    </tr>
    <tr>
      <td><strong>Yr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Sway force due to yaw rate.</td>
    </tr>
    <tr>
      <td><strong>Zq</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Heave force due to pitch rate.</td>
    </tr>
    <tr>
      <td><strong>Kv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Roll moment due to sway velocity.</td>
    </tr>
    <tr>
      <td><strong>Kr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Roll moment due to yaw rate.</td>
    </tr>
    <tr>
      <td><strong>Mw</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Pitch moment due to heave velocity.</td>
    </tr>
    <tr>
      <td><strong>Nv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Yaw moment due to sway velocity.</td>
    </tr>
    <tr>
      <td><strong>Np</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Yaw moment due to roll rate.</td>
    </tr>
    <tr>
      <td><strong>Xuu</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Quadratic surge damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Yvv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Quadratic sway damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Yrv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Sway damping due to |r|v interaction.</td>
    </tr>
    <tr>
      <td><strong>Yvr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Sway damping due to |v|r interaction.</td>
    </tr>
    <tr>
      <td><strong>Yrr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Sway damping due to |r|r interaction.</td>
    </tr>
    <tr>
      <td><strong>Nvv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Yaw damping due to |v|v interaction.</td>
    </tr>
    <tr>
      <td><strong>Nrv</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Yaw damping due to |r|v interaction.</td>
    </tr>
    <tr>
      <td><strong>Nvr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Coupling: Yaw damping due to |v|r interaction.</td>
    </tr>
    <tr>
      <td><strong>Nrr</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Quadratic yaw damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Zww</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Quadratic heave damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Kpp</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Quadratic roll damping coefficient.</td>
    </tr>
    <tr>
      <td><strong>Mqq</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Quadratic pitch damping coefficient.</td>
    </tr>
  </tbody>
</table>

<h2>Connectors</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Connectors of the Viscous block</caption>
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
      <td><strong>frame_a</strong></td>
      <td>Frame_a</td>
      <td>-</td>
      <td>3D mechanical connector attached to the vessel's hull.</td>
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
      <td><em>genVel</em></td>
      <td>Real[6]</td>
      <td>-</td>
      <td>Generalized velocity vector (u, v, w, p, q, r).</td>
    </tr>
    <tr>
      <td><em>vBody</em></td>
      <td>Velocity[3]</td>
      <td>m/s</td>
      <td>Linear velocity resolved in the body frame.</td>
    </tr>
    <tr>
      <td><em>omega</em></td>
      <td>AngularVelocity[3]</td>
      <td>rad/s</td>
      <td>Angular velocity resolved in the body frame.</td>
    </tr>
    <tr>
      <td><em>fViscous</em></td>
      <td>Force[3]</td>
      <td>N</td>
      <td>Calculated viscous force vector (Surge, Sway, Heave).</td>
    </tr>
    <tr>
      <td><em>tauViscous</em></td>
      <td>Torque[3]</td>
      <td>N.m</td>
      <td>Calculated viscous moment vector (Roll, Pitch, Yaw).</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes the viscous force vector <em>τ<sub>D</sub></em> based on <strong>Equation 6.101</strong> from Fossen (2011). The total damping is the sum of linear and nonlinear contributions:
</p>

<ul>
  <li><strong>Equation Form:</strong> The force is calculated as <em>f = D · v</em>. Since hydrodynamic damping opposes motion, the coefficients (D) provided as parameters should typically be <strong>negative</strong> (representing derivatives like <em>X<sub>u</sub></em>, <em>Y<sub>v</sub></em>, etc.).</li>
  <li><strong>Linear Damping:</strong> Proportional to the first power of velocity: <em>f<sub>i</sub></em> = <em>D<sub>i</sub></em> · <em>ν<sub>i</sub></em> (e.g., <em>X<sub>u</sub></em> · <em>u</em>).</li>
  <li><strong>Quadratic Damping:</strong> Proportional to the square of velocity (signed square): <em>f<sub>i</sub></em> = <em>D<sub>ii</sub></em> · |<em>ν<sub>i</sub></em>| · <em>ν<sub>i</sub></em> (e.g., <em>X<sub>uu</sub></em> · |<em>u</em>|<em>u</em>).</li>
  <li><strong>Relative Velocity (Stream):</strong> If <code>useStream</code> is enabled, the velocity vector <em>ν</em> is calculated relative to the ocean current: <em>v = v<sub>vessel</sub> - v<sub>current</sub></em>.</li>
  <li><strong>Coupling Effects:</strong> The model accounts for interactions where motion in one axis creates resistance in another. For example, the Sway force includes terms like <em>Y<sub>v</sub>v</em>, <em>Y<sub>p</sub>p</em> (linear coupling), and <em>Y<sub>rv</sub></em>|<em>r</em>|<em>v</em> (nonlinear coupling).</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the HydroForces package within the Aquanaut library and is based on the formulation by Fossen (2011).</em>
</p>


</body></html>"));
end Viscous;

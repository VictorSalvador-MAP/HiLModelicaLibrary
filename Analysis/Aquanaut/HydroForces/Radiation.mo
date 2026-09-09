within Aquanaut.HydroForces;

model Radiation
  // Options
  parameter Boolean useStream = false "If true, velocity is calculated relative to the stream";
  
  // Connectors
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
  
  // Parameters
  // Matrices with hydrodynamic coefficients (Added Mass)
  parameter Real mAdded[6, 6] = [180.335189897495, -7.44174862801348, 69.6890402915645, -4.39007097567196, 1155.89226555321, 29.3293505194535; -4.84110637653422, 5757.44128100768, -137.038985472874, 3778.90412879883, -181.31045351422, -5619.98272807521; 115.601920635157, -86.1284543734622, 11558.6535706342, 181.446223798158, 6572.33123951005, 465.283763579646; -1.65928226980252, 3752.44130697272, 117.967781614745, 4869.30377536301, 3.75775111292269, -5070.08865715427; 1260.26516046638, -314.933844362056, 6462.68727701292, -88.5914961013906, 52449.6492337649, 2379.90929597369; 4.12331262488362, -5737.62714165604, 184.092903985374, -5290.43336666732, 985.78348245588, 22223.7723247971];
  
  Real mAdded_f[6,6];
  
  // State-space matrices for radiation forces
  // Surge (1,1)
  parameter Real A_Surge[:, :] = [-0, -0, 0, -0, -0, 2.41641848456364; 1, 0, 0, -0, 0, 1.66492452512905; 0, 0.999999999999999, 0, -0, 0, 1.22354973552274; 0, 0, -1, 0, -0, -0.330862435795427; 0, 0, 0, 10, 0, -0.858381279446004; 0, 0, 0, 0, 100, -9.72213134916116];
  parameter Real B_Surge[:, :] = [0; -1.85610100823825; -1.20075559096487; 0.738810544091954; 1.21408781946749; 24.3168093638309];
  parameter Real C_Surge[:, :] = [0, 0, 0, 0, 0, 241.641848456364];
  
  // Pitch on Surge (1,5)
  parameter Real A_PitchOnSurge[:, :] = [0, -0, 0, -1.38625617605506; 1, -0, -0, -0.509939384044057; 0, 9.99999999999999, -0, -3.41623515287456; 0, 0, 9.99999999999999, -3.75960312222953];
  parameter Real B_PitchOnSurge[:, :] = [-0; 12.6451883285808; 31.1966947172478; 65.8562054372281];
  parameter Real C_PitchOnSurge[:, :] = [0, 0, 0, 138.625617605506];
  
  // Sway (2,2)
  parameter Real A_Sway[:, :] = [0, 0, -0, 0.486389443810072; 0.999999999999999, -0, -0, 0.197703001525717; 0, -10, -0, -0.911195935858334; 0, 0, 100, -7.22247757532507];
  parameter Real B_Sway[:, :] = [0; -14.7286439768212; 64.9332129632618; 166.151954060643];
  parameter Real C_Sway[:, :] = [0, 0, 0, 48.6389443810071];
  
  // Roll on Sway (2,4)
  parameter Real A_RollOnSway[:, :] = [0, -2.83692033208408; 10, -4.59289201656813];
  parameter Real B_RollOnSway[:, :] = [0; -272.501267765004];
  parameter Real C_RollOnSway[:, :] = [0, 28.3692033208408];
  
  // Heave (3,3)
  parameter Real A_Heave[:, :] = [-0, -0, 0, 0.197340394724591; 1, -0, 0, 0.131922369910159; 0, -10, 0, -0.503910920755586; 0, 0, 100, -5.50774722982973];
  parameter Real B_Heave[:, :] = [0; -19.496640206621; 30.2132667320253; 579.668004015087];
  parameter Real C_Heave[:, :] = [0, 0, 0, 197.340394724591];
  
  // Sway on Roll (4,2)
  parameter Real A_SwayOnRoll[:, :] = [0, -0, 10.2836506720696; 0.999999999999999, -0, 4.67873841855505; 0, -10, -9.78469061950064];
  parameter Real B_SwayOnRoll[:, :] = [0; -30.2520021533338; 134.051081066867];
  parameter Real C_SwayOnRoll[:, :] = [0, 0, -102.836506720696];
  
  // Roll (4,4)
  parameter Real A_Roll[:, :] = [0, -4.8592074140417; 10, -6.38047540301524];
  parameter Real B_Roll[:, :] = [0; -165.123424805755];
  parameter Real C_Roll[:, :] = [0, -48.592074140417];
  
  // Surge on Pitch (5,1)
  parameter Real A_SurgeOnPitch[:, :] = [-0, -0, 3.17594233429249; -1, -0, -2.01147477468996; 0, 10, -8.11731373190006];
  parameter Real B_SurgeOnPitch[:, :] = [0; 18.5135662484601; 115.3604021129];
  parameter Real C_SurgeOnPitch[:, :] = [0, 0, 317.594233429249];
  
  // Pitch (5,5)
  parameter Real A_Pitch[:, :] = [0, -0, -0, 0.279466164442329; 1, -0, 0, 0.0979590216070075; 0, -10, -0, -0.51006232265488; 0, 0, 100, -3.59950588833949];
  parameter Real B_Pitch[:, :] = [-0; -33.4286196351807; 69.7069191792515; 719.51143276619];
  parameter Real C_Pitch[:, :] = [0, 0, 0, 279.46616444233];
  
  // Variables
  // Velocities
  Modelica.Units.SI.Velocity v[3];
  Modelica.Units.SI.Velocity vBody[3];
  Modelica.Units.SI.AngularVelocity omega[3];
  Real[6] genVel;
  
  // Accelerations
  Modelica.Units.SI.Acceleration aBody[3];
  Modelica.Units.SI.AngularAcceleration alpha[3];
  Real[6] genAcc;
  
  // Hydrodynamic Forces
  Modelica.Units.SI.Force fAdded[3];
  Modelica.Units.SI.Torque tauAdded[3];
  Modelica.Units.SI.Force fRad[3];
  Modelica.Units.SI.Torque tauRad[3];
  Modelica.Units.SI.Force fCoriolis[3];
  Modelica.Units.SI.Torque tauCoriolis[3];

  // Sub-models
  // Radiation state-space models
  Modelica.Blocks.Continuous.StateSpace rad_Surge(A = A_Surge, B = B_Surge, C = C_Surge);
  Modelica.Blocks.Continuous.StateSpace rad_PitchOnSurge(A = A_PitchOnSurge, B = B_PitchOnSurge, C = C_PitchOnSurge);
  Modelica.Blocks.Continuous.StateSpace rad_Sway(A = A_Sway, B = B_Sway, C = C_Sway);
  Modelica.Blocks.Continuous.StateSpace rad_RollOnSway(A = A_RollOnSway, B = B_RollOnSway, C = C_RollOnSway);
  Modelica.Blocks.Continuous.StateSpace rad_Heave(A = A_Heave, B = B_Heave, C = C_Heave);
  Modelica.Blocks.Continuous.StateSpace rad_SwayOnRoll(A = A_SwayOnRoll, B = B_SwayOnRoll, C = C_SwayOnRoll);
  Modelica.Blocks.Continuous.StateSpace rad_Roll(A = A_Roll, B = B_Roll, C = C_Roll);
  Modelica.Blocks.Continuous.StateSpace rad_SurgeOnPitch(A = A_SurgeOnPitch, B = B_SurgeOnPitch, C = C_SurgeOnPitch);
  Modelica.Blocks.Continuous.StateSpace rad_Pitch(A = A_Pitch, B = B_Pitch, C = C_Pitch);

protected
  outer HydroForces.Stream Stream;
  
  // Virtual forces
  Real virtualSurgeForce;
  Real virtualSwayForce;
  Real virtualHeaveForce;
  
  // Virtual moments
  Real virtualRollMoment;
  Real virtualPitchMoment;
  Real virtualYawMoment;

equation

  // Kinematics
  genAcc = cat(1, aBody, alpha);
  genVel = cat(1, vBody, omega);

  // Translational kinematics
  if useStream then
    //v = der(frame_a.r_0) - {Stream.vStream[1], Stream.vStream[2], 0};
    v = der(frame_a.r_0) - {Stream.v[1], Stream.v[2], 0};
  else
    v = der(frame_a.r_0);
  end if;
  
  vBody = Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, v);
  aBody = Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, der(v));
  
  // Rotational kinematics
  omega = Modelica.Mechanics.MultiBody.Frames.angularVelocity2(frame_a.R);
  alpha = der(omega);

  // Kinetics (Forces and Torques)
  // Added mass force and torque
  fAdded = mAdded[1:3, 1:6]*genAcc;
  tauAdded = mAdded[4:6, 1:6]*genAcc;
  
  mAdded_f = (mAdded + transpose(mAdded))/2;
  
  // Coriolis virtual momentum components
  virtualSurgeForce = mAdded_f[1, 1]*vBody[1] + mAdded_f[1, 2]*vBody[2] + mAdded_f[1, 3]*vBody[3] + mAdded_f[1, 4]*omega[1] + mAdded_f[1, 5]*omega[2] + mAdded_f[1, 6]*omega[3];
  virtualSwayForce = mAdded_f[2, 1]*vBody[1] + mAdded_f[2, 2]*vBody[2] + mAdded_f[2, 3]*vBody[3] + mAdded_f[2, 4]*omega[1] + mAdded_f[2, 5]*omega[2] + mAdded_f[2, 6]*omega[3];
  virtualHeaveForce = mAdded_f[3, 1]*vBody[1] + mAdded_f[3, 2]*vBody[2] + mAdded_f[3, 3]*vBody[3] + mAdded_f[3, 4]*omega[1] + mAdded_f[3, 5]*omega[2] + mAdded_f[3, 6]*omega[3];
  virtualRollMoment = mAdded_f[4, 1]*vBody[1] + mAdded_f[4, 2]*vBody[2] + mAdded_f[4, 3]*vBody[3] + mAdded_f[4, 4]*omega[1] + mAdded_f[4, 5]*omega[2] + mAdded_f[4, 6]*omega[3];
  virtualPitchMoment = mAdded_f[5, 1]*vBody[1] + mAdded_f[5, 2]*vBody[2] + mAdded_f[5, 3]*vBody[3] + mAdded_f[5, 4]*omega[1] + mAdded_f[5, 5]*omega[2] + mAdded_f[5, 6]*omega[3];
  virtualYawMoment = mAdded_f[6, 1]*vBody[1] + mAdded_f[6, 2]*vBody[2] + mAdded_f[6, 3]*vBody[3] + mAdded_f[6, 4]*omega[1] + mAdded_f[6, 5]*omega[2] + mAdded_f[6, 6]*omega[3];
  fCoriolis[1] = -omega[2]*virtualHeaveForce + omega[3]*virtualSwayForce;
  fCoriolis[2] = omega[1]*virtualHeaveForce - omega[3]*virtualSurgeForce;
  fCoriolis[3] = -omega[1]*virtualSwayForce + omega[2]*virtualSurgeForce;
  tauCoriolis[1] = -omega[2]*virtualYawMoment + omega[3]*virtualPitchMoment - vBody[2]*virtualHeaveForce + vBody[3]*virtualSwayForce;
  tauCoriolis[2] = omega[1]*virtualYawMoment - omega[3]*virtualRollMoment + vBody[1]*virtualHeaveForce - vBody[3]*virtualSurgeForce;
  tauCoriolis[3] = -omega[1]*virtualPitchMoment + omega[2]*virtualRollMoment - vBody[1]*virtualSwayForce + vBody[2]*virtualSurgeForce;
  
  // Radiation forces and moments (State-Space connections)
  rad_Surge.u = {genVel[1]};
  rad_PitchOnSurge.u = {genVel[5]};
  fRad[1] = rad_Surge.y[1] + rad_PitchOnSurge.y[1];
  rad_Sway.u = {genVel[2]};
  rad_RollOnSway.u = {genVel[4]};
  fRad[2] = rad_Sway.y[1] + rad_RollOnSway.y[1];
  rad_Heave.u = {genVel[3]};
  fRad[3] = rad_Heave.y[1];
  rad_SwayOnRoll.u = {genVel[2]};
  rad_Roll.u = {genVel[4]};
  tauRad[1] = rad_SwayOnRoll.y[1] + rad_Roll.y[1];
  rad_SurgeOnPitch.u = {genVel[1]};
  rad_Pitch.u = {genVel[5]};
  tauRad[2] = rad_SurgeOnPitch.y[1] + rad_Pitch.y[1];
  tauRad[3] = 0;
    
  // Resolve torques and forces to the frame
  // frame_a.f = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, fRad + fAdded + fCoriolis);
  frame_a.f = fRad + fAdded + fCoriolis;
  frame_a.t = tauRad + tauAdded + tauCoriolis;

  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(textColor = {85, 85, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name", textStyle = {TextStyle.Bold}), Line(origin = {51.22, 4.05}, points = {{34.7752, -82.0482}, {46.7752, -52.0482}, {-47.2248, -2.04815}, {40.7752, 45.9518}, {14.7752, 81.9518}}, color = {85, 85, 255}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {15.22, 4.05}, points = {{34.7752, -82.0482}, {46.7752, -52.0482}, {-47.2248, -2.04815}, {40.7752, 45.9518}, {14.7752, 81.9518}}, color = {123, 0, 185}, thickness = 4.25, smooth = Smooth.Bezier), Line(origin = {-18.78, 4.05}, points = {{34.7752, -82.0482}, {46.7752, -52.0482}, {-47.2248, -2.04815}, {40.7752, 45.9518}, {14.7752, 81.9518}}, color = {85, 0, 127}, thickness = 4.25, smooth = Smooth.Bezier), Rectangle(origin = {-12, 3}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 39}, {3, -39}}), Polygon(origin = {-70, 4}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}})}),
    Documentation(info = "<html><head></head><body>
<h1>Radiation Damping and Added Mass Model</h1>

<p>
  The <em>Radiation</em> model implements frequency-dependent hydrodynamic effects caused by the vessel's own motion relative to the fluid in 6 Degrees of Freedom (6-DOF). 
  It accounts for the inertia of the entrained fluid (added mass), the non-linear Coriolis-centripetal effects of this fluid mass, and the energy dissipation due to wave-making resistance (potential damping) through a state-space approximation.
</p>

<h2>Description</h2>

<p>
  When a vessel moves through a fluid, it forces the fluid to move, creating pressure fields that result in additional forces. 
  This model captures phenomena described by Fossen (2011): <strong>Added Mass</strong> (pressure forces proportional to acceleration), <strong>Added Mass Coriolis</strong> (forces due to the rotation of the body dragging the fluid), and <strong>Potential Damping</strong> (energy carried away by generated waves).
  Instead of using computationally expensive convolution integrals (retardation functions), this block approximates the fluid memory effects using bandwidth-limited state-space filters.
  The block can also evaluate these forces relative to an ambient fluid flow (ocean currents) by utilizing the <code>useStream</code> option and linking to a global <code>Stream</code> object.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Radiation block</caption>
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
      <td>If true, velocity is calculated relative to the stream (Vessel - Stream). Requires a global <code>Stream</code> object.</td>
    </tr>
    <tr>
      <td><strong>mAdded</strong></td>
      <td>Real[6,6]</td>
      <td>-</td>
      <td>Matrix with hydrodynamic added mass coefficients.</td>
    </tr>
    <tr>
      <td><strong>A_Surge, B_Surge, C_Surge</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Surge channel.</td>
    </tr>
    <tr>
      <td><strong>A_Sway, B_Sway, C_Sway</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Sway channel.</td>
    </tr>
    <tr>
      <td><strong>A_Heave, B_Heave, C_Heave</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Heave channel.</td>
    </tr>
    <tr>
      <td><strong>A_Roll, B_Roll, C_Roll</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Roll channel.</td>
    </tr>
    <tr>
      <td><strong>A_Pitch, B_Pitch, C_Pitch</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Pitch channel.</td>
    </tr>
    <tr>
      <td><strong>A_PitchOnSurge, B_PitchOnSurge, C_PitchOnSurge</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Pitch on Surge coupling.</td>
    </tr>
    <tr>
      <td><strong>A_RollOnSway, B_RollOnSway, C_RollOnSway</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Roll on Sway coupling.</td>
    </tr>
    <tr>
      <td><strong>A_SwayOnRoll, B_SwayOnRoll, C_SwayOnRoll</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Sway on Roll coupling.</td>
    </tr>
    <tr>
      <td><strong>A_SurgeOnPitch, B_SurgeOnPitch, C_SurgeOnPitch</strong></td>
      <td>Real[:,:]</td>
      <td>-</td>
      <td>State-space matrices for Surge on Pitch coupling.</td>
    </tr>
  </tbody>
</table>

<h2>Connectors</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Connectors of the Radiation block</caption>
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
      <td>Generalized velocity vector (surge, sway, heave, roll, pitch, yaw).</td>
    </tr>
    <tr>
      <td><em>genAcc</em></td>
      <td>Real[6]</td>
      <td>-</td>
      <td>Generalized acceleration vector.</td>
    </tr>
    <tr>
      <td><em>vBody</em></td>
      <td>Velocity[3]</td>
      <td>m/s</td>
      <td>Linear velocity resolved in the body frame (u, v, w).</td>
    </tr>
    <tr>
      <td><em>aBody</em></td>
      <td>Acceleration[3]</td>
      <td>m/s²</td>
      <td>Linear acceleration resolved in the body frame.</td>
    </tr>
    <tr>
      <td><em>alpha</em></td>
      <td>AngularAcceleration[3]</td>
      <td>rad/s²</td>
      <td>Angular acceleration resolved in the body frame.</td>
    </tr>
    <tr>
      <td><em>omega</em></td>
      <td>AngularVelocity[3]</td>
      <td>rad/s</td>
      <td>Angular velocity resolved in the body frame (p, q, r).</td>
    </tr>
    <tr>
      <td><em>fAdded</em></td>
      <td>Force[3]</td>
      <td>N</td>
      <td>Forces resulting from the added mass effect.</td>
    </tr>
    <tr>
      <td><em>tauAdded</em></td>
      <td>Torque[3]</td>
      <td>N.m</td>
      <td>Moments resulting from the added mass effect.</td>
    </tr>
    <tr>
      <td><em>fCoriolis</em></td>
      <td>Force[3]</td>
      <td>N</td>
      <td>Coriolis-centripetal forces due to the added mass.</td>
    </tr>
    <tr>
      <td><em>tauCoriolis</em></td>
      <td>Torque[3]</td>
      <td>N.m</td>
      <td>Coriolis-centripetal moments due to the added mass.</td>
    </tr>
    <tr>
      <td><em>fRad</em></td>
      <td>Force[3]</td>
      <td>N</td>
      <td>Forces resulting from potential damping (radiation).</td>
    </tr>
    <tr>
      <td><em>tauRad</em></td>
      <td>Torque[3]</td>
      <td>N.m</td>
      <td>Moments resulting from potential damping (radiation).</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes the total hydrodynamic radiation vector <em>τ<sub>R</sub></em> as the sum of added mass, added Coriolis, and potential damping terms:
</p>

<ul>
  <li><strong>Added Mass:</strong> Calculated as a linear function of acceleration: <em>τ<sub>added</sub> = M<sub>A</sub> · ν̇</em>. The matrix <em>M<sub>A</sub></em> (<code>mAdded</code>) represents the added mass.</li>
  <li><strong>Coriolis-Centripetal Matrix:</strong> The model computes intermediate momentum components (e.g., <em>virtualSurgeForce</em>) to construct the cross-product terms representing the added mass Coriolis matrix <em>C<sub>A</sub>(ν)</em>. These components generate <em>fCoriolis</em> and <em>tauCoriolis</em>, capturing the nonlinear cross-coupling of rotation and fluid inertia.</li>
  <li><strong>Fluid Memory (Filtering):</strong> To approximate frequency dependence without convolution, the model uses state-space models for the radiation forces. For a degree of freedom <em>i</em>: the velocity is the input to a state-space system representing the radiation force.</li>
  <li><strong>Potential Damping: </strong> The radiation force is given by the output of these state-space filters. This mimics the decay of wave-generation energy.</li>
  <li><strong>Coupling:</strong> Off-diagonal terms (e.g., <code>A_PitchOnSurge</code>) account for geometric asymmetries, where motion in one axis (like pitching) induces resistance in another (like surging).</li>
  <li><strong>Total Application:</strong> The total load vector (Radiation + Added Mass + Coriolis) is resolved back to the world frame and applied to the vessel through <code>frame_a.f</code> and <code>frame_a.t</code>.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the HydroForces package within the Aquanaut library and is based on the formulation by Fossen (2011).</em>
</p>


</body></html>"));
end Radiation;

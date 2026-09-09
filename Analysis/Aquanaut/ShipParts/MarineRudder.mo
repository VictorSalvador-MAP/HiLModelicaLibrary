within Aquanaut.ShipParts;

model MarineRudder
  extends Modelica.Blocks.Icons.Block;

  // 1. CONFIGURATIONS & PARAMETERS
  // Geometric and Physical Parameters
  parameter Modelica.Units.SI.Area Ar = 0.2774529156 "Rudder area";
  parameter Modelica.Units.SI.Length b = 0.83208 "Rudder height / span";
  parameter Modelica.Units.SI.Length c = 0.308 "Rudder chord length";
  parameter Modelica.Units.SI.Length d = 0.05 "Rudder stock position from leading edge";
  parameter Modelica.Units.SI.Length t = 0.05 "Rudder thickness";
  parameter Real Cq = 1.0 "Cross-flow resistance coefficient (Eq. 6.59/6.60)";
  parameter Real rho = 1025 "Water density";
  parameter Real nu = 1.18e-6 "Kinematic viscosity";
  
  // Vessel-Rudder Interaction Parameters
  parameter Modelica.Units.SI.Length xR = -3.893 "Distance from rudder to midship (negative for stern)";
  parameter Modelica.Units.SI.Length e = 0.3199106 "Distance between leading edge and aft end of hull";
  parameter Modelica.Units.SI.Length T_ship = 1.131 "Ship draft";
  parameter Modelica.Units.SI.Position hullRudderXPos = -3.98381 "X axis distance between CM from hull to Rudder";
  parameter Modelica.Units.SI.Position hullRudderYPos = 0.01518 "Y axis distance between CM from hull to Rudder";
  parameter Modelica.Units.SI.Position hullRudderZPos = 0.97030 "Z axis distance between CM from hull to Rudder";
  parameter Modelica.Units.SI.Length distRudder = 0.46074 "Distance from propeller to rudder center of gravity";
  
  // Limits & Mechanical Constraints
  parameter Modelica.Units.SI.Mass rudderMass = 69.040 "Rudder mass";
  parameter Modelica.Units.SI.Frequency f_cut = 5.0 "Rudder cut frequency";
  parameter Modelica.Units.SI.Angle maxAngle = 0.6108652381980153 "Maximum rudder angle";
  parameter Modelica.Units.SI.Inertia rudderIxx = 3.973 "Moment of Inertia about surge axis";
  parameter Modelica.Units.SI.Inertia rudderIyy = 5.049 "Moment of Inertia about sway axis";
  parameter Modelica.Units.SI.Inertia rudderIzz = 1.092 "Moment of Inertia about heave axis";

  // 2. CONNECTORS & INTERFACES
  // Input Control and Flow Signals
  Modelica.Blocks.Interfaces.RealInput angleInput annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 74}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput flowDiameter annotation(
    Placement(transformation(origin = {-120, 18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -25}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput flowSpeed annotation(
    Placement(transformation(origin = {-120, -22}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -76}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput wakeFraction annotation(
    Placement(transformation(origin = {-120, -62}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 24}, extent = {{-20, -20}, {20, 20}})));
  
  // 3D MultiBody Frame Connection
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {98, 2}, extent = {{-16, -16}, {16, 16}})));

// 3. INTERNAL VARIABLES
  // Hydrodynamic Angles
  Modelica.Units.SI.Angle deltaR "Geometric rudder angle";
  Modelica.Units.SI.Angle alpha "Effective angle of attack (Bertram 2012, Eq. 6.87)";
  Modelica.Units.SI.Angle beta "Local drift angle at rudder";
  Modelica.Units.SI.Angle gamma "Flow angle (Bertram 2012, Eq. 6.86)";
  
  // Hydrodynamic Forces and Moments
  Modelica.Units.SI.Force L "Lift force (Bertram 2012, Eq. 6.53)";
  Modelica.Units.SI.Force D "Drag force (Bertram 2012, Eq. 6.54)";
  Modelica.Units.SI.Torque Qn "Nose moment (Bertram 2012, Eq. 6.55)";
  Modelica.Units.SI.Torque Qr "Stock torque (Bertram 2012, Eq. 6.52)";
  
  // Intermediate Coefficients & Flow Metrics
  Real LambdaAr "Aspect ratio = b^2/Ar (Bertram 2012, Eq. 6.56)";
  Real Cm "Mean chord length = Ar/b";
  Real q "Dynamic pressure (0.5*rho*V^2)";
  Real Rn "Reynolds number";
  Real u_eff "Effective axial speed at rudder (accounting for wake) [m/s]";
  Real u_eff_safe "u_eff clamped away from zero for division safety";
  Real Cl "Total lift coefficient (Bertram 2012, Eq. 6.59)";
  Real Cd "Total drag coefficient (Bertram 2012, Eq. 6.60)";
  Real Cd0 "Surface friction coefficient (Bertram 2012, Eq. 6.62)";
  Real Cqn "Nose-moment coefficient (Bertram 2012, Eq. 6.61)";
  Real Cqr "Stock-torque coefficient";
  Real vR "Local transverse flow speed at rudder (Bertram 2012, Eq. 6.86)";
  Real Cs "Center-of-pressure position from leading edge (Bertram 2012, Eq. 6.58)";
  Real F_X "Force on ship X-axis (surge)";
  Real F_Y "Force on ship Y-axis (sway)";
  
  // Velocity Kinematics
  Modelica.Units.SI.Velocity worldVel[3] "Velocity in world frame";
  Modelica.Units.SI.Velocity bodyVel[3] "Velocity in body frame";
  Modelica.Units.SI.AngularVelocity w_body[3] "Angular velocity in body frame";
  Modelica.Units.SI.Velocity u_ship "Surge velocity";
  Modelica.Units.SI.Velocity v_ship "Sway velocity";
  Modelica.Units.SI.AngularVelocity r_ship "Yaw velocity component";
  
  // Slipstream & Correction Factors
  Real lambda "Lift correction factor for non-uniform propeller inflow";
  Real f_exp "Exponent for lambda formula";
  Real propD "Equivalent square half-width of slipstream";
  Real a_h "Increase of lateral force due to hull above rudder root [-] (Soding, 1982)";

  // 4. SUB-COMPONENTS & PHYSICAL INSTANCES
  // Core MultiBody Mechanical Joints and Bodies
  Modelica.Mechanics.MultiBody.Joints.Revolute RudderRevolute(useAxisFlange = true) annotation(
    Placement(transformation(origin = {17, 42}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Mechanics.MultiBody.Parts.Body Rudder(I_11 = rudderIxx, I_22 = rudderIyy, I_33 = rudderIzz, m = rudderMass) annotation(
    Placement(transformation(origin = {-30, 23}, extent = {{10, 10}, {-10, -10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation FixedHullRudderRevolution(animation = false, r = {hullRudderXPos, hullRudderYPos, hullRudderZPos}) annotation(
    Placement(transformation(origin = {74, 42}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  
  // Actuation Mechanics
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = maxAngle) annotation(
    Placement(transformation(origin = {-76, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Position position(useSupport = false, f_crit = f_cut) annotation(
    Placement(transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}})));
  
  // Hydrodynamic Force Applications
  Modelica.Mechanics.MultiBody.Forces.WorldForce forceLift(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b, animation = false) annotation(
    Placement(transformation(origin = {39, -1}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Forces.WorldForce forceDrag(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b, animation = false) annotation(
    Placement(transformation(origin = {39, -21}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Forces.WorldTorque moment(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b, animation = false) annotation(
    Placement(transformation(origin = {39, -42}, extent = {{-10, -10}, {10, 10}})));

  // Geometry Visualizer
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape fixedShape3(height = b, length = c, r_shape = {-0.75*c, 0, 0}, width = t) annotation(
    Placement(transformation(origin = {-31, -2}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));

  Modelica.Units.SI.Velocity waterVelXY[2];
  Modelica.Units.SI.Velocity waterVel;

protected
  Real C_L1 "Thin-foil lift component";
  Real C_L2 "Cross-flow lift component";
  Real C_D1 "Induced drag component [-]";
  Real C_D2 "Cross-flow drag component";
  Real wf "Internal copy of wake fraction";

public
  Aquanaut.Equipment.Sensors.AngleSensorSignal feedbackSensor annotation(
    Placement(transformation(origin = {4, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput rudderFeedbackRad annotation(
    Placement(transformation(origin = {111, 91}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-65, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput rudderFeedbackVoltage annotation(
    Placement(transformation(origin = {111, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {68, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput rudderFeedbackDeg annotation(
    Placement(transformation(origin = {-50, 111}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain radToDeg(k = 180/Modelica.Constants.pi) annotation(
    Placement(transformation(origin = {-24, 86}, extent = {{-6, -6}, {6, 6}}, rotation = 180)));equation
// 5. EQUATIONS & LOGIC
// Hull-Rudder Interaction (Bertram 2012, Eq. 6.83)
  a_h = 1/(1 + ((4.9*e/T_ship) + (3*c/T_ship))^2);
// Wake fraction passthrough
  wf = wakeFraction;
// Kinematics from MultiBody frame
  worldVel = der(frame_a.r_0);
  bodyVel = Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, worldVel);
  u_ship = bodyVel[1];
  v_ship = bodyVel[2];
  w_body = Modelica.Mechanics.MultiBody.Frames.angularVelocity2(frame_a.R);
  r_ship = w_body[3];
  waterVelXY[1] = flowSpeed;
  waterVelXY[2] = v_ship;
  waterVel = (waterVelXY[1]^2 + waterVelXY[2]^2)^0.5;
// Local transverse flow speed (Bertram 2012, Eq. 6.86)
  vR = -(0.36*v_ship + 0.66*xR*r_ship);
// Rudder geometric angle (from rotational flange)
  deltaR = position.flange.phi;
  gamma = atan2(vR, u_eff_safe);
// Total effective angle of attack (Bertram 2012, Eq. 6.87)
  alpha = deltaR + gamma;
// Drift angle and effective angle of attack
// beta: local flow angle due to ship drift (positive = flow from starboard)
  beta = if noEvent(abs(u_ship) > Modelica.Constants.eps) then atan2(-v_ship, u_ship) else 0;
// alpha: total angle seen by the rudder (Eq. 6.87 simplified - no yaw rate here)
// alpha = deltaR + beta;
// Aspect ratio and Profile properties
// Bertram 2012, Eq. 6.56
  LambdaAr = b^2/Ar;
  Cm = Ar/b;
// Effective Inflow Speed (Slipstream / Wake coupling)
// Use flowSpeed (corrected slipstream from propeller block) when available, otherwise fall back to ship-speed with wake fraction
  u_eff = if noEvent(flowSpeed > Modelica.Constants.eps) then flowSpeed else u_ship*(1.0 - wf);
  u_eff_safe = max(abs(u_eff), 1e-3);
// Flow Dynamic Conditions
  q = 0.5*rho*u_eff_safe^2;
  Rn = u_eff_safe*Cm/nu;
// Surface-friction coefficient (ITTC-1957, Eq. 6.62)
  Cd0 = 2.5*0.075/(log10(max(Rn, 1.0)) - 2.0)^2;
// Lift Components Generation (Bertram 2012, Eq. 6.59)
  C_L1 = 2.0*Modelica.Constants.pi*(LambdaAr*(LambdaAr + 0.7))/(LambdaAr + 1.7)^2*sin(alpha);
  C_L2 = Cq*sin(alpha)*abs(sin(alpha))*cos(alpha);
  Cl = C_L1 + C_L2;
// Drag Components Generation (Bertram 2012, Eq. 6.60)
  C_D1 = Cl^2/(Modelica.Constants.pi*LambdaAr);
  C_D2 = Cq*abs(sin(alpha))^3;
  Cd = C_D1 + C_D2 + Cd0;
// Nose-Moment Coefficient (Bertram 2012, Eq. 6.61)
  Cqn = -(C_L1*cos(alpha) + C_D1*sin(alpha))*(0.47 - (LambdaAr + 2.0)/(4.0*(LambdaAr + 1.0))) - 0.75*(C_L2*cos(alpha) + C_D2*sin(alpha));
// Center of Pressure from leading edge (Bertram 2012, Eq. 6.58)
  Cs = Cm*Cqn/max(Cl*cos(alpha) + Cd*sin(alpha), 1e-6);
// Dimensional Hydrodynamic Forces & Moments
  L = Cl*q*Ar*lambda;
  D = Cd*q*Ar;
  Qn = Cqn*q*Ar*Cm;
// Rudder Stock Torque (Bertram 2012, Eq. 6.52 / 6.57)
  Qr = Qn + (L*cos(alpha) + D*sin(alpha))*d;
  Cqr = Qr/max(q*Ar*Cm, 1e-6);
//Propeller Inflow Correction (Bertram 2012, Eqs. 6.76–6.77)
  propD = (flowDiameter/2.0)*0.886;
  f_exp = 2.0*(2.0/(2.0 + propD/Cm))^8;
  lambda = if noEvent(flowSpeed > Modelica.Constants.eps) then (u_ship/flowSpeed)^f_exp else 1.0;
//Projection onto Ship Frame
  F_X = -(D*cos(alpha) + L*sin(alpha));
  F_Y = (L*cos(alpha) - D*sin(alpha))*(1 + a_h);
// Dynamic Loads Transmitted to MultiBody System
  forceDrag.force = {F_X, 0, 0};
  forceLift.force = {0, F_Y, 0};
  moment.torque = {0, 0, -Qr};
// 6. CONNECTIONS
  connect(angleInput, limiter.u) annotation(
    Line(points = {{-120, 60}, {-88, 60}}, color = {0, 0, 127}));
  connect(limiter.y, position.phi_ref) annotation(
    Line(points = {{-64, 60}, {-42, 60}}, color = {0, 0, 127}));
// 7. GRAPHICS & DOCUMENTATION ANNOTATIONS
  connect(FixedHullRudderRevolution.frame_a, frame_a) annotation(
    Line(points = {{84, 42}, {100, 42}, {100, 0}}, color = {95, 95, 95}));
  connect(forceLift.frame_b, FixedHullRudderRevolution.frame_b) annotation(
    Line(points = {{49, -1}, {54, -1}, {54, 42}, {64, 42}}, color = {95, 95, 95}));
  connect(forceDrag.frame_b, FixedHullRudderRevolution.frame_b) annotation(
    Line(points = {{49, -21}, {54, -21}, {54, 42}, {64, 42}}, color = {95, 95, 95}));
  connect(moment.frame_b, FixedHullRudderRevolution.frame_b) annotation(
    Line(points = {{49, -42}, {54, -42}, {54, 42}, {64, 42}}, color = {95, 95, 95}));
  connect(RudderRevolute.frame_a, FixedHullRudderRevolution.frame_b) annotation(
    Line(points = {{27, 42}, {64, 42}}, color = {95, 95, 95}));
  connect(RudderRevolute.frame_b, Rudder.frame_a) annotation(
    Line(points = {{7, 42}, {-9, 42}, {-9, 23}, {-20, 23}}, color = {95, 95, 95}));
  connect(position.flange, RudderRevolute.axis) annotation(
    Line(points = {{-20, 60}, {17, 60}, {17, 52}}));
  connect(fixedShape3.frame_a, Rudder.frame_a) annotation(
    Line(points = {{-21, -2}, {-9, -2}, {-9, 23}, {-20, 23}}, color = {95, 95, 95}));
  connect(rudderFeedbackVoltage, feedbackSensor.v) annotation(
    Line(points = {{111, 70}, {15, 70}}, color = {0, 0, 127}));
  connect(feedbackSensor.phi, rudderFeedbackRad) annotation(
    Line(points = {{4, 82}, {4, 91}, {111, 91}}, color = {0, 0, 127}));
  connect(radToDeg.u, feedbackSensor.phi) annotation(
    Line(points = {{-17, 86}, {4, 86}, {4, 82}}, color = {0, 0, 127}));
  connect(radToDeg.y, rudderFeedbackDeg) annotation(
    Line(points = {{-31, 86}, {-50, 86}, {-50, 112}}, color = {0, 0, 127}));
  connect(feedbackSensor.flange, position.flange) annotation(
    Line(points = {{4, 60}, {-20, 60}}));
  annotation(
    Icon(graphics = {Polygon(origin = {15, -14}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, points = {{-43, 10}, {-37, -70}, {23, -70}, {43, 70}, {-33, 70}, {-33, 22}, {-23, 22}, {-23, 10}, {-43, 10}}), Polygon(origin = {-18, 34}, points = {{-10, -38}, {10, -38}, {10, -26}, {0, -26}, {0, 52}, {-10, 52}, {-10, -38}})}, coordinateSystem(grid = {1, 1})),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Marine Rudder Model</h1>

<p>
  The <em>MarineRudder</em> model simulates the hydrodynamic lift, drag, and steering moments generated by a vessel's rudder. 
  It calculates these forces based on the rudder's geometry, the angle of attack, and the local fluid flow conditions, including interactions with the propeller's slipstream.
</p>

<h2>Description</h2>

<p>
  This component provides a 6-DOF representation of a marine rudder by applying semi-empirical hydrodynamic equations. 
  It calculates the effective angle of attack by combining the commanded rudder angle with the drift angle induced by the ship's transverse velocity. 
  The model computes non-dimensional lift and drag coefficients, scaling them by the dynamic pressure to generate physical forces that act upon the mechanical flange through a revolute joint.
  It also calculates the torque on the rudder stock, which is essential for sizing steering gears.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the MarineRudder block</caption>
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
      <td><strong>Ar</strong></td>
      <td>Area</td>
      <td>m²</td>
      <td>Rudder profile area.</td>
    </tr>
    <tr>
      <td><strong>b</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Rudder span or height.</td>
    </tr>
    <tr>
      <td><strong>c</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Rudder mean chord length.</td>
    </tr>
    <tr>
      <td><strong>d</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Rudder stock position relative to the leading edge.</td>
    </tr>
    <tr>
      <td><strong>t</strong></td>
      <td>Thickness</td>
      <td>m</td>
      <td>Maximum thickness of the rudder profile.</td>
    </tr>
    <tr>
      <td><strong>Cq</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Cross-flow resistance coefficient.</td>
    </tr>
    <tr>
      <td><strong>rho</strong></td>
      <td>Density</td>
      <td>kg/m³</td>
      <td>Mass density of the fluid (default 1025).</td>
    </tr>
    <tr>
      <td><strong>nu</strong></td>
      <td>KinematicViscosity</td>
      <td>m²/s</td>
      <td>Kinematic viscosity of water (default 1.18e-6).</td>
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
      <td><strong>frame_a</strong></td>
      <td>Frame_a</td>
      <td>-</td>
      <td>3D mechanical connector attaching the rudder to the hull.</td>
    </tr>
    <tr>
      <td><strong>angleInput</strong></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>Commanded rudder angle setpoint (limited to ±35 internally).</td>
    </tr>
    <tr>
      <td><strong>flowDiameter</strong></td>
      <td>RealInput</td>
      <td>m</td>
      <td>Diameter of the propeller water slipstream reaching the rudder.</td>
    </tr>
    <tr>
      <td><strong>flowSpeed</strong></td>
      <td>RealInput</td>
      <td>m/s</td>
      <td>Speed of the accelerated slipstream water flow.</td>
    </tr>
    <tr>
      <td><strong>wakeFraction</strong></td>
      <td>RealInput</td>
      <td>-</td>
      <td>Local wake fraction at the rudder location.</td>
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
      <td><em>u_ship, v_ship</em></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Longitudinal and transverse velocity of the rudder frame.</td>
    </tr>
    <tr>
      <td><em>beta</em></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Drift angle representing the local flow direction: <em>atan2(-v, u)</em>.</td>
    </tr>
    <tr>
      <td><em>alpha</em></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Effective angle of attack: <em>δ<sub>R</sub> + β</em>.</td>
    </tr>
    <tr>
      <td><em>Rn</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Reynolds number of the flow over the rudder.</td>
    </tr>
    <tr>
      <td><em>q</em></td>
      <td>Pressure</td>
      <td>Pa</td>
      <td>Stagnation pressure: <em>0.5 · ρ · u<sup>2</sup></em>.</td>
    </tr>
    <tr>
      <td><em>Cl, Cd</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Total non-dimensional Lift and Drag coefficients.</td>
    </tr>
    <tr>
      <td><em>L, D</em></td>
      <td>Force</td>
      <td>N</td>
      <td>Total Lift and Drag forces applied to the fluid center of effort.</td>
    </tr>
    <tr>
      <td><em>Qn</em></td>
      <td>Torque</td>
      <td>N.m</td>
      <td>Hydrodynamic moment about the rudder's leading edge.</td>
    </tr>
    <tr>
      <td><em>Qr</em></td>
      <td>Torque</td>
      <td>N.m</td>
      <td>Torque required at the rudder stock to hold or turn the rudder.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes the control forces and moments using aerodynamic profile theory adapted for marine conditions:
</p>

<ul>
  <li><strong>Angle of Attack:</strong> The rudder's true angle relative to the water flow (<em>α</em>) accounts for both the mechanical deflection (<em>δ<sub>R</sub></em>) and the drift angle (<em>β</em>) caused by the ship's sway.</li>
  <li><strong>Lift and Drag Coefficients:</strong> Lift (<em>C<sub>L</sub></em>) and Drag (<em>C<sub>D</sub></em>) are computed using standard empirical maneuvering polynomials. They combine linear potential flow components (dominant at low angles) with cross-flow resistance (dominant at high angles). A skin friction coefficient (<em>C<sub>D0</sub></em>) is added based on the Reynolds number.</li>
  <li><strong>Empirical Coefficients:</strong> The parameters for the hydrodynamic coefficients were derived from the reference <em>Bertram, V. (2012). Practical ship hydrodynamics</em>, specifically utilizing equations 6.59, 6.60, and 6.61, which had their precision demonstrated in Table 6.5 of the literature.</li>
  <li><strong>Force Generation:</strong> The physical forces are derived from the dynamic pressure: <em>L = C<sub>L</sub> · q · A<sub>R</sub></em> and <em>D = C<sub>D</sub> · q · A<sub>R</sub></em>. These forces only develop when the longitudinal velocity is positive.</li>
  <li><strong>Moments and Actuation:</strong> The center of pressure shifts depending on the angle of attack. The model calculates the normal moment <em>Q<sub>n</sub></em>, which is then translated to the physical stock axis (offset by distance <em>d</em>) to determine the rudder stock torque <em>Q<sub>r</sub></em>.</li>
  <li><strong>Mechanical Interface:</strong> The calculated Lift, Drag, and Moment are applied directly to a <code>Revolute</code> joint using <code>WorldForce</code> and <code>WorldTorque</code> blocks, which accurately transmits the reaction loads back to the hull via <code>frame_a</code>.</li>
</ul>

<hr>
<h2>References</h2>
<p>
  <em>Note: This component is part of the ShipParts package within the Aquanaut library. The hydrodynamic formulations are based on:</em>
</p>
<ul>
  <li>Bertram, V. (2012). <em>Practical ship hydrodynamics</em>. Elsevier.</li>
  <li>Brix, J. (1987). <em>Manoeuvring technical manual</em>. Schiff und Hafen, 36(5).</li>
  <li>Lee, H., &amp; Shin, S. (1998). <em>The Prediction of ship's manoeuvring performance In initial design stage</em>.</li>
</ul>


</body></html>"),
    Diagram(coordinateSystem(grid = {1, 1})));
end MarineRudder;
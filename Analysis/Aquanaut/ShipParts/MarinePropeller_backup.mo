within Aquanaut.ShipParts;

model MarinePropeller_backup
  extends Modelica.Blocks.Icons.Block;
  // 1. CONFIGURATIONS & PARAMETERS
  // Simulation Options
  parameter Boolean useStream = false "Use external fluid stream velocity";
  // Physical & Geometry Parameters
  parameter Modelica.Units.SI.Length D(displayUnit = "m") = 0.9 "Propeller diameter" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Real P_D = 0.85 "Pitch-diameter ratio" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Real Ae_Ao = 0.65 "Blade area ratio" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Real Z = 4 "Number of blades" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Density rhoProp = 7100 "Propeller material density" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Mass propMass = 198.308 "Propeller mass" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Inertia propIxx = 2.832 "Moment of Inertia about surge axis" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Inertia propIyy = 0 "Moment of Inertia about sway axis" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Inertia propIzz = 0 "Moment of Inertia about heave axis" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Position propXPos = -3.52307 "X axis position of the propeller" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Position propYPos = 0.01518 "Y axis position of the propeller" annotation(
    Dialog(group = "Propeller parameters"));
  parameter Modelica.Units.SI.Position propZPos = 0.95201 "Z axis position of the propeller" annotation(
    Dialog(group = "Propeller parameters"));
  // Inertia Parameters
  parameter Modelica.Units.SI.Inertia J_prop = 0.0002744*Ae_Ao*(Ae_Ao + 3)*rhoProp*D^5 "Propeller inertia (Ursolov & Dmytro, 2021)" annotation(
    Dialog(group = "Inertia parameters"));
  parameter Modelica.Units.SI.Inertia J_addedWater = 0.3*J_prop "Water inertia" annotation(
    Dialog(group = "Inertia parameters"));
  // Environment & Ship Parameters
  parameter Modelica.Units.SI.Density rhoWater(displayUnit = "kg/m3") = 1025 "Water density" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Modelica.Units.SI.Length Lpp = 9 "Length between perpendiculars" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Modelica.Units.SI.Length B = 2.9424 "Moulded beam" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Real Cb = 0.2139 "Ship block coefficient [-]" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Real Cp = 0.7068 "Ship prismatic coefficient [-]" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Real lcb = -1.14 "%lcb from Lpp/2 (0.75% Aft -> -0.75), positive fwd" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Real Fa = -2 "Aft body factor [-2 (U shape), 0 (N shape), +2 (V shape)]" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  parameter Modelica.Units.SI.Length distRudder = 0.4611 "Distance from propeller to rudder center of gravity" annotation(
    Dialog(group = "Environment and Ship Parameters"));
  // Propeller-Hull Interaction Factors
  parameter Real w_calc = 0.1*B/Lpp + 0.149 + (((0.05*B)/(Lpp)) + 0.449)/((585 - 5027*B/Lpp + 11700*((B/Lpp)^2))*(0.98 - Cb)^3 + 1) + 0.025*Fa/(100*(Cb - 0.7)^2 + 1) - 0.18 + (0.00756/((D/Lpp) + 0.002)) "Calculated wake fraction (Kristensen & Lützen, 2012)" annotation(
    Dialog(tab = "Factors", group = "Propeller-hull factors"));
  parameter Real t_deduction = (0.625*B/Lpp + 0.08) + (0.165 - 0.25*B/Lpp)/((525 - 8060*B/Lpp + 20300*(B/Lpp)^2)*(0.98 - Cb)^3 + 1) - 0.01*Fa + 2*(D/Lpp - 0.04) "Thrust deduction fraction (Kristensen & Lützen, 2012)" annotation(
    Dialog(tab = "Factors", group = "Propeller-hull factors"));
  parameter Real eta_R = 0.9922 - 0.05908*Ae_Ao + 0.07424*(Cp - 0.0225*lcb) "Relative rotative efficiency (Holtrop & Mennen, 1982)" annotation(
    Dialog(tab = "Factors", group = "Propeller-hull factors"));
  // 2. CONNECTORS & INTERFACES
  // 1D Rotational and 3D MultiBody Flanges
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange "Shaft connected to the engine" annotation(
    Placement(transformation(origin = {100, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "3D Mechanical connector attached to the vessel" annotation(
    Placement(transformation(origin = {64, -44}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-100, 46}, extent = {{-16, -16}, {16, 16}})));
  // Output Signals (Block Interfaces)
  Modelica.Blocks.Interfaces.RealOutput flowDiameter "Diameter of the propeller water flow reaching to rudder" annotation(
    Placement(transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {109, 0}, extent = {{9, -9}, {-9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput flowSpeed "Speed of water flow inside the flowDiameter" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {109, -38}, extent = {{9, -9}, {-9, 9}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput wakeFraction "Wake fraction coefficient" annotation(
    Placement(transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {108, 42}, extent = {{8, -8}, {-8, 8}}, rotation = 180)));
  // 3. INTERNAL VARIABLES
  // Kinematics & Dynamics
  Modelica.Units.SI.Velocity worldVel[3] "Velocity in world frame";
  Modelica.Units.SI.Velocity bodyVel[3] "Velocity in body frame (u, v, w)";
  Modelica.Units.SI.Velocity shipSpeed "Ship speed in XY";
  Modelica.Units.SI.Velocity Va "Advance speed";
  Real J0(start = 0) "Advance ratio";
  Real Kt "Thrust Coefficient";
  Real Kq "Torque Coefficient";
  Real n "Rotation in rps (revolutions per second)";
  Real rpm(unit = "rpm") "Rotation in rpm";
  // Efficiencies
  Real eta_O "Open-water efficiency";
  Real eta_B "Propeller efficiency behind the ship";
  Real eta_H "Hull efficiency";
  Real eta_D "Overall propulsive efficiency or quasipropulsive coefficient";
  // Rudder Interaction & Forces
  Real C_th "Thrust loading coefficient";
  Modelica.Units.SI.Velocity V_inf "Slipstream velocity at infinity";
  Modelica.Units.SI.Length r_inf "Slipstream radius at infinity";
  Modelica.Units.SI.Length r_x "Slipstream radius at rudder";
  Modelica.Units.SI.Velocity V_x "Slipstream velocity at rudder";
  Modelica.Units.SI.Length Delta_r "Turbulence radius correction";
  Real thrust(unit = "N") "Effective thrust";
  Real thrustPowerProp(unit = "W") "Effective thrust power";
  Real thrustPowerShaft(unit = "W") "Effective thrust power";
  Real shaftPower(unit = "W") "Delivered shaft power";
  Real propellerTorque(unit = "N.m") "Hydrodynamic propeller torque";
  // 4. SUB-COMPONENTS & PHYSICAL INSTANCES
  Modelica.Mechanics.MultiBody.Parts.Body PropellerBody(I_11 = propIxx + J_addedWater, I_22 = propIyy, I_33 = propIzz, m = propMass) annotation(
    Placement(transformation(origin = {64, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Joints.Revolute PropRevolute(n = {1, 0, 0}, useAxisFlange = true) annotation(
    Placement(transformation(origin = {64, 32}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation FixedActuatorPaddleRevolute(animation = false, r = {propXPos, propYPos, propZPos}) annotation(
    Placement(transformation(origin = {64, -10}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
    Placement(transformation(origin = {60, -76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Forces.WorldForce force(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameB.frame_b, animation = false) annotation(
    Placement(transformation(origin = {24, 12}, extent = {{-10, -10}, {10, 10}})));
  // Visualizers
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape PropBlade1(height = 0.1, length = 0.01, r_shape = {-0.02, 0, 0}, width = 1) annotation(
    Placement(transformation(origin = {42, 62}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape PropBlade2(height = -1, length = 0.01, r_shape = {-0.02, 0, 0}, width = 0.1) annotation(
    Placement(transformation(origin = {90, 62}, extent = {{-10, -10}, {10, 10}})));
protected
  Real thrustProp;
  outer HydroForces.Stream Stream;
equation
// 5. EQUATIONS & LOGIC
// Initial Assignments & Kinematics
  wakeFraction = w_calc;
  if useStream then
    worldVel = der(frame_a.r_0) - {Stream.v[1], Stream.v[2], 0};
  else
    worldVel = der(frame_a.r_0);
  end if;
  bodyVel = Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, worldVel);
  shipSpeed = bodyVel[1];
  Va = shipSpeed*(1 - wakeFraction);
  n = der(flange.phi)/(2*Modelica.Constants.pi);
  rpm = n*60;
// Hydrodynamic Coefficients (Wageningen B-series)
  if noEvent(abs(n) <= Modelica.Constants.eps) then
    J0 = 0;
    Kt = 0;
    Kq = 0;
    thrustProp = 0;
    propellerTorque = 0;
    eta_O = 0;
  else
    J0 = Va/(n*D);
//(Kt, Kq) = Functions.WageningenB_Kt_Kq(J0, P_D, Ae_Ao, Z);
    Kt = Functions.WageningenB_Kt(J0, P_D, Ae_Ao, Z);
    Kq = Functions.WageningenB_Kq(J0, P_D, Ae_Ao, Z);
    thrustProp = rhoWater*D^4*Kt*n*abs(n);
    propellerTorque = rhoWater*D^5*Kq*n*abs(n);
    if noEvent(abs(Kq) <= Modelica.Constants.eps) then
      eta_O = sign(J0)*Modelica.Constants.inf;
    else
// Eq. 6.3.20 Harvald (1983)
      eta_O = J0/(2*Modelica.Constants.pi)*(Kt/Kq);
    end if;
  end if;
// Efficiencies (Harvald, 1983)
  eta_B = eta_O*eta_R;
  eta_H = (1 - t_deduction)/(1 - wakeFraction);
  eta_D = eta_B*eta_H;
// Fundamental Propulsion Equations
  thrust = thrustProp*(1 - t_deduction);
  shaftPower = der(flange.phi)*torque.tau;
  thrustPowerShaft = (shaftPower*eta_D);
  thrustPowerProp = thrust*shipSpeed;
  torque.tau = -propellerTorque;
// Rudder Interaction & Slipstream Dynamics (Brix, 1987)
  if noEvent(Va > 0 and n > 0 and Kt > 0) then
// Brix (1987) Eq. 1.2.20
    C_th = ((8*n^2*D^2*Kt)/(Modelica.Constants.pi*Va^2));
// Brix (1987) Eq. 1.2.19
    V_inf = Va*(1 + C_th)^0.5;
// Brix (1987) Eq. 1.2.21
    r_inf = (D/2)*(0.5*(1 + Va/V_inf))^0.5;
// Brix (1987) Eq. 1.2.22
    r_x = (D/2)*(0.14*(r_inf/(D/2))^3 + (r_inf/(D/2))*(distRudder/(D/2))^1.5)/(0.14*(r_inf/(D/2))^3 + (distRudder/(D/2))^1.5);
// Brix (1987) Eq. 1.2.23
    V_x = V_inf*(r_inf/r_x)^2;
// Turbulence Correction and Final Result
// Brix (1987) Eq. 1.2.24
    Delta_r = 0.15*distRudder*((V_inf*r_inf^2 - Va*r_x^2)/(V_inf*r_inf^2 + Va*r_x^2));
    flowDiameter = 2*(r_x + Delta_r);
// Brix (1987) Eq. 1.2.25
    flowSpeed = (V_x - Va)*(r_x^2/(r_x + Delta_r)^2) + Va;
  else
    C_th = 0;
    V_inf = Va;
    r_inf = 0;
    r_x = 0;
    V_x = 0;
    Delta_r = 0;
    flowDiameter = 0;
    flowSpeed = Va;
  end if;
// External Forces Applied
  force.force = {thrust, 0, 0};
// 6. CONNECTIONS
  connect(torque.flange, flange) annotation(
    Line(points = {{70, -76}, {84, -76}, {84, 32}, {100, 32}}));
  connect(PropBlade1.frame_a, PropellerBody.frame_a) annotation(
    Line(points = {{52, 62}, {64, 62}, {64, 72}}, color = {95, 95, 95}));
  connect(PropBlade2.frame_a, PropellerBody.frame_a) annotation(
    Line(points = {{80, 62}, {64, 62}, {64, 72}}, color = {95, 95, 95}));
// 7. GRAPHICS & DOCUMENTATION ANNOTATIONS
  connect(force.frame_b, FixedActuatorPaddleRevolute.frame_b) annotation(
    Line(points = {{34, 12}, {64, 12}, {64, 0}}, color = {95, 95, 95}));
  connect(FixedActuatorPaddleRevolute.frame_a, frame_a) annotation(
    Line(points = {{64, -20}, {64, -44}}, color = {95, 95, 95}));
  connect(flange, PropRevolute.axis) annotation(
    Line(points = {{100, 32}, {74, 32}}));
  connect(PropRevolute.frame_b, PropellerBody.frame_a) annotation(
    Line(points = {{64, 42}, {64, 72}}, color = {95, 95, 95}));
  connect(PropRevolute.frame_a, FixedActuatorPaddleRevolute.frame_b) annotation(
    Line(points = {{64, 22}, {64, 0}}, color = {95, 95, 95}));
  annotation(
    Diagram(graphics),
    Icon(graphics = {Polygon(origin = {-9, 0}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, points = {{-22.815, 18.252}, {-22.815, 39.546}, {-7.605, 73.008}, {10.647, 91.26}, {19.773, 88.218}, {22.815, 79.092}, {22.815, 51.714}, {1.521, 18.252}, {1.521, -18.252}, {22.815, -51.714}, {22.815, -79.092}, {19.773, -88.218}, {10.647, -91.26}, {-7.605, -73.008}, {-22.815, -39.546}, {-22.815, 18.252}}, smooth = Smooth.Bezier), Rectangle(origin = {-57, 0}, fillColor = {200, 200, 200}, fillPattern = FillPattern.CrossDiag, extent = {{-44.109, 9.126}, {44.109, -9.126}}), Polygon(origin = {-12, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-24.336, 18.252}, {-24.336, -18.252}, {9.126, -18.252}, {18.252, -12.168}, {24.336, -6.084}, {24.336, 6.084}, {18.252, 12.168}, {9.126, 18.252}, {-24.336, 18.252}}), Ellipse(origin = {-10, 0}, rotation = 45, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-3.042, 33.462}, {3.042, -33.462}})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Marine Propeller Model</h1>

<p>
  The <em>MarinePropeller</em> model represents a fixed-pitch screw propeller (FPP) including its advanced hydrodynamic interactions with the vessel's hull and the trailing rudder. 
  It acts as a transducer that converts rotational energy from the shaft into axial thrust, whilst evaluating hull wake fractions, thrust deduction, and the accelerated slipstream velocity that impacts the rudder.
</p>

<h2>Description</h2>

<p>
  This component goes beyond open-water characteristics. It computes the \"behind-hull\" performance by calculating the wake fraction (<em>w</em>) and thrust deduction (<em>t</em>) based on the vessel's geometric parameters (Lpp, B, Cb, etc.). 
  The thrust and torque are derived from the <strong>Wageningen B-series</strong> polynomials. 
  Additionally, it uses Actuator Disk Theory to compute the contraction and acceleration of the water slipstream at the rudder's location, providing essential data (<code>flowDiameter</code> and <code>flowSpeed</code>) for accurate steering simulations.
  The model also includes rotational inertia dynamics (propeller mass and entrained water) and supports ambient stream velocities.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the MarinePropeller block</caption>
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
      <td>If true, computes velocities relative to an external <code>Stream</code> object.</td>
    </tr>
    <tr>
      <td><strong>D</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Propeller diameter.</td>
    </tr>
    <tr>
      <td><strong>P_D</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Pitch-to-diameter ratio (P/D).</td>
    </tr>
    <tr>
      <td><strong>Ae_Ao</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Expanded blade area ratio.</td>
    </tr>
    <tr>
      <td><strong>Z</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Number of blades.</td>
    </tr>
    <tr>
      <td><strong>rhoProp</strong></td>
      <td>Density</td>
      <td>kg/m³</td>
      <td>Propeller material density.</td>
    </tr>
    <tr>
      <td><strong>J_prop</strong></td>
      <td>Inertia</td>
      <td>kg.m²</td>
      <td>Rotational inertia of the propeller.</td>
    </tr>
    <tr>
      <td><strong>J_addedWater</strong></td>
      <td>Inertia</td>
      <td>kg.m²</td>
      <td>Hydrodynamic added inertia (entrained water mass).</td>
    </tr>
    <tr>
      <td><strong>rhoWater</strong></td>
      <td>Density</td>
      <td>kg/m³</td>
      <td>Water density.</td>
    </tr>
    <tr>
      <td><strong>Lpp</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Vessel length between perpendiculars.</td>
    </tr>
    <tr>
      <td><strong>B</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Moulded beam of the vessel.</td>
    </tr>
    <tr>
      <td><strong>Cb</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Ship block coefficient.</td>
    </tr>
    <tr>
      <td><strong>Cp</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Ship prismatic coefficient.</td>
    </tr>
    <tr>
      <td><strong>lcb</strong></td>
      <td>Real</td>
      <td>%</td>
      <td>Longitudinal center of buoyancy.</td>
    </tr>
    <tr>
      <td><strong>Fa</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Aft body factor (-2 for U-shape, 0 for N-shape, +2 for V-shape).</td>
    </tr>
    <tr>
      <td><strong>distRudder</strong></td>
      <td>Length</td>
      <td>m</td>
      <td>Distance from propeller to the rudder's center of gravity.</td>
    </tr>
    <tr>
      <td><strong>w_calc</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Calculated Taylor wake fraction.</td>
    </tr>
    <tr>
      <td><strong>t_deduction</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Calculated thrust deduction fraction.</td>
    </tr>
    <tr>
      <td><strong>eta_R</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Calculated relative rotative efficiency.</td>
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
      <td><strong>flange</strong></td>
      <td>Flange_a</td>
      <td>-</td>
      <td>1D rotational mechanical connector (shaft connection).</td>
    </tr>
    <tr>
      <td><strong>frame_a</strong></td>
      <td>Frame_a</td>
      <td>-</td>
      <td>3D mechanical connector attached to the vessel.</td>
    </tr>
    <tr>
      <td><strong>Stream</strong></td>
      <td>Stream (outer)</td>
      <td>-</td>
      <td>Global object providing ambient fluid velocity (if <code>useStream</code>=true).</td>
    </tr>
    <tr>
      <td><strong>flowDiameter</strong></td>
      <td>RealOutput</td>
      <td>m</td>
      <td>Diameter of the accelerated slipstream reaching the rudder.</td>
    </tr>
    <tr>
      <td><strong>flowSpeed</strong></td>
      <td>RealOutput</td>
      <td>m/s</td>
      <td>Speed of the water flow inside the slipstream diameter at the rudder.</td>
    </tr>
    <tr>
      <td><strong>wakeFraction</strong></td>
      <td>RealOutput</td>
      <td>-</td>
      <td>Output signal of the calculated wake fraction coefficient.</td>
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
      <td><em>worldVel, bodyVel</em></td>
      <td>Velocity[3]</td>
      <td>m/s</td>
      <td>Absolute/Relative velocities resolved in world and body frames.</td>
    </tr>
    <tr>
      <td><em>shipSpeed</em></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Longitudinal velocity of the ship (surge).</td>
    </tr>
    <tr>
      <td><em>Va</em></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Advance speed of water reaching the propeller (accounting for wake).</td>
    </tr>
    <tr>
      <td><em>n, rpm</em></td>
      <td>Real</td>
      <td>rps, rpm</td>
      <td>Propeller rotational speed.</td>
    </tr>
    <tr>
      <td><em>J0</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Advance ratio (J = Va / (n * D)).</td>
    </tr>
    <tr>
      <td><em>Kt, Kq</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Thrust and Torque coefficients (Wageningen B-series).</td>
    </tr>
    <tr>
      <td><em>thrustProp, thrust</em></td>
      <td>Real</td>
      <td>N</td>
      <td>Open-water thrust and effective behind-hull thrust (applying <em>t_deduction</em>).</td>
    </tr>
    <tr>
      <td><em>shaftPower, thrustPower</em></td>
      <td>Real</td>
      <td>W</td>
      <td>Delivered rotational power and effective pushing power.</td>
    </tr>
    <tr>
      <td><em>eta_O, eta_B, eta_H, eta_D</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Open water, behind hull, hull, and overall propulsive efficiencies.</td>
    </tr>
    <tr>
      <td><em>C_th</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Thrust loading coefficient.</td>
    </tr>
    <tr>
      <td><em>V_inf, r_inf</em></td>
      <td>Real</td>
      <td>m/s, m</td>
      <td>Slipstream velocity and radius at infinity.</td>
    </tr>
    <tr>
      <td><em>V_x, r_x</em></td>
      <td>Real</td>
      <td>m/s, m</td>
      <td>Slipstream velocity and radius at the rudder distance.</td>
    </tr>
    <tr>
      <td><em>Delta_r</em></td>
      <td>Length</td>
      <td>m</td>
      <td>Turbulence radius correction for slipstream expansion.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes propulsion and interaction forces based on a combination of empirical regressions and momentum theory:
</p>

<ul>
  <li><strong>Hull Interaction:</strong> The water reaching the propeller is slowed by the hull's boundary layer. The Advance Speed is <em>V<sub>a</sub> = u · (1 - w)</em>. The generated thrust pushes against the hull, reducing effective thrust: <em>T<sub>eff</sub> = T<sub>prop</sub> · (1 - t)</em>.</li>
  <li><strong>Propeller Characteristics:</strong> The Wageningen B-series polynomials provide <em>K<sub>T</sub></em> and <em>K<sub>Q</sub></em> based on the advance ratio <em>J<sub>0</sub></em>. The model calculates <em>T<sub>prop</sub> = ρ · n<sup>2</sup> · D<sup>4</sup> · K<sub>T</sub></em>.</li>
  <li><strong>Power Balance:</strong> The rotational equation of motion balances the driving <code>torque</code> against the hydrodynamic load torque and the lumped inertia (propeller + entrained water).</li>
  <li><strong>Slipstream (Rudder Interaction):</strong> Utilizing actuator disk theory, the model calculates the contraction of the propeller race. As the flow travels the distance <code>distRudder</code>, it accelerates to <em>V<sub>x</sub></em> and its radius contracts to <em>r<sub>x</sub></em>. A turbulence expansion correction (<em>Δr</em>) is added to provide the final <code>flowDiameter</code> and <code>flowSpeed</code>, which are crucial for calculating rudder lift.</li>
</ul>

<hr>
<h2>References</h2>
<p>
  <em>Note: This component is part of the ShipParts package within the Aquanaut library. The hydrodynamic formulations and interactions are based on:</em>
</p>
<ul>
  <li>Brix, J. (1987). <em>Manoeuvring technical manual</em>. Schiff und Hafen, 36(5).</li>
  <li>Harvald, S. A. (1983). <em>Resistance and Propulsion of Ships</em>.</li>
  <li>Holtrop, J., &amp; Mennen, G. G. J. (1982). <em>An approximate power prediction method</em>. International shipbuilding progress, 29(335), 166-170.</li>
  <li>Ursolov, Aleksandr &amp; Dmytro, Filin. (2021). <em>Rapid method for accurate determining propeller volumetric and inertia properties</em>.</li>
  <li>Kristensen, H. O., &amp; Lützen, M. (2012). <em>Prediction of resistance and propulsion power of ships</em>. Clean Shipping Currents, 1(6), 1-52.</li>

</ul>


</body></html>"));
end MarinePropeller_backup;
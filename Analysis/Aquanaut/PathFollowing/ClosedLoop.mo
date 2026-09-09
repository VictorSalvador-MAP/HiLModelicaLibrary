within Aquanaut.PathFollowing;

model ClosedLoop
  // Parameters for Closed Loop
  // Path Following Control
  parameter Real pfKp = 0.1;
  parameter Real pfKi = 0.0001;
  parameter Real pfKd = 1.0;
  parameter Real rudK = 1.0;
  // Velocity Control
  parameter Real Uref = 5.0;
  parameter Real vKp = 0.963242207995077;
  parameter Real vKi = 1.932793587;
  parameter Real vKd = 0.051946887;
  // Serret-Frenet
  parameter Modelica.Units.SI.Distance Delta = 10;
  parameter Real Wp0x = -5000.0;
  parameter Real Wp0y = -10;
  parameter Real Wp1x = 5000.0;
  parameter Real Wp1y = -10;
  // Initialization
  parameter Real initTol = 0.01;
  parameter Real opDelay = 1;
  // Blocks
  OpenLoop OT1model annotation(
    Placement(transformation(origin = {240, 26}, extent = {{-30, -30}, {30, 30}})));
  SerretFrenetModel serretFrenet(Wp = [Wp0x, Wp0y; Wp1x, Wp1y], deltaLOS = Delta) annotation(
    Placement(transformation(origin = {-272.125, -11.2663}, extent = {{-44.875, -23.9334}, {44.875, 23.9334}})));
  Modelica.Blocks.Logical.Switch switch_v_ref annotation(
    Placement(transformation(origin = {40, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.PID PID_velocity(Ti = vKp/vKi, Td = vKd/vKp) annotation(
    Placement(transformation(origin = {142, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant u_op(k = Uref) annotation(
    Placement(transformation(origin = {44, 138}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add v_e(k2 = -1) annotation(
    Placement(transformation(origin = {70, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.And and_buo annotation(
    Placement(transformation(origin = {-120, 116}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Abs abs_az annotation(
    Placement(transformation(origin = {-214, 116}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Abs abs_daz annotation(
    Placement(transformation(origin = {-214, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessThreshold th_daz(threshold = initTol) annotation(
    Placement(transformation(origin = {-178, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessThreshold th_az(threshold = initTol) annotation(
    Placement(transformation(origin = {-178, 116}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.1) annotation(
    Placement(transformation(origin = {102, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Derivative der_az annotation(
    Placement(transformation(origin = {-246, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Logical.RSFlipFlop buoFF annotation(
    Placement(transformation(origin = {-22, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(transformation(origin = {-86, 96}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch_chi_sf annotation(
    Placement(transformation(origin = {-2, -66}, extent = {{-10, -10}, {10, 10}})));
  PF_Controller pf_Controller(Kp = pfKp, Ki = pfKi, Kd = pfKd) annotation(
    Placement(transformation(origin = {85.4, -79.7692}, extent = {{-60.4, -23.2308}, {60.4, 23.2308}})));
  Modelica.Blocks.Sources.Constant zero_ref(k = 0) annotation(
    Placement(transformation(origin = {-51, -79}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Logical.Switch switch_chi_d annotation(
    Placement(transformation(origin = {-2, -92}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Math.Abs abs_ax annotation(
    Placement(transformation(origin = {-274, -138}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LessThreshold th_ax(threshold = initTol) annotation(
    Placement(transformation(origin = {-236, -138}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain controlAlocationGain(k = rudK) annotation(
    Placement(transformation(origin = {162, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.Derivative der_ax annotation(
    Placement(transformation(origin = {-312, -106}, extent = {{10, 10}, {-10, -10}}, rotation = -180)));
  Modelica.Blocks.Logical.LessThreshold th_dax(threshold = initTol) annotation(
    Placement(transformation(origin = {-244, -106}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.And and_op annotation(
    Placement(transformation(origin = {-196, -118}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.RSFlipFlop opFF annotation(
    Placement(transformation(origin = {-100, -80}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Math.Abs abs_dax annotation(
    Placement(transformation(origin = {-280, -106}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.LogicalDelay logicalDelay(delayTime = opDelay) annotation(
    Placement(transformation(origin = {-188, -76}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.And and_delay annotation(
    Placement(transformation(origin = {-142, -86}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(switch_v_ref.y, v_e.u1) annotation(
    Line(points = {{51, 86}, {58, 86}}, color = {0, 0, 127}));
  connect(v_e.y, firstOrder.u) annotation(
    Line(points = {{81, 80}, {89, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, PID_velocity.u) annotation(
    Line(points = {{113, 80}, {130, 80}}, color = {0, 0, 127}));
  connect(and_buo.y, buoFF.S) annotation(
    Line(points = {{-109, 116}, {-34, 116}}, color = {255, 0, 255}));
  connect(booleanConstant.y, buoFF.R) annotation(
    Line(points = {{-75, 96}, {-59.5, 96}, {-59.5, 104}, {-34, 104}}, color = {255, 0, 255}));
  connect(buoFF.Q, switch_v_ref.u2) annotation(
    Line(points = {{-11, 116}, {10.5, 116}, {10.5, 86}, {28, 86}}, color = {255, 0, 255}));
  connect(der_az.y, abs_daz.u) annotation(
    Line(points = {{-235, 82}, {-227, 82}}, color = {0, 0, 127}));
  connect(u_op.y, switch_v_ref.u1) annotation(
    Line(points = {{55, 138}, {63.5, 138}, {63.5, 116}, {16, 116}, {16, 94}, {28, 94}}, color = {0, 0, 127}));
  connect(abs_ax.y, th_ax.u) annotation(
    Line(points = {{-263, -138}, {-249, -138}}, color = {0, 0, 127}));
  connect(pf_Controller.r_d, controlAlocationGain.u) annotation(
    Line(points = {{135, -80}, {150, -80}}, color = {0, 0, 127}));
  connect(th_dax.y, and_op.u1) annotation(
    Line(points = {{-233, -106}, {-217, -106}, {-217, -117.25}, {-209, -117.25}, {-209, -118}}, color = {255, 0, 255}));
  connect(th_ax.y, and_op.u2) annotation(
    Line(points = {{-225, -138}, {-218, -138}, {-218, -126}, {-209, -126}}, color = {255, 0, 255}));
  connect(opFF.R, booleanConstant.y) annotation(
    Line(points = {{-112, -74}, {-112, -73}, {-122, -73}, {-122, -44}, {-62, -44}, {-62, 96}, {-75, 96}}, color = {255, 0, 255}));
  connect(opFF.Q, switch_chi_sf.u2) annotation(
    Line(points = {{-89, -86}, {-70, -86}, {-70, -66}, {-14, -66}}, color = {255, 0, 255}));
  connect(switch_chi_d.u2, opFF.Q) annotation(
    Line(points = {{-14, -92}, {-70, -92}, {-70, -86}, {-89, -86}}, color = {255, 0, 255}));
  connect(der_ax.y, abs_dax.u) annotation(
    Line(points = {{-301, -106}, {-293, -106}}, color = {0, 0, 127}));
  connect(abs_dax.y, th_dax.u) annotation(
    Line(points = {{-269, -106}, {-257, -106}}, color = {0, 0, 127}));
  connect(logicalDelay.y2, and_delay.u1) annotation(
    Line(points = {{-177, -82}, {-167, -82}, {-167, -86}, {-155, -86}}, color = {255, 0, 255}));
  connect(and_op.y, and_delay.u2) annotation(
    Line(points = {{-185, -118}, {-169, -118}, {-169, -94}, {-155, -94}}, color = {255, 0, 255}));
  connect(and_delay.y, opFF.S) annotation(
    Line(points = {{-131, -86}, {-113, -86}}, color = {255, 0, 255}));
  connect(serretFrenet.U, v_e.u2) annotation(
    Line(points = {{-230, -1}, {52, -1}, {52, 74}, {58, 74}}, color = {0, 0, 127}));
  connect(serretFrenet.U, switch_v_ref.u3) annotation(
    Line(points = {{-230, -1}, {18, -1}, {18, 78}, {28, 78}}, color = {0, 0, 127}));
  connect(controlAlocationGain.y, OT1model.rudderAngle) annotation(
    Line(points = {{173, -80}, {188, -80}, {188, 8}, {202, 8}}, color = {0, 0, 127}));
  connect(PID_velocity.y, OT1model.propellerSpeed) annotation(
    Line(points = {{154, 80}, {180, 80}, {180, 44}, {202, 44}}, color = {0, 0, 127}));
  connect(OT1model.a[1], abs_ax.u) annotation(
    Line(points = {{274, 8}, {304, 8}, {304, -196}, {-344, -196}, {-344, -138}, {-286, -138}}, color = {0, 0, 127}));
  connect(OT1model.a[1], der_ax.u) annotation(
    Line(points = {{274, 8}, {304, 8}, {304, -196}, {-344, -196}, {-344, -106}, {-324, -106}}, color = {0, 0, 127}));
  connect(OT1model.a[3], abs_az.u) annotation(
    Line(points = {{274, 8}, {312, 8}, {312, -206}, {-352, -206}, {-352, 116}, {-226, 116}}, color = {0, 0, 127}));
  connect(OT1model.a[3], der_az.u) annotation(
    Line(points = {{274, 8}, {312, 8}, {312, -206}, {-352, -206}, {-352, 82}, {-258, 82}}, color = {0, 0, 127}));
  connect(buoFF.Q, logicalDelay.u) annotation(
    Line(points = {{-10, 116}, {-8, 116}, {-8, 24}, {-204, 24}, {-204, -76}, {-200, -76}}, color = {255, 0, 255}));
  connect(zero_ref.y, switch_chi_d.u3) annotation(
    Line(points = {{-45.5, -79}, {-30.5, -79}, {-30.5, -84}, {-14, -84}}, color = {0, 0, 127}));
  connect(zero_ref.y, switch_chi_sf.u3) annotation(
    Line(points = {{-45.5, -79}, {-30, -79}, {-30, -74}, {-14, -74}}, color = {0, 0, 127}));
  connect(switch_chi_sf.u1, serretFrenet.chi_sf) annotation(
    Line(points = {{-14, -58}, {-20, -58}, {-20, -12}, {-230, -12}}, color = {0, 0, 127}));
  connect(switch_chi_d.u1, serretFrenet.chi_d) annotation(
    Line(points = {{-14, -100}, {-24, -100}, {-24, -24}, {-230, -24}}, color = {0, 0, 127}));
  connect(switch_chi_d.y, pf_Controller.chi_d) annotation(
    Line(points = {{10, -92}, {29, -92}}, color = {0, 0, 127}));
  connect(switch_chi_sf.y, pf_Controller.chi_SF) annotation(
    Line(points = {{10, -66}, {18, -66}, {18, -67}, {29, -67}}, color = {0, 0, 127}));
  connect(abs_daz.y, th_daz.u) annotation(
    Line(points = {{-202, 82}, {-190, 82}}, color = {0, 0, 127}));
  connect(abs_az.y, th_az.u) annotation(
    Line(points = {{-202, 116}, {-190, 116}}, color = {0, 0, 127}));
  connect(th_az.y, and_buo.u1) annotation(
    Line(points = {{-166, 116}, {-132, 116}}, color = {255, 0, 255}));
  connect(th_daz.y, and_buo.u2) annotation(
    Line(points = {{-166, 82}, {-142, 82}, {-142, 108}, {-132, 108}}, color = {255, 0, 255}));
  connect(OT1model.p[2], serretFrenet.y) annotation(
    Line(points = {{274, 44}, {350, 44}, {350, -220}, {-362, -220}, {-362, -3}, {-314, -3}}, color = {0, 0, 127}));
  connect(OT1model.p[1], serretFrenet.x) annotation(
    Line(points = {{274, 44}, {350, 44}, {350, -220}, {-362, -220}, {-362, 6}, {-314, 6}}, color = {0, 0, 127}));
  connect(OT1model.v[2], serretFrenet.vy) annotation(
    Line(points = {{276, 26}, {330, 26}, {330, -214}, {-356, -214}, {-356, -30}, {-314, -30}}, color = {0, 0, 127}));
  connect(OT1model.p[6], serretFrenet.psi) annotation(
    Line(points = {{274, 44}, {350, 44}, {350, -220}, {-362, -220}, {-362, -12}, {-314, -12}}, color = {0, 0, 127}));
  connect(OT1model.v[1], serretFrenet.vx) annotation(
    Line(points = {{276, 26}, {330, 26}, {330, -214}, {-356, -214}, {-356, -21}, {-314, -21}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 250, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Diagram(coordinateSystem(extent = {{-380, 180}, {360, -240}}), graphics = {Rectangle(origin = {-133, 95}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-133, 73}, {133, -73}}), Text(origin = {-196, 162}, extent = {{-68, 6}, {68, -6}}, textString = "Buoyancy stead-state analysis", textStyle = {TextStyle.Bold}), Rectangle(origin = {-199, -109}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-133, 63}, {133, -63}}), Text(origin = {-247, -52}, extent = {{-81, 6}, {81, -6}}, textString = "Operation Point stead-state analysis", textStyle = {TextStyle.Bold}), Rectangle(origin = {90, 108}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-78, 62}, {78, -62}}), Text(origin = {64, 164}, extent = {{-48, 6}, {48, -6}}, textString = "Velocity Control", textStyle = {TextStyle.Bold}), Rectangle(origin = {84, -82}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-112, 38}, {112, -38}}), Text(origin = {82, -112}, extent = {{-48, 6}, {48, -6}}, textString = "Path Following Control", textStyle = {TextStyle.Bold}), Text(origin = {238, 66}, extent = {{-38, 8}, {38, -8}}, textString = "OT1 model", textStyle = {TextStyle.Bold}), Text(origin = {-293, -189}, extent = {{-45, -3}, {45, 3}}, textString = "acceleration on x-axis", textStyle = {TextStyle.Italic}), Text(origin = {-309, 99}, extent = {{-43, -3}, {43, 3}}, textString = "acceleration on z-axis", textStyle = {TextStyle.Italic}), Text(origin = {-98, 5}, extent = {{-36, -3}, {36, 3}}, textString = "body velocity", textStyle = {TextStyle.Italic}), Text(origin = {359, 49}, extent = {{-79, -3}, {79, 3}}, textString = "position on x and y axes, and yaw angle", textStyle = {TextStyle.Italic}, horizontalAlignment = TextAlignment.Left), Text(origin = {324, 31}, extent = {{-46, -3}, {46, 3}}, textString = "velocity on x and y axes", textStyle = {TextStyle.Italic}, horizontalAlignment = TextAlignment.Left), Text(origin = {-98, -7}, extent = {{-36, -3}, {36, 3}}, textString = "chi_sf", textStyle = {TextStyle.Italic}), Text(origin = {-98, -19}, extent = {{-36, -3}, {36, 3}}, textString = "chi_d", textStyle = {TextStyle.Italic}), Text(origin = {206, 85}, extent = {{-36, -3}, {36, 3}}, textString = "propeller speed", textStyle = {TextStyle.Italic}, horizontalAlignment = TextAlignment.Left), Text(origin = {226, -37}, extent = {{-36, -3}, {36, 3}}, textString = "rudder angle", textStyle = {TextStyle.Italic}, horizontalAlignment = TextAlignment.Left)}),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {60, 30}, lineThickness = 1, extent = {{-20, 20}, {20, -20}}), Rectangle(origin = {-28, 30}, lineThickness = 1, extent = {{-36, 20}, {36, -20}}), Text(origin = {-28, 31}, extent = {{-28, 7}, {28, -7}}, textString = "Controller", textStyle = {TextStyle.UnderLine}), Text(origin = {60, 31}, extent = {{-14, 7}, {14, -7}}, textString = "OT1", textStyle = {TextStyle.UnderLine}), Rectangle(origin = {8, -37}, lineThickness = 1, extent = {{-36, 21}, {36, -21}}), Text(origin = {8, -35}, extent = {{-28, 7}, {28, -7}}, textString = "Serret-Frenèt", textStyle = {TextStyle.UnderLine}), Line(origin = {52, -15}, points = {{8, 25}, {8, -23}, {-8, -23}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-55, -3}, points = {{27, -35}, {-27, -35}, {-27, 33}, {-9, 33}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {24, 30}, points = {{-16, 0}, {16, 0}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Closed-Loop Path Following Control System</h1>

<p>
  The <em>ClosedLoop</em> model serves as the top-level integration system architecture for the autonomous vehicle model. It pairs an Open-Loop vehicle plant model with look-ahead guidance formulas, velocity regulations, and path-following controllers to build a fully automated, closed-loop navigation infrastructure.
</p>

<h2>Description</h2>

<p>
  This assembly establishes path trajectory tracking over a waypoint path segment. It features two continuous-time control loops: a <strong>Velocity Controller</strong> that uses a PID layout to adjust propeller speed toward a given velocity target (<code>Uref</code>), and a <strong>Path-Following Controller</strong> that relies on look-ahead angles to determine required rudder angles. 
</p>
<p>
  Furthermore, the system embeds state logic configurations (using flip-flops, thresholds, and logic delays) to execute real-time steady-state checks on buoyancy states (Z-axis checks) and initial operating points (X-axis checks), holding back full steering actuation until structural dynamics satisfy the specified initial tolerances.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the ClosedLoop integration model</caption>
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
      <td><strong>pfKp, pfKi, pfKd</strong></td>
      <td>Real</td>
      <td>Varies</td>
      <td>Proportional, Integral, and Derivative gain tunings for the trajectory path-following loop.</td>
    </tr>
    <tr>
      <td><strong>rudK</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Static scaling coefficient for the final rudder command mapping.</td>
    </tr>
    <tr>
      <td><strong>Uref</strong></td>
      <td>Real</td>
      <td>m/s</td>
      <td>Target cruise reference velocity parameter for the vessel.</td>
    </tr>
    <tr>
      <td><strong>vKp, vKi, vKd</strong></td>
      <td>Real</td>
      <td>Varies</td>
      <td>Proportional, Integral, and Derivative gain tunings for the speed controller loop.</td>
    </tr>
    <tr>
      <td><strong>Delta</strong></td>
      <td>Distance</td>
      <td>m</td>
      <td>Look-ahead baseline distance utilized inside the Serret-Frenet block.</td>
    </tr>
    <tr>
      <td><strong>Wp0x, Wp0y</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Coordinates for the initial waypoint vector (origin boundary).</td>
    </tr>
    <tr>
      <td><strong>Wp1x, Wp1y</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Coordinates for the final waypoint vector (destination boundary).</td>
    </tr>
    <tr>
      <td><strong>initTol</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Numeric convergence error boundary threshold for state-check logic.</td>
    </tr>
    <tr>
      <td><strong>opDelay</strong></td>
      <td>Real</td>
      <td>s</td>
      <td>Time-delay filter length used to guarantee operational point stabilization.</td>
    </tr>
  </tbody>
</table>

<h2>Key Internal Sub-components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Primary internal block component identifiers</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Instance Name</th>
      <th>Model Class Type</th>
      <th>Primary Functional Duty</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>OT1model</strong></td>
      <td>OpenLoop</td>
      <td>Represents the physical multi-degree-of-freedom core vehicle plant dynamics.</td>
    </tr>
    <tr>
      <td><strong>serretFrenet</strong></td>
      <td>SerretFrenetModel</td>
      <td>Translates global positions into tracking error vectors based on a target line segment.</td>
    </tr>
    <tr>
      <td><strong>PID_velocity</strong></td>
      <td>Modelica.Blocks.Continuous.PID</td>
      <td>Regulates velocity error signals into physical propeller speed commands.</td>
    </tr>
    <tr>
      <td><strong>pf_Controller</strong></td>
      <td>PF_Controller</td>
      <td>Calculates precise steering corrections based on angular errors.</td>
    </tr>
  </tbody>
</table>

<h2>System Operation and Interconnections</h2>

<p>
  The system orchestrates multi-loop tracking and control sequences using the following routing criteria:
</p>
<ul>
  <li><strong>Velocity Error Loop:</strong> Gathers total velocity <code>U</code> from the Serret-Frenet block, extracts its difference relative to the reference node (or logic switches), dampens it via a <code>FirstOrder</code> block filter, and triggers <code>PID_velocity</code> to spin the physical propellers.</li>
  <li><strong>Path Steering Loop:</strong> Maps position states (<code>p[1]</code>, <code>p[2]</code>) and velocity components (<code>v[1]</code>, <code>v[2]</code>) into the Serret-Frenet framework. Resulting values for tracking profiles (<code>chi_sf</code>, <code>chi_d</code>) traverse safety logic switches to drive the <code>pf_Controller</code>, which sets rudder orientation through <code>controlAlocationGain</code>.</li>
  <li><strong>Buoyancy & Operating Point Interlocks:</strong> Monitors the absolute values and derivatives of vehicle accelerations (<code>a[1]</code> on X-axis and <code>a[3]</code> on Z-axis). Flip-flops prevent reference angles from switching to active modes until transitional oscillations decay below the specified <code>initTol</code>.</li>
</ul>

</body></html>"));
end ClosedLoop;

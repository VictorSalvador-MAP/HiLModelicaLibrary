within Aquanaut.HydroForces;

model BuoyancyInterpolation
  /*************************************************/
  /****************** PARAMETERS *******************/
  /*************************************************/
  // user interface
  parameter Boolean useComplexShape = false "Assumption on vessel shape. True: 3D model. False: Sphere";
  // general parameters
  parameter Modelica.Units.SI.DampingCoefficient Cb = 10000 "Vertical hydrodynamic drag (steady water)";
  // simplified model parameters and variables
  parameter Modelica.Units.SI.Radius sphereRadius = 5 "Sphere radius" annotation(
    Dialog(tab = "Simple Shape"));
  // complex shape
  parameter String shapePath = "" "File path of vessel 3D model" annotation(
    Dialog(tab = "Complex Shape"));
  final parameter String shapePath_abs = if shapePath <> "" then Modelica.Utilities.Files.loadResource(shapePath) else "";
  parameter String wavePath = "" "File path of wave 3D model" annotation(
    Dialog(tab = "Complex Shape"));
  final parameter String wavePath_abs = if wavePath <> "" then Modelica.Utilities.Files.loadResource(wavePath) else "";
  parameter String output_folder = "" annotation(
    Dialog(tab = "Complex Shape"));
  final parameter String output_folder_abs = if output_folder <> "" then Modelica.Utilities.Files.loadResource(output_folder) else "";
  parameter Modelica.Units.SI.Distance dist_keel_cg = 0 "Vertical distance from the keel to the center of gravity (KG)" annotation(
    Dialog(tab = "Complex Shape"));
  parameter Real time_step = 1 "Wave file time step [s]" annotation(
    Dialog(tab = "Complex Shape"));
  parameter Boolean outputEnable = false "File output flag. True: Enable output. False: Disable output" annotation(
    Dialog(tab = "Complex Shape"));
  parameter Boolean noForcesAndTorques = false "Disable the output of forces and torques for testing purposes" annotation(
    Dialog(tab = "Debug"));
  parameter Boolean useSTLPositionXY = false "Disable the XY possition given by STL for testing purposes" annotation(
    Dialog(tab = "Debug"));
  /************************************************/
  /****************** VARIABLES *******************/
  /************************************************/
  // unidimensional
  Modelica.Units.SI.Position keelZPos "Keel Z-coord position";
  Modelica.Units.SI.Position CoBZ;
  Modelica.Units.SI.Position auxCoBZ;
  Modelica.Units.SI.Distance submergedDepth;
  Modelica.Units.SI.Velocity vDepth;
  // volumetric
  Modelica.Units.SI.Volume displacedVolume;
  Modelica.Units.SI.Mass displacedMass;
  Modelica.Units.SI.Weight displacedWeight;
  // forces and torques
  Modelica.Units.SI.Force fBuoy[3];
  Modelica.Units.SI.Torque tauBuoy[3];
  // center of buoyancy
  Real e_n_0[3];
  Modelica.Units.SI.Position rBuoy[3];
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Units.SI.Volume totalVolume "Total volume";
  Modelica.Units.SI.Angle shipAngles[3];
  parameter Modelica.Units.SI.Position ship_CM[3] = {-0.12693, -0.01518, 0.26499};
  Utils.InterpolatedBuoyancyBlock interpolationBlock;
  Modelica.Units.SI.Position r_geom_0[3];
  Modelica.Units.SI.Position rb_cm_0[3];

protected
  outer HydroForces.Stream Stream;
  Integer outFlag(start = 0);
  Real disableFT;
  Modelica.Units.SI.Distance h "Height of the spherical cap";
  
  // Function Outputs
  Modelica.Units.SI.Volume funcSubVolume "Underwater volume";
  Real subPercentage "Submerged volume percentage [%]";
  Real funcCoB[3] "Underwater centroid";

equation
// buoyancy direction resolved in world frame
  e_n_0 = {0, 0, 1};
  if noForcesAndTorques then
    disableFT = 0;
  else
    disableFT = 1;
  end if;
  if outputEnable then
    outFlag = 1;
  else
    outFlag = 0;
  end if;
    
  shipAngles[3] = 0;
  shipAngles[2] = atan2(-frame_a.R.T[1,3], sqrt(frame_a.R.T[1,1]^2 + frame_a.R.T[1,2]^2));  
  shipAngles[1] = atan2(  -frame_a.R.T[2,3], frame_a.R.T[3,3]);     
  r_geom_0 = frame_a.r_0 + Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, -ship_CM);
  interpolationBlock.HeaveInput = r_geom_0[3];
  interpolationBlock.RollInput = abs(shipAngles[1]);
  interpolationBlock.PitchInput = shipAngles[2];
// Buoyancy data: depends only on vessel shape
  if useComplexShape then
    
    funcSubVolume = interpolationBlock.DVOutput;
    rb_cm_0 = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, {interpolationBlock.XcobOutput, if shipAngles[1] > 0 then -interpolationBlock.YcobOutput else interpolationBlock.YcobOutput, 0});
    funcCoB = {r_geom_0[1] + rb_cm_0[1], r_geom_0[2] + rb_cm_0[2], interpolationBlock.ZcobOutput};
    
    totalVolume = 0;
    subPercentage = 0;
    h = 0;
    keelZPos = frame_a.r_0[3] + dist_keel_cg;
    submergedDepth = max(0, keelZPos);
    vDepth = der(keelZPos);
    displacedVolume = funcSubVolume;
    auxCoBZ = funcCoB[3];
    CoBZ = max(auxCoBZ, 0);
    if useSTLPositionXY then
      rBuoy = {funcCoB[1], funcCoB[2], CoBZ};
    else
      rBuoy = {frame_a.r_0[1], frame_a.r_0[2], CoBZ};
    end if;
  else
    rb_cm_0 = {0,0,0};
    funcSubVolume = 0;
    subPercentage = 0;
    funcCoB = {0, 0, 0};
    keelZPos = frame_a.r_0[3] + sphereRadius;
    submergedDepth = max(0, keelZPos);
    vDepth = der(keelZPos);
    h = max(0, min(submergedDepth, 2*sphereRadius));
    totalVolume = 4/3*Modelica.Constants.pi*sphereRadius^3;
    displacedVolume = Modelica.Constants.pi*(h^2)*(3*sphereRadius - h)/3;
    auxCoBZ = frame_a.r_0[3] + (3*((2*sphereRadius - h)^2)/(4*(3*sphereRadius - h)));
    CoBZ = max(auxCoBZ, 0);
    rBuoy = {frame_a.r_0[1], frame_a.r_0[2], CoBZ};
  end if;
// fluid weight (salt water density: 1025 kg/m3)
  displacedMass = Stream.fluidDensity*displacedVolume;
  displacedWeight = Modelica.Constants.g_n*displacedMass;
// compute forces and torques
  fBuoy = -(displacedWeight + vDepth*Cb)*e_n_0;
  tauBuoy = cross(rBuoy - frame_a.r_0, fBuoy);
// force and torque applied to body (to be connected) center of mass
  zeros(3) = frame_a.f + Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, fBuoy)*disableFT;
  zeros(3) = frame_a.t + Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, tauBuoy)*disableFT;
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {0, -17}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 39}, {3, -39}}), Ellipse(origin = {0, -60}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-16, 16}, {16, -16}}), Line(origin = {2.03, -30.3}, points = {{-90.0305, -9.70056}, {-56.0305, 8.29944}, {-30.0305, -9.70056}, {3.96953, 8.29944}, {39.9695, -9.70056}, {67.9695, 10.2994}, {89.9695, -9.70056}}, color = {85, 170, 255}, thickness = 4.25, smooth = Smooth.Bezier), Polygon(origin = {0, 38}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}}), Text(textColor = {85, 85, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name", textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html>
<head>
</head>
<body>
<h1>Buoyancy Interpolation Model</h1>

<p>
  The <em>BuoyancyInterpolation</em> model calculates the hydrostatic restoring forces and moments acting on a vessel. 
  To significantly improve simulation speed, this component utilizes a pre-calculated interpolation strategy for complex 3D hull shapes, determining volumetric properties based on the vessel's current heave, roll, and pitch states.
</p>

<h2>Description</h2>

<p>
  Based on Archimedes' Principle, this block evaluates the displaced volume and the precise location of the Center of Buoyancy (COB) to generate vertical restoring forces and stabilizing moments (metacentric stability). 
  When <code>useComplexShape</code> is enabled, the model avoids computationally expensive real-time boolean mesh intersections. Instead, it extracts the vessel's kinematics and feeds them into the <code>InterpolatedBuoyancyBlock</code>, instantly retrieving the submerged volume and centroid data. 
  It also features a simplified spherical fallback mode and several debugging toggles to isolate forces during autopilot or stability testing.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the BuoyancyInterpolation block</caption>
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
      <td><strong>useComplexShape</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>Set to true to use the 3D interpolated hull data; false to use the spherical approximation.</td>
    </tr>
    <tr>
      <td><strong>Cb</strong></td>
      <td>DampingCoefficient</td>
      <td>N.s/m</td>
      <td>Vertical hydrodynamic drag coefficient (heave damping).</td>
    </tr>
    <tr>
      <td><strong>sphereRadius</strong></td>
      <td>Radius</td>
      <td>m</td>
      <td>Radius used when <code>useComplexShape</code> is false.</td>
    </tr>
    <tr>
      <td><strong>shapePath, wavePath</strong></td>
      <td>String</td>
      <td>-</td>
      <td>File paths for the vessel's 3D STL model and the wave sequence.</td>
    </tr>
    <tr>
      <td><strong>dist_keel_cg</strong></td>
      <td>Distance</td>
      <td>m</td>
      <td>Vertical distance from the keel to the center of gravity (KG).</td>
    </tr>
    <tr>
      <td><strong>ship_CM</strong></td>
      <td>Position[3]</td>
      <td>m</td>
      <td>Pre-defined Center of Mass offset vector.</td>
    </tr>
    <tr>
      <td><strong>noForcesAndTorques</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>Disables the application of forces/torques to the hull for isolated testing or debugging.</td>
    </tr>
    <tr>
      <td><strong>useSTLPositionXY</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>Overrides the local X/Y force application point with the raw STL centroid.</td>
    </tr>
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Connectors and global objects</caption>
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
      <td>3D mechanical connector attached to the vessel's structure.</td>
    </tr>
    <tr>
      <td><strong>Stream</strong></td>
      <td>Stream (outer)</td>
      <td>-</td>
      <td>Global object providing ambient fluid properties such as <code>fluidDensity</code>.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Components & Variables</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 3:</strong> Key internal variables and sub-models</caption>
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
      <td><em>interpolationBlock</em></td>
      <td>InterpolatedBuoyancyBlock</td>
      <td>-</td>
      <td>Sub-model that stores and interpolates the 3D volumetric data based on input states.</td>
    </tr>
    <tr>
      <td><em>shipAngles</em></td>
      <td>Angle[3]</td>
      <td>rad</td>
      <td>Vessel's current Roll, Pitch, and Yaw angles extracted from <code>frame_a</code>.</td>
    </tr>
    <tr>
      <td><em>keelZPos</em></td>
      <td>Position</td>
      <td>m</td>
      <td>Z-coordinate of the vessel's keel.</td>
    </tr>
    <tr>
      <td><em>funcSubVolume</em></td>
      <td>Volume</td>
      <td>m&sup3;</td>
      <td>Submerged volume retrieved directly from the interpolation block or sphere formula.</td>
    </tr>
    <tr>
      <td><em>funcCoB</em></td>
      <td>Position[3]</td>
      <td>m</td>
      <td>Raw Center of Buoyancy coordinates retrieved from the interpolation block.</td>
    </tr>
    <tr>
      <td><em>displacedMass</em></td>
      <td>Mass</td>
      <td>kg</td>
      <td>Mass of the displaced fluid (using <code>Stream.fluidDensity</code>).</td>
    </tr>
    <tr>
      <td><em>fBuoy</em></td>
      <td>Force[3]</td>
      <td>N</td>
      <td>Resolved 3D buoyancy force vector in the world frame.</td>
    </tr>
    <tr>
      <td><em>tauBuoy</em></td>
      <td>Torque[3]</td>
      <td>N.m</td>
      <td>Restoring moment vector generated by the COB offset.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes the buoyancy force vector <em>f<sub>b</sub></em> and the resulting torque <em>&tau;<sub>b</sub></em> using the following logic flow:
</p>

<ul>
  <li><strong>State Extraction:</strong> The model continuously extracts the vessel's Heave (Z-axis offset), absolute Roll, and Pitch angles from <code>frame_a</code>. These values are fed as inputs to the <code>interpolationBlock</code>.</li>
  <li><strong>Volumetric Interpolation:</strong> When <code>useComplexShape</code> is true, the <code>interpolationBlock</code> outputs <code>DVOutput</code> (Displaced Volume) and the centroid coordinates (<code>Xcob, Ycob, Zcob</code>). The model corrects these coordinates using the <code>ship_CM</code> offsets to ensure forces are applied relative to the proper mechanical center.</li>
  <li><strong>Force Calculation:</strong> The total vertical force combines the static weight of the displaced fluid with a linear dynamic damping term for vertical motion: <em>f<sub>b</sub> = -(W<sub>displaced</sub> + v<sub>depth</sub> &middot; C<sub>b</sub>) &middot; e<sub>z</sub></em>.</li>
  <li><strong>Torque Generation:</strong> The stabilizing righting moment is calculated using the cross product of the distance from the mechanical frame to the Center of Buoyancy and the buoyancy force vector: <em>&tau;<sub>b</sub> = (r<sub>buoy</sub> - r<sub>frame</sub>) &times; f<sub>b</sub></em>.</li>
  <li><strong>Debugging Application:</strong> The resulting forces and torques are applied to the <code>frame_a</code> connector. If the <code>noForcesAndTorques</code> flag is active, a <code>disableFT</code> multiplier (set to 0) zeroes out the loads, allowing the system to log the hydrostatic data without physically affecting the vessel's dynamics.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the HydroForces package within the Aquanaut library and provides a computationally efficient alternative to real-time mesh evaluations.</em>
</p>

</body>
</html>"),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
  __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
end BuoyancyInterpolation;

within Aquanaut.HydroForces;

model BuoyancyInterpolationWithFailback

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
  
  parameter Boolean zeroOnFailback = false "True: Return zeros during failback. False: Call STL function" annotation(
      Dialog(tab = "Complex Shape"));
  
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
  shipAngles[1] = atan2(-frame_a.R.T[2,3], frame_a.R.T[3,3]);     
  
  r_geom_0 = frame_a.r_0 + Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, -ship_CM);
  interpolationBlock.HeaveInput = r_geom_0[3];
  interpolationBlock.RollInput = abs(shipAngles[1]);
  interpolationBlock.PitchInput = shipAngles[2];

// Buoyancy data: depends only on vessel shape
  if useComplexShape then
    if not interpolationBlock.rangeFlagOut then
      funcSubVolume = interpolationBlock.DVOutput;
      rb_cm_0 = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, {interpolationBlock.XcobOutput, if shipAngles[1] > 0 then -interpolationBlock.YcobOutput else interpolationBlock.YcobOutput, 0});
      funcCoB = {r_geom_0[1] + rb_cm_0[1], r_geom_0[2] + rb_cm_0[2], interpolationBlock.ZcobOutput};
      totalVolume = 0;
      subPercentage = 0;
    else
      rb_cm_0 = {0,0,0};
      if zeroOnFailback then
        totalVolume = 0;
        funcSubVolume = 0;
        subPercentage = 0;
        funcCoB = {0, 0, 0};
      else
      (totalVolume, funcSubVolume, subPercentage, funcCoB[1], funcCoB[2], funcCoB[3]) = Functions.getSubmergedPropertiesFromWave(shapePath_abs, wavePath_abs, time, time_step, frame_a.r_0[1], frame_a.r_0[2], frame_a.r_0[3], frame_a.R.T, outFlag, output_folder_abs);
      end if;
    end if;

    h = 0;
    keelZPos = frame_a.r_0[3] + dist_keel_cg;
    submergedDepth = max(0, keelZPos);
    vDepth = der(keelZPos);
    displacedVolume = funcSubVolume;
    auxCoBZ = funcCoB[3];
    CoBZ = auxCoBZ;

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
    Documentation(info = "<html><head>
</head>
<body>
<h1>Buoyancy Interpolation with Failback Model</h1>

<p>
  The <em>BuoyancyInterpolationWithFailback</em> model calculates the hydrostatic restoring forces and moments acting on a vessel. 
  It combines the extreme computational efficiency of a surrogate model (interpolation) with the robust accuracy of a direct 3D mesh solver, ensuring the simulation maintains stability during extreme maneuvers.
</p>

<h2>Description</h2>

<p>
  To achieve real-time performance, hydrodynamic simulations often rely on pre-computed interpolation tables for buoyancy. However, if the vessel experiences severe motions (e.g., extreme roll from a wave impact) that push it outside the bounds of the pre-computed data, interpolation can fail or yield unphysical results. 
</p>
<p>
  This block solves that problem using a <strong>failback mechanism</strong>. It continuously monitors the <code>rangeFlagOut</code> from the interpolation block. If the vessel's heave, roll, or pitch stays within the mapped bounds, it uses the instant interpolation data. The moment the vessel exceeds these bounds, the model automatically triggers a failback protocol. Depending on the user's configuration, it will either switch to a exact 3D boolean intersection solver, or safely output zero buoyancy to prevent solver crashes during specific debugging scenarios.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the BuoyancyInterpolationWithFailback block</caption>
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
      <td>Set to true to use the hybrid 3D interpolation/mesh mode; false to use the simple spherical approximation.</td>
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
      <td>File paths for the vessel's 3D STL model and the wave sequence (required for the failback solver).</td>
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
      <td><strong>zeroOnFailback</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>If true, the model outputs zero volume and forces when out of bounds instead of calling the 3D mesh solver.</td>
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

<h2>Internal Components &amp; Variables</h2>

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
      <td>Sub-model that interpolates volumetric data and outputs a <code>rangeFlagOut</code> if inputs exceed mapped bounds.</td>
    </tr>
    <tr>
      <td><em>funcSubVolume</em></td>
      <td>Volume</td>
      <td>m³</td>
      <td>Submerged volume, sourced either from interpolation, the exact mesh solver, or forced to zero.</td>
    </tr>
    <tr>
      <td><em>funcCoB</em></td>
      <td>Position[3]</td>
      <td>m</td>
      <td>Center of Buoyancy coordinates, sourced dynamically depending on the active solver.</td>
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
  The model computes the buoyancy force vector and the resulting torque using a conditional execution path:
</p>

<ul>
  <li><strong>State Extraction:</strong> The vessel's Heave, Roll, and Pitch are extracted from <code>frame_a</code> and sent to the <code>interpolationBlock</code>.</li>
  <li><strong>Failback Logic (The Core Feature):</strong> 
    <ul>
      <li>If <code>interpolationBlock.rangeFlagOut</code> is <strong>false</strong> (Safe Zone): The model reads <code>DVOutput</code> and the centroid coordinates directly from the fast interpolation table.</li>
      <li>If <code>interpolationBlock.rangeFlagOut</code> is <strong>true</strong> (Out of Bounds): The model ignores the interpolation and evaluates the <code>zeroOnFailback</code> flag. 
        <ul>
            <li>If <code>zeroOnFailback</code> is <strong>true</strong>, it forces the submerged volume and centroid to zero, effectively neutralizing buoyancy.</li>
            <li>If <code>zeroOnFailback</code> is <strong>false</strong>, it triggers <code>Functions.getSubmergedPropertiesFromWave</code> to perform an exact 3D calculation between the STL hull and the flat wave plane based on the exact 6-DOF transform matrix.</li>
        </ul>
      </li>
    </ul>
  </li>
  <li><strong>Force and Torque Generation:</strong> Regardless of the data source, the total vertical force combines the displaced fluid weight with heave damping. The stabilizing righting moment is calculated using the cross product of the COB offset and the buoyancy force vector.</li>
  <li><strong>Application:</strong> The resulting loads are applied to the <code>frame_a</code> mechanical connector to drive the multi-body dynamics.</li></ul>


</body></html>"));
end BuoyancyInterpolationWithFailback;

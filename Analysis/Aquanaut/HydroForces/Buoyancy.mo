within Aquanaut.HydroForces;

model Buoyancy
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
  Modelica.Units.SI.Distance CoBZ;
  Modelica.Units.SI.Distance auxCoBZ;
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
    
protected
  outer Aquanaut.HydroForces.Stream Stream;
  
  Integer outFlag(start=0);
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

// Buoyancy data: depends only on vessel shape
  if useComplexShape then

    (totalVolume, funcSubVolume, subPercentage, funcCoB[1], funcCoB[2], funcCoB[3]) = Functions.getSubmergedPropertiesFromWave(shapePath_abs, wavePath_abs, time, time_step, frame_a.r_0[1], frame_a.r_0[2], frame_a.r_0[3], frame_a.R.T, outFlag, output_folder_abs);
    
    h = 0;
        
    keelZPos = frame_a.r_0[3] + dist_keel_cg;
    
    submergedDepth = max(0,keelZPos);
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
    funcSubVolume = 0;
    subPercentage = 0;
    funcCoB = {0,0,0};
    
    keelZPos = frame_a.r_0[3] + sphereRadius;
    submergedDepth = max(0,keelZPos);
    vDepth = der(keelZPos);
    h = max(0,min(submergedDepth,2*sphereRadius));
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
  //zeros(3) = frame_a.f + fBuoy*disableFT;
  zeros(3) = frame_a.f + Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, fBuoy)*disableFT;
  zeros(3) = frame_a.t + Modelica.Mechanics.MultiBody.Frames.resolve2(frame_a.R, tauBuoy)*disableFT;
  annotation(
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {0, -17}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-3, 39}, {3, -39}}), Ellipse(origin = {0, -60}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-16, 16}, {16, -16}}), Line(origin = {2.03, -30.3}, points = {{-90.0305, -9.70056}, {-56.0305, 8.29944}, {-30.0305, -9.70056}, {3.96953, 8.29944}, {39.9695, -9.70056}, {67.9695, 10.2994}, {89.9695, -9.70056}}, color = {85, 170, 255}, thickness = 4.25, smooth = Smooth.Bezier), Polygon(origin = {0, 38}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}}), Text(textColor = {85, 85, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name", textStyle = {TextStyle.Bold})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Buoyancy Force Model</h1>

<p>
  The <em>Buoyancy</em> model calculates the hydrostatic restoring forces and moments acting on a vessel based on its immersion state in the fluid. 
  This component is essential for simulating static and dynamic stability in 6 Degrees of Freedom (6-DOF), following the hydrostatic principles detailed by Fossen (2011).
</p>

<h2>Description</h2>

<p>
  According to Archimedes' Principle, buoyancy is a vertical force that opposes the weight of a submerged or floating object. 
  This block models this interaction by considering the fluid density (provided by a global Stream object), gravitational acceleration, and the displaced volume of the hull.
  The model supports two modes of operation: a simplified spherical approximation, and a complex 3D shape evaluation that calculates precise volumetric properties by interacting with dynamic wave files.
  In addition to the vertical force, the block calculates the restoring moments resulting from the misalignment between the Center of Gravity (<em>CG</em>) and the Center of Buoyancy (<em>COB</em>), ensuring the vessel returns to its equilibrium position (metacentric stability).
</p>

<h2>Parameters</h2>

      <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Buoyancy block</caption>
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
      <td>-</td><td>True if using a 3D mesh model; false for spherical approximation.</td>
    </tr>
    <tr>
      <td><strong>Cb</strong></td>
      <td>DampingCoefficient</td>
      <td>N.s/m</td>
      <td>Vertical hydrodynamic damping coefficient (heave damping).</td>
    </tr>
    <tr>
      <td><strong>maxDepth</strong></td>
      <td>Distance</td>
      <td>m</td>
      <td>Maximum depth used as a safety constraint for the simulation.</td>
    </tr>
    <tr>
      <td><strong>sphereRadius</strong></td>
      <td>Radius</td>
      <td>m</td>
      <td>Radius used when <code>useComplexShape == false</code>.</td>
    </tr>
	<tr>
      <td><strong>shapePath</strong></td>
      <td>String</td>
      <td>-</td>
      <td>File path of the vessel's 3D model (used when <code>useComplexShape == true</code>).</td>
    </tr>
    <tr>
      <td><strong>wavePath</strong></td>
      <td>String</td>
      <td>-</td>
      <td>File path of the wave 3D model.</td>
    </tr>
    <tr>
      <td><strong>output_folder</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Directory path for exporting complex shape evaluation files.</td>
    </tr>
    <tr>
      <td><strong>dist_keel_cg</strong></td>
      <td>Distance</td>
      <td>m</td>
      <td>Vertical distance from the keel to the center of gravity (KG).</td>
    </tr>
    <tr>
      <td><strong>time_step</strong></td>
      <td>Real</td>
      <td>s</td>
      <td>Wave file time step for the complex shape evaluation.</td>
    </tr>
    <tr>
      <td><strong>outputEnable</strong></td>
      <td>Boolean</td>
      <td>-</td>
      <td>File output flag. True: Enable output. False: Disable output.</td>
    </tr>
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Connectors and global objects of the Buoyancy block</caption>
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
      <td>Global object providing fluid properties such as <code>fluidDensity</code>.</td>
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
      <td><em>depth</em></td>
      <td>Distance</td>
      <td>m</td>
      <td>Calculated immersion depth of the center of the body.</td>
    </tr>
	<tr>
      <td><em>vDepth</em></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Vertical velocity of the immersion depth.</td>
    </tr>
    <tr>
      <td><em>displacedVolume</em></td>
      <td>Volume</td>
      <td>m&sup3;</td>
      <td>Submerged volume calculated based on geometry and depth.</td>
    </tr>
	<tr>
      <td><em>displacedMass</em></td>
      <td>Mass</td>
      <td>kg</td>
      <td>Mass of the displaced fluid (uses Stream.fluidDensity).</td>
    </tr>
    <tr>
      <td><em>displacedWeight</em></td>
      <td>Weight</td>
      <td>N</td>
      <td>Gravitational weight of the displaced fluid.</td>
    </tr>
	<tr>
      <td><em>total_volume</em></td>
      <td>Real</td>
      <td>m&sup3;</td>
      <td>Total Volume returned by the 3D complex shape function.</td>
    </tr>
	<tr>
      <td><em>submerged_volume</em></td>
      <td>Real</td>
      <td>m&sup3;</td>
      <td>Underwater Volume returned by the 3D complex shape function.</td>
    </tr>
    <tr>
      <td><em>percentage</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Percentage of submerged volume returned by the 3D complex shape function.</td>
    </tr>
    <tr>
      <td><em>rBuoy</em></td>
      <td>Position[3]</td>
      <td>m</td>
      <td>Position of the Center of Buoyancy in the world (global) frame.</td>
    </tr>
	<tr>
      <td><em>center_of_buoyancy</em></td>
      <td>Real[3]</td>
      <td>m</td>
      <td>Underwater Centroid returned by the 3D complex shape function.</td>
    </tr>
    <tr>
      <td><em>fBuoy</em></td>
      <td>Force[3]</td>
      <td>N</td>
      <td>Resolved buoyancy force vector in the world frame.</td>
    </tr>
    <tr>
      <td><em>tauBuoy</em></td>
      <td>Torque[3]</td>
      <td>N.m</td>
      <td>Restoring moment vector relative to the frame origin.</td>
    </tr>
	<tr>
      <td><em>e_n_0</em></td>
      <td>Real[3]</td>
      <td>-</td>
      <td>Buoyancy direction resolved in world frame ({0, 0, 1}).</td>
    </tr>
	<tr>
      <td><em>CoBZ</em></td>
      <td>Distance</td>
      <td>m</td>
      <td>Z-coordinate of the Center of Buoyancy (saturated to maxDepth).</td>
    </tr>
    <tr>
      <td><em>auxCoBZ</em></td>
      <td>Distance</td>
      <td>m</td>
      <td>Auxiliary unbounded Z-coordinate for the Center of Buoyancy.</td>
    </tr>
	<tr>
      <td><em>outFlag</em></td>
      <td>Integer</td>
      <td>-</td>
      <td>Protected integer flag (0 or 1) converted from <code>outputEnable</code> for the external function.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model computes the buoyancy force vector <em>f<sub>b</sub></em> and the resulting torque <em>&tau;<sub>b</sub></em> applied to the connector, contributing to the restoring vector <em>g(&eta;)</em>. The calculation method depends on the chosen shape mode:
</p>

<ul>
  <li><strong>Force Calculation:</strong> The fluid density is acquired from the outer <code>Stream</code> model. The vertical force includes the weight of the displaced fluid and a damping term for heave motions: <em>f<sub>b</sub></em> = -(<em>W<sub>displaced</sub></em> + <em>v<sub>z</sub></em> &middot; <em>C<sub>b</sub></em>) &middot; <em>e<sub>z</sub></em>.</li>
  
  <li><strong>Torque Generation:</strong> The restoring moment is generated by the offset between the frame origin and the resolved Center of Buoyancy: <em>&tau;<sub>b</sub></em> = (<em>r<sub>buoy</sub></em> - <em>r<sub>frame</sub></em>) &times; <em>f<sub>b</sub></em>.</li>
  
  <li><strong>Static Stability:</strong> For small inclinations, the restoring force is proportional to the metacentric height (<em>GM</em>). The model ensures that for a stable vessel, the <em>COB</em> shifts to create a righting arm (<em>GZ</em>).</li>
  
  <li><strong>Volume Approximation:</strong> For spherical geometry, the submerged volume is calculated as: <em>V</em> = (π · <em>h</em><sup>2</sup> · (3<em>R</em> - <em>h</em>)) / 3, where <em>h</em> is the immersion depth.</li>

  <li><strong>Complex Shape Mode (useComplexShape = true):</strong> The model calls the external function <code>Functions.getSubmergedPropertiesFromWave</code>, passing the 3D mesh paths (<code>shapePath</code>, <code>wavePath</code>), output preferences, and current 6-DOF kinematics. The function returns precise volumetric properties and the 3D Center of Buoyancy (<em>center_of_buoyancy</em>). The <em>depth</em> is calculated using the vertical position offset by <code>dist_keel_cg</code>.</li>
  
  <li><strong>Simple Shape Mode (useComplexShape = false):</strong> The submerged volume is analytically approximated using a spherical geometry formula: <em>V</em> = (&pi; &middot; <em>h</em><sup>2</sup> &middot; (3<em>R</em> - <em>h</em>)) / 3, where <em>h</em> is the immersion depth and <em>R</em> is the <code>sphereRadius</code>. The Z-coordinate of the Center of Buoyancy is derived analytically.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the HydroForces package within the Aquanaut library and is based on the formulation by Fossen (2011).</em>
</p>


</body>
</html>"));
end Buoyancy;

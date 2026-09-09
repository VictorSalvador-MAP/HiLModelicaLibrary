within Aquanaut.Utils;

model verifySubmergeFunction
  extends Modelica.Icons.Example;

  parameter String shapePath = "modelica://Aquanaut/Resources/STL/sphereRef1cm.stl" "File path of vessel 3D model";
  final parameter String shapePath_abs = if shapePath <> "" then Modelica.Utilities.Files.loadResource(shapePath) else "";
  parameter String wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_" "File path of wave 3D model";
  final parameter String wavePath_abs = if wavePath <> "" then Modelica.Utilities.Files.loadResource(wavePath) else "";
  parameter String output_folder = "modelica://Aquanaut/Resources/STL/";
  final parameter String output_folder_abs = if output_folder <> "" then Modelica.Utilities.Files.loadResource(output_folder) else "";
  parameter Real time_step = 3 "Wave file time step [s]";
  parameter Integer outFlag = 0;
  
  Real totalVolume "Total volume";
  Real funcSubVolume "Underwater volume";
  Real subPercentage "Submerged volume percentage [%]";
  Real funcCoB[3] "Underwater centroid";
  
  Modelica.Units.SI.Volume finalVolumeTotal;
  Modelica.Units.SI.Volume finalVolumeSub;

  Real position[3] = {0,0,0}; // x, y, z
  Real R[3,3] = {{1,0,0},{0,1,0},{0,0,1}};


equation
  (totalVolume, funcSubVolume, subPercentage, funcCoB[1], funcCoB[2], funcCoB[3]) = Functions.getSubmergedPropertiesFromWave(shapePath_abs, wavePath_abs, time, time_step, position[1], position[2], position[3], R, outFlag, output_folder_abs);

  totalVolume = finalVolumeTotal * 1000000000;
  funcSubVolume = finalVolumeSub * 1000000000;
  
annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
  Documentation(info = "<html>
<head>
</head>
<body>
<h1>Verify Submerge Function Example</h1>

<p>
  The <em>verifySubmergeFunction</em> model is a standalone unit test designed to isolate and validate the external C-based intersection solver (<code>Functions.getSubmergedPropertiesFromWave</code>). 
  It bypasses the complex multi-body dynamics of the <em>Hull</em> and <em>Buoyancy</em> blocks to directly evaluate the volumetric outputs of a 3D STL mesh interacting with a wave surface.
</p>

<h2>Description</h2>

<p>
  This utility is crucial for debugging mesh geometries and verifying the external hydrodynamics library. 
  It forces the vessel into a static, centralized position (origin 0,0,0 with no rotation) and directly calls the external C-function. 
  A key feature of this model is its handling of file paths: it explicitly resolves <code>modelica://</code> URIs into absolute operating system paths, which is a strict requirement when passing file locations to external C or C++ binaries.
  Furthermore, it handles specific volumetric unit conversions to map the raw solver output into standard SI units.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters and Path Resolvers</caption>
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
      <td><strong>shapePath</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Modelica URI path to the 3D hull mesh (default: <code>sphereRef1cm.stl</code>).</td>
    </tr>
    <tr>
      <td><strong>shapePath_abs</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Final resolved absolute OS path of the 3D hull mesh (Required for C-function).</td>
    </tr>
    <tr>
      <td><strong>wavePath</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Modelica URI path to the 3D wave model sequence.</td>
    </tr>
    <tr>
      <td><strong>wavePath_abs</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Final resolved absolute OS path of the wave sequence.</td>
    </tr>
    <tr>
      <td><strong>output_folder</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Directory path for exporting diagnostic intersection meshes.</td>
    </tr>
    <tr>
      <td><strong>output_folder_abs</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Final resolved absolute OS path for the output directory.</td>
    </tr>
    <tr>
      <td><strong>time_step</strong></td>
      <td>Real</td>
      <td>s</td>
      <td>Time step interval to iterate through the wave files (default: 3).</td>
    </tr>
    <tr>
      <td><strong>outFlag</strong></td>
      <td>Integer</td>
      <td>-</td>
      <td>Flag to enable (1) or disable (0) the generation of export files.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Variables</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Kinematic states and volumetric outputs</caption>
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
      <td><em>position</em></td>
      <td>Real[3]</td>
      <td>m</td>
      <td>Static position vector forced to {0, 0, 0} for the test.</td>
    </tr>
    <tr>
      <td><em>R</em></td>
      <td>Real[3,3]</td>
      <td>-</td>
      <td>Static identity rotation matrix (no tilt or yaw).</td>
    </tr>
    <tr>
      <td><em>totalVolume</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Raw total volume returned directly by the external C-function.</td>
    </tr>
    <tr>
      <td><em>funcSubVolume</em></td>
      <td>Real</td>
      <td>-</td>
      <td>Raw submerged volume returned directly by the external C-function.</td>
    </tr>
    <tr>
      <td><em>subPercentage</em></td>
      <td>Real</td>
      <td>%</td>
      <td>Percentage of the hull currently submerged.</td>
    </tr>
    <tr>
      <td><em>funcCoB</em></td>
      <td>Real[3]</td>
      <td>-</td>
      <td>Raw coordinates of the Center of Buoyancy returned by the solver.</td>
    </tr>
    <tr>
      <td><em>finalVolumeTotal</em></td>
      <td>Volume</td>
      <td>m&sup3;</td>
      <td>Converted SI total volume.</td>
    </tr>
    <tr>
      <td><em>finalVolumeSub</em></td>
      <td>Volume</td>
      <td>m&sup3;</td>
      <td>Converted SI submerged volume.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The logic of this verification block is straightforward and execution-focused:
</p>

<ul>
  <li><strong>URI Resolution:</strong> The block uses <code>Modelica.Utilities.Files.loadResource()</code> to convert the portable <code>modelica://Aquanaut/...</code> URIs into absolute system paths (e.g., <code>C:/...</code> or <code>/usr/local/...</code>). This prevents file-not-found errors in the external C binary.</li>
  <li><strong>Function Call:</strong> The <code>Functions.getSubmergedPropertiesFromWave</code> is called directly in the equation section using the static identity matrix <code>R</code> and zeroed <code>position</code>.</li>
  <li><strong>Unit Conversion:</strong> The raw volumetric variables (<code>totalVolume</code>, <code>funcSubVolume</code>) are equated to the SI variables (<code>finalVolumeTotal</code>, <code>finalVolumeSub</code>) multiplied by a factor of <em>10<sup>9</sup></em>. This scaling corrects dimensional discrepancies between the 3D mesh scale (likely modeled in millimeters, resulting in cubic millimeters) and the Modelica standard SI base unit (cubic meters).</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the Utils package within the Aquanaut library and runs a fast 1-second simulation strictly for data validation.</em>
</p>

</body>
</html>"));
end verifySubmergeFunction;

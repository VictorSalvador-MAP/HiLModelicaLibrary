within Aquanaut.Functions;

function getSubmergedPropertiesFromWave
  extends Modelica.Icons.Function;

  // Inputs
  input String hull_file;
  input String wave_file;
  input Real simulation_time;
  input Real time_step;
  input Real pos_x;
  input Real pos_y;
  input Real pos_z;
  input Real R[3,3];
  input Integer export_files;
  input String export_directory;

  // Outputs
  output Real total_volume;
  output Real submerged_volume;
  output Real percentage;
  output Real cob_x;
  output Real cob_y;
  output Real cob_z;
  
  external "C" GetSubmergedPropertiesFromWave(
    hull_file,
    wave_file,
    simulation_time,
    time_step,
    pos_x,
    pos_y,
    pos_z,
    R,
    total_volume,
    submerged_volume,
    percentage,
    cob_x,
    cob_y,
    cob_z,
    export_files,
    export_directory) annotation(
    Library="hydrodynamics_lib",
    Documentation(revisions = "<html><head></head><body><br></body></html>"));

annotation(
    Documentation(info = "<html><head>
</head>
<body>
<h1>Submerged Properties from Wave Function</h1>

<p>
  The <em>getSubmergedPropertiesFromWave</em> function calculates the real-time hydrostatic properties of a vessel interacting with a dynamic wave environment. 
  It determines the submerged volume and the exact position of the Center of Buoyancy (COB) based on the intersection of the 3D hull mesh and the wave surface.
</p>

<h2>Description</h2>

<p>
  This function serves as an interface to an external C library (<code>hydrodynamics_lib</code>). 
  Instead of relying on simplified geometric formulas (like a sphere or box), it passes the vessel's current 6-DOF state (position and rotation matrix) and 3D mesh data to the external solver. 
  The solver computes the complex boolean intersection between the hull and the instantaneous wave elevation, returning the necessary volumetric data to compute accurate buoyancy and restoring moments in rough seas.
</p>

<h2>Inputs</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Input arguments of the function</caption>
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
      <td><strong>hull_file</strong></td>
      <td>String</td>
      <td>-</td>
      <td>File path to the 3D mesh model of the vessel's hull.</td>
    </tr>
    <tr>
      <td><strong>wave_file</strong></td>
      <td>String</td>
      <td>-</td>
      <td>File path to the wave definition data or spectrum parameters.</td>
    </tr>
    <tr>
      <td><strong>simulation_time</strong></td>
      <td>Real</td>
      <td>s</td>
      <td>Current absolute time in the simulation.</td>
    </tr>
    <tr>
      <td><strong>time_step</strong></td>
      <td>Real</td>
      <td>s</td>
      <td>Time step interval used for the calculations.</td>
    </tr>
    <tr>
      <td><strong>pos_x</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Absolute position of the hull in the X-axis (World Frame).</td>
    </tr>
    <tr>
      <td><strong>pos_y</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Absolute position of the hull in the Y-axis (World Frame).</td>
    </tr>
    <tr>
      <td><strong>pos_z</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Absolute position of the hull in the Z-axis (World Frame).</td>
    </tr>
    <tr>
      <td><strong>R</strong></td>
      <td>Real[3,3]</td>
      <td>-</td>
      <td>Rotation matrix defining the current orientation of the vessel.</td>
    </tr>
    <tr>
      <td><strong>export_files</strong></td>
      <td>Integer</td>
      <td>-</td>
      <td>Flag (e.g., 0 or 1) to enable the export of generated mesh/wave data for visualization or debugging.</td>
    </tr>
    <tr>
      <td><strong>export_directory</strong></td>
      <td>String</td>
      <td>-</td>
      <td>Directory path where the exported files will be saved.</td>
    </tr>
  </tbody>
</table>

<h2>Outputs</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Returned values</caption>
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
      <td><strong>total_volume</strong></td>
      <td>Real</td>
      <td>m³</td>
      <td>Calculated total internal volume of the complete hull mesh.</td>
    </tr>
    <tr>
      <td><strong>submerged_volume</strong></td>
      <td>Real</td>
      <td>m³</td>
      <td>Volume of the hull that is currently under the wave surface.</td>
    </tr>
    <tr>
      <td><strong>percentage</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Ratio of submerged volume to total volume (0.0 to 100.0).</td>
    </tr>
    <tr>
      <td><strong>cob_x</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Calculated X-coordinate of the Center of Buoyancy.</td>
    </tr>
    <tr>
      <td><strong>cob_y</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Calculated Y-coordinate of the Center of Buoyancy.</td>
    </tr>
    <tr>
      <td><strong>cob_z</strong></td>
      <td>Real</td>
      <td>m</td>
      <td>Calculated Z-coordinate of the Center of Buoyancy.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Computational Logic</h2>

<p>
  The calculation is delegated to the external <code>GetSubmergedPropertiesFromWave</code> function via the Modelica external C interface:
</p>

<ul>
  <li><strong>Mesh Processing:</strong> The external solver loads the hull geometry (<code>hull_file</code>) and transforms it into the world space using the translation vector (<code>pos_x</code>, <code>pos_y</code>, <code>pos_z</code>) and the rotation matrix (<code>R</code>).</li>
  <li><strong>Wave Interaction:</strong> The wave elevation field is generated based on the <code>wave_file</code> and the current <code>simulation_time</code>.</li>
  <li><strong>Integration:</strong> The solver computes the boolean intersection of the hull and the water domain. It then integrates over the submerged volume to find the geometric centroid, which physically corresponds to the Center of Buoyancy (COB).</li>
  <li><strong>Feedback:</strong> These precise volumetric properties can be utilized by components like <em>Buoyancy</em> to compute accurate Froude-Krylov forces and restoring moments under nonlinear wave conditions.</li>
</ul>

<hr>
<p>
  <em>Note: This function belongs to the Functions package within the Aquanaut library and depends on the compiled <code>hydrodynamics_lib</code> external binary.</em>
</p>


</body></html>"));
end getSubmergedPropertiesFromWave;

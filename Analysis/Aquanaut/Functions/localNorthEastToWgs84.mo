within Aquanaut.Functions;

function localNorthEastToWgs84
  extends Modelica.Icons.Function;

  input Real originLatitudeDeg(unit = "deg");
  input Real originLongitudeDeg(unit = "deg");
  input Real northM(unit = "m");
  input Real eastM(unit = "m");

  output Real latitudeDeg(unit = "deg");
  output Real longitudeDeg(unit = "deg");

  external "C" wgs84_direct_from_north_east(
    originLatitudeDeg,
    originLongitudeDeg,
    northM,
    eastM,
    latitudeDeg,
    longitudeDeg)
    annotation(
      Include = "#include \"wgs84_geodesic_wrapper.h\"",
      IncludeDirectory = "modelica://Aquanaut/Resources/Include",
      Library = {"wgs84_geodesic_wrapper", "Geographic", "stdc++"},
      LibraryDirectory = "modelica://Aquanaut/Resources/Library/linux64");        annotation(
    Documentation(info = "<html><head>
                    </head>
                    <body>
                    <h1>Local North-East to WGS84 Geodetic Converter</h1>
                    
                    <p>
                      The <em>localNorthEastToWgs84</em> function converts local planar Cartesian displacements (North and East positions in meters) relative to a reference origin into absolute WGS84 geodetic coordinates (Latitude and Longitude in degrees).
                    </p>
                    
                    <h2>Description</h2>
                    
                    <p>
                      This function performs a direct geodesic transformation from a local tangent frame to global geodetic coordinates. It relies on an external C wrapper interface (<code>wgs84_direct_from_north_east</code>), which links directly to the high-precision <strong>GeographicLib</strong> library. 
                    </p>
                    <p>
                      By taking a known geographic origin point alongside local North and East spatial offsets, it calculates precise geographic coordinates, taking into account the curvature of the WGS84 reference ellipsoid.
                    </p>
                    
                    <h2>Parameters</h2>
                    
                    <p><em>Note: As a standalone function, this component operates strictly with input and output arguments rather than configurable block parameters.</em></p>

                    <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
                      <caption align=\"bottom\"><strong>Tab. 1:</strong> Function Input Arguments</caption>
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
                          <td><strong>originLatitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Geodetic latitude coordinate of the local reference origin.</td>
                        </tr>
                        <tr>
                          <td><strong>originLongitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Geodetic longitude coordinate of the local reference origin.</td>
                        </tr>
                        <tr>
                          <td><strong>northM</strong></td>
                          <td>Real</td>
                          <td>m</td>
                          <td>Local displacement along the North direction relative to origin.</td>
                        </tr>
                        <tr>
                          <td><strong>eastM</strong></td>
                          <td>Real</td>
                          <td>m</td>
                          <td>Local displacement along the East direction relative to origin.</td>
                        </tr>
                      </tbody>
                    </table>

                    <br/>

                    <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
                      <caption align=\"bottom\"><strong>Tab. 2:</strong> Function Output Arguments</caption>
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
                          <td><strong>latitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Resulting absolute WGS84 latitude coordinate.</td>
                        </tr>
                        <tr>
                          <td><strong>longitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Resulting absolute WGS84 longitude coordinate.</td>
                        </tr>
                      </tbody>
                    </table>
                    
                    <h2>Key Internal Sub-components</h2>
                    
                    <p>
                      This component does not instantiate internal Modelica blocks. It interfaces directly with external dynamically linked dynamic C libraries:
                    </p>
                    <ul>
                      <li><strong>wgs84_geodesic_wrapper:</strong> C-wrapper header and implementation (<code>wgs84_geodesic_wrapper.h</code>) bridging Modelica to native C++ calls.</li>
                      <li><strong>Geographic / stdc++:</strong> External static/shared libraries providing high-accuracy ellipsoid spatial transformation algorithms.</li>
                    </ul>
                    
                    <h2>System Operation and Interconnections</h2>
                    
                    <p>
                      The execution flow for this function follows a stateless C-interface invocation pattern:
                    </p>
                    <ul>
                      <li><strong>Argument Passing:</strong> Receives local planar position vectors (<code>northM</code>, <code>eastM</code>) along with origin datum anchors (<code>originLatitudeDeg</code>, <code>originLongitudeDeg</code>).</li>
                      <li><strong>External C Routine Execution:</strong> Calls <code>wgs84_direct_from_north_east()</code> natively, leveraging external geodesic routines compiled for <code>linux64</code> target environments.</li>
                      <li><strong>Global Coordinate Generation:</strong> Instantly evaluates exact geographic position pairs (<code>latitudeDeg</code>, <code>longitudeDeg</code>) and returns them to caller models for tracking, mapping, or visualization.</li>
                    </ul>
                    
                    </body></html>"));

end localNorthEastToWgs84;
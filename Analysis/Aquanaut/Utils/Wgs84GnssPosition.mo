within Aquanaut.Utils;

block Wgs84GnssPosition
  parameter Real originLatitudeDeg(unit = "deg") = 0;
  parameter Real originLongitudeDeg(unit = "deg") = 0;

  Modelica.Blocks.Interfaces.RealInput northM(unit = "m")
    annotation(Placement(
      transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput eastM(unit = "m")
    annotation(Placement(
      transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput latitudeDeg(unit = "deg")
    annotation(Placement(
      transformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput longitudeDeg(unit = "deg")
    annotation(Placement(
      transformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}})));

public
equation
  (latitudeDeg, longitudeDeg) = Aquanaut.Functions.localNorthEastToWgs84(
    originLatitudeDeg,
    originLongitudeDeg,
    northM,
    eastM);
    
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(lineColor = {0, 75, 140}, fillColor = {225, 240, 250}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, -46}, extent = {{-84, 72}, {84, 32}}, textString = "WGS84 Converter
North/East
to Lat/Lon"), Text(extent = {{-84, -26}, {84, -60}}, textString = ""), Text(extent = {{42, 56}, {96, 26}}, textString = "Lat [deg]", horizontalAlignment = TextAlignment.Right), Text(origin = {-2, 0},extent = {{42, -26}, {96, -56}}, textString = "Lon [deg]", horizontalAlignment = TextAlignment.Right), Text(origin = {-124, 22},extent = {{26, 26}, {60, 12}}, textString = "N [m]", horizontalAlignment = TextAlignment.Right), Text(origin = {-122, -58}, extent = {{26, 26}, {60, 12}}, textString = "E [m]", horizontalAlignment = TextAlignment.Right)}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(extent = {{-90, 88}, {90, 58}}, textString = "WGS84 geodesic conversion")}),
  Documentation(info = "<html><head>
                    </head>
                    <body>
                    <h1>WGS84 GNSS Position Block</h1>
                    
                    <p>
                      The <em>Wgs84GnssPosition</em> block converts local planar North and East Cartesian displacement signals into absolute WGS84 geographic coordinates (Latitude and Longitude) using a configured reference origin point.
                    </p>
                    
                    <h2>Description</h2>
                    
                    <p>
                      This continuous-time utility block acts as a interface wrapper that exposes the spatial transformations provided by the <code>Aquanaut.Functions.localNorthEastToWgs84</code> function into standard Modelica block-diagram workflows.
                    </p>
                    <p>
                      It continuously ingests real-time North (<code>northM</code>) and East (<code>eastM</code>) position offset signals measured in meters. By combining these offsets with user-configurable datum parameters (<code>originLatitudeDeg</code> and <code>originLongitudeDeg</code>), it computes and outputs corresponding geographic latitude and longitude coordinates in degrees.
                    </p>
                    
                    <h2>Parameters</h2>
                    
                    <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
                      <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Wgs84GnssPosition block</caption>
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
                          <td>Geodetic latitude coordinate of the local spatial reference origin.</td>
                        </tr>
                        <tr>
                          <td><strong>originLongitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Geodetic longitude coordinate of the local spatial reference origin.</td>
                        </tr>
                      </tbody>
                    </table>
                    
                    <h2>Key Internal Sub-components</h2>
                    
                    <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
                      <caption align=\"bottom\"><strong>Tab. 2:</strong> Primary internal function and interface dependencies</caption>
                      <thead>
                        <tr bgcolor=\"#f2f2f2\">
                          <th>Instance / Reference Name</th>
                          <th>Model Class Type</th>
                          <th>Primary Functional Duty</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td><strong>localNorthEastToWgs84</strong></td>
                          <td>Aquanaut.Functions.localNorthEastToWgs84</td>
                          <td>Executes underlying external geodesic C-library transformation algorithms.</td>
                        </tr>
                        <tr>
                          <td><strong>northM, eastM</strong></td>
                          <td>Modelica.Blocks.Interfaces.RealInput</td>
                          <td>Input signal ports for local Cartesian spatial coordinates (meters).</td>
                        </tr>
                        <tr>
                          <td><strong>latitudeDeg, longitudeDeg</strong></td>
                          <td>Modelica.Blocks.Interfaces.RealOutput</td>
                          <td>Output signal ports for absolute WGS84 geodetic coordinates (degrees).</td>
                        </tr>
                      </tbody>
                    </table>
                    
                    <h2>System Operation and Interconnections</h2>
                    
                    <p>
                      The block operates as a continuous algebraic mapping block following these interconnection pathways:
                    </p>
                    <ul>
                      <li><strong>Input Ingestion:</strong> Continuous position inputs <code>northM</code> and <code>eastM</code> are received from vehicle dynamic models, navigation filters, or local tracking estimators.</li>
                      <li><strong>Geodesic Equation Evaluation:</strong> In every continuous calculation step, the block passes the input signal values alongside fixed parameters <code>originLatitudeDeg</code> and <code>originLongitudeDeg</code> to the underlying <code>localNorthEastToWgs84</code> function.</li>
                      <li><strong>Geographic Signal Streaming:</strong> The resulting output signals (<code>latitudeDeg</code> and <code>longitudeDeg</code>) are driven directly to the block's output interfaces for downstream consumption by telemetry systems, display indicators, or map-following routines.</li>
                    </ul>
                    
                    </body></html>"));

end Wgs84GnssPosition;
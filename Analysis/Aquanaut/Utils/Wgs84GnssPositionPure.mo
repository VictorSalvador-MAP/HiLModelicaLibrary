within Aquanaut.Utils;

block Wgs84GnssPositionPure
  "Pure Modelica utility block converting local North/East Cartesian meters to WGS84 Geodetic Lat/Lon degrees"

  // Configurable reference origin geodetic parameters
  parameter Real originLatitudeDeg(unit = "deg") = 0
    "Geodetic latitude coordinate of the local reference origin [deg]";
  parameter Real originLongitudeDeg(unit = "deg") = 0
    "Geodetic longitude coordinate of the local reference origin [deg]";

  // Real Input Ports: Local Cartesian displacements relative to origin
  Modelica.Blocks.Interfaces.RealInput northM(unit = "m")
    "Input signal for local North displacement [m]"
    annotation(Placement(
      transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput eastM(unit = "m")
    "Input signal for local East displacement [m]"
    annotation(Placement(
      transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  // Real Output Ports: Resulting global geodetic coordinates
  Modelica.Blocks.Interfaces.RealOutput latitudeDeg(unit = "deg")
    "Output signal for calculated WGS84 latitude [deg]"
    annotation(Placement(
      transformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput longitudeDeg(unit = "deg")
    "Output signal for calculated WGS84 longitude [deg]"
    annotation(Placement(
      transformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}})));

equation
  // Continuous algebraic system evaluation using pure native Modelica conversion function
  (latitudeDeg, longitudeDeg) =
    Aquanaut.Functions.localNorthEastToWgs84Pure(
      originLatitudeDeg,
      originLongitudeDeg,
      northM,
      eastM);

  annotation(
    Icon(
      coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(
          lineColor = {0, 75, 140},
          fillColor = {225, 240, 250},
          fillPattern = FillPattern.Solid,
          extent = {{-100, 100}, {100, -100}}),

        Text(
          origin = {-4, -52},extent = {{-84, 72}, {84, 32}},
          textString = "WGS84 Local
North/East
to Lat/Lon"),

        Text(
          extent = {{42, 56}, {96, 26}},
          textString = "Lat [deg]",
          horizontalAlignment = TextAlignment.Right),

        Text(
          extent = {{42, -26}, {96, -56}},
          textString = "Lon [deg]",
          horizontalAlignment = TextAlignment.Right),

        Text(
          origin = {-124, 22},
          extent = {{26, 26}, {60, 12}},
          textString = "N [m]",
          horizontalAlignment = TextAlignment.Right),

        Text(
          origin = {-122, -58},
          extent = {{26, 26}, {60, 12}},
          textString = "E [m]",
          horizontalAlignment = TextAlignment.Right)}),

    Documentation(info = "<html>
      <p>Conversão local Norte/Leste para latitude/longitude WGS84,
      implementada integralmente em Modelica.</p>
    </html>", __OpenModelica_infoHeader = "<html><head>
</head>
<body>
<h1>Pure Modelica Local North-East to WGS84 Geodetic Position Block</h1>

<p>
  The <em>Wgs84GnssPositionPure</em> block converts local Cartesian displacements expressed in North and East directions into absolute WGS84 geodetic coordinates, providing Latitude and Longitude in degrees relative to a configurable geographic reference origin.
</p>

<h2>Description</h2>

<p>
  This block provides a <strong>100% native Modelica implementation</strong> for converting local planar North-East coordinates into global WGS84 geodetic coordinates. It is intended to provide a direct interface between simulation models operating in a local Cartesian reference frame and navigation or GNSS-related components requiring geographic Latitude and Longitude.
</p>

<p>
  The geographic reference origin is defined through the configurable parameters <code>originLatitudeDeg</code> and <code>originLongitudeDeg</code>. The input ports <code>northM</code> and <code>eastM</code> represent the local displacement of the simulated object relative to this origin.
</p>

<p>
  The coordinate transformation is continuously evaluated through the <code>Aquanaut.Functions.localNorthEastToWgs84Pure</code> function. This function applies the mathematical representation of the <strong>WGS84 Reference Ellipsoid</strong>, accounting for Earth's oblateness and the variation of the meridional and transverse radii of curvature with latitude.
</p>

<h2>Parameters</h2>

<table border=\"\&quot;1\&quot;\" cellspacing=\"\&quot;0\&quot;\" cellpadding=\"\&quot;2\&quot;\">
  <caption align=\"\&quot;bottom\&quot;\"><strong>Tab. 1:</strong> Block Configuration Parameters</caption>
  <thead>
    <tr bgcolor=\"#ffffff\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Default</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>originLatitudeDeg</strong></td>
      <td>Real</td>
      <td>deg</td>
      <td>0</td>
      <td>Geodetic latitude coordinate defining the origin of the local North-East reference frame.</td>
    </tr>
    <tr>
      <td><strong>originLongitudeDeg</strong></td>
      <td>Real</td>
      <td>deg</td>
      <td>0</td>
      <td>Geodetic longitude coordinate defining the origin of the local North-East reference frame.</td>
    </tr>
  </tbody>
</table>

<br>

<h2>Input Ports</h2>

<table border=\"\&quot;1\&quot;\" cellspacing=\"\&quot;0\&quot;\" cellpadding=\"\&quot;2\&quot;\">
  <caption align=\"\&quot;bottom\&quot;\"><strong>Tab. 2:</strong> Block Input Signals</caption>
  <thead>
    <tr bgcolor=\"#ffffff\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>northM</strong></td>
      <td>RealInput</td>
      <td>m</td>
      <td>Local Cartesian displacement in the North direction relative to the configured geographic origin.</td>
    </tr>
    <tr>
      <td><strong>eastM</strong></td>
      <td>RealInput</td>
      <td>m</td>
      <td>Local Cartesian displacement in the East direction relative to the configured geographic origin.</td>
    </tr>
  </tbody>
</table>

<br>

<h2>Output Ports</h2>

<table border=\"\&quot;1\&quot;\" cellspacing=\"\&quot;0\&quot;\" cellpadding=\"\&quot;2\&quot;\">
  <caption align=\"\&quot;bottom\&quot;\"><strong>Tab. 3:</strong> Block Output Signals</caption>
  <thead>
    <tr bgcolor=\"#ffffff\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>latitudeDeg</strong></td>
      <td>RealOutput</td>
      <td>deg</td>
      <td>Calculated absolute WGS84 geodetic latitude.</td>
    </tr>
    <tr>
      <td><strong>longitudeDeg</strong></td>
      <td>RealOutput</td>
      <td>deg</td>
      <td>Calculated absolute WGS84 geodetic longitude.</td>
    </tr>
  </tbody>
</table>

<h2>Key Internal Sub-components</h2>

<p>
  The block does not implement the geodetic transformation equations directly. Instead, it delegates the coordinate conversion to the native Modelica function:
</p>

<ul>
  <li><strong>Aquanaut.Functions.localNorthEastToWgs84Pure:</strong> Pure Modelica coordinate transformation function responsible for converting the local North-East displacement into WGS84 Latitude and Longitude.</li>
</ul>

<p>
  The underlying function uses WGS84 ellipsoid parameters and evaluates the local meridional and prime vertical radii of curvature at the configured reference latitude. No external C/C++ libraries or dynamically linked binaries are required.
</p>

<h2>System Operation and Interconnections</h2>

<p>
  During simulation, the block operates as a continuous algebraic coordinate transformation:
</p>

<ul>
  <li><strong>Reference Origin Definition:</strong> The parameters <code>originLatitudeDeg</code> and <code>originLongitudeDeg</code> establish the fixed geographic origin associated with the local Cartesian coordinate system.</li>
  <li><strong>Local Position Acquisition:</strong> The <code>northM</code> and <code>eastM</code> input ports receive the instantaneous local displacement relative to the configured origin.</li>
  <li><strong>WGS84 Coordinate Transformation:</strong> The input displacements and reference coordinates are passed to <code>localNorthEastToWgs84Pure</code>, which evaluates the corresponding geodetic position on the WGS84 reference ellipsoid.</li>
  <li><strong>Geodetic Position Output:</strong> The resulting absolute geographic coordinates are continuously provided through <code>latitudeDeg</code> and <code>longitudeDeg</code>.</li>
</ul>

<h2>Typical Application</h2>

<p>
  This block is suitable for simulation architectures in which the dynamic model calculates vessel or vehicle motion in a local Cartesian reference frame while navigation, GNSS, guidance, or Hardware-in-the-Loop interfaces require geographic coordinates expressed according to WGS84.
</p>

<p>
  A typical signal flow is:
</p>

<p>
  <code>Local North/East Position [m] → Wgs84GnssPositionPure → Latitude/Longitude [deg]</code>
</p>

</body></html>"));

end Wgs84GnssPositionPure;
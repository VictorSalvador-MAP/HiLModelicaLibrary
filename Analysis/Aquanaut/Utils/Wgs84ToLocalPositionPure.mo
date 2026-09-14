within Aquanaut.Utils;

block Wgs84ToLocalPositionPure
  "Pure Modelica utility block converting WGS84 Geodetic Lat/Lon degrees to local North/East Cartesian meters"

  // Configurable reference origin geodetic parameters
  parameter Real originLatitudeDeg(unit = "deg") = 0
    "Geodetic latitude coordinate of the local reference origin [deg]";

  parameter Real originLongitudeDeg(unit = "deg") = 0
    "Geodetic longitude coordinate of the local reference origin [deg]";

  // Real Input Ports: Global WGS84 geodetic coordinates
  Modelica.Blocks.Interfaces.RealInput latitudeDeg(unit = "deg")
    "Input WGS84 latitude [deg]"
    annotation(Placement(
      transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput longitudeDeg(unit = "deg")
    "Input WGS84 longitude [deg]"
    annotation(Placement(
      transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  // Real Output Ports: Local Cartesian displacements
  Modelica.Blocks.Interfaces.RealOutput northM(unit = "m")
    "Output local North displacement [m]"
    annotation(Placement(
      transformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput eastM(unit = "m")
    "Output local East displacement [m]"
    annotation(Placement(
      transformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}})));

protected

  // Mathematical conversion constants
  constant Real pi = Modelica.Constants.pi
    "Mathematical constant Pi";

  constant Real degToRad = pi / 180
    "Conversion factor from degrees to radians";

  // WGS84 Ellipsoid constants
  constant Real semiMajorAxisM = 6378137.0
    "WGS84 ellipsoid semi-major axis (a) [m]";

  constant Real flattening = 1 / 298.257223563
    "WGS84 ellipsoid flattening (f)";

  constant Real eccentricitySquared = flattening * (2 - flattening)
    "First eccentricity squared (e^2)";

  // Intermediate variables
  Real originLatitudeRad(unit = "rad")
    "Origin latitude converted to radians";

  Real originLongitudeRad(unit = "rad")
    "Origin longitude converted to radians";

  Real latitudeRad(unit = "rad")
    "Input latitude converted to radians";

  Real longitudeRad(unit = "rad")
    "Input longitude converted to radians";

  Real sinLatitude
    "Sine of the origin latitude";

  Real curvatureFactor
    "Auxiliary WGS84 curvature term";

  Real meridionalRadiusM(unit = "m")
    "Meridional radius of curvature at origin latitude";

  Real transverseRadiusM(unit = "m")
    "Prime vertical radius of curvature at origin latitude";

equation

  // Convert geographic coordinates from degrees to radians
  originLatitudeRad = originLatitudeDeg * degToRad;
  originLongitudeRad = originLongitudeDeg * degToRad;

  latitudeRad = latitudeDeg * degToRad;
  longitudeRad = longitudeDeg * degToRad;

  // Compute WGS84 curvature terms at the configured origin
  sinLatitude = sin(originLatitudeRad);

  curvatureFactor =
    sqrt(1 - eccentricitySquared * sinLatitude * sinLatitude);

  // Meridional radius of curvature
  meridionalRadiusM =
    semiMajorAxisM * (1 - eccentricitySquared) /
    curvatureFactor^3;

  // Prime vertical radius of curvature
  transverseRadiusM =
    semiMajorAxisM / curvatureFactor;

  // Inverse transformation of localNorthEastToWgs84Pure
  northM =
    (latitudeRad - originLatitudeRad) *
    meridionalRadiusM;

  eastM =
    (longitudeRad - originLongitudeRad) *
    transverseRadiusM *
    cos(originLatitudeRad);

  annotation(
    Icon(
      coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(
          lineColor = {0, 75, 140},
          fillColor = {143, 240, 164},
          fillPattern = FillPattern.Solid,
          extent = {{-100, 100}, {100, -100}}),

        Text(
          origin = {-4, -52},
          extent = {{-84, 72}, {84, 32}},
          textString = "WGS84
Lat/Lon
to North/East"),

        Text(
          extent = {{42, 56}, {96, 26}},
          textString = "N [m]",
          horizontalAlignment = TextAlignment.Right),

        Text(
          extent = {{42, -26}, {96, -56}},
          textString = "E [m]",
          horizontalAlignment = TextAlignment.Right),

        Text(
          origin = {-124, 22},
          extent = {{26, 26}, {60, 12}},
          textString = "Lat [deg]",
          horizontalAlignment = TextAlignment.Right),

        Text(
          origin = {-122, -58},
          extent = {{26, 26}, {60, 12}},
          textString = "Lon [deg]",
          horizontalAlignment = TextAlignment.Right)}),

    Documentation(info = "<html>
<p>Converts WGS84 Latitude and Longitude into local North and East Cartesian displacements relative to a configurable geographic reference origin.</p>

<p>The transformation is the algebraic inverse of the local planar conversion implemented by <code>Aquanaut.Functions.localNorthEastToWgs84Pure</code>.</p>

<p>The coordinate convention is:</p>

<ul>
<li><strong>northM:</strong> local displacement toward North [m];</li>
<li><strong>eastM:</strong> local displacement toward East [m].</li>
</ul>

<p>The WGS84 meridional and prime vertical radii of curvature are evaluated at the configured reference latitude, using the same ellipsoid parameters as the forward transformation.</p>
</html>"));

end Wgs84ToLocalPositionPure;
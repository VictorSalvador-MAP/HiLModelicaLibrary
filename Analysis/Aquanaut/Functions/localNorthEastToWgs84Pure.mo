within Aquanaut.Functions;

function localNorthEastToWgs84Pure
  "Pure Modelica implementation converting local planar North/East offsets (meters) to WGS84 geodetic coordinates (degrees)"
  extends Modelica.Icons.Function;

  // Input arguments: Reference origin coordinates and local planar offsets
  input Real originLatitudeDeg(unit = "deg") "Geodetic latitude of the reference origin point [deg]";
  input Real originLongitudeDeg(unit = "deg") "Geodetic longitude of the reference origin point [deg]";
  input Real northM(unit = "m") "Local displacement along the North direction relative to origin [m]";
  input Real eastM(unit = "m") "Local displacement along the East direction relative to origin [m]";

  // Output arguments: Resulting WGS84 coordinates
  output Real latitudeDeg(unit = "deg") "Calculated WGS84 target latitude [deg]";
  output Real longitudeDeg(unit = "deg") "Calculated WGS84 target longitude [deg]";

protected
  // Mathematical conversion constants
  constant Real pi = Modelica.Constants.pi "Mathematical constant Pi";
  constant Real degToRad = pi / 180 "Conversion factor from degrees to radians";
  constant Real radToDeg = 180 / pi "Conversion factor from radians to degrees";

  // WGS84 Ellipsoid constants
  constant Real semiMajorAxisM = 6378137.0 "WGS84 ellipsoid semi-major axis (a) [m]";
  constant Real flattening = 1 / 298.257223563 "WGS84 ellipsoid flattening (f)";
  constant Real eccentricitySquared = flattening * (2 - flattening) "First eccentricity squared (e^2)";

  // Intermediate variable declarations for geodesic calculations
  Real originLatitudeRad "Origin latitude converted to radians [rad]";
  Real originLongitudeRad "Origin longitude converted to radians [rad]";
  Real sinLatitude "Sine of the origin latitude angle";
  Real curvatureFactor "Auxiliary term derived from ellipsoid eccentricity and latitude";
  Real meridionalRadiusM "Meridional radius of curvature M(phi) along North-South axis [m]";
  Real transverseRadiusM "Prime vertical radius of curvature N(phi) along East-West axis [m]";

algorithm
  // Step 1: Convert input origin coordinates from degrees to radians
  originLatitudeRad := originLatitudeDeg * degToRad;
  originLongitudeRad := originLongitudeDeg * degToRad;

  // Step 2: Compute intermediate trigonometric and curvature terms
  sinLatitude := sin(originLatitudeRad);

  // Auxiliary denominator term: W = sqrt(1 - e^2 * sin^2(phi))
  curvatureFactor := sqrt(1 - eccentricitySquared * sinLatitude * sinLatitude);

  // Step 3: Compute principal radii of curvature at origin latitude
  // Meridional radius M(phi) = a*(1 - e^2) / (1 - e^2*sin^2(phi))^(3/2)
  meridionalRadiusM := semiMajorAxisM * (1 - eccentricitySquared) / curvatureFactor ^ 3;

  // Transverse (Prime Vertical) radius N(phi) = a / sqrt(1 - e^2*sin^2(phi))
  transverseRadiusM := semiMajorAxisM / curvatureFactor;

  // Step 4: Map local North offset to latitude change and convert back to degrees
  latitudeDeg := (originLatitudeRad + northM / meridionalRadiusM) * radToDeg;

  // Step 5: Map local East offset to longitude change considering parallel convergence
  longitudeDeg := (originLongitudeRad + eastM / (transverseRadiusM * cos(originLatitudeRad))) * radToDeg;

annotation(
    Documentation(__OpenModelica_infoHeader = "<html><head>
                    </head>
                    <body>
                    <h1>Pure Modelica Local North-East to WGS84 Geodetic Converter</h1>
                    
                    <p>
                      The <em>localNorthEastToWgs84Pure</em> function calculates global WGS84 geodetic coordinates (Latitude and Longitude in degrees) from local planar Cartesian displacements (North and East in meters) relative to a specified reference geographic origin.
                    </p>
                    
                    <h2>Description</h2>
                    
                    <p>
                      Unlike external library bindings, this component delivers a <strong>100% native Modelica analytical implementation</strong> of local tangent frame geodesic transformations. It uses the standard <strong>WGS84 Reference Ellipsoid</strong> mathematical model to dynamically evaluate local surface radii of curvature.
                    </p>
                    <p>
                      By computing both the <em>Meridional Radius of Curvature</em> (M) along the North-South meridian and the <em>Prime Vertical Radius of Curvature</em> (N) along the East-West prime vertical, the function accurately maps linear displacements in meters into equivalent angular differences in degrees, accounting for Earth's oblateness and parallel convergence at higher latitudes.
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
                          <td>Geodetic latitude coordinate of the local spatial reference origin.</td>
                        </tr>
                        <tr>
                          <td><strong>originLongitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Geodetic longitude coordinate of the local spatial reference origin.</td>
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

                    <br>

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
                          <td>Calculated absolute WGS84 latitude coordinate.</td>
                        </tr>
                        <tr>
                          <td><strong>longitudeDeg</strong></td>
                          <td>Real</td>
                          <td>deg</td>
                          <td>Calculated absolute WGS84 longitude coordinate.</td>
                        </tr>
                      </tbody>
                    </table>
                    
                    <h2>Key Internal Sub-components</h2>
                    
                    <p>
                      This function is self-contained and does not instantiate internal blocks or rely on external C/C++ dynamically linked binaries. It uses protected internal constants and mathematical primitives:
                    </p>
                    <ul>
                      <li><strong>Modelica.Constants.pi:</strong> System standard mathematical constant $\pi$ used for radian-degree transformations.</li>
                      <li><strong>WGS84 Ellipsoid Constants:</strong> Hardcoded ellipsoid parameters including semi-major axis ($a = 6378137.0\text{ m}$), inverse flattening ($1/f = 298.257223563$), and first eccentricity squared ($e^2$).</li>
                    </ul>
                    
                    <h2>System Operation and Interconnections</h2>
                    
                    <p>
                      The internal mathematical routine executes in a single algorithmic evaluation sequence:
                    </p>
                    <ul>
                      <li><strong>Coordinate Angular Conversion:</strong> Concurrently converts input geographic origin angles (<code>originLatitudeDeg</code>, <code>originLongitudeDeg</code>) to radians.</li>
                      <li><strong>Local Ellipsoidal Radii Evaluation:</strong> Calculates the curvature factor $W = \sqrt{1 - e^2 \sin^2(\phi_{origin})}$ to determine the local North-South meridional radius <code>meridionalRadiusM</code> ($M$) and East-West transverse radius <code>transverseRadiusM</code> ($N$).</li>
                      <li><strong>Cartesian-to-Geodetic Mapping:</strong> Scales <code>northM</code> by $1/M$ to find latitude offset, and scales <code>eastM</code> by $1/(N \cdot \cos(\phi_{origin}))$ to account for longitudinal meridian convergence, returning both calculated global output signals in degrees.</li>
                    </ul>
                    
                    </body></html>"));
end localNorthEastToWgs84Pure;
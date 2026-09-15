within Aquanaut.Utils;

model IdealGNSSCompass
  "GNSS Compass model with position, velocity, heading and rate of turn outputs"
  Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor worldSensor(get_a = true, get_angles = true, get_r = true, get_v = true, get_w = true, get_z = true, guessAngle1(displayUnit = "rad"), resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.world) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Reference frame whose position, velocity and orientation are measured" annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-104, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Latitude annotation(
    Placement(transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Longitude annotation(
    Placement(transformation(origin = {110, 55}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Altitude annotation(
    Placement(transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput SOG annotation(
    Placement(transformation(origin = {110, 5}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput COG annotation(
    Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput rate_of_turn annotation(
    Placement(transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Heading annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -84}, extent = {{-10, -10}, {10, 10}})));
  parameter Real originLatitudeDeg(unit = "deg") = -22.734233 "Geodetic latitude of the local reference origin";
  parameter Real originLongitudeDeg(unit = "deg") = -43.085687 "Geodetic longitude of the local reference origin";
  parameter Real forwardAxis[3] = {1, 0, 0} "Vessel longitudinal axis pointing toward the bow";
protected
  /*
           * Vessel longitudinal axis resolved in world coordinates.
           */
  Real forwardWorld[3] "Vessel longitudinal axis resolved in world coordinates";
  /*
           * Raw navigation values.
           *
           * These values preserve the original calculations before
           * applying the output limits required by the PGNs.
           */
  Real latitudeRaw(unit = "deg");
  Real longitudeRaw(unit = "deg");
  Real sogRaw(unit = "m/s");
  Real cogRaw(unit = "rad");
  Real headingRaw(unit = "rad");
  /*
           * Angular values converted from the atan2 range [-pi, +pi]
           * to the navigation convention [0, 2*pi).
           */
  Real cogWrapped(unit = "rad");
  Real headingWrapped(unit = "rad");
  /*
           * -----------------------------------------------------------------
           * POSITION LIMITS
           * -----------------------------------------------------------------
           *
           * PGN 129025 / PGN 129029:
           *
           * Latitude:
           *   minimum = -90 deg
           *   maximum = +90 deg
           *
           * Longitude:
           *   minimum = -180 deg
           *   maximum = +180 deg
           *
           * Resolution is intentionally NOT applied in this model version.
           */
  constant Real latitudeMin(unit = "deg") = -90;
  constant Real latitudeMax(unit = "deg") = 90;
  constant Real longitudeMin(unit = "deg") = -180;
  constant Real longitudeMax(unit = "deg") = 180;
  /*
           * -----------------------------------------------------------------
           * ANGULAR LIMITS
           * -----------------------------------------------------------------
           *
           * PGN 127250 / PGN 129026:
           *
           * Heading and COG:
           *   minimum = 0 rad
           *   maximum = 6.2831 rad
           *
           * Resolution of 0.0001 rad is intentionally NOT applied
           * in this model version.
           */
  constant Real angleMin(unit = "rad") = 0;
  constant Real angleMax(unit = "rad") = 6.2831;
  constant Real twoPi(unit = "rad") = 2*Modelica.Constants.pi;
  /*
           * -----------------------------------------------------------------
           * SOG LIMITS
           * -----------------------------------------------------------------
           *
           * PGN 129026:
           *
           * minimum = 0 m/s
           * maximum = 655.32 m/s
           *
           * Resolution of 0.01 m/s is intentionally NOT applied
           * in this model version.
           */
  constant Real sogMin(unit = "m/s") = 0;
  constant Real sogMax(unit = "m/s") = 655.32;
public
equation
/*
         * -----------------------------------------------------------------
         * REFERENCE FRAME CONNECTION
         * -----------------------------------------------------------------
         *
         * Connect the vessel reference frame to the internal absolute sensor.
         */
  connect(frame_a, worldSensor.frame_a);
/*
         * -----------------------------------------------------------------
         * WGS84 POSITION
         * -----------------------------------------------------------------
         *
         * Original local position convention:
         *
         *   worldSensor.r[1] -> North displacement
         *   worldSensor.r[2] -> East displacement
         *
         * First calculate the original continuous WGS84 coordinates.
         */
  (latitudeRaw, longitudeRaw) = Functions.localNorthEastToWgs84Pure(originLatitudeDeg, originLongitudeDeg, worldSensor.r[1], worldSensor.r[2]);
/*
         * Limit Latitude according to the valid geographic range:
         *
         *   -90 <= Latitude <= +90 deg
         *
         * No quantization is applied.
         */
  Latitude = min(latitudeMax, max(latitudeMin, latitudeRaw));
/*
         * Limit Longitude according to the valid geographic range:
         *
         *   -180 <= Longitude <= +180 deg
         *
         * No quantization is applied.
         */
  Longitude = min(longitudeMax, max(longitudeMin, longitudeRaw));
/*
         * -----------------------------------------------------------------
         * ALTITUDE
         * -----------------------------------------------------------------
         *
         * No range or resolution requirement was defined for Altitude,
         * therefore the original behavior is preserved.
         */
  Altitude = worldSensor.r[3];
/*
         * -----------------------------------------------------------------
         * SPEED OVER GROUND
         * -----------------------------------------------------------------
         *
         * Original SOG calculation:
         *
         *   SOG = sqrt(Vnorth^2 + Veast^2)
         */
  sogRaw = sqrt(worldSensor.v[1]^2 + worldSensor.v[2]^2);
/*
         * Limit SOG according to PGN 129026:
         *
         *   0 <= SOG <= 655.32 m/s
         *
         * No 0.01 m/s quantization is applied.
         *
         * Therefore the continuous shape of the original SOG signal
         * is preserved while still respecting the specified limits.
         */
  SOG = min(sogMax, max(sogMin, sogRaw));
/*
         * -----------------------------------------------------------------
         * COURSE OVER GROUND
         * -----------------------------------------------------------------
         *
         * Original COG calculation:
         *
         *   COG = atan2(Veast, Vnorth)
         *
         * atan2() returns an angle approximately within:
         *
         *   -pi <= COG <= +pi
         */
  cogRaw = Modelica.Math.atan2(worldSensor.v[2], worldSensor.v[1]);
/*
         * Convert negative atan2 angles into the navigation convention:
         *
         *   0 <= COG < 2*pi
         *
         * Example:
         *
         *   -0.2 rad -> -0.2 + 2*pi = 6.083185... rad
         *
         * No mod(), floor(), ceil() or integer() operation is required.
         */
  cogWrapped = if cogRaw < 0 then cogRaw + twoPi else cogRaw;
/*
         * Enforce the specified PGN range:
         *
         *   0 <= COG <= 6.2831 rad
         *
         * No 0.0001 rad quantization is applied.
         */
  COG = min(angleMax, max(angleMin, cogWrapped));
/*
         * -----------------------------------------------------------------
         * RATE OF TURN
         * -----------------------------------------------------------------
         *
         * Original behavior is preserved.
         *
         * worldSensor.w[3] corresponds to yaw angular velocity.
         */
  rate_of_turn = worldSensor.w[3];
/*
         * -----------------------------------------------------------------
         * HEADING
         * -----------------------------------------------------------------
         *
         * Resolve the vessel longitudinal axis into world coordinates.
         */
  forwardWorld = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, forwardAxis);
/*
         * Original Heading calculation:
         *
         *   Heading = atan2(ForwardEast, ForwardNorth)
         *
         * atan2() produces an angle approximately within:
         *
         *   -pi <= Heading <= +pi
         */
  headingRaw = Modelica.Math.atan2(forwardWorld[2], forwardWorld[1]);
/*
         * Convert negative Heading values into:
         *
         *   0 <= Heading < 2*pi
         */
  headingWrapped = if headingRaw < 0 then headingRaw + twoPi else headingRaw;
/*
         * Enforce the specified Heading range:
         *
         *   0 <= Heading <= 6.2831 rad
         *
         * No 0.0001 rad quantization is applied.
         */
  Heading = min(angleMax, max(angleMin, headingWrapped));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {154, 153, 150}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 100}, {100, -100}}), Text(origin = {-6, 0}, textColor = {255, 255, 255}, extent = {{-64, 48}, {64, -48}}, textString = "GNSS Compass", textStyle = {TextStyle.Bold}), Text(origin = {82, 91}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Lat"), Text(origin = {82, 61}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Lon"), Text(origin = {82, 31}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Alt"), Text(origin = {82, 3}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "SOG"), Text(origin = {78, -27}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "COG"), Text(origin = {60, -57}, textColor = {255, 255, 255}, extent = {{34, -15}, {-34, 15}}, textString = "Rate of Turn"), Text(origin = {68, -87}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Heading"), Rectangle(fillColor = {154, 153, 150}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 100}, {100, -100}}), Text(origin = {-6, 0}, textColor = {255, 255, 255}, extent = {{-64, 48}, {64, -48}}, textString = "GNSS Compass", textStyle = {TextStyle.Bold}), Text(origin = {82, 91}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Lat"), Text(origin = {82, 61}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Lon"), Text(origin = {82, 31}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Alt"), Text(origin = {82, 3}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "SOG"), Text(origin = {78, -27}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "COG"), Text(origin = {60, -57}, textColor = {255, 255, 255}, extent = {{34, -15}, {-34, 15}}, textString = "Rate of Turn"), Text(origin = {68, -87}, textColor = {255, 255, 255}, extent = {{26, -9}, {-26, 9}}, textString = "Heading"), Rectangle(lineColor = {0, 50, 100}, fillColor = {30, 95, 160}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Rectangle(lineColor = {205, 225, 245}, extent = {{-94, 94}, {94, -94}}), Text(origin = {-14, 72}, textColor = {255, 255, 255}, extent = {{-70, 14}, {70, -14}}, textString = "GNSS Compass", textStyle = {TextStyle.Bold}), Ellipse(lineColor = {255, 255, 255}, fillColor = {245, 250, 255}, fillPattern = FillPattern.Solid, extent = {{-34, 34}, {34, -34}}), Ellipse(lineColor = {140, 165, 190}, extent = {{-27, 27}, {27, -27}}), Line(points = {{0, -27}, {0, 27}}, color = {150, 150, 150}), Line(points = {{-27, 0}, {27, 0}}, color = {150, 150, 150}), Line(points = {{0, 0}, {18, 18}}, color = {0, 55, 110}, thickness = 2), Polygon(lineColor = {0, 55, 110}, fillColor = {0, 55, 110}, fillPattern = FillPattern.Solid, points = {{18, 18}, {9, 15}, {15, 9}, {18, 18}}), Text(origin = {0, 17}, textColor = {0, 55, 110}, extent = {{-8, 7}, {8, -7}}, textString = "N", textStyle = {TextStyle.Bold}), Line(points = {{-60, 26}, {-52, 34}}, color = {255, 255, 255}, thickness = 1), Line(points = {{-52, 34}, {-44, 26}}, color = {255, 255, 255}, thickness = 1), Line(points = {{-54, 22}, {-48, 28}}, color = {255, 255, 255}), Text(origin = {73, 84}, textColor = {255, 255, 255}, extent = {{-18, 7}, {18, -7}}, textString = "Lat"), Text(origin = {73, 58}, textColor = {255, 255, 255}, extent = {{-18, 7}, {18, -7}}, textString = "Lon"), Text(origin = {73, 32}, textColor = {255, 255, 255}, extent = {{-18, 7}, {18, -7}}, textString = "Alt"), Text(origin = {73, 6}, textColor = {255, 255, 255}, extent = {{-18, 7}, {18, -7}}, textString = "SOG"), Text(origin = {73, -20}, textColor = {255, 255, 255}, extent = {{-18, 7}, {18, -7}}, textString = "COG"), Text(origin = {72, -50}, textColor = {255, 255, 255}, extent = {{-18, 7}, {18, -7}}, textString = "ROT"), Text(origin = {65, -80}, textColor = {255, 255, 255}, extent = {{-25, 7}, {25, -7}}, textString = "Heading")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-120, -100}, {120, 100}}), graphics = {Text(origin = {-100, 18}, extent = {{-18, 6}, {18, -6}}, textString = "frame_a")}),
    Documentation(info = "<html><head></head><body></body></html>", __OpenModelica_infoHeader = "<html><head></head>
      <body>
      
      <h1>Aquanaut.Utils.IdealGNSSCompass Model Specification</h1>
      
      <p>This model represents an idealized GNSS Compass navigation sensor used in the Aquanaut vessel simulation. The block receives the vessel MultiBody reference frame and derives global position, ground velocity, course, heading, and angular rate from the vessel absolute kinematic state.</p>
      
      <p>The <strong>IdealGNSSCompass</strong> calculates continuous navigation quantities and applies output range conditioning according to the specified navigation signal limits. Latitude, Longitude, and SOG are limited to their valid ranges, while COG and Heading are additionally converted from the native atan2 angular convention into the navigation interval from 0 to 2*pi. No output resolution quantization or discrete sampling is applied.</p>
      
      <h2>1. Model Parameters</h2>
      
      <p>The model parameters define the geographic reference origin used for WGS84 coordinate conversion and the vessel body axis considered as the forward direction for heading calculation.</p>
      
      <table border=\"1\">
      <tbody>
      <tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\"><th>Parameter Name</th><th>Type</th><th>Value / Default</th><th>Unit</th><th>Description</th></tr>
      <tr><td>originLatitudeDeg</td><td>Real</td><td>-22.734233</td><td>deg</td><td>Geodetic latitude of the local Cartesian reference origin. This coordinate corresponds to the zero-North position of the local simulation reference frame.</td></tr>
      <tr><td>originLongitudeDeg</td><td>Real</td><td>-43.085687</td><td>deg</td><td>Geodetic longitude of the local Cartesian reference origin. This coordinate corresponds to the zero-East position of the local simulation reference frame.</td></tr>
      <tr><td>forwardAxis</td><td>Real[3]</td><td>{1, 0, 0}</td><td>-</td><td>Vessel longitudinal body axis pointing toward the bow. This vector is resolved from the vessel reference frame into the world frame and is used to calculate absolute Heading.</td></tr>
      </tbody>
      </table>
      
      <h2>2. External Interface</h2>
      <h3>2.1 MultiBody Frame Interface</h3>
      
      <table border=\"1\">
      <tbody>
      <tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\"><th>Interface</th><th>Type</th><th>Description</th></tr>
      <tr><td>frame_a</td><td>Modelica.Mechanics.MultiBody.Interfaces.Frame_a</td><td>Vessel reference frame used to obtain absolute position, translational velocity, angular velocity, and orientation. The frame is connected directly to the internal absolute kinematic sensor.</td></tr>
      </tbody>
      </table>
      
      <h3>2.2 Navigation Outputs</h3>
      
      <table border=\"1\">
      <tbody>
      <tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\"><th>Output</th><th>Type</th><th>Unit</th><th>Description</th></tr>
      <tr><td>Latitude</td><td>RealOutput</td><td>deg</td><td>WGS84 geodetic latitude calculated from local North displacement and limited to the interval from -90 to +90 deg.</td></tr>
      <tr><td>Longitude</td><td>RealOutput</td><td>deg</td><td>WGS84 geodetic longitude calculated from local East displacement and limited to the interval from -180 to +180 deg.</td></tr>
      <tr><td>Altitude</td><td>RealOutput</td><td>m</td><td>Vessel vertical position obtained directly from the third component of the absolute position vector. No additional range conditioning is applied.</td></tr>
      <tr><td>SOG</td><td>RealOutput</td><td>m/s</td><td>Speed Over Ground calculated from the horizontal North and East velocity components and limited to the interval from 0 to 655.32 m/s.</td></tr>
      <tr><td>COG</td><td>RealOutput</td><td>rad</td><td>Course Over Ground calculated from the horizontal velocity vector. Negative atan2 results are converted to the navigation convention from 0 to 2*pi and the final output is limited to 6.2831 rad.</td></tr>
      <tr><td>rate_of_turn</td><td>RealOutput</td><td>rad/s</td><td>Vessel yaw angular velocity obtained directly from the third component of the absolute angular velocity vector.</td></tr>
      <tr><td>Heading</td><td>RealOutput</td><td>rad</td><td>Absolute vessel heading calculated from the configured forward body axis. Negative atan2 results are converted to the navigation convention from 0 to 2*pi and the final output is limited to 6.2831 rad.</td></tr>
      </tbody>
      </table>
      
      <h2>3. Internal Sensor Architecture</h2>
      <h3>3.1 Absolute Kinematic Sensor</h3>
      
      <p>The model uses a <strong>Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor</strong>, named <strong>worldSensor</strong>, to extract the absolute kinematic state associated with <strong>frame_a</strong>.</p>
      
      <p>The AbsoluteSensor is configured with the following measurements enabled:</p>
      
      <ul>
      <li><strong>get_r = true:</strong> absolute position vector;</li>
      <li><strong>get_v = true:</strong> absolute translational velocity vector;</li>
      <li><strong>get_a = true:</strong> absolute translational acceleration vector;</li>
      <li><strong>get_w = true:</strong> absolute angular velocity vector;</li>
      <li><strong>get_z = true:</strong> absolute angular acceleration vector;</li>
      <li><strong>get_angles = true:</strong> absolute orientation angles.</li>
      </ul>
      
      <p>The sensor resolves its measured quantities in the <strong>world reference frame</strong> through:</p>
      
      <p><code>resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.world</code></p>
      
      <p>The vessel frame is connected directly to the internal sensor through:</p>
      
      <p><code>connect(frame_a, worldSensor.frame_a);</code></p>
      
      <h2>4. Position and WGS84 Coordinate Calculation</h2>
      
      <p>The absolute position vector is interpreted according to the local navigation coordinate convention:</p>
      
      <ul>
      <li><strong>worldSensor.r[1]:</strong> North displacement [m];</li>
      <li><strong>worldSensor.r[2]:</strong> East displacement [m];</li>
      <li><strong>worldSensor.r[3]:</strong> vertical position / Altitude [m].</li>
      </ul>
      
      <p>The horizontal North and East displacements are converted into WGS84 geodetic coordinates using:</p>
      
      <p><code>Aquanaut.Functions.localNorthEastToWgs84Pure(...)</code></p>
      
      <p>The raw geographic coordinates are calculated as:</p>
      
      <p><code>(latitudeRaw, longitudeRaw) = Aquanaut.Functions.localNorthEastToWgs84Pure(originLatitudeDeg, originLongitudeDeg, worldSensor.r[1], worldSensor.r[2]);</code></p>
      
      <p>The configured geographic reference origin is:</p>
      
      <ul>
      <li><strong>Latitude:</strong> -22.734233 deg;</li>
      <li><strong>Longitude:</strong> -43.085687 deg.</li>
      </ul>
      
      <p>The final geographic outputs are limited as follows:</p>
      
      <ul>
      <li><strong>Latitude:</strong> -90 to +90 deg;</li>
      <li><strong>Longitude:</strong> -180 to +180 deg.</li>
      </ul>
      
      <p>The implemented output conditioning is:</p>
      
      <p><code>Latitude = min(latitudeMax, max(latitudeMin, latitudeRaw));</code></p>
      <p><code>Longitude = min(longitudeMax, max(longitudeMin, longitudeRaw));</code></p>
      
      <p>Altitude is obtained directly from:</p>
      
      <p><code>Altitude = worldSensor.r[3];</code></p>
      
      <p>No position quantization is applied.</p>
      
      <h2>5. Speed Over Ground Calculation</h2>
      
      <p>Speed Over Ground represents the magnitude of the vessel horizontal velocity relative to the world reference frame. The horizontal velocity components are:</p>
      
      <ul>
      <li><strong>worldSensor.v[1]:</strong> North velocity [m/s];</li>
      <li><strong>worldSensor.v[2]:</strong> East velocity [m/s].</li>
      </ul>
      
      <p>The raw SOG value is calculated as:</p>
      
      <p><code>sogRaw = sqrt(worldSensor.v[1]^2 + worldSensor.v[2]^2);</code></p>
      
      <p>Therefore:</p>
      <p><strong>SOGraw = sqrt(Vnorth^2 + Veast^2)</strong></p>
      
      <p>The resulting value is limited to:</p>
      <p><strong>0 &lt;= SOG &lt;= 655.32 m/s</strong></p>
      
      <p>through:</p>
      <p><code>SOG = min(sogMax, max(sogMin, sogRaw));</code></p>
      
      <p>No SOG quantization is applied.</p>
      
      <h2>6. Course Over Ground Calculation</h2>
      
      <p>Course Over Ground represents the direction of the vessel horizontal velocity vector relative to the world reference frame.</p>
      
      <p>The raw COG value is calculated as:</p>
      <p><code>cogRaw = Modelica.Math.atan2(worldSensor.v[2], worldSensor.v[1]);</code></p>
      
      <p>The native atan2 result is approximately within:</p>
      <p><strong>-pi &lt;= cogRaw &lt;= +pi</strong></p>
      
      <p>Negative values are converted into the navigation angular convention:</p>
      <p><code>cogWrapped = if cogRaw &lt; 0 then cogRaw + twoPi else cogRaw;</code></p>
      
      <p>This transformation produces an angular representation within approximately:</p>
      <p><strong>0 &lt;= COG &lt; 2*pi</strong></p>
      
      <p>The final COG output is then limited to:</p>
      <p><strong>0 &lt;= COG &lt;= 6.2831 rad</strong></p>
      
      <p>through:</p>
      <p><code>COG = min(angleMax, max(angleMin, cogWrapped));</code></p>
      
      <p>No COG quantization is applied.</p>
      
      <h2>7. Heading Calculation</h2>
      
      <p>Heading represents the direction in which the vessel longitudinal axis points relative to the world reference frame.</p>
      
      <p>The default vessel forward axis is:</p>
      <p><code>forwardAxis = {1, 0, 0};</code></p>
      
      <p>This body-fixed vector is transformed into world coordinates using:</p>
      <p><code>forwardWorld = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, forwardAxis);</code></p>
      
      <p>The raw Heading value is then calculated as:</p>
      <p><code>headingRaw = Modelica.Math.atan2(forwardWorld[2], forwardWorld[1]);</code></p>
      
      <p>The native atan2 result is approximately within:</p>
      <p><strong>-pi &lt;= headingRaw &lt;= +pi</strong></p>
      
      <p>Negative Heading values are converted into the navigation angular convention using:</p>
      <p><code>headingWrapped = if headingRaw &lt; 0 then headingRaw + twoPi else headingRaw;</code></p>
      
      <p>The final Heading output is limited to:</p>
      <p><strong>0 &lt;= Heading &lt;= 6.2831 rad</strong></p>
      
      <p>through:</p>
      <p><code>Heading = min(angleMax, max(angleMin, headingWrapped));</code></p>
      
      <p>No Heading quantization is applied.</p>
      
      <h2>8. Rate of Turn Calculation</h2>
      
      <p>Rate of Turn represents the vessel rotational velocity around its vertical axis. It is obtained directly from the third component of the absolute angular velocity vector:</p>
      
      <p><code>rate_of_turn = worldSensor.w[3];</code></p>
      
      <p>Therefore, <strong>rate_of_turn</strong> represents the vessel <strong>yaw rate</strong> expressed in rad/s. It is an angular velocity and shall not be interpreted as an angular acceleration.</p>
      
      <p>No additional range limiting or quantization is applied.</p>
      
      <h2>9. Heading and Course Distinction</h2>
      
      <p>The model provides both <strong>Heading</strong> and <strong>COG</strong> because they represent different navigation quantities.</p>
      
      <table border=\"1\">
      <tbody>
      <tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\"><th>Quantity</th><th>Derived From</th><th>Physical Meaning</th></tr>
      <tr><td>Heading</td><td>Vessel orientation</td><td>Direction in which the vessel longitudinal axis / bow is pointing.</td></tr>
      <tr><td>COG</td><td>Vessel horizontal velocity</td><td>Direction in which the vessel is actually moving over the ground.</td></tr>
      </tbody>
      </table>
      
      <p>For straight-ahead motion without lateral velocity, Heading and COG tend to be aligned. They may differ whenever the vessel presents lateral motion or when its trajectory differs from its longitudinal orientation.</p>
      
      <h2>10. Output Range Conditioning</h2>
      
      <p>The model applies range conditioning to selected navigation outputs while preserving continuous signal behavior. No resolution quantization or discrete sampling is introduced.</p>
      
      <table border=\"1\">
      <tbody>
      <tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\"><th>Signal</th><th>Minimum</th><th>Maximum</th><th>Additional Processing</th></tr>
      <tr><td>Latitude</td><td>-90 deg</td><td>+90 deg</td><td>Range limiting</td></tr>
      <tr><td>Longitude</td><td>-180 deg</td><td>+180 deg</td><td>Range limiting</td></tr>
      <tr><td>SOG</td><td>0 m/s</td><td>655.32 m/s</td><td>Range limiting</td></tr>
      <tr><td>COG</td><td>0 rad</td><td>6.2831 rad</td><td>Negative-angle wrapping followed by range limiting</td></tr>
      <tr><td>Heading</td><td>0 rad</td><td>6.2831 rad</td><td>Negative-angle wrapping followed by range limiting</td></tr>
      <tr><td>Altitude</td><td>-</td><td>-</td><td>No additional conditioning</td></tr>
      <tr><td>rate_of_turn</td><td>-</td><td>-</td><td>No additional conditioning</td></tr>
      </tbody>
      </table>
      
      <h2>11. Quantization and Sampling</h2>
      
      <p>The model does not apply resolution quantization to any navigation output. The calculated values remain continuous within their specified output ranges.</p>
      
      <p>The implementation therefore does not use:</p>
      
      <ul>
      <li>floor-based quantization;</li>
      <li>ceil-based quantization;</li>
      <li>integer conversion for signal resolution;</li>
      <li>discrete sampling;</li>
      <li>sample-and-hold behavior.</li>
      </ul>
      
      <h2>12. Ideal Sensor Assumptions</h2>
      
      <p>The navigation quantities are derived directly from the simulated vessel kinematic state. The model therefore represents an ideal navigation sensor with deterministic output conditioning.</p>
      
      <p>The implementation does not internally introduce:</p>
      
      <ul>
      <li>measurement noise;</li>
      <li>position uncertainty;</li>
      <li>heading uncertainty;</li>
      <li>velocity uncertainty;</li>
      <li>signal latency;</li>
      <li>sampling delay;</li>
      <li>communication delay;</li>
      <li>signal loss;</li>
      <li>resolution quantization;</li>
      <li>sensor initialization or acquisition time.</li>
      </ul>
      
      <h2>13. Signal Mapping Summary</h2>
      
      <table border=\"1\">
      <tbody>
      <tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\"><th>Output</th><th>Internal Source</th><th>Calculation</th><th>Output Processing</th></tr>
      <tr><td>Latitude</td><td>worldSensor.r[1]</td><td>Local North position converted to WGS84 latitude</td><td>Limited to -90 ... +90 deg</td></tr>
      <tr><td>Longitude</td><td>worldSensor.r[2]</td><td>Local East position converted to WGS84 longitude</td><td>Limited to -180 ... +180 deg</td></tr>
      <tr><td>Altitude</td><td>worldSensor.r[3]</td><td>Direct assignment</td><td>None</td></tr>
      <tr><td>SOG</td><td>worldSensor.v[1], worldSensor.v[2]</td><td>sqrt(Vnorth^2 + Veast^2)</td><td>Limited to 0 ... 655.32 m/s</td></tr>
      <tr><td>COG</td><td>worldSensor.v[1], worldSensor.v[2]</td><td>atan2(Veast, Vnorth)</td><td>Wrapped to the positive navigation interval and limited to 0 ... 6.2831 rad</td></tr>
      <tr><td>rate_of_turn</td><td>worldSensor.w[3]</td><td>Direct yaw angular velocity</td><td>None</td></tr>
      <tr><td>Heading</td><td>frame_a.R</td><td>atan2(ForwardEast, ForwardNorth)</td><td>Wrapped to the positive navigation interval and limited to 0 ... 6.2831 rad</td></tr>
      </tbody>
      </table>
      
      <h2>14. Functional Processing Summary</h2>
      
      <p>The model processing sequence is:</p>
      
      <ol>
      <li>Receive the vessel reference frame through <strong>frame_a</strong>;</li>
      <li>Extract the absolute vessel kinematic state through <strong>worldSensor</strong>;</li>
      <li>Convert local North and East displacement into raw WGS84 Latitude and Longitude;</li>
      <li>Apply valid geographic limits to Latitude and Longitude;</li>
      <li>Obtain Altitude directly from the vertical absolute position;</li>
      <li>Calculate raw SOG from North and East velocity and apply its valid range;</li>
      <li>Calculate raw COG from horizontal velocity;</li>
      <li>Convert negative COG values to the positive navigation angular convention and apply the final angular limit;</li>
      <li>Obtain Rate of Turn directly from yaw angular velocity;</li>
      <li>Resolve the vessel forward axis into world coordinates;</li>
      <li>Calculate raw Heading from the resolved forward direction;</li>
      <li>Convert negative Heading values to the positive navigation angular convention and apply the final angular limit;</li>
      <li>Expose the conditioned continuous navigation quantities through the external interface.</li>
      </ol>
      
      <h2>15. Simulation Metadata</h2>
      
      <ul>
      <li><strong>Model Type:</strong> Continuous ideal navigation sensor model with output range conditioning.</li>
      <li><strong>Reference Frame:</strong> Navigation quantities are derived from the vessel absolute state resolved in the world frame.</li>
      <li><strong>Geodetic Reference:</strong> WGS84 coordinates calculated from the configured local North-East origin.</li>
      <li><strong>Heading Reference:</strong> Vessel longitudinal forward axis defined by <code>forwardAxis</code>.</li>
      <li><strong>Signal Representation:</strong> Continuous range-limited navigation values without resolution quantization.</li>
      <li><strong>Angular Convention:</strong> COG and Heading are represented using the positive navigation angular interval, with final outputs limited to 6.2831 rad.</li>
      <li><strong>Solver Configuration:</strong> No simulation solver, integration interval, start time, stop time, or tolerance is defined locally by this block. These settings are inherited from the top-level simulation model.</li>
      </ul>
      
      </body>
      </html>"));

end IdealGNSSCompass;
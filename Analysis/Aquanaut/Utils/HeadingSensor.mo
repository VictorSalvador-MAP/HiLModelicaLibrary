within Aquanaut.Utils;

model HeadingSensor "Absolute vessel heading calculated from the body reference frame"
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a "Reference frame whose heading is measured" annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput heading(final quantity = "Angle", final unit = "rad") "Heading angle" annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}})));
  parameter Real forwardAxis[3] = {1, 0, 0} "Vessel longitudinal axis pointing toward the bow";
protected
  Real forwardWorld[3] "Vessel longitudinal axis resolved in world coordinates";
equation
// Ideal sensor: it does not apply forces or torques
  frame_a.f = zeros(3);
  frame_a.t = zeros(3);
// Resolve vessel longitudinal axis in world coordinates
  forwardWorld = Modelica.Mechanics.MultiBody.Frames.resolve1(frame_a.R, forwardAxis);
// Heading from horizontal projection
  heading = Modelica.Math.atan2(forwardWorld[2], forwardWorld[1]);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-80, 60}, {80, -60}}), Ellipse(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-45, 45}, {45, -45}}), Line(points = {{0, -35}, {0, 35}}, color = {160, 160, 160}), Line(points = {{-35, 0}, {35, 0}}, color = {160, 160, 160}), Line(points = {{0, 0}, {25, 25}}, color = {0, 0, 127}, thickness = 2), Polygon(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, points = {{25, 25}, {14, 21}, {21, 14}, {25, 25}}), Text(origin = {0, 4}, textColor = {0, 0, 127}, extent = {{-25, 58}, {25, 38}}, textString = "N"), Text(textColor = {0, 0, 127}, extent = {{-70, -62}, {70, -82}}, textString = "Heading"), Text(textColor = {0, 0, 255}, extent = {{-100, -84}, {100, -104}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-75, 50}, {75, -50}}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-65, 35}, {65, 15}}, textString = "Heading Sensor", textColor = {0, 0, 127}), Text(extent = {{-65, 5}, {65, -15}}, textString = "Body frame -> World", textColor = {0, 0, 0}), Text(extent = {{-65, -15}, {65, -35}}, textString = "atan2(y,x)", textColor = {0, 0, 0}), Line(points = {{-80, 0}, {-75, 0}}, color = {0, 0, 127}), Line(points = {{75, 0}, {90, 0}}, color = {0, 0, 127})}),
    preferredView = "diagram",
    Documentation(info = "<html>
<p>Ideal heading sensor.</p>
<p>The vessel longitudinal axis is resolved in the world frame.</p>
<p>The heading is obtained from its horizontal projection:</p>
<p><b>heading = atan2(yWorld, xWorld)</b></p>
<p>The output is expressed in radians.</p>
</html>"));
end HeadingSensor;
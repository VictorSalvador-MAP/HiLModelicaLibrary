within Aquanaut.Utils;

block SOGAndCOGCalculation
  import Modelica.Math;

  // Input Definitions
  Modelica.Blocks.Interfaces.RealInput vel_n_m_s "North Velocity in [m/s]"
    annotation (Placement(transformation(extent={{-120, 30}, {-80, 70}}), iconTransformation(origin = {-48, 30.5}, extent = {{-78, 19.5}, {-52, 45.5}})));
    
  Modelica.Blocks.Interfaces.RealInput vel_e_m_s "East Velocity in [m/s]"
    annotation (Placement(transformation(extent={{-120, -70}, {-80, -30}}), iconTransformation(origin = {-44, -31}, extent = {{-84, -49}, {-56, -21}})));

  // Output Definitions
  Modelica.Blocks.Interfaces.RealOutput sog_m_s "Speed Over Ground in [m/s]"
    annotation (Placement(transformation(extent={{80, 30}, {120, 70}}), iconTransformation(origin = {44, 25}, extent = {{56, 21}, {84, 49}})));
    
  Modelica.Blocks.Interfaces.RealOutput cog_rad "Course Over Ground in [rad]"
    annotation (Placement(transformation(extent={{80, -70}, {120, -30}}), iconTransformation(origin = {44, -37}, extent = {{56, -49}, {84, -21}})));

equation
  // Speed Over Ground calculation (Pythagorean theorem)
  sog_m_s = sqrt(vel_n_m_s^2 + vel_e_m_s^2);

  // Course Over Ground calculation referenced to True North
  cog_rad = Math.atan2(vel_e_m_s, vel_n_m_s);
  
  // Graphical representation of the block (Icon)
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, borderPattern = BorderPattern.Raised, extent = {{-100, 100}, {100, -100}}), Text(origin = {2, -2}, textColor = {255, 255, 255}, extent = {{-70, 56}, {70, -56}}, textString = "SOG and COG 
Calculation"), Text(origin = {-66, 65}, textColor = {255, 255, 255}, extent = {{-30, 19}, {30, -19}}, textString = "Vel_north"), Text(origin = {-66, -65}, textColor = {255, 255, 255}, extent = {{-30, 19}, {30, -19}}, textString = "Vel_east"), Text(origin = {76, 60}, textColor = {255, 255, 255}, extent = {{-14, 8}, {14, -8}}, textString = "SOG"), Text(origin = {80, -72}, textColor = {255, 255, 255}, extent = {{-14, 8}, {14, -8}}, textString = "COG")}));
end SOGAndCOGCalculation;
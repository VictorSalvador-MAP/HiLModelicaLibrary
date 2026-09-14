within Aquanaut.Utils;

block SOGAndCOGToVelocity
  "Converts Speed Over Ground and Course Over Ground into North and East velocity components"

  import Modelica.Math;

  // Input Definitions
  Modelica.Blocks.Interfaces.RealInput sog_m_s(unit = "m/s")
    "Speed Over Ground [m/s]"
    annotation(Placement(
      transformation(extent = {{-120, 30}, {-80, 70}}),
      iconTransformation(origin = {-48, 30.5}, extent = {{-78, 19.5}, {-52, 45.5}})));

  Modelica.Blocks.Interfaces.RealInput cog_rad(unit = "rad")
    "Course Over Ground referenced to North [rad]"
    annotation(Placement(
      transformation(extent = {{-120, -70}, {-80, -30}}),
      iconTransformation(origin = {-44, -31}, extent = {{-84, -49}, {-56, -21}})));

  // Output Definitions
  Modelica.Blocks.Interfaces.RealOutput vel_n_m_s(unit = "m/s")
    "North velocity [m/s]"
    annotation(Placement(
      transformation(extent = {{80, 30}, {120, 70}}),
      iconTransformation(origin = {44, 25}, extent = {{56, 21}, {84, 49}})));

  Modelica.Blocks.Interfaces.RealOutput vel_e_m_s(unit = "m/s")
    "East velocity [m/s]"
    annotation(Placement(
      transformation(extent = {{80, -70}, {120, -30}}),
      iconTransformation(origin = {44, -37}, extent = {{56, -49}, {84, -21}})));

equation

  // North velocity component
  vel_n_m_s = sog_m_s * Math.cos(cog_rad);

  // East velocity component
  vel_e_m_s = sog_m_s * Math.sin(cog_rad);

  annotation(
    Icon(
      coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(
          lineColor = {0, 0, 127},
          fillColor = {38, 162, 105},
          fillPattern = FillPattern.Solid,
          borderPattern = BorderPattern.Raised,
          extent = {{-100, 100}, {100, -100}}),

        Text(
          origin = {2, -2},
          textColor = {255, 255, 255},
          extent = {{-70, 56}, {70, -56}},
          textString = "SOG and COG
to Velocity"),

        Text(
          origin = {-66, 65},
          textColor = {255, 255, 255},
          extent = {{-30, 19}, {30, -19}},
          textString = "SOG"),

        Text(
          origin = {-66, -65},
          textColor = {255, 255, 255},
          extent = {{-30, 19}, {30, -19}},
          textString = "COG"),

        Text(
          origin = {72, 60},
          textColor = {255, 255, 255},
          extent = {{-24, 8}, {24, -8}},
          textString = "Vel_north"),

        Text(
          origin = {72, -72},
          textColor = {255, 255, 255},
          extent = {{-24, 8}, {24, -8}},
          textString = "Vel_east")}),

    Documentation(info = "<html>
<p>Converts Speed Over Ground and Course Over Ground into North and East horizontal velocity components.</p>

<p>The block uses the same navigation convention as the corresponding SOG/COG calculation:</p>

<p><code>COG = atan2(Veast, Vnorth)</code></p>

<p>Therefore, the inverse transformation is:</p>

<p><code>Vnorth = SOG * cos(COG)</code></p>
<p><code>Veast = SOG * sin(COG)</code></p>

<p>COG is referenced to North, with increasing positive angle toward East.</p>
</html>"));

end SOGAndCOGToVelocity;
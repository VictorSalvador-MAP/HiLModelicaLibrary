within Aquanaut.PathFollowing;

model OpenLoop
  // Parameters
  parameter Real propellerF = 5.0 "Propeller cut frequency (Hz)";
  parameter Real rudderF    = 5.0 "Rudder cut frequency (Hz)";
  parameter Real rudderMaxAngle = 0.6108652381980153 "Rudder max absolute angle (rad)";
  
  Aquanaut.ShipParts.Hull hull(Ixx = 4749.54, Iyx = 213.75, Iyy = 28293.74, Izx = -3411.63, Izy = 15.59, Izz = 27690.71, initPos = true, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", sphereViewer = false, vesselMass = 4484.75, vesselZ0 = -0.57) annotation(
    Placement(transformation(origin = {70, 66}, extent = {{-10, -10}, {10, 10}})));
  inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
    Placement(transformation(origin = {-64, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
    Placement(transformation(origin = {-30, -48}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.HydroForces.BuoyancyInterpolation buoyancy(Cb = 10000, dist_keel_cg = 1.758417010307312, output_folder = "modelica://Aquanaut/Resources/STL", shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", sphereRadius = 2, time_step = 3, useComplexShape = true, useSTLPositionXY = true, wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_") annotation(
    Placement(transformation(origin = {70, 42}, extent = {{-10, -10}, {10, 10}})));
  inner Aquanaut.HydroForces.Stream Stream(psiCurr = 0, velocityMean = 1) annotation(
    Placement(transformation(origin = {-44, -82}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.ShipParts.MarinePropeller marinePropeller(Fa = +2, eta_R = 1, useStream = false) annotation(
    Placement(transformation(origin = {-60, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact = false, phi(displayUnit = "rad"), useSupport = false, f_crit = propellerF) annotation(
    Placement(transformation(origin = {-96, 2}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.ShipParts.MarineRudder marineRudder(maxAngle = rudderMaxAngle, f_cut = rudderF) annotation(
    Placement(transformation(origin = {-18, 4}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.HydroForces.Viscous viscous(Kp = 5000, Mq = 15000, Nr = 10000, Xu = 1000, Yv = 5000, Zw = 5000) annotation(
    Placement(transformation(origin = {70, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput propellerSpeed annotation(
    Placement(transformation(origin = {-200, 38}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-124, 60}, extent = {{-24, -24}, {24, 24}})));
  Modelica.Blocks.Interfaces.RealInput rudderAngle annotation(
    Placement(transformation(origin = {-200, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-124, -60}, extent = {{-24, -24}, {24, 24}})));
  Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor worldSensor(resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.world, get_r = true, get_v = true, get_a = true, get_w = true, get_z = true, get_angles = true) annotation(
    Placement(transformation(origin = {28, -8}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor boatSensor(get_a = true, get_angles = true, get_r = true, get_v = true, get_w = true, get_z = true, resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.frame_a) annotation(
    Placement(transformation(origin = {40, -78}, extent = {{10, 10}, {-10, -10}}, rotation = -0)));
  // Outputs
  Modelica.Blocks.Interfaces.RealOutput v[6] annotation(
    Placement(transformation(origin = {126, -42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {117, -1}, extent = {{-17, -17}, {17, 17}})));
  Modelica.Blocks.Interfaces.RealOutput p[6] annotation(
    Placement(transformation(origin = {126, -24}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, 60}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Blocks.Interfaces.RealOutput a[6] annotation(
    Placement(transformation(origin = {126, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, -60}, extent = {{-16, -16}, {16, 16}})));
equation
  connect(speed.flange, marinePropeller.flange) annotation(
    Line(points = {{-86, 2}, {-70, 2}}));
  connect(world.frame_b, fixedFrame.frame_a) annotation(
    Line(points = {{-54, -48}, {-40, -48}}, color = {95, 95, 95}));
  connect(marinePropeller.wakeFraction, marineRudder.wakeFraction) annotation(
    Line(points = {{-49.2, 6.2}, {-29.2, 6.2}}, color = {0, 0, 127}));
  connect(marinePropeller.flowDiameter, marineRudder.flowDiameter) annotation(
    Line(points = {{-49.1, 2}, {-29.1, 2}}, color = {0, 0, 127}));
  connect(marinePropeller.flowSpeed, marineRudder.flowSpeed) annotation(
    Line(points = {{-49.1, -1.8}, {-33.1, -1.8}, {-33.1, -3.8}, {-29.1, -3.8}}, color = {0, 0, 127}));
  connect(hull.frame_a, buoyancy.frame_a) annotation(
    Line(points = {{60, 66}, {46, 66}, {46, 42}, {60, 42}}, color = {95, 95, 95}));
  connect(viscous.frame_a, buoyancy.frame_a) annotation(
    Line(points = {{60, 18}, {46, 18}, {46, 42}, {60, 42}}, color = {95, 95, 95}));
  connect(marineRudder.frame_a, buoyancy.frame_a) annotation(
    Line(points = {{-8, 4}, {23, 4}, {23, 42}, {60, 42}}, color = {95, 95, 95}));
  connect(marinePropeller.frame_a, buoyancy.frame_a) annotation(
    Line(points = {{-70, 6}, {-78, 6}, {-78, 42}, {60, 42}}, color = {95, 95, 95}));
  connect(rudderAngle, marineRudder.angleInput) annotation(
    Line(points = {{-200, 60}, {-36, 60}, {-36, 12}, {-30, 12}}, color = {0, 0, 127}));
  connect(propellerSpeed, speed.w_ref) annotation(
    Line(points = {{-200, 38}, {-146, 38}, {-146, 2}, {-108, 2}}, color = {0, 0, 127}));
  connect(worldSensor.frame_a, buoyancy.frame_a) annotation(
    Line(points = {{38, -8}, {38, 42}, {60, 42}}, color = {95, 95, 95}));
  connect(worldSensor.r[1], p[1]) annotation(
    Line(points = {{38, -18}, {38, -24}, {126, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.r[2], p[2]) annotation(
    Line(points = {{38, -18}, {38, -24}, {126, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.r[3], p[3]) annotation(
    Line(points = {{38, -18}, {38, -24}, {126, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.angles[1], p[4]) annotation(
    Line(points = {{38, -67}, {38, -24}, {126, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.angles[2], p[5]) annotation(
    Line(points = {{38, -67}, {38, -24}, {126, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.angles[3], p[6]) annotation(
    Line(points = {{38, -67}, {38, -24}, {126, -24}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.v[1], v[1]) annotation(
    Line(points = {{34, -18}, {34, -42}, {126, -42}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.v[2], v[2]) annotation(
    Line(points = {{34, -18}, {34, -42}, {126, -42}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.v[3], v[3]) annotation(
    Line(points = {{34, -18}, {34, -42}, {126, -42}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.w[1], v[4]) annotation(
    Line(points = {{34, -66}, {34, -42}, {126, -42}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.w[2], v[5]) annotation(
    Line(points = {{34, -66}, {34, -42}, {126, -42}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.w[3], v[6]) annotation(
    Line(points = {{34, -66}, {34, -42}, {126, -42}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.a[1], a[1]) annotation(
    Line(points = {{30, -18}, {30, -60}, {126, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.a[2], a[2]) annotation(
    Line(points = {{30, -18}, {30, -60}, {126, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(worldSensor.a[3], a[3]) annotation(
    Line(points = {{30, -18}, {30, -60}, {126, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.z[1], a[4]) annotation(
    Line(points = {{30, -66}, {30, -60}, {126, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.z[2], a[5]) annotation(
    Line(points = {{30, -66}, {30, -60}, {126, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.z[3], a[6]) annotation(
    Line(points = {{30, -66}, {30, -60}, {126, -60}}, color = {0, 0, 127}, thickness = 0.5));
  connect(boatSensor.frame_a, viscous.frame_a) annotation(
    Line(points = {{50, -78}, {56, -78}, {56, 18}, {60, 18}}, color = {95, 95, 95}));

  annotation(
    Diagram(graphics = {Rectangle(origin = {53, -10}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-57, 90}, {57, -90}})}, coordinateSystem(extent = {{-220, 80}, {140, -100}})),
    experiment(StartTime = 0, StopTime = 50, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=fmuExperimental ",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {4, 50}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Polygon(origin = {10, 44}, lineColor = {85, 170, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, points = {{-14, 10}, {-14, 2}, {-2, 2}, {8, 10}, {-14, 10}}), Line(origin = {-3.97, 41.7}, points = {{-10.0305, 0.29944}, {-4.0305, 4.29944}, {1.9695, -1.70056}, {7.9695, 4.29944}, {15.9695, -1.70056}, {21.9695, 4.2994}, {25.9695, 0.29944}}, color = {0, 170, 255}, thickness = 1.5, smooth = Smooth.Bezier), Polygon(origin = {10, 44}, fillColor = {85, 85, 255}, lineThickness = 0.75, points = {{-14, 10}, {-14, 2}, {-2, 2}, {8, 10}, {-14, 10}}), Rectangle(origin = {4, 0}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Rectangle(origin = {4, -1}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-1, 7}, {1, -7}}), Ellipse(origin = {4, -10}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Polygon(origin = {4, 4}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-2, 2}, {2, 2}, {0, 8}, {-2, 2}}), Line(origin = {-3.97, -4.3}, points = {{-10.0305, 0.29944}, {-4.0305, 4.29944}, {1.9695, -1.70056}, {7.9695, 4.29944}, {15.9695, -1.70056}, {21.9695, 4.2994}, {25.9695, 0.29944}}, color = {0, 170, 255}, thickness = 1.5, smooth = Smooth.Bezier), Rectangle(origin = {4, -50}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Rectangle(origin = {-2, -50}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-2, 5}, {2, -5}}), Polygon(origin = {-26, -50}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-4, -20}, {4, -20}, {0, -12}, {-4, -20}}), Ellipse(origin = {8, -50}, lineColor = {85, 0, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Sphere, extent = {{-8, 8}, {8, -8}}), Line(origin = {-9, -34.89}, points = {{30.997, -19.1092}, {26.9972, -19.1092}, {18.9972, -27.1092}, {6.9972, -21.1092}, {-3.0028, -21.1092}}, color = {85, 0, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -54.89}, points = {{24.9972, 14.8908}, {18.9972, 14.8908}, {10.9972, 18.8908}, {-1.0028, 12.8908}, {-9.0028, 12.8908}}, color = {85, 85, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -46.89}, points = {{24.9972, 8.8908}, {18.9972, 8.8908}, {10.9972, 12.8908}, {-1.0028, 6.8908}, {-9.0028, 6.89078}}, color = {85, 170, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-9, -22.89}, points = {{30.997, -21.1092}, {24.9972, -21.1092}, {16.9972, -15.1092}, {6.9972, -21.1092}, {-3.0028, -21.1092}}, color = {85, 0, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -70.89}, points = {{24.9972, 12.8908}, {20.9972, 12.8908}, {12.9972, 6.8908}, {-1.0028, 12.8908}, {-9.0028, 12.8908}}, color = {85, 85, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -66.89}, points = {{24.9972, 6.8908}, {20.9972, 6.8908}, {12.9972, 0.8908}, {-1.0028, 6.8908}, {-9.0028, 6.89078}}, color = {85, 170, 255}, thickness = 1, smooth = Smooth.Bezier), Rectangle(origin = {-60, 60}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Polygon(origin = {-55, 60}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, points = {{-4.563, 3.6504}, {-4.563, 7.9092}, {-1.521, 14.6016}, {2.1294, 18.252}, {3.9546, 17.6436}, {4.563, 15.8184}, {4.563, 10.3428}, {0.3042, 3.6504}, {0.3042, -3.6504}, {4.563, -10.3428}, {4.563, -15.8184}, {3.9546, -17.6436}, {2.1294, -18.252}, {-1.521, -14.6016}, {-4.563, -7.9092}, {-4.563, 3.6504}}, smooth = Smooth.Bezier), Rectangle(origin = {-69, 60}, fillColor = {200, 200, 200}, fillPattern = FillPattern.CrossDiag, extent = {{-8, 3}, {8, -3}}), Polygon(origin = {-52, 60}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-10.336, 4.252}, {-10.336, -4.252}, {-0.874, -4.252}, {2.252, -2.168}, {2.336, -2.084}, {2.336, 0.084}, {2.252, 2.168}, {-0.874, 4.252}, {-10.336, 4.252}}), Ellipse(origin = {-57.5, 60}, rotation = 45, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-1, 6}, {1, -6}}), Rectangle(origin = {-60, -60}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Polygon(origin = {-29, -78}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, points = {{-35, 18}, {-35, 4}, {-25, 4}, {-19, 30}, {-33, 30}, {-33, 22}, {-31, 22}, {-31, 18}, {-35, 18}}), Polygon(origin = {-70, -22}, points = {{6, -38}, {10, -38}, {10, -34}, {8, -34}, {8, -24}, {6, -24}, {6, -38}}), Ellipse(origin = {60, 0}, fillColor = {198, 198, 198}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}}), Ellipse(origin = {60, 0}, fillColor = {98, 98, 98}, fillPattern = FillPattern.Solid, extent = {{-2, 2}, {2, -2}}), Polygon(origin = {65, 5}, rotation = -45, fillPattern = FillPattern.Solid, points = {{-1.5, -5.9}, {-0.1, -7.5}, {1.3, -5.9}, {-0.1, 7.5}, {-1.5, -5.9}}), Line(origin = {60, 13}, points = {{0, 3}, {0, -3}, {0, -3}}), Line(origin = {47, 0}, points = {{-3, 0}, {3, 0}}), Line(origin = {73, 0}, points = {{3, 0}, {-3, 0}}), Line(origin = {50, 8}, points = {{-2, 2}, {2, -2}}), Line(origin = {70, 8}, points = {{2, 2}, {-2, -2}, {-2, -2}}), Line(origin = {89, 0}, points = {{-11, 0}, {11, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {89, 31}, points = {{-11, -29}, {1, -29}, {1, 29}, {11, 29}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {89, -32}, points = {{-11, 30}, {1, 30}, {1, -28}, {11, -28}}, arrow = {Arrow.None, Arrow.Filled})}),
    Documentation(info = "<html>
<h1>Aquanaut.PathFollowing.OpenLoop Model Specification</h1>
<p>This model represents an open-loop vessel dynamic system, integrating hydrodynamic forces, marine propulsion, steering systems, and environment state sensors.</p>

<h2>1. Model Parameters</h2>
<p>The configuration parameters defined at the top level of the model control the filtering frequencies and constraints for actuators:</p>
<table border=1>
  <tr style=background-color:#f2f2f2;font-weight:bold;text-align:left;>
    <th>Parameter Name</th>
    <th>Type</th>
    <th>Value / Default</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>propellerF</td>
    <td>Real</td>
    <td>5.0</td>
    <td>Propeller cut frequency (Hz)</td>
  </tr>
  <tr>
    <td>rudderF</td>
    <td>Real</td>
    <td>5.0</td>
    <td>Rudder cut frequency (Hz)</td>
  </tr>
  <tr>
    <td>rudderMaxAngle</td>
    <td>Real</td>
    <td>0.6108652381980153</td>
    <td>Rudder max absolute angle (rad) (~35 degrees)</td>
  </tr>
</table>

<h2>2. Component Architecture (Submodels)</h2>
<h3>2.1 Ship Parts & Hydrodynamics</h3>
<ul>
  <li><strong>hull</strong> (Aquanaut.ShipParts.Hull): Defines structural mass (4484.75 kg) and inertia properties.</li>
  <li><strong>buoyancy</strong> (Aquanaut.HydroForces.BuoyancyInterpolation): Hydrostatic calculations utilizing 3D shape meshes.</li>
  <li><strong>viscous</strong> (Aquanaut.HydroForces.Viscous): Linear/angular fluid damping coefficients.</li>
  <li><strong>Stream</strong> (Aquanaut.HydroForces.Stream): Current field field with a mean velocity of 1.0 m/s.</li>
</ul>

<h3>2.2 Actuation & Propulsion</h3>
<ul>
  <li><strong>marinePropeller</strong> (Aquanaut.ShipParts.MarinePropeller): Computes thrust forces utilizing slipstream and localized wake fraction.</li>
  <li><strong>speed</strong> (Modelica.Mechanics.Rotational.Sources.Speed): Actuates propeller shaft rotation.</li>
  <li><strong>marineRudder</strong> (Aquanaut.ShipParts.MarineRudder): Steering forces constrained by rudderMaxAngle.</li>
</ul>

<h3>2.3 Interface Blocks & Kinematics</h3>
<ul>
  <li><strong>Inputs:</strong> propellerSpeed, rudderAngle.</li>
  <li><strong>Outputs:</strong> Vector array outputs p[6], v[6], a[6].</li>
  <li><strong>Sensors:</strong> worldSensor and boatSensor extract spatial kinematics.</li>
</ul>

<h2>3. Equation & Interconnection Network</h2>
<ul>
  <li><strong>Propulsion & Steering Line:</strong> Extends connection from speed source to propeller shaft. Propeller wake variables map to rudder inputs to compute flow velocity amplification over steering fins.</li>
  <li><strong>Kinematic Mapping:</strong> Integrates absolute position vectors from sensors directly into the structural six-dimensional interface outputs.</li>
  <ul>
 <li>p = [x, y, z, roll, pitch, yaw]; </li>
 <li>v = [vx, vy, vz, roll rate, pitch rate, yaw rate];</li>
 <li>a = [ax, ay, az, roll acc, pitch acc, yaw acc]; </li>
 </ul>
</ul>

<h2>4. Simulation Metadata</h2>
<ul>
  <li><strong>Solver Settings:</strong> Start Time = 0.0s, Stop Time = 50.0s, Interval = 0.01s, Tolerance = 1e-06 with Euler integration.</li>
</ul>
</html>"));
end OpenLoop;

package UpdatedPackage15_09
   
package Models
    model OT1Model
      // Parameters
      parameter Real propellerF = 5.0 "Propeller cut frequency (Hz)";
      parameter Real rudderF = 5.0 "Rudder cut frequency (Hz)";
      parameter Real rudderMaxAngle = 0.6108652381980153 "Rudder max absolute angle (rad)";
      parameter Modelica.Units.SI.Time derivativeFilterTime = 0.01 "Derivative filter time constant";
      parameter Real gravity = Modelica.Constants.g_n "Gravity Acceleration";
      Aquanaut.ShipParts.Hull hull(Ixx = 4749.54, Iyx = 213.75, Iyy = 28293.74, Izx = -3411.63, Izy = 15.59, Izz = 27690.71, initPos = true, shapeModel = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", sphereViewer = false, vesselMass = 4484.75, vesselZ0 = -0.57) annotation(
        Placement(transformation(origin = {70, 66}, extent = {{-10, -10}, {10, 10}})));
      inner Modelica.Mechanics.MultiBody.World world(label2 = "z", n = {0, 0, 1}) annotation(
        Placement(transformation(origin = {-160, -44}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame(length = 10) annotation(
        Placement(transformation(origin = {-126, -44}, extent = {{-10, -10}, {10, 10}})));
      Aquanaut.HydroForces.BuoyancyInterpolation buoyancy(Cb = 10000, dist_keel_cg = 1.758417010307312, output_folder = "modelica://Aquanaut/Resources/STL", shapePath = "modelica://Aquanaut/Resources/STL/Hull_STL_Fixed(Solid)-CM_origin.stl", sphereRadius = 2, time_step = 3, useComplexShape = true, useSTLPositionXY = true, wavePath = "modelica://Aquanaut/Resources/STL/flat_wave_") annotation(
        Placement(transformation(origin = {70, 42}, extent = {{-10, -10}, {10, 10}})));
      inner Aquanaut.HydroForces.Stream Stream(psiCurr = 0, velocityMean = 1) annotation(
        Placement(transformation(origin = {-144, -80}, extent = {{-10, -10}, {10, 10}})));
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
      // Outputs
      Modelica.Blocks.Interfaces.RealOutput SOG annotation(
        Placement(transformation(origin = {120, 18}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {117, 57}, extent = {{-17, -17}, {17, 17}})));
      Modelica.Blocks.Interfaces.RealOutput Altitude annotation(
        Placement(transformation(origin = {120, 36}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {72, 116}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput COG annotation(
        Placement(transformation(origin = {120, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Blocks.Interfaces.RealOutput rudderFeedback_rad annotation(
        Placement(transformation(origin = {120, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -116}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor propSpeedSensor annotation(
        Placement(transformation(origin = {-78, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput PropellerFeedback_rad_s annotation(
        Placement(transformation(origin = {120, -64}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-76, -116}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Aquanaut.HiL.FinalModels.NewModelUtils.IdealGNSSCompass2 Hemisphere_GNSSCompass annotation(
        Placement(transformation(origin = {70, -8}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput Rate_of_Turn annotation(
        Placement(transformation(origin = {120, -18}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, -58}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Blocks.Interfaces.RealOutput Heading annotation(
        Placement(transformation(origin = {120, -34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {66, -116}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput Latitude annotation(
        Placement(transformation(origin = {120, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-80, 116}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput Longitude annotation(
        Placement(transformation(origin = {120, 54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 116}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
    equation
      connect(speed.flange, marinePropeller.flange) annotation(
        Line(points = {{-86, 2}, {-70, 2}}));
      connect(world.frame_b, fixedFrame.frame_a) annotation(
        Line(points = {{-150, -44}, {-136, -44}}, color = {95, 95, 95}));
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
      connect(marinePropeller.frame_a, buoyancy.frame_a) annotation(
        Line(points = {{-70, 6}, {-78, 6}, {-78, 42}, {60, 42}}, color = {95, 95, 95}));
      connect(rudderAngle, marineRudder.angleInput) annotation(
        Line(points = {{-200, 60}, {-36, 60}, {-36, 12}, {-30, 12}}, color = {0, 0, 127}));
      connect(propellerSpeed, speed.w_ref) annotation(
        Line(points = {{-200, 38}, {-146, 38}, {-146, 2}, {-108, 2}}, color = {0, 0, 127}));
      connect(propSpeedSensor.flange, speed.flange) annotation(
        Line(points = {{-78, -14}, {-78, 2}, {-86, 2}}));
      connect(Hemisphere_GNSSCompass.frame_a, hull.frame_a) annotation(
        Line(points = {{60, -8}, {22, -8}, {22, 42}, {46, 42}, {46, 66}, {60, 66}}, color = {95, 95, 95}));
      connect(Hemisphere_GNSSCompass.Altitude, Altitude) annotation(
        Line(points = {{81, -5}, {102, -5}, {102, 36}, {120, 36}}, color = {0, 0, 127}));
      connect(Hemisphere_GNSSCompass.SOG, SOG) annotation(
        Line(points = {{81, -7}, {104, -7}, {104, 18}, {120, 18}}, color = {0, 0, 127}));
      connect(Hemisphere_GNSSCompass.COG, COG) annotation(
        Line(points = {{81, -10}, {106, -10}, {106, 0}, {120, 0}}, color = {0, 0, 127}));
      connect(Hemisphere_GNSSCompass.rate_of_turn, Rate_of_Turn) annotation(
        Line(points = {{81, -13}, {106, -13}, {106, -18}, {120, -18}}, color = {0, 0, 127}));
      connect(Hemisphere_GNSSCompass.Heading, Heading) annotation(
        Line(points = {{81, -16}, {103.875, -16}, {103.875, -34}, {120, -34}}, color = {0, 0, 127}));
      connect(marineRudder.rudderFeedbackRad, rudderFeedback_rad) annotation(
        Line(points = {{-18, -6}, {-18, -50}, {120, -50}}, color = {0, 0, 127}));
      connect(propSpeedSensor.w, PropellerFeedback_rad_s) annotation(
        Line(points = {{-78, -34}, {-78, -64}, {120, -64}}, color = {0, 0, 127}));
      connect(marineRudder.frame_a, buoyancy.frame_a) annotation(
        Line(points = {{-8, 4}, {22, 4}, {22, 42}, {60, 42}}, color = {95, 95, 95}));
      connect(Hemisphere_GNSSCompass.Longitude, Longitude) annotation(
        Line(points = {{82, -2}, {100, -2}, {100, 54}, {120, 54}}, color = {0, 0, 127}));
      connect(Hemisphere_GNSSCompass.Latitude, Latitude) annotation(
        Line(points = {{82, 0}, {98, 0}, {98, 72}, {120, 72}}, color = {0, 0, 127}));
      annotation(
        Diagram(graphics = {Rectangle(origin = {53, -10}, lineColor = {85, 85, 255}, lineThickness = 0.75, extent = {{-57, 90}, {57, -90}})}, coordinateSystem(extent = {{-220, -200}, {140, 150}})),
        experiment(StartTime = 0, StopTime = 250, Tolerance = 1e-06, Interval = 0.02),
        __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=fmuExperimental ",
        __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
        Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {4, 50}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Polygon(origin = {10, 44}, lineColor = {85, 170, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.HorizontalCylinder, points = {{-14, 10}, {-14, 2}, {-2, 2}, {8, 10}, {-14, 10}}), Line(origin = {-3.97, 41.7}, points = {{-10.0305, 0.29944}, {-4.0305, 4.29944}, {1.9695, -1.70056}, {7.9695, 4.29944}, {15.9695, -1.70056}, {21.9695, 4.2994}, {25.9695, 0.29944}}, color = {0, 170, 255}, thickness = 1.5, smooth = Smooth.Bezier), Polygon(origin = {10, 44}, fillColor = {85, 85, 255}, lineThickness = 0.75, points = {{-14, 10}, {-14, 2}, {-2, 2}, {8, 10}, {-14, 10}}), Rectangle(origin = {4, 0}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Rectangle(origin = {4, -1}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-1, 7}, {1, -7}}), Ellipse(origin = {4, -10}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-4, 4}, {4, -4}}), Polygon(origin = {4, 4}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-2, 2}, {2, 2}, {0, 8}, {-2, 2}}), Line(origin = {-3.97, -4.3}, points = {{-10.0305, 0.29944}, {-4.0305, 4.29944}, {1.9695, -1.70056}, {7.9695, 4.29944}, {15.9695, -1.70056}, {21.9695, 4.2994}, {25.9695, 0.29944}}, color = {0, 170, 255}, thickness = 1.5, smooth = Smooth.Bezier), Rectangle(origin = {4, -50}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-20, 20}, {20, -20}}), Rectangle(origin = {-2, -50}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-2, 5}, {2, -5}}), Polygon(origin = {-26, -50}, rotation = 90, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-4, -20}, {4, -20}, {0, -12}, {-4, -20}}), Ellipse(origin = {8, -50}, lineColor = {85, 0, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Sphere, extent = {{-8, 8}, {8, -8}}), Line(origin = {-9, -34.89}, points = {{30.997, -19.1092}, {26.9972, -19.1092}, {18.9972, -27.1092}, {6.9972, -21.1092}, {-3.0028, -21.1092}}, color = {85, 0, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -54.89}, points = {{24.9972, 14.8908}, {18.9972, 14.8908}, {10.9972, 18.8908}, {-1.0028, 12.8908}, {-9.0028, 12.8908}}, color = {85, 85, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -46.89}, points = {{24.9972, 8.8908}, {18.9972, 8.8908}, {10.9972, 12.8908}, {-1.0028, 6.8908}, {-9.0028, 6.89078}}, color = {85, 170, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-9, -22.89}, points = {{30.997, -21.1092}, {24.9972, -21.1092}, {16.9972, -15.1092}, {6.9972, -21.1092}, {-3.0028, -21.1092}}, color = {85, 0, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -70.89}, points = {{24.9972, 12.8908}, {20.9972, 12.8908}, {12.9972, 6.8908}, {-1.0028, 12.8908}, {-9.0028, 12.8908}}, color = {85, 85, 255}, thickness = 1, smooth = Smooth.Bezier), Line(origin = {-3, -66.89}, points = {{24.9972, 6.8908}, {20.9972, 6.8908}, {12.9972, 0.8908}, {-1.0028, 6.8908}, {-9.0028, 6.89078}}, color = {85, 170, 255}, thickness = 1, smooth = Smooth.Bezier), Rectangle(origin = {-60, 60}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Polygon(origin = {-55, 60}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, points = {{-4.563, 3.6504}, {-4.563, 7.9092}, {-1.521, 14.6016}, {2.1294, 18.252}, {3.9546, 17.6436}, {4.563, 15.8184}, {4.563, 10.3428}, {0.3042, 3.6504}, {0.3042, -3.6504}, {4.563, -10.3428}, {4.563, -15.8184}, {3.9546, -17.6436}, {2.1294, -18.252}, {-1.521, -14.6016}, {-4.563, -7.9092}, {-4.563, 3.6504}}, smooth = Smooth.Bezier), Rectangle(origin = {-69, 60}, fillColor = {200, 200, 200}, fillPattern = FillPattern.CrossDiag, extent = {{-8, 3}, {8, -3}}), Polygon(origin = {-52, 60}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-10.336, 4.252}, {-10.336, -4.252}, {-0.874, -4.252}, {2.252, -2.168}, {2.336, -2.084}, {2.336, 0.084}, {2.252, 2.168}, {-0.874, 4.252}, {-10.336, 4.252}}), Ellipse(origin = {-57.5, 60}, rotation = 45, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-1, 6}, {1, -6}}), Rectangle(origin = {-60, -60}, lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-20, -20}, {20, 20}}), Polygon(origin = {-29, -78}, fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, points = {{-35, 18}, {-35, 4}, {-25, 4}, {-19, 30}, {-33, 30}, {-33, 22}, {-31, 22}, {-31, 18}, {-35, 18}}), Polygon(origin = {-70, -22}, points = {{6, -38}, {10, -38}, {10, -34}, {8, -34}, {8, -24}, {6, -24}, {6, -38}}), Ellipse(origin = {60, 0}, fillColor = {198, 198, 198}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}}), Ellipse(origin = {60, 0}, fillColor = {98, 98, 98}, fillPattern = FillPattern.Solid, extent = {{-2, 2}, {2, -2}}), Polygon(origin = {65, 5}, rotation = -45, fillPattern = FillPattern.Solid, points = {{-1.5, -5.9}, {-0.1, -7.5}, {1.3, -5.9}, {-0.1, 7.5}, {-1.5, -5.9}}), Line(origin = {60, 13}, points = {{0, 3}, {0, -3}, {0, -3}}), Line(origin = {47, 0}, points = {{-3, 0}, {3, 0}}), Line(origin = {73, 0}, points = {{3, 0}, {-3, 0}}), Line(origin = {50, 8}, points = {{-2, 2}, {2, -2}}), Line(origin = {70, 8}, points = {{2, 2}, {-2, -2}, {-2, -2}}), Line(origin = {89, 0}, points = {{-11, 0}, {11, 0}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {89, 31}, points = {{-11, -29}, {1, -29}, {1, 29}, {11, 29}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {89, -32}, points = {{-11, 30}, {1, 30}, {1, -28}, {11, -28}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {63, -56}, points = {{1, 40}, {1, 30}, {1, -28}, {1, -44}}, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-1, -56}, points = {{59, 38}, {59, -28}, {1, -28}, {1, -44}}, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(extent = {{-220, -200}, {140, 150}})),
        Documentation(info = "<html><head></head><body><h1>Aquanaut.PathFollowing.OpenLoop Model Specification</h1>
                  <p>This model represents an open-loop vessel dynamic system, integrating hydrodynamic forces, marine propulsion, steering systems, and environment state sensors.</p>
                  
                  <h2>1. Model Parameters</h2>
                  <p>The configuration parameters defined at the top level of the model control the filtering frequencies and constraints for actuators:</p>
                  <table border=\"1\">
                    <tbody><tr style=\"background-color:#f2f2f2;font-weight:bold;text-align:left;\">
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
                  </tbody></table>
                  
                  <h2>2. Component Architecture (Submodels)</h2>
                  <h3>2.1 Ship Parts &amp; Hydrodynamics</h3>
                  <ul>
                    <li><strong>hull</strong> (Aquanaut.ShipParts.Hull): Defines structural mass (4484.75 kg) and inertia properties.</li>
                    <li><strong>buoyancy</strong> (Aquanaut.HydroForces.BuoyancyInterpolation): Hydrostatic calculations utilizing 3D shape meshes.</li>
                    <li><strong>viscous</strong> (Aquanaut.HydroForces.Viscous): Linear/angular fluid damping coefficients.</li>
                    <li><strong>Stream</strong> (Aquanaut.HydroForces.Stream): Current field field with a mean velocity of 1.0 m/s.</li>
                  </ul>
                  
                  <h3>2.2 Actuation &amp; Propulsion</h3>
                  <ul>
                    <li><strong>marinePropeller</strong> (Aquanaut.ShipParts.MarinePropeller): Computes thrust forces utilizing slipstream and localized wake fraction.</li>
                    <li><strong>speed</strong> (Modelica.Mechanics.Rotational.Sources.Speed): Actuates propeller shaft rotation.</li>
                    <li><strong>marineRudder</strong> (Aquanaut.ShipParts.MarineRudder): Steering forces constrained by rudderMaxAngle.</li>
                  </ul>
                  
                  <h3>2.3 Interface Blocks &amp; Kinematics</h3>
                  <ul>
                    <li><strong>Inputs:</strong> propellerSpeed, rudderAngle.</li>
                    <li><strong>Outputs:</strong> Vector array outputs p[6], v[6], a[6].</li>
                    <li><strong>Sensors:</strong> worldSensor and boatSensor extract spatial kinematics.</li>
                  </ul>
                  
                  <h2>3. Equation &amp; Interconnection Network</h2>
                  <ul>
                    <li><strong>Propulsion &amp; Steering Line:</strong> Extends connection from speed source to propeller shaft. Propeller wake variables map to rudder inputs to compute flow velocity amplification over steering fins.</li>
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
                  </body></html>", __OpenModelica_infoHeader = "<html><head></head><body></body></html>"));
    end OT1Model;
    
    model ClosedLoopHiL
      // Parameters for Closed Loop
      // Path Following Control
      parameter Real pfKp = 0.045853;
      parameter Real pfKi = 0.000238;
      parameter Real pfKd = 0.532628;
      parameter Real rudK = 1.0;
      // Velocity Control
      parameter Real Uref = 3.0;
      parameter Real vKp = 1;
      parameter Real vKi = 2;
      parameter Real vKd = 0.1;
      // Serret-Frenet
      parameter Modelica.Units.SI.Distance Delta = 10.117;
      parameter Real Wp0x = -5000.0;
      parameter Real Wp0y = -10;
      parameter Real Wp1x = 5000.0;
      parameter Real Wp1y = -10;
      //parameter Real Wp0x = -10;
      //parameter Real Wp0y = -5000.0;
      //parameter Real Wp1x = -10;
      //parameter Real Wp1y = 5000.0;
      // Initialization
      parameter Real initTol = 0.01;
      parameter Real opDelay = 1;
      // Blocks
      Aquanaut.HiL.FinalModels.OT1Model2 OT1model annotation(
        Placement(transformation(origin = {228, -4}, extent = {{-30, -30}, {30, 30}})));
      Aquanaut.PathFollowing.SerretFrenetModel serretFrenet(Wp = [Wp0x, Wp0y; Wp1x, Wp1y], deltaLOS = Delta) annotation(
        Placement(transformation(origin = {-271.125, -11.2663}, extent = {{-44.875, -23.9334}, {44.875, 23.9334}})));
      Modelica.Blocks.Logical.Switch switch_v_ref annotation(
        Placement(transformation(origin = {40, 86}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.PID PID_velocity(Ti = vKp/vKi, Td = vKd/vKp, k = vKp) annotation(
        Placement(transformation(origin = {142, 80}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Constant u_op(k = Uref) annotation(
        Placement(transformation(origin = {44, 138}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Math.Add v_e(k2 = -1) annotation(
        Placement(transformation(origin = {70, 80}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.And and_buo annotation(
        Placement(transformation(origin = {-120, 116}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Math.Abs abs_az annotation(
        Placement(transformation(origin = {-214, 116}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Math.Abs abs_daz annotation(
        Placement(transformation(origin = {-214, 82}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.LessThreshold th_daz(threshold = initTol) annotation(
        Placement(transformation(origin = {-178, 82}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.LessThreshold th_az(threshold = initTol) annotation(
        Placement(transformation(origin = {-178, 116}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.1) annotation(
        Placement(transformation(origin = {102, 80}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.Derivative der_az annotation(
        Placement(transformation(origin = {-246, 82}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
      Modelica.Blocks.Logical.RSFlipFlop buoFF annotation(
        Placement(transformation(origin = {-22, 110}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
        Placement(transformation(origin = {-86, 96}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.Switch switch_chi_sf annotation(
        Placement(transformation(origin = {-2, -66}, extent = {{-10, -10}, {10, 10}})));
      Aquanaut.PathFollowing.PF_Controller pf_Controller(Kp = pfKp, Ki = pfKi, Kd = pfKd) annotation(
        Placement(transformation(origin = {85.4, -79.7692}, extent = {{-60.4, -23.2308}, {60.4, 23.2308}})));
      Modelica.Blocks.Sources.Constant zero_ref(k = 0) annotation(
        Placement(transformation(origin = {-51, -79}, extent = {{-5, -5}, {5, 5}})));
      Modelica.Blocks.Logical.Switch switch_chi_d annotation(
        Placement(transformation(origin = {-2, -92}, extent = {{-10, 10}, {10, -10}})));
      Modelica.Blocks.Math.Abs abs_ax annotation(
        Placement(transformation(origin = {-274, -138}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.LessThreshold th_ax(threshold = initTol) annotation(
        Placement(transformation(origin = {-236, -138}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Math.Gain controlAlocationGain(k = rudK) annotation(
        Placement(transformation(origin = {162, -80}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.Derivative der_ax annotation(
        Placement(transformation(origin = {-312, -106}, extent = {{10, 10}, {-10, -10}}, rotation = -180)));
      Modelica.Blocks.Logical.LessThreshold th_dax(threshold = initTol) annotation(
        Placement(transformation(origin = {-244, -106}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.And and_op annotation(
        Placement(transformation(origin = {-196, -118}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.RSFlipFlop opFF annotation(
        Placement(transformation(origin = {-100, -80}, extent = {{-10, 10}, {10, -10}})));
      Modelica.Blocks.Math.Abs abs_dax annotation(
        Placement(transformation(origin = {-280, -106}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.LogicalDelay logicalDelay(delayTime = opDelay) annotation(
        Placement(transformation(origin = {-188, -76}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Logical.And and_delay annotation(
        Placement(transformation(origin = {-142, -86}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput x annotation(
        Placement(transformation(origin = {461, 154}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {276, 32}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput y annotation(
        Placement(transformation(origin = {461, 134}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {276, 32}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput z annotation(
        Placement(transformation(origin = {461, 114}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {282, -90}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput thetaz annotation(
        Placement(transformation(origin = {460, -172}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {322, -168}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput omegaz annotation(
        Placement(transformation(origin = {460, -23}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {354, -184}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput rudderFeedback annotation(
        Placement(transformation(origin = {460, -195}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {370, -218}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput propellerFeedback annotation(
        Placement(transformation(origin = {460, -215}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {360, -256}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput SOG annotation(
        Placement(transformation(origin = {460, 23}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {287, 73}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput COG annotation(
        Placement(transformation(origin = {460, 1}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {294, 44}, extent = {{-10, -10}, {10, 10}})));
      Aquanaut.Utils.Wgs84ToLocalPositionPure wgs84ToLocalPositionPure(originLatitudeDeg = -22.734233, originLongitudeDeg = -43.085687) annotation(
        Placement(transformation(origin = {-355, 3}, extent = {{-10, -10}, {10, 10}})));
      Aquanaut.Utils.SOGAndCOGToVelocity sOGAndCOGToVelocity annotation(
        Placement(transformation(origin = {-355, -25}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.Derivative derivative(T = 0.01) annotation(
        Placement(transformation(origin = {-352, -107}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.Derivative derivative1(T = 0.05) annotation(
        Placement(transformation(origin = {-296, 116}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Continuous.Derivative derivative11(T = 0.01) annotation(
        Placement(transformation(origin = {-335, 116}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(switch_v_ref.y, v_e.u1) annotation(
        Line(points = {{51, 86}, {58, 86}}, color = {0, 0, 127}));
      connect(v_e.y, firstOrder.u) annotation(
        Line(points = {{81, 80}, {89, 80}}, color = {0, 0, 127}));
      connect(firstOrder.y, PID_velocity.u) annotation(
        Line(points = {{113, 80}, {130, 80}}, color = {0, 0, 127}));
      connect(and_buo.y, buoFF.S) annotation(
        Line(points = {{-109, 116}, {-34, 116}}, color = {255, 0, 255}));
      connect(booleanConstant.y, buoFF.R) annotation(
        Line(points = {{-75, 96}, {-59.5, 96}, {-59.5, 104}, {-34, 104}}, color = {255, 0, 255}));
      connect(buoFF.Q, switch_v_ref.u2) annotation(
        Line(points = {{-11, 116}, {10.5, 116}, {10.5, 86}, {28, 86}}, color = {255, 0, 255}));
      connect(der_az.y, abs_daz.u) annotation(
        Line(points = {{-235, 82}, {-227, 82}}, color = {0, 0, 127}));
      connect(u_op.y, switch_v_ref.u1) annotation(
        Line(points = {{55, 138}, {63.5, 138}, {63.5, 116}, {16, 116}, {16, 94}, {28, 94}}, color = {0, 0, 127}));
      connect(abs_ax.y, th_ax.u) annotation(
        Line(points = {{-263, -138}, {-249, -138}}, color = {0, 0, 127}));
      connect(pf_Controller.r_d, controlAlocationGain.u) annotation(
        Line(points = {{135, -80}, {150, -80}}, color = {0, 0, 127}));
      connect(th_dax.y, and_op.u1) annotation(
        Line(points = {{-233, -106}, {-217, -106}, {-217, -117.25}, {-209, -117.25}, {-209, -118}}, color = {255, 0, 255}));
      connect(th_ax.y, and_op.u2) annotation(
        Line(points = {{-225, -138}, {-218, -138}, {-218, -126}, {-209, -126}}, color = {255, 0, 255}));
      connect(opFF.R, booleanConstant.y) annotation(
        Line(points = {{-112, -74}, {-112, -73}, {-122, -73}, {-122, -44}, {-62, -44}, {-62, 96}, {-75, 96}}, color = {255, 0, 255}));
      connect(opFF.Q, switch_chi_sf.u2) annotation(
        Line(points = {{-89, -86}, {-70, -86}, {-70, -66}, {-14, -66}}, color = {255, 0, 255}));
      connect(switch_chi_d.u2, opFF.Q) annotation(
        Line(points = {{-14, -92}, {-70, -92}, {-70, -86}, {-89, -86}}, color = {255, 0, 255}));
      connect(der_ax.y, abs_dax.u) annotation(
        Line(points = {{-301, -106}, {-293, -106}}, color = {0, 0, 127}));
      connect(abs_dax.y, th_dax.u) annotation(
        Line(points = {{-269, -106}, {-257, -106}}, color = {0, 0, 127}));
      connect(logicalDelay.y2, and_delay.u1) annotation(
        Line(points = {{-177, -82}, {-167, -82}, {-167, -86}, {-155, -86}}, color = {255, 0, 255}));
      connect(and_op.y, and_delay.u2) annotation(
        Line(points = {{-185, -118}, {-169, -118}, {-169, -94}, {-155, -94}}, color = {255, 0, 255}));
      connect(and_delay.y, opFF.S) annotation(
        Line(points = {{-131, -86}, {-113, -86}}, color = {255, 0, 255}));
      connect(serretFrenet.U, v_e.u2) annotation(
        Line(points = {{-229, -1}, {52, -1}, {52, 74}, {58, 74}}, color = {0, 0, 127}));
      connect(serretFrenet.U, switch_v_ref.u3) annotation(
        Line(points = {{-229, -1}, {18, -1}, {18, 78}, {28, 78}}, color = {0, 0, 127}));
      connect(controlAlocationGain.y, OT1model.rudderAngle) annotation(
        Line(points = {{173, -80}, {188, -80}, {188, -10}, {214, -10}}, color = {0, 0, 127}));
      connect(PID_velocity.y, OT1model.propellerSpeed) annotation(
        Line(points = {{154, 80}, {180, 80}, {180, 11}, {214, 11}}, color = {0, 0, 127}));
      connect(buoFF.Q, logicalDelay.u) annotation(
        Line(points = {{-10, 116}, {-8, 116}, {-8, 24}, {-204, 24}, {-204, -76}, {-200, -76}}, color = {255, 0, 255}));
      connect(zero_ref.y, switch_chi_d.u3) annotation(
        Line(points = {{-45.5, -79}, {-30.5, -79}, {-30.5, -84}, {-14, -84}}, color = {0, 0, 127}));
      connect(zero_ref.y, switch_chi_sf.u3) annotation(
        Line(points = {{-45.5, -79}, {-30, -79}, {-30, -74}, {-14, -74}}, color = {0, 0, 127}));
      connect(switch_chi_sf.u1, serretFrenet.chi_sf) annotation(
        Line(points = {{-14, -58}, {-20, -58}, {-20, -12}, {-229, -12}}, color = {0, 0, 127}));
      connect(switch_chi_d.u1, serretFrenet.chi_d) annotation(
        Line(points = {{-14, -100}, {-24, -100}, {-24, -24}, {-229, -24}}, color = {0, 0, 127}));
      connect(switch_chi_d.y, pf_Controller.chi_d) annotation(
        Line(points = {{10, -92}, {29, -92}}, color = {0, 0, 127}));
      connect(switch_chi_sf.y, pf_Controller.chi_SF) annotation(
        Line(points = {{10, -66}, {18, -66}, {18, -67}, {29, -67}}, color = {0, 0, 127}));
      connect(abs_daz.y, th_daz.u) annotation(
        Line(points = {{-202, 82}, {-190, 82}}, color = {0, 0, 127}));
      connect(abs_az.y, th_az.u) annotation(
        Line(points = {{-202, 116}, {-190, 116}}, color = {0, 0, 127}));
      connect(th_az.y, and_buo.u1) annotation(
        Line(points = {{-166, 116}, {-132, 116}}, color = {255, 0, 255}));
      connect(th_daz.y, and_buo.u2) annotation(
        Line(points = {{-166, 82}, {-142, 82}, {-142, 108}, {-132, 108}}, color = {255, 0, 255}));
      connect(propellerFeedback, OT1model.PropellerFeedback_rad_s) annotation(
        Line(points = {{460, -215}, {222, -215}, {222, -20}}, color = {0, 0, 127}));
      connect(OT1model.COG, COG) annotation(
        Line(points = {{254, 0}, {460, 0}, {460, 1}}, color = {0, 0, 127}));
      connect(OT1model.SOG, SOG) annotation(
        Line(points = {{254, 10}, {440, 10}, {440, 23}, {460, 23}}, color = {0, 0, 127}));
      connect(OT1model.rudderFeedback_rad, rudderFeedback) annotation(
        Line(points = {{235, -20}, {235, -195}, {460, -195}}, color = {0, 0, 127}));
      connect(OT1model.Longitude, y) annotation(
        Line(points = {{235, 20}, {234, 20}, {234, 134}, {461, 134}}, color = {0, 0, 127}));
      connect(OT1model.Latitude, x) annotation(
        Line(points = {{221, 20}, {221, 154}, {461, 154}}, color = {0, 0, 127}));
      connect(wgs84ToLocalPositionPure.northM, serretFrenet.x) annotation(
        Line(points = {{-343, 7}, {-313, 7}, {-313, 6}}, color = {0, 0, 127}));
      connect(wgs84ToLocalPositionPure.eastM, serretFrenet.y) annotation(
        Line(points = {{-343, -1}, {-313, -1}, {-313, -3}}, color = {0, 0, 127}));
      connect(OT1model.Latitude, wgs84ToLocalPositionPure.latitudeDeg) annotation(
        Line(points = {{221, 20}, {221, 176}, {-373, 176}, {-373, 7}, {-367, 7}}, color = {0, 0, 127}));
      connect(OT1model.Longitude, wgs84ToLocalPositionPure.longitudeDeg) annotation(
        Line(points = {{235, 20}, {234, 20}, {234, 181}, {-378, 181}, {-378, -1}, {-367, -1}}, color = {0, 0, 127}));
      connect(sOGAndCOGToVelocity.sog_m_s, OT1model.SOG) annotation(
        Line(points = {{-366, -19}, {-385, -19}, {-385, -180}, {266, -180}, {266, 10}, {254, 10}}, color = {0, 0, 127}));
      connect(sOGAndCOGToVelocity.cog_rad, OT1model.COG) annotation(
        Line(points = {{-366, -32}, {-382, -32}, {-382, -176}, {272, -176}, {272, 0}, {254, 0}}, color = {0, 0, 127}));
      connect(sOGAndCOGToVelocity.vel_n_m_s, derivative.u) annotation(
        Line(points = {{-344, -19}, {-339, -19}, {-339, -72}, {-375, -72}, {-375, -107}, {-364, -107}}, color = {0, 0, 127}));
      connect(derivative.y, der_ax.u) annotation(
        Line(points = {{-341, -107}, {-323, -107}, {-323, -106}, {-324, -106}}, color = {0, 0, 127}));
      connect(derivative.y, abs_ax.u) annotation(
        Line(points = {{-341, -107}, {-337, -107}, {-337, -138}, {-286, -138}}, color = {0, 0, 127}));
      connect(derivative1.y, abs_az.u) annotation(
        Line(points = {{-285, 116}, {-226, 116}}, color = {0, 0, 127}));
      connect(derivative1.y, der_az.u) annotation(
        Line(points = {{-285, 116}, {-275, 116}, {-275, 82}, {-258, 82}}, color = {0, 0, 127}));
      connect(derivative11.y, derivative1.u) annotation(
        Line(points = {{-324, 116}, {-308, 116}}, color = {0, 0, 127}));
      connect(derivative11.u, OT1model.Altitude) annotation(
        Line(points = {{-347, 116}, {-368, 116}, {-368, 168}, {247, 168}, {247, 20}}, color = {0, 0, 127}));
      connect(sOGAndCOGToVelocity.vel_n_m_s, serretFrenet.vx) annotation(
        Line(points = {{-344, -19}, {-323, -19}, {-323, -21}, {-313, -21}}, color = {0, 0, 127}));
      connect(sOGAndCOGToVelocity.vel_e_m_s, serretFrenet.vy) annotation(
        Line(points = {{-344, -32}, {-323, -32}, {-323, -30}, {-313, -30}}, color = {0, 0, 127}));
      connect(OT1model.Altitude, z) annotation(
        Line(points = {{247, 20}, {247, 114}, {461, 114}}, color = {0, 0, 127}));
      connect(OT1model.Rate_of_Turn, omegaz) annotation(
        Line(points = {{254, -10}, {441, -10}, {441, -23}, {460, -23}}, color = {0, 0, 127}));
      connect(OT1model.Heading, thetaz) annotation(
        Line(points = {{246, -20}, {246, -172}, {460, -172}}, color = {0, 0, 127}));
      connect(serretFrenet.psi, OT1model.Heading) annotation(
        Line(points = {{-313, -12}, {-388, -12}, {-388, -184}, {246, -184}, {246, -20}}, color = {0, 0, 127}));
      annotation(
        experiment(StartTime = 0, StopTime = 250, Tolerance = 1e-06, Interval = 0.02),
        __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental -d=fmuExperimental",
        __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "euler", variableFilter = ".*"),
        Diagram(coordinateSystem(extent = {{-400, -250}, {450, 200}}, grid = {1, 1}), graphics = {Rectangle(origin = {-133, 95}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-133, 73}, {133, -73}}), Text(origin = {-196, 162}, extent = {{-68, 6}, {68, -6}}, textString = "Buoyancy stead-state analysis", textStyle = {TextStyle.Bold}), Rectangle(origin = {-199, -109}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-133, 63}, {133, -63}}), Text(origin = {-247, -52}, extent = {{-81, 6}, {81, -6}}, textString = "Operation Point stead-state analysis", textStyle = {TextStyle.Bold}), Rectangle(origin = {90, 108}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-78, 62}, {78, -62}}), Text(origin = {64, 164}, extent = {{-48, 6}, {48, -6}}, textString = "Velocity Control", textStyle = {TextStyle.Bold}), Rectangle(origin = {84, -82}, pattern = LinePattern.Dash, lineThickness = 0.75, extent = {{-112, 38}, {112, -38}}), Text(origin = {82, -112}, extent = {{-48, 6}, {48, -6}}, textString = "Path Following Control", textStyle = {TextStyle.Bold}), Text(origin = {169, 1}, extent = {{-38, 8}, {38, -8}}, textString = "OT1 model", textStyle = {TextStyle.Bold}), Text(origin = {-98, 5}, extent = {{-36, -3}, {36, 3}}, textString = "body velocity", textStyle = {TextStyle.Italic}), Text(origin = {-98, -7}, extent = {{-36, -3}, {36, 3}}, textString = "chi_sf", textStyle = {TextStyle.Italic}), Text(origin = {-98, -19}, extent = {{-36, -3}, {36, 3}}, textString = "chi_d", textStyle = {TextStyle.Italic}), Text(origin = {206, 85}, extent = {{-36, -3}, {36, 3}}, textString = "propeller speed", textStyle = {TextStyle.Italic}, horizontalAlignment = TextAlignment.Left), Text(origin = {191, -37}, extent = {{-36, -3}, {36, 3}}, textString = "rudder angle", textStyle = {TextStyle.Italic}, horizontalAlignment = TextAlignment.Left)}),
        Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-100, 100}, {100, -100}}), Rectangle(origin = {60, 30}, lineThickness = 1, extent = {{-20, 20}, {20, -20}}), Rectangle(origin = {-28, 30}, lineThickness = 1, extent = {{-36, 20}, {36, -20}}), Text(origin = {-28, 31}, extent = {{-28, 7}, {28, -7}}, textString = "Controller", textStyle = {TextStyle.UnderLine}), Text(origin = {60, 31}, extent = {{-14, 7}, {14, -7}}, textString = "OT1", textStyle = {TextStyle.UnderLine}), Rectangle(origin = {8, -37}, lineThickness = 1, extent = {{-36, 21}, {36, -21}}), Text(origin = {8, -35}, extent = {{-28, 7}, {28, -7}}, textString = "Serret-Frenèt", textStyle = {TextStyle.UnderLine}), Line(origin = {52, -15}, points = {{8, 25}, {8, -23}, {-8, -23}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-55, -3}, points = {{27, -35}, {-27, -35}, {-27, 33}, {-9, 33}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {24, 30}, points = {{-16, 0}, {16, 0}}, thickness = 0.75, arrow = {Arrow.None, Arrow.Filled})}, coordinateSystem(extent = {{-400, -250}, {450, 200}}, grid = {1, 1})),
        Documentation(info = "<html><head>
                                            </head>
                                            <body>
                                            <h1>Closed-Loop Path Following Control System</h1>
                                            
                                            <p>
                                              The <em>ClosedLoop</em> model serves as the top-level integration system architecture for the autonomous vehicle model. It pairs an Open-Loop vehicle plant model with look-ahead guidance formulas, velocity regulations, and path-following controllers to build a fully automated, closed-loop navigation infrastructure.
                                            </p>
                                            
                                            <h2>Description</h2>
                                            
                                            <p>
                                              This assembly establishes path trajectory tracking over a waypoint path segment. It features two continuous-time control loops: a <strong>Velocity Controller</strong> that uses a PID layout to adjust propeller speed toward a given velocity target (<code>Uref</code>), and a <strong>Path-Following Controller</strong> that relies on look-ahead angles to determine required rudder angles. 
                                            </p>
                                            <p>
                                              Furthermore, the system embeds state logic configurations (using flip-flops, thresholds, and logic delays) to execute real-time steady-state checks on buoyancy states (Z-axis checks) and initial operating points (X-axis checks), holding back full steering actuation until structural dynamics satisfy the specified initial tolerances.
                                            </p>
                                            
                                            <h2>Parameters</h2>
                                            
                                            <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
                                              <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the ClosedLoop integration model</caption>
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
                                                  <td><strong>pfKp, pfKi, pfKd</strong></td>
                                                  <td>Real</td>
                                                  <td>Varies</td>
                                                  <td>Proportional, Integral, and Derivative gain tunings for the trajectory path-following loop.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>rudK</strong></td>
                                                  <td>Real</td>
                                                  <td>-</td>
                                                  <td>Static scaling coefficient for the final rudder command mapping.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>Uref</strong></td>
                                                  <td>Real</td>
                                                  <td>m/s</td>
                                                  <td>Target cruise reference velocity parameter for the vessel.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>vKp, vKi, vKd</strong></td>
                                                  <td>Real</td>
                                                  <td>Varies</td>
                                                  <td>Proportional, Integral, and Derivative gain tunings for the speed controller loop.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>Delta</strong></td>
                                                  <td>Distance</td>
                                                  <td>m</td>
                                                  <td>Look-ahead baseline distance utilized inside the Serret-Frenet block.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>Wp0x, Wp0y</strong></td>
                                                  <td>Real</td>
                                                  <td>m</td>
                                                  <td>Coordinates for the initial waypoint vector (origin boundary).</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>Wp1x, Wp1y</strong></td>
                                                  <td>Real</td>
                                                  <td>m</td>
                                                  <td>Coordinates for the final waypoint vector (destination boundary).</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>initTol</strong></td>
                                                  <td>Real</td>
                                                  <td>-</td>
                                                  <td>Numeric convergence error boundary threshold for state-check logic.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>opDelay</strong></td>
                                                  <td>Real</td>
                                                  <td>s</td>
                                                  <td>Time-delay filter length used to guarantee operational point stabilization.</td>
                                                </tr>
                                              </tbody>
                                            </table>
                                            
                                            <h2>Key Internal Sub-components</h2>
                                            
                                            <table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
                                              <caption align=\"bottom\"><strong>Tab. 2:</strong> Primary internal block component identifiers</caption>
                                              <thead>
                                                <tr bgcolor=\"#f2f2f2\">
                                                  <th>Instance Name</th>
                                                  <th>Model Class Type</th>
                                                  <th>Primary Functional Duty</th>
                                                </tr>
                                              </thead>
                                              <tbody>
                                                <tr>
                                                  <td><strong>OT1model</strong></td>
                                                  <td>OpenLoop</td>
                                                  <td>Represents the physical multi-degree-of-freedom core vehicle plant dynamics.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>serretFrenet</strong></td>
                                                  <td>SerretFrenetModel</td>
                                                  <td>Translates global positions into tracking error vectors based on a target line segment.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>PID_velocity</strong></td>
                                                  <td>Modelica.Blocks.Continuous.PID</td>
                                                  <td>Regulates velocity error signals into physical propeller speed commands.</td>
                                                </tr>
                                                <tr>
                                                  <td><strong>pf_Controller</strong></td>
                                                  <td>PF_Controller</td>
                                                  <td>Calculates precise steering corrections based on angular errors.</td>
                                                </tr>
                                              </tbody>
                                            </table>
                                            
                                            <h2>System Operation and Interconnections</h2>
                                            
                                            <p>
                                              The system orchestrates multi-loop tracking and control sequences using the following routing criteria:
                                            </p>
                                            <ul>
                                              <li><strong>Velocity Error Loop:</strong> Gathers total velocity <code>U</code> from the Serret-Frenet block, extracts its difference relative to the reference node (or logic switches), dampens it via a <code>FirstOrder</code> block filter, and triggers <code>PID_velocity</code> to spin the physical propellers.</li>
                                              <li><strong>Path Steering Loop:</strong> Maps position states (<code>p[1]</code>, <code>p[2]</code>) and velocity components (<code>v[1]</code>, <code>v[2]</code>) into the Serret-Frenet framework. Resulting values for tracking profiles (<code>chi_sf</code>, <code>chi_d</code>) traverse safety logic switches to drive the <code>pf_Controller</code>, which sets rudder orientation through <code>controlAlocationGain</code>.</li>
                                              <li><strong>Buoyancy &amp; Operating Point Interlocks:</strong> Monitors the absolute values and derivatives of vehicle accelerations (<code>a[1]</code> on X-axis and <code>a[3]</code> on Z-axis). Flip-flops prevent reference angles from switching to active modes until transitional oscillations decay below the specified <code>initTol</code>.</li>
                                            </ul>
                                            
                                            </body></html>"));
    end ClosedLoopHiL;
  end Models;

  package Utils
    block Wgs84ToLocalPositionPure "Pure Modelica utility block converting WGS84 Geodetic Lat/Lon degrees to local North/East Cartesian meters"
      // Configurable reference origin geodetic parameters
      parameter Real originLatitudeDeg(unit = "deg") = 0 "Geodetic latitude coordinate of the local reference origin [deg]";
      parameter Real originLongitudeDeg(unit = "deg") = 0 "Geodetic longitude coordinate of the local reference origin [deg]";
      // Real Input Ports: Global WGS84 geodetic coordinates
      Modelica.Blocks.Interfaces.RealInput latitudeDeg(unit = "deg") "Input WGS84 latitude [deg]" annotation(
        Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));
      Modelica.Blocks.Interfaces.RealInput longitudeDeg(unit = "deg") "Input WGS84 longitude [deg]" annotation(
        Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));
      // Real Output Ports: Local Cartesian displacements
      Modelica.Blocks.Interfaces.RealOutput northM(unit = "m") "Output local North displacement [m]" annotation(
        Placement(transformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));
      Modelica.Blocks.Interfaces.RealOutput eastM(unit = "m") "Output local East displacement [m]" annotation(
        Placement(transformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}})));
    protected
      // Mathematical conversion constants
      constant Real pi = Modelica.Constants.pi "Mathematical constant Pi";
      constant Real degToRad = pi/180 "Conversion factor from degrees to radians";
      // WGS84 Ellipsoid constants
      constant Real semiMajorAxisM = 6378137.0 "WGS84 ellipsoid semi-major axis (a) [m]";
      constant Real flattening = 1/298.257223563 "WGS84 ellipsoid flattening (f)";
      constant Real eccentricitySquared = flattening*(2 - flattening) "First eccentricity squared (e^2)";
      // Intermediate variables
      Real originLatitudeRad(unit = "rad") "Origin latitude converted to radians";
      Real originLongitudeRad(unit = "rad") "Origin longitude converted to radians";
      Real latitudeRad(unit = "rad") "Input latitude converted to radians";
      Real longitudeRad(unit = "rad") "Input longitude converted to radians";
      Real sinLatitude "Sine of the origin latitude";
      Real curvatureFactor "Auxiliary WGS84 curvature term";
      Real meridionalRadiusM(unit = "m") "Meridional radius of curvature at origin latitude";
      Real transverseRadiusM(unit = "m") "Prime vertical radius of curvature at origin latitude";
    equation
    // Convert geographic coordinates from degrees to radians
      originLatitudeRad = originLatitudeDeg*degToRad;
      originLongitudeRad = originLongitudeDeg*degToRad;
      latitudeRad = latitudeDeg*degToRad;
      longitudeRad = longitudeDeg*degToRad;
    // Compute WGS84 curvature terms at the configured origin
      sinLatitude = sin(originLatitudeRad);
      curvatureFactor = sqrt(1 - eccentricitySquared*sinLatitude*sinLatitude);
    // Meridional radius of curvature
      meridionalRadiusM = semiMajorAxisM*(1 - eccentricitySquared)/curvatureFactor^3;
    // Prime vertical radius of curvature
      transverseRadiusM = semiMajorAxisM/curvatureFactor;
    // Inverse transformation of localNorthEastToWgs84Pure
      northM = (latitudeRad - originLatitudeRad)*meridionalRadiusM;
      eastM = (longitudeRad - originLongitudeRad)*transverseRadiusM*cos(originLatitudeRad);
      annotation(
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(lineColor = {0, 75, 140}, fillColor = {143, 240, 164}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, -52}, extent = {{-84, 72}, {84, 32}}, textString = "WGS84
    Lat/Lon
    to North/East"), Text(extent = {{42, 56}, {96, 26}}, textString = "N [m]", horizontalAlignment = TextAlignment.Right), Text(extent = {{42, -26}, {96, -56}}, textString = "E [m]", horizontalAlignment = TextAlignment.Right), Text(origin = {-124, 22}, extent = {{26, 26}, {60, 12}}, textString = "Lat [deg]", horizontalAlignment = TextAlignment.Right), Text(origin = {-122, -58}, extent = {{26, 26}, {60, 12}}, textString = "Lon [deg]", horizontalAlignment = TextAlignment.Right)}),
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
    
    block SOGAndCOGToVelocity "Converts Speed Over Ground and Course Over Ground into North and East velocity components"
      import Modelica.Math;
      // Input Definitions
      Modelica.Blocks.Interfaces.RealInput sog_m_s(unit = "m/s") "Speed Over Ground [m/s]" annotation(
        Placement(transformation(extent = {{-120, 30}, {-80, 70}}), iconTransformation(origin = {-48, 30.5}, extent = {{-78, 19.5}, {-52, 45.5}})));
      Modelica.Blocks.Interfaces.RealInput cog_rad(unit = "rad") "Course Over Ground referenced to North [rad]" annotation(
        Placement(transformation(extent = {{-120, -70}, {-80, -30}}), iconTransformation(origin = {-44, -31}, extent = {{-84, -49}, {-56, -21}})));
      // Output Definitions
      Modelica.Blocks.Interfaces.RealOutput vel_n_m_s(unit = "m/s") "North velocity [m/s]" annotation(
        Placement(transformation(extent = {{80, 30}, {120, 70}}), iconTransformation(origin = {44, 25}, extent = {{56, 21}, {84, 49}})));
      Modelica.Blocks.Interfaces.RealOutput vel_e_m_s(unit = "m/s") "East velocity [m/s]" annotation(
        Placement(transformation(extent = {{80, -70}, {120, -30}}), iconTransformation(origin = {44, -37}, extent = {{56, -49}, {84, -21}})));
    equation
    // North velocity component
      vel_n_m_s = sog_m_s*Math.cos(cog_rad);
    // East velocity component
      vel_e_m_s = sog_m_s*Math.sin(cog_rad);
      annotation(
        Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {38, 162, 105}, fillPattern = FillPattern.Solid, borderPattern = BorderPattern.Raised, extent = {{-100, 100}, {100, -100}}), Text(origin = {2, -2}, textColor = {255, 255, 255}, extent = {{-70, 56}, {70, -56}}, textString = "SOG and COG
    to Velocity"), Text(origin = {-66, 65}, textColor = {255, 255, 255}, extent = {{-30, 19}, {30, -19}}, textString = "SOG"), Text(origin = {-66, -65}, textColor = {255, 255, 255}, extent = {{-30, 19}, {30, -19}}, textString = "COG"), Text(origin = {72, 60}, textColor = {255, 255, 255}, extent = {{-24, 8}, {24, -8}}, textString = "Vel_north"), Text(origin = {72, -72}, textColor = {255, 255, 255}, extent = {{-24, 8}, {24, -8}}, textString = "Vel_east")}),
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
  end Utils;

  package Equipment
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
      (latitudeRaw, longitudeRaw) = Aquanaut.Functions.localNorthEastToWgs84Pure(originLatitudeDeg, originLongitudeDeg, worldSensor.r[1], worldSensor.r[2]);
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
  end Equipment;
end UpdatedPackage15_09;

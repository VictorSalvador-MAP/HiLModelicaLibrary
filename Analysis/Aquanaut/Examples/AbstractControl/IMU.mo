within Aquanaut.Examples.AbstractControl;

model IMU "Inertial Measurement Unit mounting configuration"
  import SI = Modelica.Units.SI;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(Placement(visible = true, transformation(origin = {-121, -50}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {0, -20}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation fixedTranslation1(r = IMUPos, animation = false) annotation(Placement(visible = true, transformation(origin = {-68.19, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedRotation1(angle = IMURoll, animation = false) annotation(Placement(visible = true, transformation(origin = {-35, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.FixedShape fixedShape1(length = 0.028, width = 0.0315, height = 0.013, color = {255, 85, 0}, r_shape = {-0.028 / 2, 0, 0}) annotation(Placement(visible = true, transformation(origin = {80, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.FixedFrame fixedFrame1(length = 0.05) annotation(Placement(visible = true, transformation(origin = {105, -72.139}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedRotation2(n = {0, 1, 0}, angle = IMUPitch, animation = false) annotation(Placement(visible = true, transformation(origin = {-1.854, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedRotation3(n = {0, 0, 1}, angle = IMUYaw, animation = false) annotation(Placement(visible = true, transformation(origin = {28.297, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.Body body1(r_CM = {0, 0, 0}, m = 0.0089, animation = false) annotation(Placement(visible = true, transformation(origin = {215, -11.594}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter SI.Position IMUPos[3] = {0, 0, 0} "Vector from frame_a to frame_b resolved in frame_a (fixedTranslation1.r)";
  parameter SI.Angle IMURoll = 0 "Angle to rotate frame_a around axis n into frame_b (fixedRotation1.angle)";
  parameter SI.Angle IMUPitch = 0 "Angle to rotate frame_a around axis n into frame_b (fixedRotation2.angle)";
  parameter SI.Angle IMUYaw = 0 "Angle to rotate frame_a around axis n into frame_b (fixedRotation3.angle)";
  Modelica.Mechanics.MultiBody.Sensors.AbsolutePosition absolutePosition1 annotation(Placement(visible = true, transformation(origin = {175, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Modelica.Mechanics.MultiBody.Sensors.AbsoluteAngles absoluteAngles1 annotation(Placement(visible = true, transformation(origin = {95, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Modelica.Mechanics.MultiBody.Sensors.AbsoluteAngularVelocity absoluteAngularVelocity1 annotation(Placement(visible = true, transformation(origin = {55, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Modelica.Mechanics.MultiBody.Sensors.AbsoluteVelocity absoluteVelocity1 annotation(Placement(visible = true, transformation(origin = {135, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Utils.genericUncertainty genericUncertainty1 annotation(Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -360)));
  Utils.genericUncertainty genericUncertainty2 annotation(Placement(visible = true, transformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -360)));
  Utils.genericUncertainty genericUncertainty3 annotation(Placement(visible = true, transformation(origin = {210, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -360)));
  Utils.genericUncertainty genericUncertainty4 annotation(Placement(visible = true, transformation(origin = {170, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -360)));
  Modelica.Blocks.Interfaces.RealInput uncertaintyIn[24] annotation(Placement(visible = true, transformation(origin = {27.852, 150}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 61.998}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y[12] annotation(Placement(visible = true, transformation(origin = {270, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 65.357}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(frame_a, fixedTranslation1.frame_a) annotation(Line(visible = true, origin = {-99.595, -50}, points = {{-21.405, 0}, {21.405, 0}}, color = {95, 95, 95}));
  connect(fixedTranslation1.frame_b, fixedRotation1.frame_a) annotation(Line(visible = true, origin = {-51.595, -50}, points = {{-6.595, 0}, {6.595, 0}}, color = {95, 95, 95}));
  connect(fixedRotation1.frame_b, fixedRotation2.frame_a) annotation(Line(visible = true, origin = {-18.427, -50}, points = {{-6.573, 0}, {6.573, 0}}, color = {95, 95, 95}));
  connect(fixedFrame1.frame_a, fixedShape1.frame_a) annotation(Line(visible = true, origin = {74.375, -61.07}, points = {{20.625, -11.07}, {-19.375, -11.07}, {-19.375, 11.07}, {-4.375, 11.07}}, color = {95, 95, 95}));
  connect(fixedRotation2.frame_b, fixedRotation3.frame_a) annotation(Line(visible = true, origin = {13.221, -50}, points = {{-5.076, 0}, {5.076, 0}}, color = {95, 95, 95}));
  connect(fixedRotation3.frame_b, fixedShape1.frame_a) annotation(Line(visible = true, origin = {54.149, -50}, points = {{-15.851, 0}, {15.851, 0}}, color = {95, 95, 95}));
  connect(body1.frame_a, fixedShape1.frame_a) annotation(Line(visible = true, origin = {78.767, -30.797}, points = {{126.233, 19.203}, {-23.767, 19.203}, {-23.767, -19.203}, {-8.767, -19.203}}, color = {95, 95, 95}));
  connect(absoluteAngularVelocity1.frame_a, body1.frame_a) annotation(Line(visible = true, origin = {105, -7.729}, points = {{-50, 7.729}, {-50, -3.865}, {100, -3.865}}, color = {95, 95, 95}));
  connect(absoluteAngles1.frame_a, absoluteAngularVelocity1.frame_a) annotation(Line(visible = true, origin = {75, -2.889}, points = {{20, 2.889}, {20, -8.844}, {-20, -8.844}, {-20, 2.889}}, color = {95, 95, 95}));
  connect(absoluteVelocity1.frame_a, body1.frame_a) annotation(Line(visible = true, origin = {158.333, -7.729}, points = {{-23.333, 7.729}, {-23.333, -3.865}, {46.667, -3.865}}, color = {95, 95, 95}));
  connect(absolutePosition1.frame_a, body1.frame_a) annotation(Line(visible = true, origin = {185, -7.729}, points = {{-10, 7.729}, {-10, -3.865}, {20, -3.865}}, color = {95, 95, 95}));
  connect(absoluteAngles1.angles, genericUncertainty1.u) annotation(Line(visible = true, origin = {102.667, 53.667}, points = {{-7.667, -32.667}, {-7.667, 16.333}, {15.333, 16.333}}, color = {1, 37, 163}));
  connect(absoluteAngularVelocity1.w, genericUncertainty2.u) annotation(Line(visible = true, origin = {62.667, 80.333}, points = {{-7.667, -59.333}, {-7.667, 29.667}, {15.333, 29.667}}, color = {1, 37, 163}));
  connect(absolutePosition1.r, genericUncertainty3.u) annotation(Line(visible = true, origin = {182.667, 27}, points = {{-7.667, -6}, {-7.667, 3}, {15.333, 3}}, color = {1, 37, 163}));
  connect(absoluteVelocity1.v, genericUncertainty4.u) annotation(Line(visible = true, origin = {142.667, 40.333}, points = {{-7.667, -19.333}, {-7.667, 9.667}, {15.333, 9.667}}, color = {1, 37, 163}));
  connect(genericUncertainty3.b[1:3], uncertaintyIn[1:3]) annotation(Line(visible = true, origin = {146.879, 114}, points = {{59.513, -72}, {59.513, 36}, {-119.027, 36}}, color = {1, 37, 163}));
  connect(genericUncertainty3.K[1:3], uncertaintyIn[4:6]) annotation(Line(visible = true, origin = {153.006, 114}, points = {{62.577, -72}, {62.577, 36}, {-125.153, 36}}, color = {1, 37, 163}));
  connect(genericUncertainty4.b[1:3], uncertaintyIn[7:9]) annotation(Line(visible = true, origin = {120.212, 120.667}, points = {{46.18, -58.667}, {46.18, 29.333}, {-92.36, 29.333}}, color = {1, 37, 163}));
  connect(genericUncertainty4.K, uncertaintyIn[10:12]) annotation(Line(visible = true, origin = {126.339, 120.667}, points = {{49.243, -58.667}, {49.243, 29.333}, {-98.487, 29.333}}, color = {1, 37, 163}));
  connect(genericUncertainty1.b, uncertaintyIn[13:15]) annotation(Line(visible = true, origin = {93.546, 127.333}, points = {{32.847, -45.333}, {32.847, 22.667}, {-65.693, 22.667}}, color = {1, 37, 163}));
  connect(genericUncertainty1.K, uncertaintyIn[16:18]) annotation(Line(visible = true, origin = {99.672, 127.333}, points = {{35.91, -45.333}, {35.91, 22.667}, {-71.82, 22.667}}, color = {1, 37, 163}));
  connect(genericUncertainty2.b, uncertaintyIn[19:21]) annotation(Line(visible = true, origin = {66.879, 140.667}, points = {{19.513, -18.667}, {19.513, 9.333}, {-39.027, 9.333}}, color = {1, 37, 163}));
  connect(genericUncertainty2.K, uncertaintyIn[22:24]) annotation(Line(visible = true, origin = {73.006, 140.667}, points = {{22.577, -18.667}, {22.577, 9.333}, {-45.153, 9.333}}, color = {1, 37, 163}));
  connect(genericUncertainty3.y, y[1:3]) annotation(Line(visible = true, origin = {245.5, 30}, points = {{-24.5, 0}, {24.5, 0}}, color = {1, 37, 163}));
  connect(genericUncertainty4.y, y[4:6]) annotation(Line(visible = true, origin = {234.366, 40}, points = {{-53.366, 10}, {8.866, 10}, {8.866, -10}, {35.634, -10}}, color = {1, 37, 163}));
  connect(genericUncertainty1.y, y[7:9]) annotation(Line(visible = true, origin = {224.366, 50}, points = {{-83.366, 20}, {18.866, 20}, {18.866, -20}, {45.634, -20}}, color = {1, 37, 163}));
  connect(genericUncertainty2.y, y[10:12]) annotation(Line(visible = true, origin = {214.366, 70}, points = {{-113.366, 40}, {28.866, 40}, {28.866, -40}, {55.634, -40}}, color = {1, 37, 163}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -90}, {300, 150}}, preserveAspectRatio = true, initialScale = 0.1, grid = {5, 5})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {10, 10}), graphics = {Text(visible = true, origin = {0, -16.321}, textColor = {64, 64, 64}, extent = {{-150, 110}, {150, 150}}, textString = "%name"), Polygon(visible = true, origin = {68.554, -4.161}, lineColor = {255, 170, 0}, fillColor = {255, 85, 0}, fillPattern = FillPattern.VerticalCylinder, points = {{-18.554, -5.839}, {-18.554, -30.387}, {18.554, 6.523}, {18.554, 29.703}}), Polygon(visible = true, origin = {2.328, 8.288}, lineColor = {255, 170, 0}, fillColor = {255, 85, 0}, fillPattern = FillPattern.VerticalCylinder, points = {{-87.516, -18.288}, {45.95, -18.288}, {83.894, 18.288}, {-42.328, 18.288}}), Rectangle(visible = true, origin = {-19.267, -24.065}, lineColor = {255, 170, 0}, fillColor = {255, 85, 0}, fillPattern = FillPattern.VerticalCylinder, extent = {{-67.102, -12.402}, {67.102, 12.402}}), Line(visible = true, origin = {2, -2}, points = {{-2, -18}, {-2, 92}}, color = {47, 167, 41}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 30), Line(visible = true, points = {{0, -20}, {90, -70}}, color = {64, 64, 64}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 30), Line(visible = true, origin = {2, -2}, points = {{-92, -68}, {-2, -18}}, color = {10, 90, 224}, thickness = 2, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 30), Ellipse(visible = true, origin = {-0.412, 28.035}, fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-15.247, -11.965}, {15.247, 11.965}}), Ellipse(visible = true, origin = {-35.026, -40}, fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-8.241, -14.135}, {8.241, 14.135}}), Ellipse(visible = true, origin = {32.348, -38.323}, fillColor = {255, 255, 255}, lineThickness = 1, extent = {{-5.563, -14.01}, {5.563, 14.01}}), Line(visible = true, origin = {8.091, 38.105}, points = {{1.909, -1.895}, {-1.909, 1.895}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 8), Line(visible = true, origin = {36.694, -30.905}, points = {{0.844, -2.885}, {-0.844, 2.885}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 8), Line(visible = true, origin = {-31.909, -28.105}, points = {{1.909, -1.895}, {-1.909, 1.895}}, arrow = {Arrow.None, Arrow.Filled}, arrowSize = 8), Line(visible = true, origin = {-58.41, 67.672}, points = {{-31.59, -7.672}, {-27.301, 4.44}, {-21.59, 4.44}, {-21.59, -0.505}, {-14.527, -0.505}, {-14.527, 2.328}, {-8.758, 7.737}, {-5.049, 2.328}, {0.308, 0.731}, {-1.59, -7.672}, {5.665, -7.672}, {8.41, -2.565}, {14.73, -7.672}, {14.73, -2.565}, {20.499, 5.264}, {22.972, 2.328}, {28.41, 8.561}, {30.801, -1.329}}), Polygon(visible = true, origin = {55.625, 32.726}, fillColor = {255, 255, 127}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-12.237, -4.849}, {-7.474, 7.274}, {4.186, 7.274}, {7.763, -4.849}, {7.763, -4.849}}), Polygon(visible = true, origin = {69.424, 57.272}, fillColor = {103, 103, 103}, fillPattern = FillPattern.Solid, lineThickness = 1, points = {{-21.151, -17.272}, {-9.424, -17.272}, {-9.424, 2.728}, {30.576, 2.728}, {30.576, 14.544}, {-21.151, 14.544}})}),
    Documentation(info = "<html><head>
</head>
<body>
<h1>Inertial Measurement Unit (IMU) Model</h1>

<p>
  The <em>IMU</em> model represents a configurable Inertial Measurement Unit. It acts as a comprehensive 6-DOF sensor, capturing the exact kinematic state of the rigid body it is attached to, allowing for the simulation of real-world navigation sensor conditions.
</p>

<h2>Description</h2>

<p>
  In real marine systems, the IMU is often installed away from the vessel's center of mass. This block accounts for that by letting the user set the sensor's position and orientation offsets relative to the ship’s reference frame. It also includes inputs to simulate common sensor errors, such as white noise, drift, and constant bias, making it suitable for testing navigation algorithms and tuning filters like EKFs.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> IMU configuration parameters</caption>
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
      <td><strong>IMUPos</strong></td>
      <td>Position[3]</td>
      <td>m</td>
      <td>Translation vector {x, y, z} defining the IMU's position relative to <code>frame_a</code>.</td>
    </tr>
    <tr>
      <td><strong>IMURoll</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Mounting angle (rotation around the local X-axis).</td>
    </tr>
    <tr>
      <td><strong>IMUPitch</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Mounting angle (rotation around the local Y-axis).</td>
    </tr>
    <tr>
      <td><strong>IMUYaw</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Mounting angle (rotation around the local Z-axis).</td>
    </tr>
  </tbody>
</table>

<h2>Connectors and Interfaces</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Inputs, Outputs and Connectors</caption>
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
      <td><strong>frame_a</strong></td>
      <td>Frame_a</td>
      <td>-</td>
      <td>3D mechanical connector linking the sensor assembly to the main structure (e.g., the ship's hull).</td>
    </tr>
    <tr>
      <td><strong>uncertaintyIn</strong></td>
      <td>RealInput[24]</td>
      <td>-</td>
      <td>Input vector for injecting uncertainty parameters (noise and bias) applied individually to the sensors.</td>
    </tr>
    <tr>
      <td><strong>y</strong></td>
      <td>RealOutput[12]</td>
      <td>-</td>
      <td>Output vector containing the complete kinematic state: <code>[x, y, z, vx, vy, vz, thetaX, thetaY, thetaZ, omegaX, omegaY, omegaZ]</code>.</td>
    </tr>
  </tbody>
</table>

<h2>Internal Components</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 3:</strong> Main internal components</caption>
  <thead>
    <tr bgcolor=\"#f2f2f2\">
      <th>Name</th>
      <th>Type</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><em>fixedTranslation, fixedRotation(s)</em></td>
      <td>Parts</td>
      <td>Adjust the measurement frame based on the mounting offset parameters.</td>
    </tr>
    <tr>
      <td><em>absolutePosition, absoluteVelocity</em></td>
      <td>Sensors</td>
      <td>Measure the linear position (x, y, z) and velocity (vx, vy, vz) at the exact point of the IMU.</td>
    </tr>
    <tr>
      <td><em>absoluteAngles, absoluteAngularVelocity</em></td>
      <td>Sensors</td>
      <td>Measure the attitude (Euler angles) and rotational rate (omega) of the sensor.</td>
    </tr>
    <tr>
      <td><em>genericUncertainty (1 to 4)</em></td>
      <td>Utils</td>
      <td>Blocks that receive the perfect measurements and apply the <code>uncertaintyIn</code> vector to generate the final noisy signals.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model captures simulation data following this architecture:
</p>

<ul>
  <li><strong>Lever Arm Effect:</strong> The reference frame <code>frame_a</code> is translated and rotated according to the IMU mounting configuration. This accounts for the lever arm effect, so vessel rotations produce the corresponding translational motion at the sensor location.</li>

  <li><strong>Data Capture:</strong> After the sensor frame is defined, the MultiBody sensors measure the main motion variables relative to the global inertial frame <code>World</code>. These include position, orientation, linear velocity, and angular velocity, resulting in 12 output values.</li>

  <li><strong>Signal Degradation:</strong> Before reaching the output port, the signals can pass through uncertainty blocks that reproduce typical sensor imperfections. If <code>uncertaintyIn</code> is set to zero, the sensor behaves as an ideal sensor.</li>

  <li><strong>Vector Grouping:</strong> The processed signals are grouped into a single 12-element output vector, <code>y</code>. This provides a simple and consistent interface for controllers and navigation algorithms.</li>
</ul>

<hr>
<p>
  <em>Note: This component is part of the AbstractControl package and was designed for the development and calibration of autonomous navigation algorithms.</em>
</p>


</body></html>"));
end IMU;

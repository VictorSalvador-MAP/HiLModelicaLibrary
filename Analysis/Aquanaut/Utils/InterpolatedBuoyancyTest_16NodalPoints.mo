within Aquanaut.Utils;

model InterpolatedBuoyancyTest_16NodalPoints
  Aquanaut.Utils.InterpolatedBuoyancyBlock lagrangeIntepolatedBuoyancy annotation(
    Placement(transformation(origin = {3, -9}, extent = {{-31, -31}, {31, 31}})));
  
  Modelica.Blocks.Interfaces.RealOutput XCOBOutput annotation(
    Placement(transformation(origin = {78, 38}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput YCOBOutput annotation(
    Placement(transformation(origin = {78, 10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput ZCOBOutput annotation(
    Placement(transformation(origin = {78, -10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput DVOutput annotation(
    Placement(transformation(origin = {78, -30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput HeaveOutput annotation(
    Placement(transformation(origin = {-56, 46}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-84, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PitchOutput annotation(
    Placement(transformation(origin = {-56, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput RollOutput annotation(
    Placement(transformation(origin = {-56, -34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput rangeFlagOutput annotation(
    Placement(transformation(origin = {78, -54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -76}, extent = {{-10, -10}, {10, 10}})));
  
  Aquanaut.Utils.SmoothedInterleavedSignal16Points Heave_16Points annotation(
    Placement(transformation(origin = {-80, 28}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.Utils.SmoothedInterleavedSignal16Points Pitch_16Points(frequencyTime = 16, valueOutput = (linspace(-4, 3, 16))*Modelica.Constants.pi/180) annotation(
    Placement(transformation(origin = {-80, -8}, extent = {{-10, -10}, {10, 10}})));
  Aquanaut.Utils.SmoothedInterleavedSignal16Points Roll_16Points(frequencyTime = 256, valueOutput = linspace(0.0, 0.174532925199, 16)) annotation(
    Placement(transformation(origin = {-80, -48}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(Pitch_16Points.CiclicContinuousOutput, lagrangeIntepolatedBuoyancy.PitchInput) annotation(
    Line(points = {{-69, -8}, {-32, -8}}, color = {0, 0, 127}));
  connect(PitchOutput, lagrangeIntepolatedBuoyancy.PitchInput) annotation(
    Line(points = {{-56, 2}, {-50, 2}, {-50, -8}, {-32, -8}}, color = {0, 0, 127}));
  connect(Roll_16Points.CiclicContinuousOutput, lagrangeIntepolatedBuoyancy.RollInput) annotation(
    Line(points = {{-69, -48}, {-37.5, -48}, {-37.5, -28}, {-32, -28}}, color = {0, 0, 127}));
  connect(RollOutput, Roll_16Points.CiclicContinuousOutput) annotation(
    Line(points = {{-56, -34}, {-48, -34}, {-48, -48}, {-68, -48}}, color = {0, 0, 127}));
  connect(XCOBOutput, lagrangeIntepolatedBuoyancy.XcobOutput) annotation(
    Line(points = {{78, 38}, {58, 38}, {58, 18}, {38, 18}}, color = {0, 0, 127}));
  connect(YCOBOutput, lagrangeIntepolatedBuoyancy.YcobOutput) annotation(
    Line(points = {{78, 10}, {62, 10}, {62, 2}, {38, 2}}, color = {0, 0, 127}));
  connect(ZCOBOutput, lagrangeIntepolatedBuoyancy.ZcobOutput) annotation(
    Line(points = {{78, -10}, {38, -10}}, color = {0, 0, 127}));
  connect(DVOutput, lagrangeIntepolatedBuoyancy.DVOutput) annotation(
    Line(points = {{78, -30}, {62, -30}, {62, -22}, {38, -22}}, color = {0, 0, 127}));
  connect(rangeFlagOutput, lagrangeIntepolatedBuoyancy.rangeFlagOut) annotation(
    Line(points = {{78, -54}, {58, -54}, {58, -34}, {38, -34}}, color = {255, 0, 255}));
  connect(Heave_16Points.CiclicContinuousOutput, lagrangeIntepolatedBuoyancy.HeaveInput) annotation(
    Line(points = {{-68, 28}, {-38, 28}, {-38, 10}, {-32, 10}}, color = {0, 0, 127}));
  connect(HeaveOutput, Heave_16Points.CiclicContinuousOutput) annotation(
    Line(points = {{-56, 46}, {-50, 46}, {-50, 28}, {-68, 28}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 4096, Tolerance = 1e-06, Interval = 1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --maxSizeLinearization=6000 --fmuRuntimeDepends=modelica ",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {170, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {71, 81}, textColor = {255, 255, 255}, extent = {{-19, 17}, {19, -17}}, textString = "Xcob"), Text(origin = {71, 47}, textColor = {255, 255, 255}, extent = {{-19, 17}, {19, -17}}, textString = "Ycob"), Text(origin = {71, 9}, textColor = {255, 255, 255}, extent = {{-19, 17}, {19, -17}}, textString = "Zcob"), Text(origin = {78, -33}, textColor = {255, 255, 255}, extent = {{-14, 11}, {14, -11}}, textString = "DV"), Text(origin = {74, -76}, textColor = {255, 255, 255}, extent = {{-22, 12}, {22, -12}}, textString = "O.R.F"), Text(origin = {-86, -84}, textColor = {255, 255, 255}, extent = {{-22, 12}, {22, -12}}, textString = "H"), Text(origin = {-30, -84}, textColor = {255, 255, 255}, extent = {{-22, 12}, {22, -12}}, textString = "P"), Text(origin = {16, -84}, textColor = {255, 255, 255}, extent = {{-22, 12}, {22, -12}}, textString = "S"), Text(origin = {-31, 0}, textColor = {255, 255, 255}, extent = {{-55, 54}, {55, -54}}, textString = "Experiment", textStyle = {TextStyle.Bold})}));
end InterpolatedBuoyancyTest_16NodalPoints;

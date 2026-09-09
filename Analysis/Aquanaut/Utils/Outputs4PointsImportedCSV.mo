within Aquanaut.Utils;

model Outputs4PointsImportedCSV
  Modelica.Blocks.Sources.CombiTimeTable dataTable(tableOnFile = true, tableName = "OutputData", fileName = ModelicaServices.ExternalReferences.loadResource("modelica://Aquanaut/Resources/CoB_and_Displaced_Vol_4xZ_4xphi_4xtheta.csv"), columns = {2, 3, 4, 5}, extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint)  annotation(
    Placement(transformation(origin = {-52, 6}, extent = {{-10, -10}, {10, 10}})));
Modelica.Blocks.Interfaces.RealOutput cob_X annotation(
    Placement(transformation(origin = {22, 42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 76}, extent = {{-10, -10}, {10, 10}})));
Modelica.Blocks.Interfaces.RealOutput cob_Y annotation(
    Placement(transformation(origin = {22, 6}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}})));
Modelica.Blocks.Interfaces.RealOutput cob_Z annotation(
    Placement(transformation(origin = {24, -28}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}})));
Modelica.Blocks.Interfaces.RealOutput DV annotation(
    Placement(transformation(origin = {24, -58}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -72}, extent = {{-10, -10}, {10, 10}})));
equation
connect(dataTable.y[1], cob_X) annotation(
    Line(points = {{-40, 6}, {-20, 6}, {-20, 42}, {22, 42}}, color = {0, 0, 127}));
connect(dataTable.y[2], cob_Y) annotation(
    Line(points = {{-40, 6}, {22, 6}}, color = {0, 0, 127}));
connect(dataTable.y[3], cob_Z) annotation(
    Line(points = {{-40, 6}, {-20, 6}, {-20, -28}, {24, -28}}, color = {0, 0, 127}));
connect(dataTable.y[4], DV) annotation(
    Line(points = {{-40, 6}, {-20, 6}, {-20, -58}, {24, -58}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 64, Tolerance = 1e-06, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --maxSizeLinearization=6000 --fmuRuntimeDepends=modelica ",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
Icon(graphics = {Rectangle(fillColor = {48, 48, 48},fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-28, 79}, textColor = {255, 255, 255}, extent = {{60, 43}, {-60, -43}}, textString = "4 Points
Reference Interpolation Results", textStyle = {TextStyle.Bold}), Text(origin = {81, 76}, textColor = {255, 255, 255}, extent = {{-15, 12}, {15, -12}}, textString = "Xcob", textStyle = {TextStyle.Bold}), Text(origin = {81, 32}, textColor = {255, 255, 255}, extent = {{-15, 12}, {15, -12}}, textString = "Ycob", textStyle = {TextStyle.Bold}), Text(origin = {81, -22}, textColor = {255, 255, 255}, extent = {{-15, 12}, {15, -12}}, textString = "Zcob", textStyle = {TextStyle.Bold}), Text(origin = {83, -70}, textColor = {255, 255, 255}, extent = {{-15, 12}, {15, -12}}, textString = "DV", textStyle = {TextStyle.Bold}), Text(origin = {-7, 111}, extent = {{-65, 15}, {65, -15}}, textString = "%name")}),
Diagram(graphics));
end Outputs4PointsImportedCSV;

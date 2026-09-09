within Aquanaut.Utils;

model InterpolatedBuoyancyBlock
  extends Modelica.Blocks.Icons.Block;
  import Modelica.Utilities.Streams;
  
  /************************************************/
  /****************** INPUTS **********************/
  /************************************************/
  Modelica.Blocks.Interfaces.RealInput HeaveInput (unit = "m") annotation(
    Placement(transformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-114, 64}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput PitchInput (unit = "rad") annotation(
    Placement(transformation(origin = {-120, 2}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-114, 2}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput RollInput (unit = "rad") annotation(
    Placement(transformation(origin = {-120, -64}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-112, -60}, extent = {{-12, -12}, {12, 12}})));
  
  /*************************************************/
  /****************** OUTPUTS **********************/
  /*************************************************/
  Modelica.Blocks.Interfaces.RealOutput XcobOutput (unit = "m") annotation(
    Placement(transformation(origin = {110, 82}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput YcobOutput (unit = "m") annotation(
    Placement(transformation(origin = {110, 46}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput ZcobOutput (unit = "m") annotation(
    Placement(transformation(origin = {110, -38}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput DVOutput (unit = "m3") annotation(
    Placement(transformation(origin = {110, -78}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -44}, extent = {{-10, -10}, {10, 10}})));
  
  // out of range output
  Modelica.Blocks.Interfaces.BooleanOutput rangeFlagOut annotation(
    Placement(transformation(origin = {2, -120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {111, -83}, extent = {{-11, -11}, {11, 11}})));
  
  /*************************************************/
  /****************** PARAMETERS *******************/
  /*************************************************/
  
  //xcob nodal values
  parameter Real Xcob[64] (each unit = "m") = {
    0.7022272348403931, 0.7163207530975342, 0.5343266129493713, 0.2980009913444519,
    0.013729824684560299, -0.06665302813053131, -0.2073458582162857, -0.26647713780403137,
    -0.9185400009155273, -0.9854252338409424, -0.9011335968971252, -0.7761529088020325,
    -1.7584630250930786, -1.6182634830474854, -1.4202156066894531, -1.221725344657898,
    0.7121220827102661, 0.7131161689758301, 0.5181577205657959, 0.29539090394973755,
    0.016778208315372467, -0.08066519349813461, -0.2055799514055252, -0.2654614746570587,
    -0.9433227181434631, -0.9785818457603455, -0.8905436992645264, -0.7755570411682129,
    -1.7584922313690186, -1.612402081489563, -1.413643479347229, -1.2163258790969849,
    0.7415631413459778, 0.6998875141143799, 0.4762853980064392, 0.28433701395988464,
    0.0257245060056448, -0.11462065577507019, -0.21034325659275055, -0.26415640115737915,
    -1.0076024532318115, -0.9676974415779114, -0.8633853197097778, -0.7704451680183411,
    -1.7628499269485474, -1.5953528881072998, -1.391971230506897, -1.201855182647705,
    0.7813693881034851, 0.6665713787078857, 0.42351531982421875, 0.26281386613845825,
    0.03432275354862213, -0.14500948786735535, -0.22089973092079163, -0.2619209289550781,
    -1.06991708278656, -0.949397623538971, -0.8318096399307251, -0.7579883337020874,
    -1.7742549180984497, -1.5685702562332153, -1.356224775314331, -1.1818416118621826
  } annotation(Evaluate=true);

  //ycob nodal values
  parameter Real Ycob[64] (each unit = "m") = {
    -0.0035688297357410192, -0.0026596689131110907, -0.0011893856571987271, -0.001306935679167509,
    -0.0030272891744971275, -0.0021505404729396105, -0.0021268120035529137, -0.001829159096814692,
    -0.002698261523619294, -0.001410798286087811, -0.0021139471791684628, -0.0021859135013073683,
    -0.002109191380441189, -0.001457152422517538, -0.0019557105842977762, -0.0022685613948851824,
    -0.025780068710446358, 0.0052389721386134624, 0.027698829770088196, 0.026632700115442276,
    -0.04007891193032265, 0.009710859507322311, 0.04153342917561531, 0.025942428037524223,
    -0.021971749141812325, 0.025343313813209534, 0.02914373390376568, 0.022448847070336342,
    0.01145222783088684, 0.015033253468573093, 0.014916746877133846, 0.01471834909170866,
    -0.04381563887000084, 0.014857102185487747, 0.052155837416648865, 0.052577223628759384,
    -0.0731423869729042, 0.03274045139551163, 0.07205119729042053, 0.05425405874848366,
    -0.026117384433746338, 0.04463111236691475, 0.05801863223314285, 0.04600503295660019,
    0.019274873659014702, 0.030357765033841133, 0.031835589557886124, 0.030853578820824623,
    -0.056416090577840805, 0.027086898684501648, 0.07142490893602371, 0.07400695979595184,
    -0.09431295096874237, 0.053286850452423096, 0.09077269583940506, 0.08092647045850754,
    -0.024705205112695694, 0.0586710050702095, 0.08083214610815048, 0.06728315353393555,
    0.020316651090979576, 0.04327451437711716, 0.0483568049967289, 0.04574935883283615
  } annotation(Evaluate=true);
  
  //zcob nodal values
  parameter Real Zcob[64] (each unit = "m") = {
    0.2032601684331894, 0.22195079922676086, 0.24225357174873352, 0.2733069956302643,
    0.20646482706069946, 0.2126760482788086, 0.22658276557922363, 0.26375052332878113,
    0.2028629183769226, 0.20820733904838562, 0.23416545987129211, 0.27437520027160645,
    0.20307065546512604, 0.22581738233566284, 0.26038768887519836, 0.3018702268600464,
    0.20169690251350403, 0.22053930163383484, 0.24177774786949158, 0.2740321457386017,
    0.2048601508140564, 0.20960237085819244, 0.22751697897911072, 0.26467394828796387,
    0.19999465346336365, 0.20771797001361847, 0.2344561070203781, 0.2752050757408142,
    0.20261017978191376, 0.2258969247341156, 0.260551780462265, 0.3020642399787903,
    0.19725902378559113, 0.21664617955684662, 0.24068865180015564, 0.276065468788147,
    0.19980067014694214, 0.20235148072242737, 0.2286602407693863, 0.2676032781600952,
    0.19220969080924988, 0.20559559762477875, 0.2354459911584854, 0.2774524390697479,
    0.20100483298301697, 0.22607935965061188, 0.26089903712272644, 0.3028170168399811,
    0.19053977727890015, 0.21087487041950226, 0.23958827555179596, 0.2785947620868683,
    0.19036874175071716, 0.19536131620407104, 0.22950609028339386, 0.27195391058921814,
    0.18292157351970673, 0.2020530104637146, 0.23724962770938873, 0.28058794140815735,
    0.19807812571525574, 0.22608380019664764, 0.2614114284515381, 0.30422183871269226
  } annotation(Evaluate=true);
  
  //displaced volume nodal values
  parameter Real DV[64] (each unit = "m3") = {
    1.8082314729690552, 3.100939989089966, 5.051894664764404, 7.534726619720459,
    1.6527718305587769, 3.0318167209625244, 5.243583679199219, 7.796162128448486,
    1.837514042854309, 3.4377434253692627, 5.612236022949219, 8.11744213104248,
    2.421173334121704, 4.072813510894775, 6.127315998077393, 8.506491661071777,
    1.814468264579773, 3.1217844486236572, 5.078523635864258, 7.53526496887207,
    1.655527114868164, 3.07867693901062, 5.2495436668396, 7.789306640625,
    1.8566889762878418, 3.4575998783111572, 5.624446392059326, 8.110175132751465,
    2.43007230758667, 4.078487396240234, 6.132501125335693, 8.511189460754395,
    1.8363075256347656, 3.186166763305664, 5.15126895904541, 7.542776107788086,
    1.6697783470153809, 3.2079789638519287, 5.301055431365967, 7.771728515625,
    1.917749285697937, 3.528532028198242, 5.662156581878662, 8.102871894836426,
    2.4608166217803955, 4.09921407699585, 6.156408786773682, 8.527342796325684,
    1.8723889589309692, 3.291999101638794, 5.25368070602417, 7.575076580047607,
    1.7084401845932007, 3.3654136657714844, 5.392897129058838, 7.760469913482666,
    1.9990596771240234, 3.643869638442993, 5.71678352355957, 8.107885360717773,
    2.5119199752807617, 4.138439655303955, 6.19938850402832, 8.550816535949707
  } annotation(Evaluate=true);
  
   
  //nodal points
  parameter Real HeaveReference[4] (each unit ="m") = linspace(-0.85, -0.45, 4);
  parameter Real PitchReference[4] (each unit = "rad") = (linspace(-4, 3, 4))*Modelica.Constants.pi/180;
  parameter Real RollReference[4] (each unit = "rad") = (linspace(0, 10, 4))*Modelica.Constants.pi/180;
  
  /***********************************************************/
  /****************** PROTECTED PARAMETERS *******************/
  /***********************************************************/
  
  protected
    //denominators of lagrange weights
    parameter Real denHeaveData[4] = {
    (HeaveReference[1] - HeaveReference[2])*(HeaveReference[1] - HeaveReference[3])*(HeaveReference[1] - HeaveReference[4]),
    (HeaveReference[2] - HeaveReference[1])*(HeaveReference[2] - HeaveReference[3])*(HeaveReference[2] - HeaveReference[4]),
    (HeaveReference[3] - HeaveReference[1])*(HeaveReference[3] - HeaveReference[2])*(HeaveReference[3] - HeaveReference[4]),
    (HeaveReference[4] - HeaveReference[1])*(HeaveReference[4] - HeaveReference[2])*(HeaveReference[4] - HeaveReference[3])
    };
    
     parameter Real denPitchData[4] = {
    (PitchReference[1] - PitchReference[2])*(PitchReference[1] - PitchReference[3])*(PitchReference[1] - PitchReference[4]),
    (PitchReference[2] - PitchReference[1])*(PitchReference[2] - PitchReference[3])*(PitchReference[2] - PitchReference[4]),
    (PitchReference[3] - PitchReference[1])*(PitchReference[3] - PitchReference[2])*(PitchReference[3] - PitchReference[4]),
    (PitchReference[4] - PitchReference[1])*(PitchReference[4] - PitchReference[2])*(PitchReference[4] - PitchReference[3])
    };
    
    parameter Real denRollData[4] = {
    (RollReference[1] - RollReference[2])*(RollReference[1] - RollReference[3])*(RollReference[1] - RollReference[4]),
    (RollReference[2] - RollReference[1])*(RollReference[2] - RollReference[3])*(RollReference[2] - RollReference[4]),
    (RollReference[3] - RollReference[1])*(RollReference[3] - RollReference[2])*(RollReference[3] - RollReference[4]),
    (RollReference[4] - RollReference[1])*(RollReference[4] - RollReference[2])*(RollReference[4] - RollReference[3])
    };
  
  /***********************************************************/
  /****************** BLOCK OPERATIONS ***********************/
  /***********************************************************/  
  equation
    //checks if any input values is out of operating range
    rangeFlagOut = (HeaveInput < HeaveReference[1]) or (HeaveInput > HeaveReference[4]) or (PitchInput < PitchReference[1]) or (PitchInput > PitchReference[4]) or (RollInput < RollReference[1]) or (RollInput > RollReference[4]);
  
    //lagrange interpolation
    (XcobOutput, YcobOutput, ZcobOutput, DVOutput) = Aquanaut.Functions.LagrangeInterpolationFunction(
      heave = HeaveInput,
      pitch = PitchInput,
      roll = RollInput,
      xcob = Xcob,
      ycob = Ycob,
      zcob = Zcob,
      dv = DV,
      heaveRef = HeaveReference,
      pitchRef = PitchReference,
      rollRef = RollReference,
      denHeave = denHeaveData,
      denPitch = denPitchData,
      denRoll = denRollData); 
  
  annotation(
    uses(Modelica(version = "4.0.0")),
    Icon(graphics = {Text(origin = {-74, 65}, extent = {{-42, 9}, {42, -9}}, textString = "Heave"), Text(origin = {-76, 3}, extent = {{-42, 9}, {42, -9}}, textString = "Pitch"), Text(origin = {-80, -61}, extent = {{-42, 9}, {42, -9}}, textString = "Roll"), Text(origin = {82, 85}, extent = {{-42, 9}, {42, -9}}, textString = "Xcob"), Text(origin = {80, 39}, extent = {{-42, 9}, {42, -9}}, textString = "Ycob"), Text(origin = {80, -1}, extent = {{-42, 9}, {42, -9}}, textString = "Zcob"), Text(origin = {86, -43}, extent = {{-42, 9}, {42, -9}}, textString = "DV"), Text(origin = {52, -81}, extent = {{-42, 9}, {42, -9}}, textString = "OutRangeFlag"), Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-53, 39}, {53, -39}}), Rectangle(origin = {0, -0.5}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-1.5, 19.5}, {1.5, -19.5}}), Ellipse(origin = {0, -26}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-8, 8}, {8, -8}}), Polygon(origin = {0, 23}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-5, -10}, {5, -10}, {0, 10}, {-5, -10}}), Text(origin = {25, 23}, textColor = {255, 0, 0}, extent = {{-21, 5}, {21, -5}}, textString = "Interpoled", textStyle = {TextStyle.Bold}), Line(origin = {1.015, -11.15}, points = {{-45.015, -4.85}, {-28.015, 4.15}, {-15.015, -4.85}, {1.985, 4.15}, {19.985, -4.85}, {33.985, 5.15}, {44.985, -4.85}}, color = {85, 170, 255}, thickness = 2.125, smooth = Smooth.Bezier)}),
    Diagram(graphics),
    experiment(StartTime = 0, StopTime = 64, Tolerance = 1e-06, Interval = 1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
    Documentation(info = "<html><head>
</head>
<body>
<h1 style=\"text-align: left;\">Interpolated Buoyancy Block</h1>
<div>The InterpoledBuoyancyBlock is a model replacement designed to calculate the hydostatic properties of a vessel in real-time. It replaces computationally expensive volume integration over a hull mesh with optimized 3D Lagrange interpolation, reducing the block computational cost of its real-time processing.</div>

<div><br></div>

<h2>Description</h2>
<div>The block acts a data manager and interpolator, connecting the vessel's kinematics to its hydrostatic forces. It receives continuous position data from vessel's body, specifically Heave [m], Pitch [rad] and Roll [rad] and provides the resulting Displaced Volume (DV) [m³] and the coordinates of the Center of Buoyancy (Xcob, Ycob, Zcob) [m]. Additionally, the block includes a flag named rangeFlagOut that continuously monitors the inputs against the operation range of the implemented 3D lagrange interpolation.</div>

<div><br></div>
<div>The 3D Lagrange Interpolation is implemented via an external Modelica function called LagrangeInterpolationFunction. This encapsulates all algebraic summations, ensuring both clean code and high performance. The interpolation relies on a grid of 64 nodal points, comprising 4 points for heave, 4 for pitch, and 4 for roll. Within the flattened 64-element array, the nodal data is structured with sequential offsets: heave nodes iterate at every single index, pitch nodes offset every 4 indices, and roll nodes offset every 16 indices. This function dynamically evaluates the instantaneous inputs (HeaveInput, PitchInput, and RollInput) to compute the exact hydrostatic responses as XcobOutput, YcobOutput, ZcobOutput, and DVOutput.<br><br>
</div>

<div>Before calling the 3D Lagrange Interpolation function, the Xcob, Ycob, Zcob, and DV nodal values are stored in arrays, and the reference nodal points are defined (HeaveReference, PitchReference, RollReference). Additionally, the Lagrange weight denominators (denHeaveData, denPitchData, and denRollData) are pre-calculated to be passed into the function.</div>

<div><br>
<h2>Parameters</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"6\" style=\"border-collapse: collapse; width: 100%; text-align: left;\">
  <thead>
    <tr style=\"background-color: #f2f2f2;\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Xcob</b></td>
      <td>Real[64]</td>
      <td>m</td>
      <td>Pre-calculated exact nodal values for the Center of Buoyancy X-coordinate.</td>
    </tr>
    <tr>
      <td><b>Ycob</b></td>
      <td>Real[64]</td>
      <td>m</td>
      <td>Pre-calculated exact nodal values for the Center of Buoyancy Y-coordinate.</td>
    </tr>
    <tr>
      <td><b>Zcob</b></td>
      <td>Real[64]</td>
      <td>m</td>
      <td>Pre-calculated exact nodal values for the Center of Buoyancy Z-coordinate.</td>
    </tr>
    <tr>
      <td><b>DV</b></td>
      <td>Real[64]</td>
      <td>m³</td>
      <td>Pre-calculated exact nodal values for the Displaced Volume.</td>
    </tr>
    <tr>
      <td><b>HeaveReference</b></td>
      <td>Real[4]</td>
      <td>m</td>
      <td>Reference nodal points defining the boundaries and steps of the heave axis in the interpolation grid.</td>
    </tr>
    <tr>
      <td><b>PitchReference</b></td>
      <td>Real[4]</td>
      <td>rad</td>
      <td>Reference nodal points defining the boundaries and steps of the pitch axis in the interpolation grid.</td>
    </tr>
    <tr>
      <td><b>RollReference</b></td>
      <td>Real[4]</td>
      <td>rad</td>
      <td>Reference nodal points defining the boundaries and steps of the roll axis in the interpolation grid.</td>
    </tr>
  </tbody>
</table>
<p style=\"text-align: center; font-size: 0.9em;\"><b>Tab. 1:</b> Parameters used for 3D Lagrange Interpolation Function</p>
</div>

<div>
<h2>Connectors and Interfaces</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"6\" style=\"border-collapse: collapse; width: 100%; text-align: left;\">
  <thead>
    <tr style=\"background-color: #f2f2f2;\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>HeaveInput</b></td>
      <td>RealInput</td>
      <td>m</td>
      <td>Continuous input signal representing the vessel's vertical displacement.</td>
    </tr>
    <tr>
      <td><b>PitchInput</b></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>Continuous input signal representing the vessel's pitch angle.</td>
    </tr>
    <tr>
      <td><b>RollInput</b></td>
      <td>RealInput</td>
      <td>rad</td>
      <td>Continuous input signal representing the vessel's roll angle.</td>
    </tr>
    <tr>
      <td><b>XcobOutput</b></td>
      <td>RealOutput</td>
      <td>m</td>
      <td>Interpolated longitudinal coordinate of the Center of Buoyancy.</td>
    </tr>
    <tr>
      <td><b>YcobOutput</b></td>
      <td>RealOutput</td>
      <td>m</td>
      <td>Interpolated transversal coordinate of the Center of Buoyancy.</td>
    </tr>
    <tr>
      <td><b>ZcobOutput</b></td>
      <td>RealOutput</td>
      <td>m</td>
      <td>Interpolated vertical coordinate of the Center of Buoyancy.</td>
    </tr>
    <tr>
      <td><b>DVOutput</b></td>
      <td>RealOutput</td>
      <td>m³</td>
      <td>Interpolated submerged volume displaced by the hull.</td>
    </tr>
    <tr>
      <td><b>rangeFlagOut</b></td>
      <td>BooleanOutput</td>
      <td>-</td>
      <td>Safety signal that outputs <code>true</code> if any input exceeds the defined reference grid limits.</td>
    </tr>
  </tbody>
</table>
<p style=\"text-align: center; font-size: 0.9em;\"><b>Tab. 2:</b> Connectors and interfaces of the Interpolated Buoyancy block</p>
</div>

<div>
<h2>Internal Variables</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"6\" style=\"border-collapse: collapse; width: 100%; text-align: left;\">
  <thead>
    <tr style=\"background-color: #f2f2f2;\">
      <th>Name</th>
      <th>Type</th>
      <th>Unit</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><i>denHeaveData</i></td>
      <td>Real[4]</td>
      <td>-</td>
      <td>Pre-calculated Lagrange weight denominators for the heave axis (protected).</td>
    </tr>
    <tr>
      <td><i>denPitchData</i></td>
      <td>Real[4]</td>
      <td>-</td>
      <td>Pre-calculated Lagrange weight denominators for the pitch axis (protected).</td>
    </tr>
    <tr>
      <td><i>denRollData</i></td>
      <td>Real[4]</td>
      <td>-</td>
      <td>Pre-calculated Lagrange weight denominators for the roll axis (protected).</td>
    </tr>
  </tbody>
</table>
<p style=\"text-align: center; font-size: 0.9em;\"><b>Tab. 3:</b> Protected internal parameters used for optimization</p>
</div>

<div>
<h2>Operating Range</h2>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"6\" style=\"border-collapse: collapse; width: 100%; text-align: left;\">
  <thead>
    <tr style=\"background-color: #f2f2f2;\">
      <th>Input Variable</th>
      <th>Minimum</th>
      <th>Maximum</th>
      <th>Nodal Points</th>
      <th>Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>HeaveInput</b></td>
      <td>-0.85</td>
      <td>-0.45</td>
      <td>4</td>
      <td>m</td>
    </tr>
    <tr>
      <td><b>PitchInput</b></td>
      <td>-0.0698 (-4.0°)</td>
      <td>0.0523 (3.0°)</td>
      <td>4</td>
      <td>rad (°)</td>
    </tr>
    <tr>
      <td><b>RollInput</b></td>
      <td>0.0000 (0.0°)</td>
      <td>0.1745 (10.0°)</td>
      <td>4</td>
      <td>rad (°)</td>
    </tr>
  </tbody>
</table>
<p style=\"text-align: center; font-size: 0.9em;\"><b>Tab. 4:</b> Operational boundaries and grid definition for the 3D interpolation</p>
</div>


</body></html>"));
end InterpolatedBuoyancyBlock;

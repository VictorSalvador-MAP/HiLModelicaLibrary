within Aquanaut.Functions;

function WageningenB_Kt_Kq "Wageningen B series Kt & Kq"
  extends Modelica.Icons.Function;
  input Real J "Advance ratio";
  input Real P_D "Pitch-diameter ratio";
  input Real Ae_Ao "Blade area ratio";
  input Real Z "Number of blades";
  output Real Kt "Kt coefficient";
  output Real Kq "Kq coefficient";
protected
  Real T[39, 5];
  //Matrix Kt
  Real Q[47, 5];
  //Matrix Kq
algorithm
//Load Kt matrix
  T[1, 1] := 0.00880496;
  T[2, 1] := -0.204554;
  T[3, 1] := 0.166351;
  T[4, 1] := 0.158114;
  T[5, 1] := -0.147581;
  T[6, 1] := -0.481497;
  T[7, 1] := 0.415437;
  T[8, 1] := 0.0144043;
  T[9, 1] := -0.0530054;
  T[10, 1] := 0.0143481;
  T[11, 1] := 0.0606826;
  T[12, 1] := -0.0125894;
  T[13, 1] := 0.0109689;
  T[14, 1] := -0.133698;
  T[15, 1] := 0.00638407;
  T[16, 1] := -0.00132718;
  T[17, 1] := 0.168496;
  T[18, 1] := -0.0507214;
  T[19, 1] := 0.0854559;
  T[20, 1] := -0.0504475;
  T[21, 1] := 0.010465;
  T[22, 1] := -0.00648272;
  T[23, 1] := -0.00841728;
  T[24, 1] := 0.0168424;
  T[25, 1] := -0.00102296;
  T[26, 1] := -0.0317791;
  T[27, 1] := 0.018604;
  T[28, 1] := -0.00410798;
  T[29, 1] := -0.000606848;
  T[30, 1] := -0.0049819;
  T[31, 1] := 0.0025983;
  T[32, 1] := -0.000560528;
  T[33, 1] := -0.00163652;
  T[34, 1] := -0.000328787;
  T[35, 1] := 0.000116502;
  T[36, 1] := 0.000690904;
  T[37, 1] := 0.00421749;
  T[38, 1] := 0.0000565229;
  T[39, 1] := -0.00146564;
  T[1, 2] := 0;
  T[2, 2] := 1;
  T[3, 2] := 0;
  T[4, 2] := 0;
  T[5, 2] := 2;
  T[6, 2] := 1;
  T[7, 2] := 0;
  T[8, 2] := 0;
  T[9, 2] := 2;
  T[10, 2] := 0;
  T[11, 2] := 1;
  T[12, 2] := 0;
  T[13, 2] := 1;
  T[14, 2] := 0;
  T[15, 2] := 0;
  T[16, 2] := 2;
  T[17, 2] := 3;
  T[18, 2] := 0;
  T[19, 2] := 2;
  T[20, 2] := 3;
  T[21, 2] := 1;
  T[22, 2] := 2;
  T[23, 2] := 0;
  T[24, 2] := 1;
  T[25, 2] := 3;
  T[26, 2] := 0;
  T[27, 2] := 1;
  T[28, 2] := 0;
  T[29, 2] := 0;
  T[30, 2] := 1;
  T[31, 2] := 2;
  T[32, 2] := 3;
  T[33, 2] := 1;
  T[34, 2] := 1;
  T[35, 2] := 2;
  T[36, 2] := 0;
  T[37, 2] := 0;
  T[38, 2] := 3;
  T[39, 2] := 0;
  T[1, 3] := 0;
  T[2, 3] := 0;
  T[3, 3] := 1;
  T[4, 3] := 2;
  T[5, 3] := 0;
  T[6, 3] := 1;
  T[7, 3] := 2;
  T[8, 3] := 0;
  T[9, 3] := 0;
  T[10, 3] := 1;
  T[11, 3] := 1;
  T[12, 3] := 0;
  T[13, 3] := 0;
  T[14, 3] := 3;
  T[15, 3] := 6;
  T[16, 3] := 6;
  T[17, 3] := 0;
  T[18, 3] := 0;
  T[19, 3] := 0;
  T[20, 3] := 0;
  T[21, 3] := 6;
  T[22, 3] := 6;
  T[23, 3] := 3;
  T[24, 3] := 3;
  T[25, 3] := 3;
  T[26, 3] := 3;
  T[27, 3] := 0;
  T[28, 3] := 2;
  T[29, 3] := 0;
  T[30, 3] := 0;
  T[31, 3] := 0;
  T[32, 3] := 0;
  T[33, 3] := 2;
  T[34, 3] := 6;
  T[35, 3] := 6;
  T[36, 3] := 0;
  T[37, 3] := 3;
  T[38, 3] := 6;
  T[39, 3] := 3;
  T[1, 4] := 0;
  T[2, 4] := 0;
  T[3, 4] := 0;
  T[4, 4] := 0;
  T[5, 4] := 1;
  T[6, 4] := 1;
  T[7, 4] := 1;
  T[8, 4] := 0;
  T[9, 4] := 0;
  T[10, 4] := 0;
  T[11, 4] := 0;
  T[12, 4] := 1;
  T[13, 4] := 1;
  T[14, 4] := 0;
  T[15, 4] := 0;
  T[16, 4] := 0;
  T[17, 4] := 1;
  T[18, 4] := 2;
  T[19, 4] := 2;
  T[20, 4] := 2;
  T[21, 4] := 2;
  T[22, 4] := 2;
  T[23, 4] := 0;
  T[24, 4] := 0;
  T[25, 4] := 0;
  T[26, 4] := 1;
  T[27, 4] := 2;
  T[28, 4] := 2;
  T[29, 4] := 0;
  T[30, 4] := 0;
  T[31, 4] := 0;
  T[32, 4] := 0;
  T[33, 4] := 0;
  T[34, 4] := 0;
  T[35, 4] := 0;
  T[36, 4] := 1;
  T[37, 4] := 1;
  T[38, 4] := 1;
  T[39, 4] := 2;
  T[1, 5] := 0;
  T[2, 5] := 0;
  T[3, 5] := 0;
  T[4, 5] := 0;
  T[5, 5] := 0;
  T[6, 5] := 0;
  T[7, 5] := 0;
  T[8, 5] := 1;
  T[9, 5] := 1;
  T[10, 5] := 1;
  T[11, 5] := 1;
  T[12, 5] := 1;
  T[13, 5] := 1;
  T[14, 5] := 0;
  T[15, 5] := 0;
  T[16, 5] := 0;
  T[17, 5] := 0;
  T[18, 5] := 0;
  T[19, 5] := 0;
  T[20, 5] := 0;
  T[21, 5] := 0;
  T[22, 5] := 0;
  T[23, 5] := 1;
  T[24, 5] := 1;
  T[25, 5] := 1;
  T[26, 5] := 1;
  T[27, 5] := 1;
  T[28, 5] := 1;
  T[29, 5] := 2;
  T[30, 5] := 2;
  T[31, 5] := 2;
  T[32, 5] := 2;
  T[33, 5] := 2;
  T[34, 5] := 2;
  T[35, 5] := 2;
  T[36, 5] := 2;
  T[37, 5] := 2;
  T[38, 5] := 2;
  T[39, 5] := 2;
//Load Kq matrix
  Q[1, 1] := 0.00379368;
  Q[2, 1] := 0.00886523;
  Q[3, 1] := -0.032241;
  Q[4, 1] := 0.00344778;
  Q[5, 1] := -0.0408811;
  Q[6, 1] := -0.108009;
  Q[7, 1] := -0.0885381;
  Q[8, 1] := 0.188561;
  Q[9, 1] := -0.00370871;
  Q[10, 1] := 0.00513696;
  Q[11, 1] := 0.0209449;
  Q[12, 1] := 0.00474319;
  Q[13, 1] := -0.00723408;
  Q[14, 1] := 0.00438388;
  Q[15, 1] := -0.0269403;
  Q[16, 1] := 0.0558082;
  Q[17, 1] := 0.0161886;
  Q[18, 1] := 0.00318086;
  Q[19, 1] := 0.015896;
  Q[20, 1] := 0.0471729;
  Q[21, 1] := 0.0196283;
  Q[22, 1] := -0.0502782;
  Q[23, 1] := -0.030055;
  Q[24, 1] := 0.0417122;
  Q[25, 1] := -0.0397722;
  Q[26, 1] := -0.00350024;
  Q[27, 1] := -0.0106854;
  Q[28, 1] := 0.00110903;
  Q[29, 1] := -0.000313912;
  Q[30, 1] := 0.0035985;
  Q[31, 1] := -0.00142121;
  Q[32, 1] := -0.00383637;
  Q[33, 1] := 0.0126803;
  Q[34, 1] := -0.00318278;
  Q[35, 1] := 0.00334268;
  Q[36, 1] := -0.00183491;
  Q[37, 1] := 0.000112451;
  Q[38, 1] := -0.0000297228;
  Q[39, 1] := 0.000269551;
  Q[40, 1] := 0.00083265;
  Q[41, 1] := 0.00155334;
  Q[42, 1] := 0.000302683;
  Q[43, 1] := -0.0001843;
  Q[44, 1] := -0.000425399;
  Q[45, 1] := 0.0000869243;
  Q[46, 1] := -0.0004659;
  Q[47, 1] := 0.0000554194;
  Q[1, 2] := 0;
  Q[2, 2] := 2;
  Q[3, 2] := 1;
  Q[4, 2] := 0;
  Q[5, 2] := 0;
  Q[6, 2] := 1;
  Q[7, 2] := 2;
  Q[8, 2] := 0;
  Q[9, 2] := 1;
  Q[10, 2] := 0;
  Q[11, 2] := 1;
  Q[12, 2] := 2;
  Q[13, 2] := 2;
  Q[14, 2] := 1;
  Q[15, 2] := 0;
  Q[16, 2] := 3;
  Q[17, 2] := 0;
  Q[18, 2] := 1;
  Q[19, 2] := 0;
  Q[20, 2] := 1;
  Q[21, 2] := 3;
  Q[22, 2] := 0;
  Q[23, 2] := 3;
  Q[24, 2] := 2;
  Q[25, 2] := 0;
  Q[26, 2] := 0;
  Q[27, 2] := 3;
  Q[28, 2] := 3;
  Q[29, 2] := 0;
  Q[30, 2] := 3;
  Q[31, 2] := 0;
  Q[32, 2] := 1;
  Q[33, 2] := 0;
  Q[34, 2] := 2;
  Q[35, 2] := 0;
  Q[36, 2] := 1;
  Q[37, 2] := 3;
  Q[38, 2] := 3;
  Q[39, 2] := 1;
  Q[40, 2] := 2;
  Q[41, 2] := 0;
  Q[42, 2] := 0;
  Q[43, 2] := 0;
  Q[44, 2] := 0;
  Q[45, 2] := 3;
  Q[46, 2] := 0;
  Q[47, 2] := 1;
  Q[1, 3] := 0;
  Q[2, 3] := 0;
  Q[3, 3] := 1;
  Q[4, 3] := 2;
  Q[5, 3] := 1;
  Q[6, 3] := 1;
  Q[7, 3] := 1;
  Q[8, 3] := 2;
  Q[9, 3] := 0;
  Q[10, 3] := 1;
  Q[11, 3] := 1;
  Q[12, 3] := 1;
  Q[13, 3] := 0;
  Q[14, 3] := 1;
  Q[15, 3] := 2;
  Q[16, 3] := 0;
  Q[17, 3] := 3;
  Q[18, 3] := 3;
  Q[19, 3] := 0;
  Q[20, 3] := 0;
  Q[21, 3] := 0;
  Q[22, 3] := 1;
  Q[23, 3] := 1;
  Q[24, 3] := 2;
  Q[25, 3] := 3;
  Q[26, 3] := 6;
  Q[27, 3] := 0;
  Q[28, 3] := 3;
  Q[29, 3] := 6;
  Q[30, 3] := 0;
  Q[31, 3] := 6;
  Q[32, 3] := 0;
  Q[33, 3] := 2;
  Q[34, 3] := 3;
  Q[35, 3] := 6;
  Q[36, 3] := 1;
  Q[37, 3] := 2;
  Q[38, 3] := 6;
  Q[39, 3] := 0;
  Q[40, 3] := 0;
  Q[41, 3] := 2;
  Q[42, 3] := 6;
  Q[43, 3] := 0;
  Q[44, 3] := 3;
  Q[45, 3] := 3;
  Q[46, 3] := 6;
  Q[47, 3] := 6;
  Q[1, 4] := 0;
  Q[2, 4] := 0;
  Q[3, 4] := 0;
  Q[4, 4] := 0;
  Q[5, 4] := 1;
  Q[6, 4] := 1;
  Q[7, 4] := 1;
  Q[8, 4] := 1;
  Q[9, 4] := 0;
  Q[10, 4] := 0;
  Q[11, 4] := 0;
  Q[12, 4] := 0;
  Q[13, 4] := 1;
  Q[14, 4] := 1;
  Q[15, 4] := 1;
  Q[16, 4] := 1;
  Q[17, 4] := 1;
  Q[18, 4] := 1;
  Q[19, 4] := 2;
  Q[20, 4] := 2;
  Q[21, 4] := 2;
  Q[22, 4] := 2;
  Q[23, 4] := 2;
  Q[24, 4] := 2;
  Q[25, 4] := 2;
  Q[26, 4] := 2;
  Q[27, 4] := 0;
  Q[28, 4] := 0;
  Q[29, 4] := 0;
  Q[30, 4] := 1;
  Q[31, 4] := 1;
  Q[32, 4] := 2;
  Q[33, 4] := 2;
  Q[34, 4] := 2;
  Q[35, 4] := 2;
  Q[36, 4] := 0;
  Q[37, 4] := 0;
  Q[38, 4] := 0;
  Q[39, 4] := 1;
  Q[40, 4] := 1;
  Q[41, 4] := 1;
  Q[42, 4] := 1;
  Q[43, 4] := 2;
  Q[44, 4] := 2;
  Q[45, 4] := 2;
  Q[46, 4] := 2;
  Q[47, 4] := 2;
  Q[1, 5] := 0;
  Q[2, 5] := 0;
  Q[3, 5] := 0;
  Q[4, 5] := 0;
  Q[5, 5] := 0;
  Q[6, 5] := 0;
  Q[7, 5] := 0;
  Q[8, 5] := 0;
  Q[9, 5] := 1;
  Q[10, 5] := 1;
  Q[11, 5] := 1;
  Q[12, 5] := 1;
  Q[13, 5] := 1;
  Q[14, 5] := 1;
  Q[15, 5] := 1;
  Q[16, 5] := 0;
  Q[17, 5] := 0;
  Q[18, 5] := 0;
  Q[19, 5] := 0;
  Q[20, 5] := 0;
  Q[21, 5] := 0;
  Q[22, 5] := 0;
  Q[23, 5] := 0;
  Q[24, 5] := 0;
  Q[25, 5] := 0;
  Q[26, 5] := 0;
  Q[27, 5] := 1;
  Q[28, 5] := 1;
  Q[29, 5] := 1;
  Q[30, 5] := 1;
  Q[31, 5] := 1;
  Q[32, 5] := 1;
  Q[33, 5] := 1;
  Q[34, 5] := 1;
  Q[35, 5] := 1;
  Q[36, 5] := 2;
  Q[37, 5] := 2;
  Q[38, 5] := 2;
  Q[39, 5] := 2;
  Q[40, 5] := 2;
  Q[41, 5] := 2;
  Q[42, 5] := 2;
  Q[43, 5] := 2;
  Q[44, 5] := 2;
  Q[45, 5] := 2;
  Q[46, 5] := 2;
  Q[47, 5] := 2;
// Compute Kt & Kq
  Kt := 0;
  for i in 1:39 loop
    Kt := Kt + T[i, 1]*J^T[i, 2]*P_D^T[i, 3]*Ae_Ao^T[i, 4]*Z^T[i, 5];
  end for;
  Kq := 0;
  for i in 1:47 loop
    Kq := Kq + Q[i, 1]*J^Q[i, 2]*P_D^Q[i, 3]*Ae_Ao^Q[i, 4]*Z^Q[i, 5];
  end for;
  annotation(
    Documentation(info = "<html><head>
</head>
<body>
<h1>Wageningen B-Series Propeller Characteristics</h1>

<p>
  The <em>WageningenB_Kt_Kq</em> function calculates the non-dimensional hydrodynamic coefficients for fixed-pitch propellers (FPP). 
  It implements the standard regression polynomials derived from the Wageningen B-series model tests, enabling the computation of thrust and torque based on propeller geometry and flow conditions.
</p>

<h2>Description</h2>

<p>
  This function is a mathematical implementation of the \"Open-Water\" characteristics. 
  It takes the geometric properties of a specific propeller design (pitch, area, blades) and the current operating point (advance ratio <em>J</em>) to return the Thrust Coefficient (<em>K<sub>T</sub></em>) and Torque Coefficient (<em>K<sub>Q</sub></em>).
  These coefficients are essential for the <em>MarinePropeller</em> component to calculate physical forces.
</p>

<h2>Inputs</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Input arguments of the function</caption>
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
      <td><strong>J</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Advance ratio (Flow speed / Rotational tip speed).</td>
    </tr>
    <tr>
      <td><strong>P_D</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Pitch-to-Diameter ratio (P/D).</td>
    </tr>
    <tr>
      <td><strong>Ae_Ao</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Expanded Blade Area Ratio (A<sub>E</sub>/A<sub>0</sub>).</td>
    </tr>
    <tr>
      <td><strong>Z</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Number of propeller blades.</td>
    </tr>
  </tbody>
</table>

<h2>Outputs</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Returned values</caption>
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
      <td><strong>Kt</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Calculated Thrust Coefficient.</td>
    </tr>
    <tr>
      <td><strong>Kq</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Calculated Torque Coefficient.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The coefficients are computed using multiple regression polynomials as defined by <strong>Oosterveld &amp; Van Oossanen (1975)</strong>:
</p>

<ul>
  <li><strong>Polynomial Summation:</strong> The function iterates through a series of terms (39 for <em>K<sub>T</sub></em>, 47 for <em>K<sub>Q</sub></em>) where each term is a product of the inputs raised to specific powers, scaled by a regression coefficient:
    <br><em>K<sub>T</sub> = ∑ C<sub>T,i</sub> · J<sup>s</sup> · (P/D)<sup>t</sup> · (A<sub>E</sub>/A<sub>0</sub>)<sup>u</sup> · Z<sup>v</sup></em>.
  </li>
  <li><strong>Validity Range:</strong> While the function will compute values for any input, the regression is physically valid only within standard B-series ranges (e.g., 2 to 7 blades, 0.5 to 1.4 P/D ratio).</li>
  <li><strong>Reynolds Number:</strong> This implementation assumes a standard Reynolds number correction is either negligible or handled externally, focusing on the core polynomial shape.</li>
</ul>

<hr>
<h2>References</h2>
<ul>
  <li>Oosterveld, M.W.C., &amp; Van Oossanen, P. (1975). <em>Further computer-analyzed data of the Wageningen B-screw series</em>. International Shipbuilding Progress.</li>
  <li>Code adapted from <strong>ShipSIM</strong> repository: <a href=\"https://github.com/BasilioPV/ShipSIM\">https://github.com/BasilioPV/ShipSIM</a></li>
</ul>


</body></html>", revisions = "<html><head></head><body><br></body></html>"));
end WageningenB_Kt_Kq;

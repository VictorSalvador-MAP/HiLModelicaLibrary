within Aquanaut.Functions;

function LagrangeInterpolationFunction
  extends Modelica.Icons.Function;
  /**********************************************************/
  /****************** FUNCTION PARAMETERS *******************/
  /**********************************************************/
  //inputs
  input Real heave;
  input Real pitch;
  input Real roll;
  //node values
  input Real xcob[64];
  input Real ycob[64];
  input Real zcob[64];
  input Real dv[64];
  //node points
  input Real heaveRef[4];
  input Real pitchRef[4];
  input Real rollRef[4];
  //calculated parameters - lagrange denominators
  input Real denHeave[4];
  input Real denPitch[4];
  input Real denRoll[4];
  
  /**********************************************************/
  /****************** FUNCTION RETURNS **********************/
  /**********************************************************/
  //output variables
  output Real xcobOut;
  output Real ycobOut;
  output Real zcobOut;
  output Real dvOut;
  
  /**********************************************************/
  /****************** INTERNAL VARIABLES ********************/
  /**********************************************************/
protected
  
  //heave lagrange weight numerator
  Real numHeave[4];
  
  //pitch lagrange weight numerator
  Real numPitch[4];
  
  //roll lagrange weight numerator
  Real numRoll[4];
  
  //lagrange weights
  Real Lh[4], Lp[4], Lr[4]; 
  
  //aux variable to select each node value.
  Integer row; 
  
  /**********************************************************/
  /****************** FUNCTION OPERATION ********************/
  /**********************************************************/
algorithm
  
  //lagrange weights numerators calculation
  numHeave[1] := (heave - heaveRef[2])*(heave - heaveRef[3])*(heave - heaveRef[4]);
  numHeave[2] := (heave - heaveRef[1])*(heave - heaveRef[3])*(heave - heaveRef[4]);
  numHeave[3] := (heave - heaveRef[1])*(heave - heaveRef[2])*(heave - heaveRef[4]);
  numHeave[4] := (heave - heaveRef[1])*(heave - heaveRef[2])*(heave - heaveRef[3]);
  numPitch[1] := (pitch - pitchRef[2])*(pitch - pitchRef[3])*(pitch - pitchRef[4]);
  numPitch[2] := (pitch - pitchRef[1])*(pitch - pitchRef[3])*(pitch - pitchRef[4]);
  numPitch[3] := (pitch - pitchRef[1])*(pitch - pitchRef[2])*(pitch - pitchRef[4]);
  numPitch[4] := (pitch - pitchRef[1])*(pitch - pitchRef[2])*(pitch - pitchRef[3]);
  numRoll[1] := (roll - rollRef[2])*(roll - rollRef[3])*(roll - rollRef[4]);
  numRoll[2] := (roll - rollRef[1])*(roll - rollRef[3])*(roll - rollRef[4]);
  numRoll[3] := (roll - rollRef[1])*(roll - rollRef[2])*(roll - rollRef[4]);
  numRoll[4] := (roll - rollRef[1])*(roll - rollRef[2])*(roll - rollRef[3]);

  //lagrange weights calculation
  for i in 1:4 loop
    Lh[i] := numHeave[i]/denHeave[i];
    Lp[i] := numPitch[i]/denPitch[i];
    Lr[i] := numRoll[i]/denRoll[i];
  end for;

  //output variables initialization
  xcobOut := 0.0;
  ycobOut := 0.0;
  zcobOut := 0.0;
  dvOut := 0.0;
  
  //lagrange interpolation
  //Roll loop
  for k in 1:4 loop
    //Pitch loop
    for j in 1:4 loop
      //Heave loop
      for i in 1:4 loop
        //node index selection
        row := (k - 1)*16 + (j - 1)*4 + i;
        
        //Sum of Xcob_ijk*L(roll)*L(pitch)*L(heave)
        xcobOut := xcobOut + xcob[row]*Lh[i]*Lp[j]*Lr[k];
        
        //Sum of Ycob_ijk*L(roll)*L(pitch)*L(heave)
        ycobOut := ycobOut + ycob[row]*Lh[i]*Lp[j]*Lr[k];
        
        //Sum of zcob_ijk*L(roll)*L(pitch)*L(heave)
        zcobOut := zcobOut + zcob[row]*Lh[i]*Lp[j]*Lr[k];
        
        //Sum of dvOut_ijk*L(roll)*L(pitch)*L(heave)
        dvOut := dvOut + dv[row]*Lh[i]*Lp[j]*Lr[k];

      end for;
    end for;
  end for;
annotation(
    Documentation(info = "<html><head>
</head>

<body>

<h1 style=\"text-align: left;\">Lagrange Interpolation Function</h1>

<div>
The <b>LagrangeInterpolationFunction</b> is an Modelica function responsible for performing the optimized three-dimensional Lagrange interpolation used by the InterpolatedBuoyancyBlock. The function computes the hydrostatic responses of the vessel based on the instantaneous heave, pitch, and roll inputs, using pre-calculated nodal hydrostatic data and pre-computed Lagrange denominators.
</div>

<div><br></div>

<h2>Description</h2>

<div>
The function receives the vessel instantaneous kinematic states through the variables <b>heave</b>, <b>pitch</b>, and <b>roll</b>. Using these inputs, the function evaluates the corresponding hydrostatic responses by applying a three-dimensional Lagrange interpolation over a structured grid composed of 64 nodal points.
</div>

<div><br></div>

<div>
The interpolation grid is composed of:
<ul>
<li>4 nodal points for heave;</li>
<li>4 nodal points for pitch;</li>
<li>4 nodal points for roll.</li>
</ul>

This results in a total of:
</div>

<div style=\"text-align:center;\">
4 × 4 × 4 = 64 nodal points
</div>

<div><br></div>

<div>
The function interpolates the following hydrostatic properties:
<ul>
<li>Center of Buoyancy X-coordinate (xcobOut);</li>
<li>Center of Buoyancy Y-coordinate (ycobOut);</li>
<li>Center of Buoyancy Z-coordinate (zcobOut);</li>
<li>Displaced Volume (dvOut).</li>
</ul>
</div>

<div><br></div>

<div>
To optimize real-time performance, the denominators of the Lagrange basis functions are pre-calculated externally and passed into the function through the arrays:
<ul>
<li><b>denHeave</b>;</li>
<li><b>denPitch</b>;</li>
<li><b>denRoll</b>.</li>
</ul>

During execution, the function computes only the numerators and the corresponding interpolation weights, minimizing redundant calculations during simulation runtime.
</div>

<div><br></div>

<div>
The interpolation process is performed in three stages:
<ol>
<li>Calculation of the Lagrange basis numerators;</li>
<li>Calculation of the interpolation weights for each axis;</li>
<li>Accumulation of the weighted hydrostatic nodal values.</li>
</ol>
</div>

<div><br></div>

<div>
The nodal values are stored in flattened 64-element arrays. The internal indexing follows the convention:
<ul>
<li>Heave varies every 1 index;</li>
<li>Pitch varies every 4 indices;</li>
<li>Roll varies every 16 indices.</li>
</ul>

The node index is reconstructed internally using:
</div>

<div style=\"text-align:center;\">
row := (k - 1)*16 + (j - 1)*4 + i
</div>

<div><br></div>


<h2>Inputs</h2>

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
<td><b>heave</b></td>
<td>Real</td>
<td>m</td>
<td>Instantaneous vessel heave position used for interpolation.</td>
</tr>

<tr>
<td><b>pitch</b></td>
<td>Real</td>
<td>rad</td>
<td>Instantaneous vessel pitch angle used for interpolation.</td>
</tr>

<tr>
<td><b>roll</b></td>
<td>Real</td>
<td>rad</td>
<td>Instantaneous vessel roll angle used for interpolation.</td>
</tr>

<tr>
<td><b>xcob</b></td>
<td>Real[64]</td>
<td>m</td>
<td>Flattened nodal values for the X-coordinate of the Center of Buoyancy.</td>
</tr>

<tr>
<td><b>ycob</b></td>
<td>Real[64]</td>
<td>m</td>
<td>Flattened nodal values for the Y-coordinate of the Center of Buoyancy.</td>
</tr>

<tr>
<td><b>zcob</b></td>
<td>Real[64]</td>
<td>m</td>
<td>Flattened nodal values for the Z-coordinate of the Center of Buoyancy.</td>
</tr>

<tr>
<td><b>dv</b></td>
<td>Real[64]</td>
<td>m³</td>
<td>Flattened nodal values for displaced volume.</td>
</tr>

<tr>
<td><b>heaveRef</b></td>
<td>Real[4]</td>
<td>m</td>
<td>Reference nodal points for the heave axis.</td>
</tr>

<tr>
<td><b>pitchRef</b></td>
<td>Real[4]</td>
<td>rad</td>
<td>Reference nodal points for the pitch axis.</td>
</tr>

<tr>
<td><b>rollRef</b></td>
<td>Real[4]</td>
<td>rad</td>
<td>Reference nodal points for the roll axis.</td>
</tr>

<tr>
<td><b>denHeave</b></td>
<td>Real[4]</td>
<td>-</td>
<td>Pre-calculated Lagrange denominators for the heave interpolation basis.</td>
</tr>

<tr>
<td><b>denPitch</b></td>
<td>Real[4]</td>
<td>-</td>
<td>Pre-calculated Lagrange denominators for the pitch interpolation basis.</td>
</tr>

<tr>
<td><b>denRoll</b></td>
<td>Real[4]</td>
<td>-</td>
<td>Pre-calculated Lagrange denominators for the roll interpolation basis.</td>
</tr>

</tbody>
</table>

<p style=\"text-align: center; font-size: 0.9em;\">
<b>Tab. 1:</b> Input variables and interpolation data used by the LagrangeInterpolationFunction
</p>

<div><br></div>

<h2>Outputs</h2>

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
<td><b>xcobOut</b></td>
<td>Real</td>
<td>m</td>
<td>Interpolated X-coordinate of the Center of Buoyancy.</td>
</tr>

<tr>
<td><b>ycobOut</b></td>
<td>Real</td>
<td>m</td>
<td>Interpolated Y-coordinate of the Center of Buoyancy.</td>
</tr>

<tr>
<td><b>zcobOut</b></td>
<td>Real</td>
<td>m</td>
<td>Interpolated Z-coordinate of the Center of Buoyancy.</td>
</tr>

<tr>
<td><b>dvOut</b></td>
<td>Real</td>
<td>m³</td>
<td>Interpolated displaced volume.</td>
</tr>

</tbody>
</table>

<p style=\"text-align: center; font-size: 0.9em;\">
<b>Tab. 2:</b> Output variables generated by the interpolation function
</p>

<div><br></div>

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
<td><i>numHeave</i></td>
<td>Real[4]</td>
<td>-</td>
<td>Lagrange basis numerators calculated for the heave axis.</td>
</tr>

<tr>
<td><i>numPitch</i></td>
<td>Real[4]</td>
<td>-</td>
<td>Lagrange basis numerators calculated for the pitch axis.</td>
</tr>

<tr>
<td><i>numRoll</i></td>
<td>Real[4]</td>
<td>-</td>
<td>Lagrange basis numerators calculated for the roll axis.</td>
</tr>

<tr>
<td><i>Lh</i></td>
<td>Real[4]</td>
<td>-</td>
<td>Final Lagrange interpolation weights for the heave axis.</td>
</tr>

<tr>
<td><i>Lp</i></td>
<td>Real[4]</td>
<td>-</td>
<td>Final Lagrange interpolation weights for the pitch axis.</td>
</tr>

<tr>
<td><i>Lr</i></td>
<td>Real[4]</td>
<td>-</td>
<td>Final Lagrange interpolation weights for the roll axis.</td>
</tr>

<tr>
<td><i>row</i></td>
<td>Integer</td>
<td>-</td>
<td>Auxiliary index variable used to access flattened nodal arrays.</td>
</tr>

</tbody>
</table>

<p style=\"text-align: center; font-size: 0.9em;\">
<b>Tab. 3:</b> Internal protected variables used during interpolation execution
</p>

<div>
<h2>Mathematical Logic</h2>


<strong>3D Lagrange Interpolation: </strong>The hydrostatic outputs are calculated by summing the products of the 1D Lagrange weights and their corresponding nodal values, expressed as:
<br>
<br>
<em>F</em>(<em>h</em>, <em>p</em>, <em>r</em>) = Σ Σ Σ <em>F<sub>i,j,k</sub></em> · <em>L<sub>h</sub></em>(<em>i</em>) · <em>L<sub>p</sub></em>(<em>j</em>) · <em>L<sub>r</sub></em>(<em>k</em>), 
<br>
for <em>i</em> = 1..4, <em>j</em> = 1..4, and <em>k</em> = 1..4.


</div></body></html>"));
end LagrangeInterpolationFunction;

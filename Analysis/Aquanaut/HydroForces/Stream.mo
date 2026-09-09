within Aquanaut.HydroForces;

model Stream

 // deterministic parameters
  parameter Modelica.Units.SI.Velocity velocityMean=20 "Current velocity nominal value";
  parameter Modelica.Units.SI.Angle psiCurr=0 "Heading angle of the ocean current field";
  parameter Modelica.Units.SI.Density fluidDensity (displayUnit = "kg/m3")= 1025 "Fluid density";
  // random number parameters
  parameter Modelica.Units.SI.Velocity velocitySigma=10 "Current velocity standard deviation";
  parameter Real mu = 1 "Gauss-Markov relaxation coefficient";
  parameter Integer localSeed=2;
  //parameter Integer globalSeed=2*globalSeed;
  parameter Integer globalSeed=2*localSeed;

// Velocities
  Modelica.Units.SI.Velocity v[2] "Current velocity 2D vector resolved in world frame"; 
  Modelica.Units.SI.Velocity vC(start=0) "Current velocity amplitude";
  Modelica.Units.SI.Velocity noiseSource "Noisy velocity amplitude";

  Modelica.Units.SI.Acceleration aC "Current acceleration";  
// auxiliary variables for random number generation
  Real uniformSample;
  Integer uniformState[Modelica.Math.Random.Generators.Xorshift128plus.nState];
initial equation
// initialization of random number
  uniformState = Modelica.Math.Random.Generators.Xorshift128plus.initialState(localSeed, globalSeed);
  
equation
// random number generation
  when sample(0,0.01) then
    (uniformSample, uniformState) = Modelica.Math.Random.Generators.Xorshift128plus.random(pre(uniformState));
    noiseSource = Modelica.Math.Distributions.Normal.quantile(uniformSample, velocityMean, velocitySigma);
  end when;
// Gauss-Markov Process
  aC = der(vC);
  aC + mu*vC = noiseSource;
// Ocean Current 2D vector
  v = vC*{cos(psiCurr),sin(psiCurr)};
  
  //vStream = v;

annotation(defaultComponentName="Stream",
    defaultComponentPrefixes="inner",
    missingInnerMessage="No \"stream\" component is defined. A default stream
component with the default current velocity field and water density will be used. If this is not desired,
drag Aquanaut.HydroForces.Stream into the top level of your model.",
    Diagram(graphics),
    Icon(graphics = {Rectangle(fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(textColor = {85, 85, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name", textStyle = {TextStyle.Bold}), Polygon(origin = {34, 44}, rotation = 48, lineColor = {85, 0, 255}, fillColor = {85, 0, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}}), Line(origin = {32, 46}, points = {{-48, 44}, {48, -44}}, color = {85, 0, 255}, thickness = 4.25), Line(origin = {-34, 30}, points = {{-48, 44}, {114, -112}}, color = {85, 85, 255}, thickness = 4.25), Line(origin = {-40, -32}, points = {{-48, 44}, {48, -44}}, color = {85, 170, 255}, thickness = 4.25), Polygon(origin = {-8, 4}, rotation = 48, lineColor = {85, 85, 255}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}}), Polygon(origin = {-40, -32}, rotation = 48, lineColor = {85, 170, 255}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, points = {{-10, -20}, {10, -20}, {0, 20}, {-10, -20}})}),
 Documentation(info = "<html><head></head><body>
<h1>Ocean Current Environment (Stream)</h1>

<p>
  The <em>Stream</em> model defines the global environmental properties for the marine simulation, specifically the fluid density and the ocean current velocity field.
  It is designed to be instantiated as an <strong>inner</strong> component at the top level of the system hierarchy, allowing other components (such as <em>Viscous</em>, <em>Radiation</em>, or <em>Buoyancy</em>) to access environmental data automatically via <code>outer</code> references.
</p>

<h2>Description</h2>

<p>
  This component simulates a spatially uniform but temporally varying ocean current. 
  Instead of a constant velocity, the current speed is modeled as a stochastic process (Gauss-Markov) to introduce realistic variability and noise into the simulation. 
  This is crucial for testing control systems against environmental disturbances.
</p>

<h2>Parameters</h2>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 1:</strong> Parameters of the Stream block</caption>
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
      <td><strong>velocityMean</strong></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Nominal mean value of the current velocity magnitude.</td>
    </tr>
    <tr>
      <td><strong>psiCurr</strong></td>
      <td>Angle</td>
      <td>rad</td>
      <td>Heading angle of the ocean current field (direction of flow).</td>
    </tr>
    <tr>
      <td><strong>fluidDensity</strong></td>
      <td>Density</td>
      <td>kg/m³</td>
      <td>Density of the fluid (default: 1025 kg/m³ for seawater). Used by buoyancy and lift calculations.</td>
    </tr>
    <tr>
      <td><strong>velocitySigma</strong></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Standard deviation of the current velocity (intensity of the fluctuation).</td>
    </tr>
    <tr>
      <td><strong>mu</strong></td>
      <td>Real</td>
      <td>-</td>
      <td>Gauss-Markov relaxation coefficient. Controls how quickly the velocity correlation decays (higher values = faster fluctuation).</td>
    </tr>
    <tr>
      <td><strong>localSeed</strong></td>
      <td>Integer</td>
      <td>-</td>
      <td>Seed for the local random number generator.</td>
    </tr>
    <tr>
      <td><strong>globalSeed</strong></td>
      <td>Integer</td>
      <td>-</td>
      <td>Global seed offset for randomization.</td>
    </tr>
  </tbody>
</table>

<h2>Global Variables</h2>

<p>
  This component does not have physical connectors. Instead, it exposes variables that are accessed globally by other components.
</p>

<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Tab. 2:</strong> Accessible variables</caption>
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
      <td><strong>v</strong></td>
      <td>Velocity[2]</td>
      <td>m/s</td>
      <td>Current velocity vector resolved in the world frame (North, East).</td>
    </tr>
    <tr>
      <td><strong>vC</strong></td>
      <td>Velocity</td>
      <td>m/s</td>
      <td>Instantaneous magnitude of the current velocity.</td>
    </tr>
    <tr>
      <td><strong>aC</strong></td>
      <td>Acceleration</td>
      <td>m/s²</td>
      <td>Instantaneous acceleration of the current flow.</td>
    </tr>
  </tbody>
</table>

<h2>Physical and Mathematical Logic</h2>

<p>
  The model generates a time-varying current velocity magnitude <em>v<sub>C</sub></em> using a first-order <strong>Gauss-Markov process</strong>. This creates \"colored noise\" rather than pure white noise, representing the inertial nature of fluid flow variations.
</p>

<ul>
  <li><strong>Stochastic Process:</strong> The differential equation governing the velocity magnitude is: <br>
  <em>v̇<sub>C</sub></em> + <em>μ</em> · <em>v<sub>C</sub></em> = <em>w(t)</em> <br>
  Where <em>w(t)</em> is a noise source derived from a Normal distribution defined by <code>velocityMean</code> and <code>velocitySigma</code>.</li>
  
  <li><strong>Vector Decomposition:</strong> The calculated magnitude is projected onto the global coordinate system using the heading angle <em>ψ</em>:
    <ul>
      <li><em>v<sub>x</sub></em> = <em>v<sub>C</sub></em> · cos(<em>ψ</em>)</li>
      <li><em>v<sub>y</sub></em> = <em>v<sub>C</sub></em> · sin(<em>ψ</em>)</li>
    </ul>
  </li>
</ul>

<hr>
<p>
  <em>Note: This component must be present in the top level of any simulation involving Aquanaut hydrodynamics to provide the necessary environmental context.</em>
</p>


</body></html>"));
end Stream;

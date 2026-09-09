within Aquanaut;

package Info
  extends Modelica.Icons.Information;
  annotation(
    Documentation(info = "<html><head>
</head>
<body>
<h1>Aquanaut Library</h1>
<p>
  The <strong>Aquanaut</strong> library is an environment for modeling and simulating maritime systems and vessel dynamics. 
  It is based on the theoretical principles and conventions presented by <strong>Thor I. Fossen</strong> in the book <em>'Handbook of Marine Craft Hydrodynamics and Motion Control' (2011)</em>. 
  The library provides modular components to simulate the interaction between the hull, propulsion systems, hydrodynamic forces, and control algorithms.
</p>

<p>
  <strong>Developed by:</strong> MWF Mechatronics under the direction of <strong>Prof. Dr. Alexandre Carvalho Leite</strong>.
</p>

<h2>Package Structure and Theoretical References</h2>
<ul>
  <li><strong>ShipParts</strong>: Contains components categorized as <strong>passive surfaces</strong> and structural parts.
    <ul>
      <li><i>Hull</i>: Implements the <i>6-DOF rigid-body equations</i> of motion using the kinematics and kinetics conventions defined in Chapters 2 and 3.</li>
      <li><i>MarinePropeller</i>: Based on open-water propeller models and the <i>Wageningen B-series</i>.</li>
      <li><i>MarineRudder</i>: Models the steering interface for directional control.</li>
    </ul>
  </li>
  
  <li><strong>Equipment</strong>: Houses <strong>more complex hardware equipment</strong> and auxiliary systems required for vessel operation.
    <ul>
      <li><em>Actuators</em>: Includes diesel engines, transmission systems, and rudder actuation systems.</li>
      <li><em>Sensors</em>: Contains angle sensors and lever sensors for command interfacing.</li>
    </ul>
  </li>

  <li><strong>HydroForces</strong>: Implements hydrodynamic force models:
    <ul>
      <li><em>Buoyancy</em>: Calculates buoyancy forces and static stability based on the hydrostatic theory.</li>
      <li><em>Radiation</em>: Handles frequency-dependent added mass and radiation damping, utilizing potential theory principles discussed in Chapters 5 and 6.</li>
      <li><em>Viscous</em>: Implements linear and quadratic viscous damping in 6 degrees of freedom (DOF) following the <i>Maneuvering Theory</i> in Chapter 6, specifically Equation (6.101).</li>
    </ul>
  </li>
  
  <li><strong>Processing</strong>: Focused on control logic, such as the <i>ControlBox</i> for rudder automation and the <i>MicroCommander</i> for throttle management.</li>
  
  <li><strong>Functions</strong>: Includes mathematical functions such as the <i>Wageningen B series</i> for calculating thrust (K_t) and torque (K_q) coefficients.</li>
  
  <li><strong>Examples</strong>: Ready-to-simulate models demonstrating the library usage, such as <i>BuoyantVessel</i> and <i>FreeFloating</i>.</li>
</ul>

<h2>How to Use</h2>
<ol>
  <li>Explore the models in the <strong>Examples</strong> package to understand the connections between components and Fossen's theory.</li>
  <li>Use the <strong>Hull</strong> model as the central base for multibody dynamics.</li>
  <li>Connect the forces from the <strong>HydroForces</strong> package to the <em>frame_a</em> of the hull to simulate behavior in a dynamic aquatic environment.</li>
  <li>Integrate control systems from the <strong>Processing</strong> package with the actuators and sensors from <strong>Equipment</strong> to close control loops.</li>
</ol>

<hr>
<p><em>Primary Reference: Fossen, T. I. (2011). Handbook of Marine Craft Hydrodynamics and Motion Control. John Wiley &amp; Sons.</em></p>

</body></html>"));
end Info;

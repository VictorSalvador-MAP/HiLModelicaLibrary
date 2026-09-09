within Aquanaut.Functions;

function WageningenB_Kt "Wageningen B series Kt"
  extends Modelica.Icons.Function;

  input Real J "Advance ratio";
  input Real P_D "Pitch-diameter ratio";
  input Real Ae_Ao "Blade area ratio";
  input Real Z "Number of blades";

  output Real Kt "Kt coefficient";

protected
  Real Kq_unused;

algorithm
  (Kt, Kq_unused) := WageningenB_Kt_Kq(J, P_D, Ae_Ao, Z);

end WageningenB_Kt;
within Aquanaut.Functions;

function WageningenB_Kq "Wageningen B series Kq"
  extends Modelica.Icons.Function;

  input Real J "Advance ratio";
  input Real P_D "Pitch-diameter ratio";
  input Real Ae_Ao "Blade area ratio";
  input Real Z "Number of blades";

  output Real Kq "Kq coefficient";

protected
  Real Kt_unused;

algorithm
  (Kt_unused, Kq) := WageningenB_Kt_Kq(J, P_D, Ae_Ao, Z);

end WageningenB_Kq;
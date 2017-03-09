function [ b ] = T_s_Solver(Inletfluid, OutletPressure)
%Uses bisection method to solve for the temperature given that a process is
%isentropic. Inputs required are the inlet fluid, the pressure after the
%process and the cycle inlet air.
Pref = 101.325;


fluid2 = WorkingFluid(Inletfluid.Y, Inletfluid.Node);
fluid2.P = OutletPressure;
Tguess = Inletfluid.T*(fluid2.P/Inletfluid.P)^(1-(1/(Inletfluid.CP/Inletfluid.CV)));
fluid2.T = Tguess;
a=300;
b=fluid2.T;
c=1400;
count=0;
x = mass_smix(Inletfluid,Pref) - mass_smix(fluid2,Pref);
while(abs(x)>.001)
    
    if(x > 0)
        a = b;
        temp = b;
        b=(c-temp)/2 + temp;
    elseif (x<0)
        c = b;
        temp = b;
        b = (temp-a)/2 + a;
    end
    fluid2.T = b;
    x = mass_smix(Inletfluid,Pref)-mass_smix(fluid2,Pref);
    count = 1+count;
end

end


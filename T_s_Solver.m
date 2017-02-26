function [ b ] = T_s_Solver(fluid1, Pnew, InletAir)
%Uses bisection method to solve for the temperature given that a process is
%isentropic. Inputs required are the inlet fluid, the pressure after the
%process and the cycle inlet air.
Pref = 101.325;
x=10;
fluid2 = WorkingFluid(291.483,99.4017, InletAir.Y);
fluid2.P = Pnew;
fluid1.P = 98.405;
Tguess = fluid1.T*(fluid2.P/fluid1.P)^(1-(1/(fluid1.CP/fluid1.CV)));
fluid2.T = 400;
disp(fluid2.T);
a=300;
b=Tguess;
c=1480;
count=0;
while(abs(x)>.01 && x~=0)
    x = mass_smix(fluid1,Pref)-mass_smix(fluid2,Pref);
    if(x>0)
        a=b;
        temp = b;
        b=(c+temp)/2;
    elseif (x<0)
        c = b;
        temp = b;
        b = (a+temp)/2;
    end
    fluid2.T = b;
    count = 1+count
end

end


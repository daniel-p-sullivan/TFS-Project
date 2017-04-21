function [ b ] = T_h_solver( workingfluid, h_target )
%Uses bisection method to solve for the temperature of the mixture given
%the enthalpy. Iterations must be used if temperature of a mixture is
%unknown
%workingfluid is the mixture of ideal gases, and h_target is the known
%enthalpy of that mixture.

a = 273; %minimum temperatre possible
b = 500;  %initial guess for temperature
c = 1480; %maximum temeperature of range
count=0;

fluid2 = WorkingFluid(workingfluid.Y, workingfluid.Node);
x = h_target - mass_hmix(fluid2.MIX,b); %difference between enthalpy at guess temperature and known enthalpy
while(abs(x)>.001 && x~=0)
    
    if(x>0)
        a=b;
        temp = b;
        b=(c+temp)/2;
        
    elseif (x<0)
        c = b;
        temp = b;
        b = (a+temp)/2;
    end
    x = h_target - mass_hmix(fluid2.MIX,b);
    count = 1+count;
end
end


function [ b ] = T_s_Solver(wet_air1)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Pref = 101.325;
x=10;
wet_air2 = WetAir();
Tguess = wet_air1.T*(wet_air2.P/wet_air1.P)^(1-(1/(wet_air1.CP/wet_air1.CV)));
wet_air2.T = Tguess;
a=0;
b=Tguess;
c=1477.594;

while(x>.01)
    x = mass_smix(wet_air1,Pref)-mass_smix(wet_air2,Pref);
    if(x>0)
        a=b;
        b=(c-a)/2;
    elseif (x<0)
        c = b;
        b = (c-a)/2;
    end
    wet_air2.T = b;
end

end


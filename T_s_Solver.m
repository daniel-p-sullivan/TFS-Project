function [ b ] = T_s_Solver(wet_air1,Pnew)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Pref = 101.325;
x=10;
wet_air2 = WetAir(.6,291.483,99.4017,2.128);
wet_air2.P = Pnew;
wet_air1.P = 98.405;
Tguess = wet_air1.T*(wet_air2.P/wet_air1.P)^(1-(1/(wet_air1.CP/wet_air1.CV)));
wet_air2.T = 400;
disp(wet_air2.T);
a=400;
b=Tguess;
c=800;
count=0;
while(abs(x)>.01 && x~=0)
    x = mass_smix(wet_air1,Pref)-mass_smix(wet_air2,Pref);
    if(x>0)
        a=b;
        temp = b;
        b=(c-temp)/2+temp;
    elseif (x<0)
        c = b;
        temp = b;
        b = (temp-a)/2+a;
    end
    wet_air2.T = b;
    count = 1+count
end

end


function [c_p] = c_p(gas, T)
%This function outputs the mass specific c_p of a gas at a temperature specified in Kelvins.

%   a,b,c,d are coefficients in the function c_p(T)
%gas inputs accepted: Oxygen, Carbon_Dio, Nitrogen, Water, Argon.
c_p = 0;
Rmolar = 8.314; %kj/(kmol K)
if(strcmp(gas,'Argon')~=1)
    switch gas %setting polynomial coefficients
        case 'Oxygen'
        a = 25.48;
        b = 1.52e-2;
        c = -.7155e-5;
        d = 1.312e-9;
        Mw = 31.999; %kg/kmol
        c_p = (a+b*(T)+c*(T^2)+d*(T^3))/Mw;
        
        case 'Nitrogen'
        a = 28.9;
        b = -.1571e-2;
        c = .8081e-5;
        d = -2.873e-9;
        Mw = 28.013;
        c_p = (a+b*(T)+c*(T^2)+d*(T^3))/Mw;
        
        case 'Water'
        a= 32.34;
        b = .1923e-2;
        c = 1.055e-5;
        d = -3.595e-9;
        Mw = 18.015;
        c_p = (a+b*(T)+c*(T^2)+d*(T^3))/Mw;
        
        case 'Carbon_Dio'
        a = 22.26;
        b = 5.981e-2;
        c = -3.501e-5;
        d = 7.469e-9;
        Mw = 44.01;  
        c_p = (a+b*(T)+c*(T^2)+d*(T^3))/Mw;
        
    end
    
         %cp is calculated with substition of temperature into polynomial expression.
        
    elseif (strcmp(gas,'Argon'))  %Argon has constant specific heats
        Mw = 39.948;
        c_p = (5/2)*(Rmolar/Mw);
    
end
end


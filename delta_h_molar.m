function [delta_h] = delta_h_molar(gas, T, Tref)
%This function outputs the specific enthalpy of a gas.  Inputs required are gas, temperature, and reference temperature (in Kelvins).
%gas inputs accepted: Oxygen, Carbon_Dio, Nitrogen, Water, Argon.
%   a,b,c,d are coefficients in the function c_p(T)
%
delta_h = 0;
Rmolar = 8.314; %kj/(kmol K)
if(strcmp(gas,'Argon')~=1)
    switch(gas) %setting polynomial coefficients
        case('Oxygen')
        a = 25.48;
        b = 1.52e-2;
        c = -.7155e-5;
        d = 1.312e-9;
        Mw = 31.999; %kg/kmol
        cp = [d c b a]; %created for the function polyint
        CP = polyint(cp); %polyint integrates cp
        delta_h = diff(polyval(CP,[Tref T])); %computes the difference between CP evaluated at Tref and T
        
        case('Nitrogen')
        a = 28.9;
        b = -.1571e-2;
        c = .8081e-5;
        d = -2.873e-9;
        Mw = 28.013;
        cp = [d c b a]; %created for the function polyint
        CP = polyint(cp); %polyint integrates cp
        delta_h = diff(polyval(CP,[Tref T])); %computes the difference between CP evaluated at Tref and T

        case('Water')
        a= 32.34;
        b = .1923e-2;
        c = 1.055e-5;
        d = -3.595e-9;
        Mw = 18.015;
        cp = [d c b a]; %created for the function polyint
        CP = polyint(cp); %polyint integrates cp
        delta_h = diff(polyval(CP,[Tref T])); %computes the difference between CP evaluated at Tref and T
        
        case('Carbon_Dio')
        a = 22.26;
        b = 5.981e-2;
        c = -3.501e-5;
        d = 7.469e-9;
        Mw = 44.01;
        cp = [d c b a]; %created for the function polyint
        CP = polyint(cp); %polyint integrates cp
        delta_h = diff(polyval(CP,[Tref T])); %computes the difference between CP evaluated at Tref and T  
    end
      
elseif(strcmp('Argon',gas)) %ARgon
        delta_h = (c_p('Argon',T)*((T)-(Tref)))*39.948; %Argon has constant specific heat, so integration not required.
end
end




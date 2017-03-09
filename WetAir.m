
classdef WetAir
    %This class is used to create an ideal gas mixture with water vapor as
    %one of the constituents. The relative humidity and temperature
    %determine the mole fraction of water vapor and the mole fraction of
    %each of the components of dry air.
    %Dry air is approximated with the following mole fractions(Nitrogen:
    %0.78084, Oxygen:0.20947, Argon:0.00934, Carbon Dioxide:0.00035)
    
    %Then an instance of the Mixture class is created with the calculated
    %mole fractions, temp, and pressure. This Mixture is accessed with c.MIX. This class stores all the mixture
    %properties, and was written as part of the property calculator
    %assignement.
    
    properties
        RH     %relative humidity
        mix    %Mixture
        CP
        CV
        X      %Mass fractions
        T      %Temperature
        P      %Pressure
        H       %Enthalpy
        Y       %Mole Fractions
        S       %Entropy
        U        %Internal Energy
        PSAT    %Saturation Pressure
     %test push
    end
    
    methods
        function c = WetAir(rh, tmix, pmix)
            c.RH = rh;
            c.T = tmix;
            psat = .61121*exp((18.678-((tmix-273.15)/234.5))*((tmix-273.15)/(257.14+tmix-273.15))); %calculating saturation pressure using the Buck Equation
            c.PSAT = psat;
            c.P = pmix;
            pwv = rh * psat; %partial pressure of water vapor
            xwv = 0.622 * (pwv / (pmix - pwv)) / (1 + 0.622 * (pwv / (pmix - pwv)));
            c.X = [1 - xwv, xwv];
            ywv = pwv / pmix;
            yda = (1 - ywv) * [0.78084, 0.20947, 0.00934 0.00035]; %This is our assumed composition of dry air being adjusted for the presence of water vapor
            y = [yda ywv];
            c.Y = y;
            wetair = Mixture([Gas.Nitrogen, Gas.Oxygen, Gas.Argon, Gas.Carbon_Dioxide, Gas.Water], y, 307.6);
            c.MIX = wetair;
            c.CP = mass_cpmix(wetair, tmix);
            c.CV = c.CP - wetair.R;
            c.H = mass_hmix(wetair, tmix);
            c.S = mass_smix(c, 101.325);
            c.U = mass_umix(wetair, tmix);
        end
    end
    %enumeration
      % Phase1 (0.6, 298.1, 99.4017, 2.128); 
   % end
end


classdef WetAir
    
    properties
        RH     %relative humidity
        MIX
        CP
        CV
        X
        T
        P
        H
        Y
        S
        U
        PSAT
     %test push
    end
    
    methods
        function c = WetAir(rh, tmix, pmix, psat)
            c.RH = rh;
            c.T = tmix;
            c.PSAT = psat;
            c.P = pmix;
            pwv = rh * psat;
            xwv = 0.622 * (pwv / (pmix - pwv)) / (1 + 0.622 * (pwv / (pmix - pwv)));
            c.X = [1 - xwv, xwv];
            ywv = pwv / pmix;
            yda = (1 - ywv) * [0.78084, 0.20947, 0.00934 0.00035];
            y = [yda ywv];
            c.Y = y;
            wetair = Mixture([Gas.Nitrogen, Gas.Oxygen, Gas.Argon, Gas.Carbon_Dioxide, Gas.Water], y, 307.6);
            c.MIX = wetair
            c.CP = mass_cpmix(wetair, tmix);
            c.CV = c.CP - wetair.R;
            c.H = mass_hmix(wetair, tmix);
            c.S = mass_smix(c, 101.325);
            c.U = mass_umix(wetair, tmix);
        end
    end
    enumeration
       Phase1 (0.6, 298.1, 99.4017, 2.128); 
    end
end

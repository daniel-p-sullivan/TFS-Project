classdef Gas
    
    properties
        M               %Molecular mass
        ABCD            %molar cp gas coefficients
        R               %specific gas constant
        HREF            %mass based enthalpy reference
        UREF            %mass based internal energy reference
        S0REF           %mass based entropy reference
        TREF            %temperature reference
    end
    
    methods
        function f = Gas(m, abcd, href, uref, s0ref, Tref)
            f.M = m;            %set M
            f.ABCD = abcd;      %set ABCD
            f.R = 8.314 / m;    %set R
            f.HREF = href;      %set HREF
            f.UREF = uref;      %set UREF
            f.S0REF = s0ref;    %set S0REF
            f.TREF = Tref;      %set TREF
        end
        
    end
    
    enumeration
        Argon (39.948, [0, 0, 0, 0], 0, 0, 4.632, 1273.15)      %Schmidt tabled, perfect gas => abcd = 0, references s0 calculated for T = 1000 C from FAQ info
        Oxygen (31.999, [25.48, 1.52e-2, -0.7155e-5, 1.312e-9], 1284.3, 953.22, 7.8798, 1273.15)        %Schmidt tables
        Nitrogen (28.013, [28.9, -0.1571e-2, 0.8081e-5, -2.873e-9], 1402.6, 1024.5, 8.4344, 1273.15)    %Schmidt tables
        Water (18.015, [32.24, 0.1923e-2, 1.055e-5, -3.595e-9], 2644.6, 2056.7, 13.488, 1273.15)         %Schmidt tables
        Carbon_Dioxide (44.01, [22.26, 5.981e-2, -3.501e-5, 7.469e-9], 1318.4, 1077.7, 6.4243, 1273.15) %Schmidt tables
    end    
end


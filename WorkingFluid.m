classdef WorkingFluid
    %This class is used to store the properties of the working fluid at
    %every stage of the cycle. The relative humidity is accounted for in
    %the wet air class with the inlet conditions. This class uses the mole
    %fractions determined to be in the inlet wet air.
    
     properties
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
        Node
    end
    
    methods
        function c = WorkingFluid(tmix, pmix, y, Node)
            
            c.T = tmix;
            c.P = pmix;
            c.Node = Node;
            c.Y = y;
            WorkingFluid = Mixture([Gas.Nitrogen, Gas.Oxygen, Gas.Argon, Gas.Carbon_Dioxide, Gas.Water], y, 307.6);
            c.MIX = WorkingFluid;
            c.CP = mass_cpmix(WorkingFluid, tmix);
            c.CV = c.CP - WorkingFluid.R;
            c.H = mass_hmix(WorkingFluid, tmix);
            c.S = mass_smix(c, 101.325);
            c.U = mass_umix(WorkingFluid, tmix);
        end
    end
    
end


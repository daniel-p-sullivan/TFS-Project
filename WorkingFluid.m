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
        function c = WorkingFluid(y, Node)
            
            c.T = Node.T;
            c.P = Node.P;
            c.Node = Node;
            c.Y = y;
            working_fluid = Mixture([Gas.Nitrogen, Gas.Oxygen, Gas.Argon, Gas.Carbon_Dioxide, Gas.Water], y, 307.6);
            c.MIX = working_fluid;
            c.CP = mass_cpmix(working_fluid, Node.T);
            c.CV = c.CP - working_fluid.R;
            c.H = mass_hmix(working_fluid, Node.T);
            c.S = mass_smix(c, 101.325);
            c.U = mass_umix(working_fluid, Node.T);
        end
    end
    
end


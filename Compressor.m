classdef Compressor < handle
    %The inlet and design parameters of the compressor are arguments of the
    %constructor. The outlet parameters are then calculated in the
    %constructor. The compression ratio, efficiency, Inlet pressure, and
    %Inlet temperature must be known to solve for outlet conditions.
    
    properties
        InletNode
        OutletNode = Node(0);
        Efficiency
        ho_s %Isentropic outlet enthalpy
        ho_a %actual outlet enthalpy
        To_s %isentropic outlet temp
        To_a %actual outlet temp
        Compression_Ratio
        Work
    end
    
    methods
        function c = Compressor(InletNode, InletFluid, Eff, Comp_ratio, outletstation)
            c.Efficiency = Eff;
            c.InletNode = InletNode;
            c.Compression_Ratio = Comp_ratio;
            c.OutletNode.Station = outletstation;
            c.OutletNode.P = InletNode.P*Comp_ratio;
            c.To_s = T_s_Solver(InletFluid, InletFluid.P*Comp_ratio);
            c.ho_s = mass_hmix(InletFluid.MIX,c.To_s);
            c.ho_a = (c.ho_s - InletFluid.H)/Eff + InletFluid.H;
            c.To_a = T_h_solver(InletFluid, c.ho_a);
            c.OutletNode.T = c.To_a;
            c.OutletNode.h = c.ho_a;
            c.Work = c.OutletNode.h - c.InletNode.h;
            
        end
    end
    
       
                
    
end


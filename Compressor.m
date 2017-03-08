classdef Compressor < handle
    %COMPRESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode = Node(0);
        Efficiency
        ho_s
        ho_a
        To_s
        To_a
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
            c.To_s = T_s_Solver(InletFluid,InletFluid.P*Comp_ratio);
            c.ho_s = mass_hmix(InletFluid.MIX,c.To_s);
            c.ho_a = (c.ho_s - InletFluid.H)/Eff + InletFluid.H;
            c.To_a = T_h_solver(InletFluid, c.ho_a);
            c.OutletNode.T = c.To_a;
            c.OutletNode.h = c.ho_a;
            c.Work = c.OutletNode.h - c.InletNode.h;
            
        end
    end
    
       
                
    
end


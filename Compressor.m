classdef Compressor
    %COMPRESSOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode
        Efficiency
        ho_s
        ho_a
        To_s
        To_a
        Compression_Ratio 
    end
    
    methods
        function c = Compressor(InletNode, OutletNode, Eff, Comp_ratio)
            c.Efficiency = Eff;
            c.InletNode = InletNode;
            c.OutletNode = OutletNode;
            c.Compression_Ratio = Comp_ratio;
        end
         function solve (OutletNode)
            
    end
    
end


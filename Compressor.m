classdef Compressor
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
        function c = Compressor(InletNode, Eff, Comp_ratio, outletstation)
            c.Efficiency = Eff;
            c.InletNode = InletNode;
            c.Compression_Ratio = Comp_ratio;
            c.OutletNode.Station = outletstation;
            c.OutletNode.P = InletNode.P*Comp_ratio;
            
        end
            
            

    end
       
                
    
end


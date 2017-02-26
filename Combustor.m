classdef Combustor
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode = Node(0);
        To_a
        
    end
   
    
    methods
     function c =  Combustor (Inlet, Tout, outletstation)
            
            
            
            c.InletNode = Inlet;
            c.OutletNode.T = Tout;
            c.OutletNode.P = Inlet.P;
            c.OutletNode.Station = outletstation;
            c.To_a = Tout;
        end
    end
    
end


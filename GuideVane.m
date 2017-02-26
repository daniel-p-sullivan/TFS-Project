classdef GuideVane
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletP
        OutletP
        P_drop
        InletNode
        OutletNode
    end
    
    methods
        function c = GuideVane (Inlet, pdrop, outlet)
            c.P_drop = pdrop;
            c.InletP = InletNode.P;
            c.OutletP = InletP - pdrop;
            c.OutletNode = outlet;
            c.InletNode = Inlet;
        end
    end
    
end


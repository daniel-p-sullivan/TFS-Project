classdef GuideVane
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletP
        OutletP
        InletT
        OutletT
        P_drop
        InletNode
        OutletNode = Node(0);
    end
    
    methods
        function c = GuideVane (Inlet, pdrop, outletstation)
            c.P_drop = pdrop;
            c.InletP = Inlet.P;
            c.OutletP = Inlet.P - pdrop;
            c.InletNode = Inlet;
            c.InletT = Inlet.T;
            c.OutletT = Inlet.T;
            c.OutletNode.T = Inlet.T;
            c.OutletNode.P = Inlet.P - pdrop;
            c.OutletNode.Station = outletstation;
        end
    end
    
end


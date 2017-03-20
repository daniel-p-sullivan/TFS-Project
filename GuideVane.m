classdef GuideVane < handle
    %This class is for a thermodynamic device that only has a pressure drop
    %between inlet and outlet. The Inlet Node, pressure drop, and
    %outletstation number are required as inputs to the constructor.
    properties
        InletP %inlet pressure
        OutletP  %outlet pressure
        InletT  %inlet temperature
        OutletT   %outlet temperature
        P_drop  %pressure drop
        InletNode    
        OutletNode = Node(0);
    end
    
    methods
        function c = GuideVane (Inlet, pdrop, outletstation)
            c.P_drop = pdrop;
            c.InletP = Inlet.P;
            c.OutletP = Inlet.P - pdrop; %calculating outlet pressure
            c.InletNode = Inlet;
            c.InletT = Inlet.T;
            c.OutletT = Inlet.T;
            c.OutletNode.T = Inlet.T;
            c.OutletNode.P = Inlet.P - pdrop;
            c.OutletNode.Station = outletstation;
            
        end
    end
    
end


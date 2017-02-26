classdef Turbine
    %TURBINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode = Node(0);
        Efficiency
        ho_s
        ho_a
        To_s
        To_a
        Work
        P_out
    end
    
    methods
        function c = Turbine(InletNode, eff, outletpressure, outletstation)
            c.Efficiency = eff;
            c.InletNode = InletNode;
            c.P_out = outletpressure;
            c.OutletNode.Station = outletstation;
            c.OutletNode.P = outletpressure;
        end
    end
    
end


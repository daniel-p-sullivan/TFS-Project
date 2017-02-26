classdef Turbine
    %TURBINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode
        Efficiency
        ho_s
        ho_a
        To_s
        To_a
    end
    
    methods
        function c = Turbine(Eff,InletNode,OutletNode)
            c.Efficiency = Eff;
            c.InletNode = InletNode;
            c.OutletNode = OutletNode;
    end
    
end


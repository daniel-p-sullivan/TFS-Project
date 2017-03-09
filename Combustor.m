classdef Combustor < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        InletNode
        OutletNode = Node(0);
        To_a
        ho_a
    end
   
    methods
     function c =  Combustor (Inlet, InletFluid, Tout, outletstation)
       
            c.InletNode = Inlet;
            c.OutletNode.T = Tout;
            c.OutletNode.P = Inlet.P;
            c.OutletNode.Station = outletstation;
            c.To_a = Tout;
            c.ho_a = mass_hmix(InletFluid.MIX,Tout);
            c.OutletNode.h = c.ho_a;
            
        end
    end
    
end


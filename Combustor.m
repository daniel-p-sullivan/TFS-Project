classdef Combustor < handle
    %This class calculates the thermodynamic properties at the outlet of
    %a combustor given the inlet fluid temperature and pressure and the outlet
    %temperature. 
    
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


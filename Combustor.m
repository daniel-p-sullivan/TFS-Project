classdef Combustor < handle
    %This class calculates the thermodynamic properties at the outlet of
    %a combustor given the inlet fluid temperature and pressure and the outlet
    %temperature. 
    
    properties
        InletNode
        OutletNode = Node(0);
        To_a %Actual Outlet Temperature
        ho_a %Actual outlet enthalpy
    end
   
    methods
     function c =  Combustor (Inlet, InletFluid, Tout, outletstation)
       
            c.InletNode = Inlet; %setting combustor inlet node
            c.OutletNode.T = Tout; %setting outlet node temperature
            c.OutletNode.P = Inlet.P;   %setting outlet node pressure
            c.OutletNode.Station = outletstation; %associating combustor outlet with station number
            c.To_a = Tout;  %actual outlet temperature
            c.ho_a = mass_hmix(InletFluid.MIX,Tout);  %actual outlet enthalpy
            c.OutletNode.h = c.ho_a;  %setting outlet node enthalpy
            
        end
    end
    
end


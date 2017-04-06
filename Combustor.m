classdef Combustor < handle
    %This class calculates the thermodynamic properties at the outlet of
    %a combustor given the inlet fluid temperature and pressure and the outlet
    %temperature. 
    
    properties
        InletNode
        OutletNode = Node(0);
        To_a %Actual Outlet Temperature
        ho_a %Actual outlet enthalpy
        OutletFluid
        y_products
    end
   
    methods
     function c =  Combustor (Inlet, InletFluid, Tout, outletstation, lhv, lmqt)
       
            c.InletNode = Inlet; %setting combustor inlet node
            c.OutletNode.T = Tout; %setting outlet node temperature
            c.OutletNode.P = Inlet.P;   %setting outlet node pressure
            c.OutletNode.Station = outletstation; %associating combustor outlet with station number
            c.To_a = Tout;  %actual outlet temperature
            c.ho_a = mass_hmix(InletFluid.MIX,Tout);  %actual outlet enthalpy
            c.OutletNode.h = c.ho_a;  %setting outlet node enthalpy
            
            L = lmqt(1)
            M = lmqt(2)
            Q = lmqt(3)
            T = lmqt(4)
            Tin = Inlet.T;
            Tref = 298.15;
            yo2 = InletFluid.Y(2)
            AN2 = InletFluid.Y(1) / yo2;
            ACO2 = InletFluid.Y(4) / yo2;
            AAr = InletFluid.Y(3) / yo2;
            AH2O = InletFluid.Y(5) / yo2;
            
            
            
            z = (lhv - L*delta_h_molar('Carbon_Dio', Tout, Tref) - M * delta_h_molar('Water', Tout, Tref) / 2 + T * delta_h_molar('Nitrogen', Tout, Tref) / 2 - (Q / 2 - L - M / 4)*delta_h_molar('Oxygen', Tout, Tref) ) / (-(delta_h_molar('Oxygen', Tin, Tref) + AN2*delta_h_molar('Nitrogen', Tin, Tref) + ACO2*delta_h_molar('Carbon_Dio', Tin, Tref) + AAr*delta_h_molar('Argon', Tin, Tref) + AH2O*delta_h_molar('Water', Tin, Tref)) + ACO2*delta_h_molar('Carbon_Dio', Tout, Tref) + AH2O*delta_h_molar('Water', Tout, Tref) + AAr*delta_h_molar('Argon', Tout, Tref) + AN2*delta_h_molar('Nitrogen', Tout, Tref) + delta_h_molar('Oxygen', Tout, Tref))
            y_total = L + ACO2*z +M/2 + AH2O*z + z*AAr + T/2 + z*AN2 + Q/2 + z - L - M / 4;
            c.y_products = [T/2 + z*AN2, Q/2 + z - L - M/4, z*AAr, L + z*ACO2, M/2 + AH2O*z] .* (1/y_total);
            
        end
    end
    
end


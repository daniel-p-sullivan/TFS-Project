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
            
            L = lmqt(1);
            M = lmqt(2);
            Q = lmqt(3);
            T = lmqt(4);
            Tin = InletNode.T;
            Tref = 298.15;
            yo2 = InletFluid.Y(2)
            AN2 = InletFluid.Y(1) / yo2;
            ACO2 = InletFluid.Y(4) / yo2;
            AAr = InletFluid.Y(3) / yo2;
            AH2O = InletFluid.Y(5) / yo2;
            
            
            
            z = (lhv - L*delta_h_molar('Carbon_Dio', To_a, Tref) - m * delta_h_molar('Water', To_a, Tref) / 2 + T * delta_h_molar('Nitrogen', To_a, Tref) / 2 - (Q / 2 - L - M / 4)*delta_h_molar('Oxygen', To_a, Tref) ) / (-(delta_h_molar('Oxygen', Tin, Tref) + AN2*delta_h_molar('Nitrogen', Tin, Tref) + ACO2*delta_h_molar('Carbon_Dio', Tin, Tref) + AAr*delta_h_molar('Argon', Tin, Tref) + AH2O*delta_h_molar('Water', Tin, Tref)) + AC02*delta_h_molar('Carbon_Dio', To_a, Tref) + AH2O*delta_h_molar('Water', To_a, Tref) + AAr*delta_h_molar('Argon', To_a, Tref) + AN2*delta_h_molar('Nitrogen', To_a, Tref) + delta_h_molar('Oxygen', To_a, Tref))
            y_total = L + ACO2*z +m/2 + AH2O*z + z*AAr + T/2 + z*AN2 + Q/2 + Z - L - M / 4;
            y_products = [T/2 + z*AN2, Q/2 + z - L - M/4, z*AAr, L + z*ACO2, M/2 + AH2O*z] / y_total;
            c.OutletFluid = WorkingFluid(y_products, OutletNode);
        end
    end
    
end


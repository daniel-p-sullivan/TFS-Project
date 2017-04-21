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
        y_products  %mole fraction of products
        AF_molar %moles of air/moles of fuel
        Z %moles of O2/moles of fuel
        Fuel_Molar %equivalent fuel molar mass (kg/kmol)
        fuel_massflow   %mass flow rate of fuel (kg/s)
    end
   
    methods
     function c =  Combustor (Inlet, InletFluid, Tout, outletstation, lhv, lmqt, fmm, inlet_massflow)
       
            c.InletNode = Inlet; %setting combustor inlet node
            c.OutletNode.T = Tout; %setting outlet node temperature
            c.OutletNode.P = Inlet.P;   %setting outlet node pressure
            c.OutletNode.Station = outletstation; %associating combustor outlet with station number
            c.To_a = Tout;  %actual outlet temperature
            c.Fuel_Molar = fmm; %setting fuel molar mass
            
            L = lmqt(1);  %number of carbon atoms in equivalent fuel 
            M = lmqt(2);  %number of hydrogen atoms in equivalent fuel
            Q = lmqt(3);    %number of oxygen atoms in equivalent fuel
            T = lmqt(4);    %number of Nitrogen atoms in equivalent fuel
            Tin = Inlet.T;  %setting inlet temperature
            Tref = 298.15;  %setting reference temperature for formation enthalpies
            yo2 = InletFluid.Y(2);   %mole fraction of oxygen in inlet air
            AN2 = InletFluid.Y(1) / yo2;    %moles of nitrogen per mole of oxygen in inlet air
            ACO2 = InletFluid.Y(4) / yo2; %moles of CO2 per mole of oxygen in inlet air
            AAr = InletFluid.Y(3) / yo2;    %moles of Argon per mole of oxygen in inlet air
            AH2O = InletFluid.Y(5) / yo2;   %moles of water per mole of oxygen in inlet air
            
            
            
            z = (lhv - L*delta_h_molar('Carbon_Dio', Tout, Tref) - M * delta_h_molar('Water', Tout, Tref) / 2 + T * delta_h_molar('Nitrogen', Tout, Tref) / 2 - (Q / 2 - L - M / 4)*delta_h_molar('Oxygen', Tout, Tref) ) / (-(delta_h_molar('Oxygen', Tin, Tref) + AN2*delta_h_molar('Nitrogen', Tin, Tref) + ACO2*delta_h_molar('Carbon_Dio', Tin, Tref) + AAr*delta_h_molar('Argon', Tin, Tref) + AH2O*delta_h_molar('Water', Tin, Tref)) + ACO2*delta_h_molar('Carbon_Dio', Tout, Tref) + AH2O*delta_h_molar('Water', Tout, Tref) + AAr*delta_h_molar('Argon', Tout, Tref) + AN2*delta_h_molar('Nitrogen', Tout, Tref) + delta_h_molar('Oxygen', Tout, Tref)); %z is the reaction coeffient of oxygen in the reactants
            y_total = L + ACO2*z +M/2 + AH2O*z + z*AAr + T/2 + z*AN2 + Q/2 + z - L - M / 4;
            c.y_products = [T/2 + z*AN2, Q/2 + z - L - M/4, z*AAr, L + z*ACO2, M/2 + AH2O*z] .* (1/y_total);
            c.AF_molar = z*(1+ AN2 + ACO2 + AAr + AH2O);  %calculating air fuel ratio
            c.Z = z;
            
            c.fuel_massflow = inlet_massflow * fmm / (InletFluid.M * c.AF_molar); %kg/s, using air fuel ratio and molar mass of fuel and air
        end
    end
    
end


%This script was written to compare the air fuel ratio calculated with the
%combustor class agreed with the analytical solution in the homework
%problem 13.xx

InletNode = Node(1);
InletNode.T = 197+273.15;
InletFluid = WorkingFluid([.79,.21,.000001,0.000001,0.00001],InletNode);
GE_fuel_LHV = [802.34 1437.2 2044.2 2659.3 3272.6 3856.7 0 0 0];  %kJ/mol
GE_fuel_LMQT = [1 4 0 0; 2 6 0 0; 3 8 0 0; 4 10 0 0; 5 12 0 0; ...
                6 14 0 0; 1 0 2 0; 0 0 0 2; 0 0 2 0;];
GE_fuel_molfrac = [.5 0 .5 0 0 ...
                   0 0 0 0];
GE_equiv_fuel_LMQT = GE_fuel_molfrac * GE_fuel_LMQT;

GE_equiv_fuel_LHV = GE_fuel_molfrac * GE_fuel_LHV'*1000;             %kJ/mol
C = Combustor(InletNode,InletFluid,900+273.15,2,GE_equiv_fuel_LHV,GE_equiv_fuel_LMQT);

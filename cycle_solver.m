%Input parameters
%Order of devices and Thermodynamic stations (nodes)
% 1 : VIGV : 2 : LPC : 25 : HPC : 3 : Combustor : 4 : HPT : 48 : LPT : 5 :
% Exhaust: 6
T1_e = 65; %Fahrenheit
P1_e = 14.417; %psi
RH1 = .6;
mflow_DA_e = 189.7; %lb/s
VIGV_dP_e = 4; %in H20
Ex_dP_e = 10; %in H20
LHV_e = 20185; %BTU/lb

%Input parameters converted to SI

T1 = (T1_e+459.67) * (5/9); %K
P1 = 6.89476*P1_e; %kPa
mflow_DA = mfow_DA_e * 0.453592; %kg/s
VIGV_dP = 0.249088908333*VIGV_dP_e; %kPa
Ex_dP = 0.249088908333*Ex_dP_e; %kPa
LHV = 2.326 * LHV_e; %kJ/kg

InletAir = WetAir(RH1,T1,P1);
%Create Nodes
Node1 = Node (1);
Node2 = Node (2);
Node25 = Node (25);
Node3 = Node(3);
Node4 = Node(4);
Node48 = Node (48);
Node5 = Node(5);
Node6 = Node (6);


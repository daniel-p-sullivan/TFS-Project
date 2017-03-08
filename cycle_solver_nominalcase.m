%Input parameters
%Order of devices and Thermodynamic stations (nodes)
% 1 : VIGV : 2 : LPC : 25 : HPC : 3 : Combustor : 4 : HPT : 48 : LPT : 5 :
% Exhaust: 6
T1_e = 65; %Fahrenheit
T4_e = 2200; %Fahrenheit
P1_e = 14.417; %psi
P48_e = 71; %psi
RH1 = .6;
mflow_DA_e = 189.7; %lb/s
VIGV_dP_e = 4; %in H20
Ex_dP_e = 10; %in H20
LHV_e = 20185; %BTU/lb
LPC_eff = .82;
r_LPC = 6;
r_HPC = 4;
HPC_eff  = .84;
LPT_eff = .100;
HPT_eff = .100;
Generator_eff = .977;
%Input parameters converted to SI
T1 = (T1_e+459.67) * (5/9); %K
T4 = (T4_e+459.67) * (5/9); %K
P1 = 6.89476*P1_e; %kPa
P48 = 6.89476*P48_e; %kPa
mflow_DA = mflow_DA_e * 0.453592; %kg/s
VIGV_dP = 0.249088908333*VIGV_dP_e; %kPa
Ex_dP = 0.249088908333*Ex_dP_e; %kPa
P5 = P1 + Ex_dP;
LHV = 2.326 * LHV_e; %kJ/kg

InletAir = WetAir(RH1,T1,P1);
MassFlow_total = (1+InletAir.X(2)/InletAir.X(1)) * mflow_DA;
%Create Nodes, Working Fluid at each node, and objects between nodes
Node1 = Node(1);
Node1.T = T1;
Node1.P = P1;
Fluid1 = WorkingFluid(InletAir.Y,Node1);

VIGV1 = GuideVane(Node1,VIGV_dP,2);
Node2 = VIGV1.OutletNode;
Fluid2 = WorkingFluid(InletAir.Y, Node2);
Node2.h = Fluid2.H;

LPC = Compressor(Node2,Fluid2, LPC_eff, r_LPC, 25);
Node25 = LPC.OutletNode;
Fluid25 = WorkingFluid(InletAir.Y, Node25);

HPC = Compressor(Node25, Fluid25, HPC_eff, r_HPC, 3);
HPC.OutletNode.T = HPC.To_a;
Node3 = HPC.OutletNode;
Fluid3 = WorkingFluid(InletAir.Y, Node3);

Combustor1 = Combustor(Node3,Fluid3, T4, 4);
Node4 = Combustor1.OutletNode;
Fluid4 = WorkingFluid(InletAir.Y, Node4);

HPT = Turbine(Node4, Fluid4, 0, P48, LPC.Work + HPC.Work, 48); 
Node48 = HPT.OutletNode;
Fluid48 = WorkingFluid(InletAir.Y, Node48);

LPT = Turbine(Node48, Fluid48, 0, P5, (30600/Generator_eff) / MassFlow_total,  5); 
Node5 = LPT.OutletNode;
Fluid5 = WorkingFluid(InletAir.Y, Node5);

cycle_Eff = LPT.Work/(Node4.h - Node3.h);

Exhaust = GuideVane(Node5, Ex_dP, 6);
Node6 = Exhaust.OutletNode;
Fluid6 = WorkingFluid(InletAir.Y, Node6);







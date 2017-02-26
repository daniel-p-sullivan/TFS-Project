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

%Input parameters converted to SI

T1 = (T1_e+459.67) * (5/9); %K
T4 = (T4_e+459.67) * (5/9); %K
P1 = 6.89476*P1_e; %kPa
P48 = 6.89476*P48_e; %kPa
mflow_DA = mflow_DA_e * 0.453592; %kg/s
VIGV_dP = 0.249088908333*VIGV_dP_e; %kPa
Ex_dP = 0.249088908333*Ex_dP_e; %kPa
LHV = 2.326 * LHV_e; %kJ/kg

InletAir = WetAir(RH1,T1,P1);
%Create Nodes, Working Fluid at each node, and objects between nodes
Node1 = Node(1);
Node1.T = T1;
Node1.P = P1;
Fluid1 = WorkingFluid(InletAir.Y,Node1);


VIGV1 = GuideVane(Node1,VIGV_dP,2);
Node2 = VIGV1.OutletNode;
Fluid2 = WorkingFluid(InletAir.Y, Node2);
Node2.h = Fluid2.H;

LPC = Compressor(Node2, LPC_eff, r_LPC, 25);
LPC.To_s = T_s_Solver(Fluid2,Fluid2.P*r_LPC);
LPC.ho_s = mass_hmix(Fluid2.MIX,LPC.To_s);
LPC.ho_a = (LPC.ho_s - Fluid2.H)/LPC_eff + Fluid2.H;
LPC.To_a = T_h_solver(Fluid2, LPC.ho_a);
LPC.OutletNode.T = LPC.To_a;
Node25 = LPC.OutletNode;
Fluid25 = WorkingFluid(InletAir.Y, Node25);
Node25.h = Fluid25.H;

HPC = Compressor(Node25, HPC_eff, r_HPC, 3);
HPC.To_s = T_s_Solver(Fluid25,Fluid25.P*r_HPC);
HPC.ho_s = mass_hmix(Fluid25.MIX,HPC.To_s);
HPC.ho_a = (HPC.ho_s - Fluid25.H)/HPC_eff + Fluid25.H;
HPC.To_a = T_h_solver(Fluid25, HPC.ho_a);
HPC.OutletNode.T = HPC.To_a;
Node3 = HPC.OutletNode;
Fluid3 = WorkingFluid(InletAir.Y, Node3);
Node3.h = Fluid3.H;

Combustor = Combustor(Node3, T4, 4);
Node4 = Combustor.OutletNode;
Fluid4 = WorkingFluid(InletAir.Y, Node4);
Node4.h = Fluid4.H;

HPT = Turbine(Node4, 100, T48, 
Node48.P = P48;
Fluid48 = WorkingFluid(InletAir.Y, Node48);

Node5 = Node(5);
Fluid5 = WorkingFluid(InletAir.Y, Node5);

Node6 = Node (6);
Fluid6 = WorkingFluid(InletAir.Y, Node6);






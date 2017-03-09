
%Input operating parameters English Units

%The following parameters must be set to 0 if they are unknown before
%solving the cycle: LPT_Work, HPT_eff, LPT_eff, and
%LPT_Efficiency

T1_e = 65; %Fahrenheit
P1_e = 14.417; %psi
RH1 = .6; %Relative Humidity
mflow_DA_e = 189.7; %Mass flow rate of dry air, lb/s
LHV_e = 20185; %BTU/lb
LPT_Work = 0; %Uknown, must be set to 0 becuase of the if statements in turbine class constructor
HPT_OutletPressure = 0; %Unknown, and used in if statements in the turbine class constructor

%Input Design Parameters
T4_e = 2200; %Fahrenheit, maximum temp
VIGV_dP_e = 4; %in H20, pressure drop across IGV
Ex_dP_e = 10; %in H20, pressure drop across exhaust
LPC_eff = .82; %LPC efficiency
r_LPC = 6; %LPC Compression Ratio
r_HPC = 4; %HPC Compress Ratio
HPC_eff  = .84; %HPC Isentropic Efficiency
LPT_eff = .9476; %LPT Isentropic Efficiency calculated with nominal case
HPT_eff = .9727; %HPT Isentropic Efficiency calculated with nominal case
Generator_eff = .977; %Given Generator Efficiency

%Input Operating parameters converted to SI
T1 = (T1_e+459.67) * (5/9); %K
P1 = 6.89476*P1_e; %kPa
mflow_DA = mflow_DA_e * 0.453592; %Dry air mass flow rate, kg/s
LHV = 2.326 * LHV_e; %kJ/kg

%Inlet Design Parameters converted to SI
T4 = (T4_e+459.67) * (5/9); %K
VIGV_dP = 0.249088908333 * VIGV_dP_e; %converting in H20 to kPa
Ex_dP = 0.249088908333 * Ex_dP_e; %converting in H20 to kPa
P5 = P1 + Ex_dP; %Calculating LPT outlet pressure

Net_Work(22) = zeros;
cycle_Eff(22) = zeros;
for i=1:22
T1 = (5*i+459.67) * (5/9);
%Inlet Ideal Gas Mixture
InletAir = WetAir(RH1,T1,P1); %Create a WetAir object with the input temp, relative Humidity, and pressure.
MassFlow_total = (1+InletAir.X(2)/InletAir.X(1)) * mflow_DA; %calculate total mass flow rate given dry air flow rate, kg/s

%Staion 1
Node1 = Node(1);
Node1.T = T1;
Node1.P = P1;
Fluid1 = WorkingFluid(InletAir.Y,Node1);

%Solving for Station 2
VIGV1 = GuideVane(Node1,VIGV_dP,2);
Node2 = VIGV1.OutletNode;
Fluid2 = WorkingFluid(InletAir.Y, Node2);
Node2.h = Fluid2.H;

%Solving for station 25
LPC = Compressor(Node2,Fluid2, LPC_eff, r_LPC, 25);
Node25 = LPC.OutletNode;
Fluid25 = WorkingFluid(InletAir.Y, Node25);

%Solving for station 3
HPC = Compressor(Node25, Fluid25, HPC_eff, r_HPC, 3);
HPC.OutletNode.T = HPC.To_a;
Node3 = HPC.OutletNode;
Fluid3 = WorkingFluid(InletAir.Y, Node3);

%Solving for station 4
Combustor1 = Combustor(Node3,Fluid3, T4, 4);
Node4 = Combustor1.OutletNode;
Fluid4 = WorkingFluid(InletAir.Y, Node4);

%Solving for station 48
HPT = Turbine(Node4, Fluid4, HPT_eff, HPT_OutletPressure, LPC.Work + HPC.Work, 48);
Node48 = HPT.OutletNode;
Fluid48 = WorkingFluid(InletAir.Y, Node48);

%Solving for station 5
LPT = Turbine(Node48, Fluid48, LPT_eff, P5, 0, 5); 
Node5 = LPT.OutletNode;
Fluid5 = WorkingFluid(InletAir.Y, Node5);

%Solving for 6
Exhaust = GuideVane(Node5, Ex_dP, 6);
Node6 = Exhaust.OutletNode;
Fluid6 = WorkingFluid(InletAir.Y, Node6);

%Cycle efficiency
cycle_Eff(i) = LPT.Work/(Node4.h - Node3.h);
Net_Work(i) = MassFlow_total * LPT.Work*Generator_eff;

end

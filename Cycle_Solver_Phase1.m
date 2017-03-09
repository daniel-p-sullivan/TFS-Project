
%Input operating parameters English Units
%The following parameters must be set to 0 if they are unknown before
%solving the cycle: LPT_Work, HPT_OutletPressure, 
T1_e = 65; %Fahrenheit
P1_e = 14.417; %psi
RH1 = .6; %Relative Humidity
mflow_DA_e = 189.7; %lb/s
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
mflow_DA = mflow_DA_e * 0.453592; %kg/s
LHV = 2.326 * LHV_e; %kJ/kg

%Inlet Design Parameters converted to SI
T4 = (T4_e+459.67) * (5/9); %K
VIGV_dP = 0.249088908333*VIGV_dP_e; %kPa
Ex_dP = 0.249088908333*Ex_dP_e; %kPa
P5 = P1 + Ex_dP; %Calculating LPT outlet pressure

InletAir = WetAir(RH1,T1,P1); %Creates a WetAir object with the input temp, relative Humidity, and pressure.
MassFlow_total = (1+InletAir.X(2)/InletAir.X(1)) * mflow_DA;

%Create Nodes, Working Fluid at each node, and objects between nodes
Node1 = Node(1);
Node1.T = T1;
Node1.P = P1;
Fluid1 = WorkingFluid(InletAir.Y,Node1);
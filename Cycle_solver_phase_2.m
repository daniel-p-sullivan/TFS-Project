%% GE Data Input

GE_data = xlsread('FULL LOAD PERFORMANCE LM2500+ G4 (1).xlsx', 1, 'B34:W170');
GE_Power = GE_data(1, :) / 1000;                %kW to MW, Net Power
GE_T48 = GE_data(18, :);                        %GE HPT Exit Temperature
GE_fuelflow_hr = GE_data(7, :);                 %GE fuel mass flow rate [lb/hr]
GE_fuelflow_s = GE_fuelflow_hr / 3600;          %GE fuel mass flow rate [lb/s]
GE_exhaustflow = GE_data(22, :);                %GE exhaust mass flow rate [lb/s]
GE_inletflow_cs = GE_data(109,:);               %GE inlet air mass flow rate (lb/s)

GE_SFC = GE_fuelflow_hr ./ (GE_Power*1E3);      %GE specific fuel consumption
GE_fuel_molfrac = [84.5 5.58 2.05 0.78 0.18 ...
                   0.17 0.67 5.93 0.14] / 100;  %mole fraction of fuel constituents. taken from GE spreadsheet
GE_fuel_massfrac = [71.8447 8.8924 4.7909 2.4027 ...
                    0.6883 0.7754 1.5628 8.8044 0.2374] / 100; %mass fraction of fuel constituents. taken from GE spreadsheet.
GE_fuel_names = ['Methane', 'Ethane', 'Propane', ...,
                 'Butane', 'Pentane', 'Hexane', ... 
                 'Carbon Dioxide', 'Nitrogen', 'Oxygen'];  %fuel name array
GE_fuel_LMQT = [1 4 0 0; 2 6 0 0; 3 8 0 0; 4 10 0 0; 5 12 0 0; ...
                6 14 0 0; 1 0 2 0; 0 0 0 2; 0 0 2 0;];  %number of carbon atoms (L), Hydrogen atoms (M), oxygen (Q), Nitrogen atoms (T) in each fuel chemical equation
GE_equiv_fuel_LMQT = GE_fuel_molfrac * GE_fuel_LMQT; %determing the equivalent fuel
GE_fuel_LHV = [802.34 1437.2 2044.2 2659.3 3272.6 3856.7 0 0 0];       %kJ/mol, LHV of each fuel constituent from online source
GE_equiv_fuel_LHV = GE_fuel_molfrac * GE_fuel_LHV'*1000;             %kJ/kmol, equivalent fuel lower heating value
GE_fuel_molar_mass = GE_equiv_fuel_LMQT * [12.01, 1.008, 15.999, 14]'; %kg/kmol


 
%% Input operating parameters English Units
%The following parameters must be set to 0 if they are unknown before
%solving the cycle: LPT_Work, HPT_eff, LPT_eff, and
%LPT_Efficiency

T1_e = 65;              %Fahrenheit
P1_e = 14.417;          %psi
RH1 = .6;               %Relative Humidity
LHV_e = 20185;          %BTU/lb, only used in phase 1
LPT_Work = 0;           %Uknown, must be set to 0 becuase of the if statements in turbine class constructor
HPT_OutletPressure = 0; %Unknown, and used in if statements in the turbine class constructor

%% Input Design Parameters

T4_e = 2200;            %Fahrenheit, assumed adiabatic flame temperature of combustor
VIGV_dP_e = 4;          %in H20, pressure drop across IGV
Ex_dP_e = 10;           %in H20, pressure drop across exhaust
LPC_eff = .82;          %LPC efficiency
r_LPC = 6;              %LPC Compression Ratio
r_HPC = 4;              %HPC Compress Ratio
HPC_eff  = .82;         %HPC Isentropic Efficiency
LPT_eff = .97;        %LPT Isentropic Efficiency calculated with nominal case
HPT_eff = .94;        %HPT Isentropic Efficiency calculated with nominal case
Generator_eff = .977;   %Given Generator Efficiency

%% Input Operating parameters converted to SI

T1 = (T1_e+459.67) * (5/9);                  %K
P1 = 6.89476*P1_e;                           %kPa
GE_inletflow = GE_inletflow_cs * .453592;       % GE inlet air mass flow rate (kg/s)
LHV = 2.326 * LHV_e;                         %kJ/kg, only used in phase 1
GE_equiv_fuel_LHV_English = (GE_equiv_fuel_LHV / GE_fuel_molar_mass) * 0.947817 / 2.2; %LHV (BTU/lb)

%% Inlet Design Parameters converted to SI

T4 = (T4_e+459.67) * (5/9);           %K
VIGV_dP = 0.249088908333 * VIGV_dP_e; %converting in H20 to kPa
Ex_dP = 0.249088908333 * Ex_dP_e;     %converting in H20 to kPa
P5 = P1 + Ex_dP;                      %Calculating LPT outlet pressure

%% Output Arrays

Net_Work(22) = zeros;                %kW
cycle_Eff(22) = zeros;
FuelMassFlowRate(22) = zeros;        %lbm/hr
HeatRate (22) = zeros;               %BTU/kW-hr
SpecificFuelConsumption(22) = zeros; %lbm/kW-hr
T48 = zeros(1, 22);                  %HPT Exit Temperature, calculated with our model
P = zeros(8, 22);                    %Pressure at each station at each inlet temperature
T = zeros(8, 22);                       %Temperature at each station at each inlet temperature
MassFlowProducts(22) = zeros;          %product mass flow rate, kg/s
MassFlowFuel(22) = zeros;               %kg/s


%% Solve

for i=1:22   %iterating through all temperatures in the GE excel data sheet

    T1 = (5*i+459.67) * (5/9); % Temperatures converted from F to K

    %Inlet Ideal Gas Mixture
    InletAir = WetAir(RH1,T1,P1);                   %Create a WetAir object with the input temp, relative Humidity, and pressure.
     
    MassFlow_total = GE_inletflow(i); %total mass flow rate given wet air flow rate read from GE spreadsheet, kg/s
   
    %Staion 1
    Node1 = Node(1); %Create Node 1
    Node1.T = T1; %Set node parameters
    Node1.P = P1;
    T(1, i) = T1; %store station T and P for output
    P(1, i) = P1;
    Fluid1 = WorkingFluid(InletAir.Y,Node1); %Create a workingfluid object with the properties of the inlet WetAir object

    %Solving for Station 2
    VIGV1 = GuideVane(Node1,VIGV_dP,2); %create a GuideVane object
    Node2 = VIGV1.OutletNode; 
    Fluid2 = WorkingFluid(InletAir.Y, Node2); %creates new WorkingFluid with exit conditions
    Node2.h = Fluid2.H;
    T(2, i) = VIGV1.OutletT;
    P(2, i) = VIGV1.OutletP;

    %Solving for station 25
    LPC = Compressor(Node2,Fluid2, LPC_eff, r_LPC, 25); %creating low pressure compressor
    Node25 = LPC.OutletNode; 
    Fluid25 = WorkingFluid(InletAir.Y, Node25); %creating new fluid at LPC exit conditions
    T(3, i) = LPC.To_a;
    P(3, i) = LPC.OutletNode.P;

    %Solving for station 3
    HPC = Compressor(Node25, Fluid25, HPC_eff, r_HPC, 3); %High pressure compressor created
    HPC.OutletNode.T = HPC.To_a;
    Node3 = HPC.OutletNode;
    Fluid3 = WorkingFluid(InletAir.Y, Node3); 
    T(4, i) = HPC.To_a;
    P(4, i) = HPC.OutletNode.P;

    %Solving for station 4
    Combustor1 = Combustor(Node3,Fluid3, T4, 4, GE_equiv_fuel_LHV, GE_equiv_fuel_LMQT, GE_fuel_molar_mass, MassFlow_total); %creating combustor
    Node4 = Combustor1.OutletNode;
    Fluid4 = WorkingFluid(Combustor1.y_products,Node4);
    T(5, i) = Combustor1.To_a;
    P(5, i) = Combustor1.OutletNode.P;
    Node4.h = Fluid4.H; 
    MassFlowProducts (i) = MassFlow_total + Combustor1.fuel_massflow;
    MassFlowFuel(i) = Combustor1.fuel_massflow;

    %Solving for station 48
    HPT = Turbine(Node4, Fluid4, HPT_eff, HPT_OutletPressure, LPC.Work + HPC.Work, 48);
    Node48 = HPT.OutletNode;
    Fluid48 = WorkingFluid(InletAir.Y, Node48);
    T(6, i) = HPT.To_a;
    P(6, i) = HPT.P_out;

    %Solving for station 5
    LPT = Turbine(Node48, Fluid48, LPT_eff, P5, 0, 5); 
    Node5 = LPT.OutletNode;
    Fluid5 = WorkingFluid(InletAir.Y, Node5);
    T(7, i) = LPT.To_a;
    P(7, i) = LPT.P_out;

    %Solving for station 6
    Exhaust = GuideVane(Node5, Ex_dP, 6);
    Node6 = Exhaust.OutletNode;
    Fluid6 = WorkingFluid(InletAir.Y, Node6);
    T(8, i) = Exhaust.OutletT;
    P(8, i) = Exhaust.OutletP;

    %Output Parameters
    cycle_Eff(i) = (LPT.Work*MassFlowProducts(i))/((GE_equiv_fuel_LHV)/GE_fuel_molar_mass*MassFlowFuel(i)); %calculate cycle efficiency
    Net_Work(i) = MassFlowProducts(i) * LPT.Work * Generator_eff; %calculate net work
    HeatRate = 1./ cycle_Eff * 3412.14; %BTU/kW-hr
    SpecificFuelConsumption(i) = FuelMassFlowRate(i) / Net_Work(i); %lbm/kW-hr

end

%% Unit Conversion

T_range_F = 5:5:110; %Inlet temp range in Fahrenheit 
Net_Work_Output = Net_Work*1E-3; %MW
FuelMassFlowRate_Output = FuelMassFlowRate*2.20462*3600; %lbm/hr
HeatRate_Output = 1./cycle_Eff .* 3412.14; %BTU/kW-hr 
SpecificFuelConsumption_Output = FuelMassFlowRate_Output ./ (Net_Work_Output * 1E3); %lbm/kW-hr

%% Plots

figure(1);
plot(T_range_F, cycle_Eff, '*')                         %plots eff versus T
title('Cycle Efficiency versus Inlet Air Temperature')
xlabel('Inlet Air Temperature (\circF)')
ylabel('Cycle Efficiency')
legend('Simulation', 'Location', 'east');

figure(2)
plot(T_range_F, Net_Work_Output, '*', T_range_F, GE_Power, 'r*')                   %plots net work versus T
title('Net Work versus Inlet Air Temperature')
xlabel('Inlet Air Temperature (\circF)')
ylabel('Net Work (MW)')
legend('Simulation', 'GE Data',  'Location', 'east');

figure(3);
plot(T_range_F, MassFlowFuel*2.20462*3600, '*', T_range_F, GE_fuelflow_hr, 'r*')           %plots mdotf versus T    
title('Fuel Mass Flow Rate versus Inlet Air Temperature')
xlabel('Inlet Air Temperature (\circF)')
ylabel('Fuel Mass Flow Rate (lb_m hr^{-1})')
legend('Simulation', 'GE Data');
% 
figure(4);
plot(T_range_F, HeatRate_Output, '*')                   %plots hr versus T
title('Heat Rate versus Inlet Air Temperature')
xlabel('Inlet Air Temperature (\circF)')
ylabel('Heat Rate (BTU kW^{-1} hr^{-1})')
legend('Simulation', 'Location', 'east');

figure(5);
plot(T_range_F, SpecificFuelConsumption_Output, '*', T_range_F, GE_SFC, 'r*')    %plots sfc versus T
title('Specific Fuel Consumption versus Inlet Air Temperature')
xlabel('Inlet Air Temperature (\circF)')
ylabel('Specific Fuel Consumption (lb_m kW^{-1} hr^{-1})')
legend('Simulation', 'GE Data', 'Location', 'east');

figure(6);
hold on
xrange = 0:1:120;   %range for the line plot
T48_max = 1551;           %LPT Firing temperature?
plot(T_range_F, T(6, :), '*', T_range_F, GE_T48, 'r*');
plot([0 120], [1551 1551], 'r--');
title('HPT Exit Temperature versus Inlet Temperature');
xlabel('Inlet Air Temperature (\circF)');
ylabel('HPT Exit Temperature (\circF)');
legend('Simulation', 'GE Data', '1551 \circF', 'Location', 'east');
%% Write Tables

csvwrite('Station_Pressures.csv', P');
csvwrite('Station_Temperatures.csv', T');
%% File Import

row_offset = 7;                                              %Number of rows until relevant data (-100 C entry on row 8)
table5s = csvread('Table5s.csv', row_offset, 0, 'A8..I41');  %read from the table into matrix
indexes = [8 10 13:2:31 32:41] - row_offset;                 %relevant table row indexes for error calculation
tab_T = table5s(indexes, 1)';        %tabulated T at relevant indexes
tab_cp = table5s(indexes, 7)';       %tabulated cp at relevant indexes
tab_h = table5s(indexes, 3)';        %tabulated h at relevant indexes
tab_u = table5s(indexes, 2)';        %tabulated u at relevant indexes
tab_s0 = table5s(indexes, 4)';       %tabulated s0 at relevant indexes
tab_p0 = table5s(indexes, 5)';       %tabulated p0 at relevant indexes

%% Calculate Values

air = Mixture.Air;                  %create Mixture with properties in the 'Air' enumeration
T_range_K = 173.15:100:2273.15;     %create a temperature range in Kelvin
T_range_C = T_range_K - 273.15;     %create a temperature range in degrees Celsius
cp = mass_cpmix(air, T_range_K);    %calculate air cpmix for all T in T_range_K 
h = mass_hmix(air, T_range_K);      %calculate air hmix for all T in T_range_K 
u = mass_umix(air, T_range_K);      %calculate air umix for all T in T_range_K 
s0 = mass_s0mix(air, T_range_K);    %calculate air s0mix for all T in T_range_K 
p0 = p0mix(air, s0);                %calculate air p0mix for all T in T_range_K 

%% Error Calculation

cp_error = 100 * (cp - tab_cp) ./ tab_cp;   %100 * (calculated - expexted) / expected
u_error = 100 * (u - tab_u) ./ tab_u;
h_error = 100 * (h - tab_h) ./ tab_h;
s0_error = 100 * (s0 - tab_s0) ./ tab_s0;
p0_error = 100 * (p0 - tab_p0) ./ tab_p0;

%% Plot

hold on
subplot(3, 2, 1)
plot(tab_T, tab_cp, 'r*', T_range_C, cp)   %plots cp v T
xlim([-220 2020])
title('c_p versus Temperature')
xlabel('Temperature (^oC)')
ylabel('c_p (kJ kg^-^1 K^-^1)')

subplot(3, 2, 3)
plot(tab_T, tab_h, 'r*', T_range_C, h)    %plots h v T
xlim([-220 2020])
title('h versus Temperature')
xlabel('Temperature (^oC)')
ylabel('h (kJ kg^-^1)')

subplot(3, 2, 2)
plot(tab_T, tab_u, 'r*', T_range_C, u)    %plots u v T
xlim([-220 2020])
title('u versus Temperature')
xlabel('Temperature (^oC)')
ylabel('u (kJ kg^-^1)')

subplot(3, 2, 4)
plot(tab_T, tab_s0, 'r*', T_range_C, s0)   %plots s0 v T
xlim([-220 2020])
title('s^o versus Temperature')
xlabel('Temperature (^oC)')
ylabel('s^o')

subplot(3, 2, 5)
plot(tab_T, tab_p0, 'r*', T_range_C, p0)    %plots p0 v T
xlim([-220 2020])
title('P^o versus Temperature')
xlabel('Temperature (^oC)')
ylabel('P^o')

%% Write Error File

outfile = 'Errors.csv';  %filename to write to
file_header = 'T,cp error,u error,h error,s0 error,p0 error\n';      %csv header 
file_data = [T_range_C' cp_error' u_error' h_error' s0_error' p0_error']; %data to write

errorwrite(outfile, file_data, file_header);    %write the csv file
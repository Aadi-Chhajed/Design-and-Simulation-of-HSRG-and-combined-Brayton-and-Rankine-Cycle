%% Rankine Cycle Full Analysis (Tasks a-e)
clear; clc; close all;

% INPUT PARAMETERS
P_cond = 10;        % Condenser Pressure [in kPa]
T_boiler_in = 500;  % Turbine Inlet Temp [in C]
eta_p = 0.85;       % Pump Efficiency
eta_t = 0.90;       % Turbine Efficiency
P_range = 5000:500:15000; % Pressure range for Parametric Study [kPa]
P_ref = 8000;       % Reference Boiler Pressure for Diagrams [kPa]

%% THERMODYNAMIC ENGINE
% State 1:Saturated Liquid
h1 = 191.81; s1 = 0.6492; v1 = 0.00101; T1 = 318.95; 
% State 3:Superheated Steam 
h3 = 3399.5; s3 = 6.7266; T3 = T_boiler_in + 273.15; %(8MPa, 500C)
% State 2: Pump 
w_p_ideal = v1 * (P_ref - P_cond);
w_p_act = w_p_ideal / eta_p;
h2_act = h1 + w_p_act;
T2 = T1 + 0.5; % Minimal temperature rise in pump
% State 4: Turbine 
h4_ideal = 2115.3; %  S4 = S3
s4_ideal = s3;
w_t_ideal = h3 - h4_ideal;
w_t_act = w_t_ideal * eta_t;
h4_act = h3 - w_t_act;
s4_act = 7.20;     % Actual entropy increase
T4 = T1;           % Temperature at condenser pressure

%% PARAMETRIC (Task e)
eff_list = [];
for P = P_range
    wp = (v1 * (P - P_cond)) / eta_p; % Actual pump work
    h2 = h1 + wp;
    qi = h3 - h2;
    wnet = w_t_act - wp; 
    eff_list = [eff_list, (wnet/qi)*100];
end

%% OUTPUTS 

BWR = w_p_act / w_t_act;

fprintf(' Metrics (at %d kPa) \n', P_ref);
fprintf('Pump Work: %.2f kJ/kg\n', w_p_act);
fprintf('Turbine Work: %.2f kJ/kg\n', w_t_act);
fprintf('Net Work Output: %.2f kJ/kg\n', w_t_act - w_p_act);
fprintf('Thermal Efficiency: %.2f%%\n', ((w_t_act - w_p_act)/(h3 - h2_act))*100);
fprintf('Back-Work Ratio: %.4f\n', BWR);

% Parametric Study Plot
figure(1);
plot(P_range/1000, eff_list, 'k-o', 'LineWidth', 2, 'MarkerFaceColor', 'g');
xlabel('Boiler Pressure (MPa)'); ylabel('Thermal Efficiency (%)');
title('Task (e): Efficiency vs. Boiler Pressure'); grid on;

% Temperature-Entropy (T-s) Diagram
figure(2);
s_vals = [s1, s1, s3, s4_act, s1]; 
T_vals = [T1, T2, T3, T4, T1];        
plot(s_vals, T_vals, 'r-o', 'LineWidth', 2, 'DisplayName', 'Actual Cycle'); hold on;
plot([s3, s4_ideal], [T3, T4], 'b--', 'LineWidth', 1.5, 'DisplayName', 'Ideal Expansion'); 
xlabel('Entropy (s) [kJ/kg.K]'); ylabel('Temperature (T) [K]');
title('T-s Diagram: Rankine Cycle'); legend; grid on;

% Enthalpy-Entropy (h-s) Diagram
figure(3);
h_vals = [h1, h2_act, h3, h4_act, h1]; 
plot(s_vals, h_vals, 'b-s', 'LineWidth', 2, 'MarkerFaceColor', 'c'); 
xlabel('Entropy (s) [kJ/kg.K]'); ylabel('Enthalpy (h) [kJ/kg]');
title('h-s Diagram: Real Rankine Cycle'); grid on;
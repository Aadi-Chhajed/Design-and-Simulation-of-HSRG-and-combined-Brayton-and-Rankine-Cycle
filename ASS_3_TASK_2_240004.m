% TASK 2 
% BRAYTON CYCLE

% INPUT PARAMETERS
P1 = 101.325;   % Ambient Pressure (kPa)
T1 = 288.15;    % Ambient Temp (K)
rp = 12;        % Pressure Ratio
T3 = 1300;      % Turbine Inlet Temp (K)
eta_c = 0.85;   % Compressor Isentropic Efficiency
eta_t = 0.90;   % Turbine Isentropic Efficiency

% Constants
R = 0.287;      % Gas Constant air
gamma = 1.4;
cp_const = 1.005;

fprintf('ANALYSIS\n');

% TASK A & B:STATES (Real & Ideal)
% State 1 is defined
fprintf('State 1: P=%.2f kPa, T=%.2f K\n', P1, T1);

% Process 1-2: Compression
% Ideal T2
T2s = T1 * (rp)^((gamma-1)/gamma);
% Real T2 (using efficiency)
T2a = T1 + (T2s - T1) / eta_c;
P2 = P1 * rp;
fprintf('State 2 (Real): P=%.2f kPa, T=%.2f K\n', P2, T2a);

% Process 2-3: Combustion (Constant Pressure)
P3 = P2;
% T3 is given
fprintf('State 3: P=%.2f kPa, T=%.2f K\n', P3, T3);

% Process 3-4: Turbine Expansion
% Ideal T4
T4s = T3 * (1/rp)^((gamma-1)/gamma);
% Real T4 (using efficiency)
T4a = T3 - eta_t * (T3 - T4s);
P4 = P1; 
fprintf('State 4 (Real): P=%.2f kPa, T=%.2f K\n', P4, T4a);

% TASK C: VARIABLE SPECIFIC HEAT (Cp) RESULTS
% Average temps for components
T_avg_c = (T1 + T2a) / 2;
T_avg_t = (T3 + T4a) / 2;

% Real Cp (approximate formula for air)
cp_c_new = 1.005 + 0.0002 * (T_avg_c - 300);
cp_t_new = 1.005 + 0.0002 * (T_avg_t - 300);

% Work & Heat with new Cp
wc_var = cp_c_new * (T2a - T1);
wt_var = cp_t_new * (T3 - T4a);
qin_var = cp_t_new * (T3 - T2a);

wnet_var = wt_var - wc_var;
eff_var = wnet_var / qin_var;

fprintf('\nTASK C COMPARISON\n');
fprintf('Constant Cp Efficiency: %.2f %%\n', thermal_eff * 100);
fprintf('Variable Cp Efficiency: %.2f %%\n', eff_var * 100);
fprintf('Difference:             %.2f %%\n', (thermal_eff - eff_var)*100);

%TASK D: WORK AND EFFICIENCY
% Using constant cp for the main baseline as per instruction (a)
wc = cp_const * (T2a - T1);      % Compressor Work
wt = cp_const * (T3 - T4a);      % Turbine Work
qin = cp_const * (T3 - T2a);     % Heat Added

wnet = wt - wc;
thermal_eff = wnet / qin;
work_ratio = wnet / wt;

fprintf('\nPERFORMANCE RESULTS\n');
fprintf('Compressor Work: %.2f kJ/kg\n', wc);
fprintf('Turbine Work:    %.2f kJ/kg\n', wt);
fprintf('Net Work Output: %.2f kJ/kg\n', wnet);
fprintf('Thermal Eff:     %.2f %%\n', thermal_eff * 100);
fprintf('Work Ratio:      %.2f\n', work_ratio);

%PLOTS
figure(1);

% T-s Diagram
subplot(1,2,1);
hold on;
% Plotting the points
s = [0, 0.1, 0.5, 0.6]; % Dummy values
plot([1,2,3,4,1], [T1, T2a, T3, T4a, T1], 'o-r', 'LineWidth', 2);
text(1, T1, '1'); text(2, T2a, '2'); text(3, T3, '3'); text(4, T4a, '4');
title('T-s Diagram (Sketch)');
xlabel('Entropy s'); ylabel('Temperature T (K)');
grid on;

% P-v Diagram
subplot(1,2,2);
hold on;
% v = RT/P
v1 = R*T1/P1; v2 = R*T2a/P2; v3 = R*T3/P3; v4 = R*T4a/P4;
plot([v1, v2, v3, v4, v1], [P1, P2, P3, P4, P1], 'o-b', 'LineWidth', 2);
title('P-v Diagram');
xlabel('Volume v'); ylabel('Pressure P (kPa)');
grid on;

%  PRESSURE RATIO SWEEP
pr_sweep = 2:1:40;
w_sweep = [];
eff_sweep = [];

for r = pr_sweep

    t2s_new = T1 * (r)^((gamma-1)/gamma);
    t2a_new = T1 + (t2s_new - T1) / eta_c;
    
    t4s_new = T3 * (1/r)^((gamma-1)/gamma);
    t4a_new = T3 - eta_t * (T3 - t4s_new);
    
    w_c_new = cp_const * (t2a_new - T1);
    w_t_new = cp_const * (T3 - t4a_new);
    q_in_new = cp_const * (T3 - t2a_new);
    
    w_sweep = [w_sweep, w_t_new - w_c_new];
    eff_sweep = [eff_sweep, (w_t_new - w_c_new)/q_in_new];
end

figure(2);
yyaxis left
plot(pr_sweep, w_sweep, 'b-', 'LineWidth', 1.5);
ylabel('Net Work (kJ/kg)');
yyaxis right
plot(pr_sweep, eff_sweep*100, 'r-', 'LineWidth', 1.5);
ylabel('Efficiency (%)');
xlabel('Pressure Ratio (rp)');
title('Optimization: Work & Efficiency vs Pressure Ratio');
grid on;
legend('Net Work', 'Efficiency');

% max work
[max_w, idx] = max(w_sweep);
fprintf('\nMax Work occurs at Pressure Ratio: %.1f\n', pr_sweep(idx));

%% CONCLUSION
% Efficiency: Does not change significantly because efficiency depends on the ratio of pressures (rp) and temperatures, which remain similar.
% Power Output: Drops drastically. Power is m*W. At high altitude, air density is low, so the mass flow rate through the engine decreases. Therefore, the engine produces much less thrust/power even if it is running efficiently.
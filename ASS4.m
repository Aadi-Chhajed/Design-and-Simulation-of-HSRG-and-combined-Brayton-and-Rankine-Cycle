%% FINAL PROJECT
clear; clc; close all;

%% 1. Fixed Input Parameters 
T1 = 298.15; P1    = 1;         % Compressor Inlet (K, bar)
eta_c = 0.88;   eta_gt = 0.90;  % Gas Side Efficiencies
eta_st = 0.92;  eta_p = 0.60;   % Steam Side Efficiencies
T_cond = 30 + 273.15;           % Condenser Temp (303.15 K)
dT_pinch = 10;                  % Pinch Point (K)
x_min = 0.92;                   % Moisture Limit

% Air/Gas Constants
Cp_a = 1.005; gamma = 1.4; R = 0.287; 

% Reference Steam Table Data (at 30 C / 0.04246 bar) 
hf = 125.74; hfg = 2430; sf = 0.4365; sfg = 8.0152; vf = 0.001004;

T3_range = 900:100:1400; % T3 in Celsius
final_results = [];

for T3c = T3_range
    T3 = T3c + 273.15;
    best_eff = 0;
    
    % Optimization
    for rp1 = 5:0.5:30   % Brayton Ratio
        for P7 = 10:5:100 % Rankine Pressure (bar)
            
            % BRAYTON CYCLE STATES (1-4)
            P2 = P1 * rp1;
            T2 = T1 * (1 + (rp1^((gamma-1)/gamma) - 1) / eta_c);
            P3 = P2 * 0.95; % Including 5% press drop 
            T4 = T3 * (1 - eta_gt * (1 - (1/rp1)^((gamma-1)/gamma)));
            P4 = P1 / 0.95; % HRSG press drop 
            
            % RANKINE CYCLE STATES (6-11) 
            Wp = vf * (P7 - 0.04246) * 100 / eta_p; % kJ/kg
            h7 = hf + Wp;
            T7 = T_cond + 1; % Small temp rise across pump (T7 is defined here)
            
            % Steam Turbine Inlet (State 10)
            T10 = T4 - 20; % Superheat approach 
            h10 = 1.9*(T10-273.15) + 2550; % linear approx
            s10 = 0.005*(T10-273.15) + 5.3;
            
            % Turbine Exit (State 11)
            h11s = hf + ((s10 - sf)/sfg) * hfg;
            h11 = h10 - eta_st * (h10 - h11s);
            x11 = (h11 - hf) / hfg; % Dryness fraction
            
            % HRSG ENERGY BALANCE (mw) 
            % Pinch point at State 8 (Sat Liquid) 
            T8 = 212.4 + 273.15; h8 = 908.5; % Ref values for P7 ~ 20-30 bar
            mw = (Cp_a * (T4 - (T8 + dT_pinch))) / (h10 - h8);
            
            % PERFORMANCE CALCULATIONS
            if x11 >= x_min && mw > 0
                W_comp = Cp_a * (T2 - T1);
                W_gt = Cp_a * (T3 - T4);
                W_st = mw * (h10 - h11);
                W_p = mw * Wp;
                
                Qin = Cp_a * (T3 - T2);
                Net_Work = (W_gt - W_comp) + (W_st - W_p);
                eff_comb = Net_Work / Qin;
                
                if eff_comb > best_eff
                    best_eff = eff_comb;
                    best_row = [T3c, rp1, P7, (W_gt-W_comp), W_st, eff_comb*100];
                    % Store state for plotting
                    opt_S = [1, 1.2, 2.5, 2.3, 0.5, 0.6, 2.0, 1.8]; % Normalized S
                    opt_T = [T1, T2, T3, T4, T_cond, T7, T10, T_cond];
                end
            end
        end
    end
    final_results = [final_results; best_row];
end

%% 2. Display Formatted Results 
fprintf('     FINAL DELIVERABLE: COMBINED CYCLE OPTIMIZATION\n');
T_Out = array2table(final_results, 'VariableNames', ...
    {'T3_Celsius', 'Opt_Brayton_rp', 'Opt_Rankine_P_bar', 'W_net_Gas_kJ', 'W_net_Steam_kJ', 'Total_Eff_Perc'});
disp(T_Out);

%% 3. Plotting
% Parametric Analysis
figure(1); plot(final_results(:,1), final_results(:,6), 'r-o', 'LineWidth', 2);
grid on; xlabel('T3 (°C)'); ylabel('Combined Efficiency (%)');
title('Parametric Analysis: Influence of T3 on Efficiency');

% T-s Diagram
figure(2); hold on;
plot(opt_S(1:4), opt_T(1:4), 'r-s', 'LineWidth', 2); % Brayton
plot(opt_S(5:8), opt_T(5:8), 'b-o', 'LineWidth', 2); % Rankine
legend('Brayton Cycle', 'Rankine Cycle'); 
xlabel('Entropy (s)'); ylabel('Temperature (T)'); title('Optimized T-s Diagram');
grid on;
%%

% COMPONENT POWER REQUIREMENTS (For the Best Case: T3 = 1400 C)
[~, best_idx] = max(final_results(:,6)); % Finding the max efficiency case
fprintf('\n[2] COMPONENT PERFORMANCE (At T3 = %.0f C)\n', final_results(best_idx, 1));
fprintf('------------------------------------------------------------\n');
fprintf('Brayton Cycle Net Work:    %10.2f kJ/kg_air\n', final_results(best_idx, 4));
fprintf('Rankine Cycle Net Work:    %10.2f kJ/kg_air\n', final_results(best_idx, 5));
fprintf('Total Combined Net Work:   %10.2f kJ/kg_air\n', final_results(best_idx, 4) + final_results(best_idx, 5));
fprintf('Max Combined Efficiency:   %10.2f %%\n', final_results(best_idx, 6));

% THERMODYNAMIC STATE POINTS
fprintf('\n[3] KEY THERMODYNAMIC STATES (Brayton & Rankine)\n');
fprintf('------------------------------------------------------------\n');
fprintf('State 1 (Inlet):      T = %7.2f K, P = %4.2f bar\n', T1, P1);
fprintf('State 2 (Comp Out):   T = %7.2f K, P = %4.2f bar\n', opt_T(2), P1*final_results(best_idx,2));
fprintf('State 3 (GT In):      T = %7.2f K, P = %4.2f bar\n', opt_T(3), P1*final_results(best_idx,2));
fprintf('State 4 (GT Out):     T = %7.2f K, P = %4.2f bar\n', opt_T(4), P1);
fprintf('State 10 (ST In):     T = %7.2f K, P = %4.2f bar\n', opt_T(7), final_results(best_idx,3));
fprintf('State 11 (ST Out):    T = %7.2f K, P = %4.2f bar\n', opt_T(8), 0.04246);
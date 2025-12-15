clc; clear;

% Time limits
t1 = 0;
t2 = 6000;
t  = linspace(t1,t2,5000);
% Temperature functions
Th = @(t) 900 - 300*exp(-0.0008*t);
Tc = @(t) 300 + 40*sin(0.002*t);

% Efficiency
eta = @(t) 1 - Tc(t)./Th(t);

% Heat input (kW)
Qin = @(t) 20000*(1 + 0.3*sin(0.003*t));

% Power output (kW)
P = @(t) eta(t).*Qin(t);

% Work done (kJ)
W_done = integral(P, t1, t2);

disp(W_done)
Sgen = @(t) Qin(t)./Tc(t) - Qin(t)./Th(t);
figure;
plot(t, Sgen(t), 'LineWidth', 2);
grid on;
xlabel('Time (s)');
ylabel('\dot{S}_{gen} (kW/K)');
title('Entropy Generation Rate vs Time');

disp(['Total Work Output = ', num2str(W_done), ' kJ']);

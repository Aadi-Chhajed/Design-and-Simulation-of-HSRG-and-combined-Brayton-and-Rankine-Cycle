
% Given
P = linspace(1,20,1000);   % bar
T1 = 300;                 % K
n  = 1.28;
cp = 1.05;                % kJ/kg-K
R  = 0.287;               % kJ/kg-K

% Polytropic temperature relation
T = T1*(P/1).^((n-1)/n);

% Compressibility factor
Z = 1 + 0.0008*P - 120./T;

% Numerical derivatives
dT = gradient(T,P);
dP = gradient(P,P);

% Entropy differential
ds = cp*(dT./T) - R*Z.*(dP./P);

% Real-gas entropy change
Delta_s_real = trapz(P, ds);

% Ideal-gas entropy change
T2 = T(end);
Delta_s_ideal = cp*log(T2/T1) - R*log(20/1);

% Percent deviation
percent_dev = 100*(Delta_s_real - Delta_s_ideal)/Delta_s_ideal;

% Display
fprintf('Real-gas entropy change: %.4f kJ/kg-K\n', Delta_s_real);
fprintf('Ideal-gas entropy change: %.4f kJ/kg-K\n', Delta_s_ideal);
fprintf('Percent deviation: %.2f %%\n', percent_dev);

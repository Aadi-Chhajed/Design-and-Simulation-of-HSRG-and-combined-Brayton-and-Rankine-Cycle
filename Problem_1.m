
syms T

T1=320;
T2=820;

cv = 700 + 0.35*T - 2e-4*T^2;
du_sym = int(cv, T, T1, T2);
du_exact = double(du_sym)

% Numerical Method 1 

cv = @(T) 700 + 0.35*T - 2e-4*T.^2;
du_integral = integral(cv, 320, 820)

% Method 2
N = 100;                         
T = linspace(320, 820, N);
cv_vals = cv(T);

du_trapz = trapz(T, cv_vals)

% error comparision
err_integral = abs(du_integral - du_exact)/du_exact * 100;
err_trapz    = abs(du_trapz - du_exact)/du_exact * 100;

% Minimum GRID Resolution Part
du_exact = double(du_sym);

for N = 5:500
    T = linspace(320, 820, N);
    du_trapz = trapz(T, cv(T));
    err = abs(du_trapz - du_exact)/du_exact * 100;

    if err < 0.1
        fprintf('Minimum N = %d (Error = %.4f%%)\n', N, err);
        break
    end
end


% FUNCTIONS

u_of_T = @(T) 450 + 1.1*T + 0.0012*T.^2;
qext   = @(t) 5000*exp(-0.002*t);
rT     = @(T) 1500*(1 - exp(-0.01*T));


% INVERSE u -> T
Tgrid = linspace(250, 1500, 5000);
ugrid = u_of_T(Tgrid);

% Inverse function using interpolation
T_of_u = @(u) interp1(ugrid, Tgrid, u, 'linear', 'extrap');

% INITIAL CONDITION
T0 = 300;
u0 = u_of_T(T0);

% ODE FUNCTION
odefun = @(t,u) qext(t) + rT( T_of_u(u) );

% SOLVE ODE

[t,u] = ode45(odefun, [0 4000], u0);


% RECOVER TEMPERATURE

T = T_of_u(u);


% HEAT COMPARISON

q_vals = qext(t);
r_vals = rT(T);

i = find(r_vals > q_vals, 1);
t_cross = t(i);

fprintf('Reaction heat exceeds external heat at t = %.2f s\n', t_cross);


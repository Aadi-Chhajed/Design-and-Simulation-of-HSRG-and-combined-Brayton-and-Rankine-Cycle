clc; clear;

R = 8.314e-3;
c = 1.8;

A_true = 1e5;
E_true = 45;

tspan = linspace(0,2000,200);
T0 = 300;

ode_true = @(t,T) (A_true*exp(-E_true./(R*T)) + 2000*exp(-0.001*t))/c;
[~,T_true] = ode45(ode_true,tspan,T0);

rng(1)
T_meas = T_true.*(1 + 0.01*randn(size(T_true)));

p0 = [5e4 30];
lb = [1e3 10];
ub = [1e7 100];

p_est = lsqcurvefit(@(p,t) model_T(p,t,T0,c,R),...
                    p0,tspan,T_meas,lb,ub);

A_est = p_est(1)
E_est = p_est(2)

T_fit = model_T(p_est,tspan,T0,c,R);

figure;
plot(tspan,T_meas,'o'); hold on;
plot(tspan,T_fit,'LineWidth',2);
xlabel('t'); ylabel('T');

function Tsim = model_T(p,tspan,T0,c,R)
A = p(1); E = p(2);
ode = @(t,T) (A*exp(-E./(R*T)) + 2000*exp(-0.001*t))/c;
[~,Tsim] = ode45(ode,tspan,T0);
end

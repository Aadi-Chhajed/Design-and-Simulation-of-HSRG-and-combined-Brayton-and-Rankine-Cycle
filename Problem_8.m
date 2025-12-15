clc; clear;

Tf = 2000;
N  = 100;
dt = Tf/N;

c  = 2.5;
Tb = 300;
T0 = 300;
Qtot = 5e5;

q0 = (Qtot/Tf)*ones(N,1);

lb = zeros(N,1);
ub = 1e4*ones(N,1);

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

q_opt = fmincon(@(q)objfun(q,T0,c,Tb,dt),...
                q0,[],[],...
                ones(1,N)*dt,Qtot,...
                lb,ub,[],options);

T_opt = temperature_profile(q_opt,T0,c,dt);
T_uni = temperature_profile(q0,T0,c,dt);

t = linspace(0,Tf,N);

figure;
plot(t,q_opt,'LineWidth',2); hold on;
plot(t,q0,'--','LineWidth',2);
xlabel('Time'); ylabel('q(t)');

figure;
plot(t,T_opt,'LineWidth',2); hold on;
plot(t,T_uni,'--','LineWidth',2);
xlabel('Time'); ylabel('T');

function S = objfun(q,T0,c,Tb,dt)
N = length(q);
T = zeros(N,1);
T(1) = T0;
for k = 1:N-1
    T(k+1) = T(k) + dt*q(k)/c;
end
S = sum((q./T - q/Tb)*dt);
end
function T = temperature_profile(q,T0,c,dt)
N = length(q);
T = zeros(N,1);
T(1) = T0;
for k = 1:N-1
    T(k+1) = T(k) + dt*q(k)/c;
end
end

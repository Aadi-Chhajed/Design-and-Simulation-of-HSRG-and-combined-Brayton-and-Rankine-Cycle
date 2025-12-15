clc;
clear;
close all;

Tc = 270;
Th = 320;
alpha = 0.02;
k = 50;

COP = @(rp) (Tc/(Th-Tc)) .* (1 - alpha*((rp-1).^2)./rp);
Wc  = @(rp) k*(sqrt(rp)-1);

Qh = @(rp) COP(rp).*Wc(rp);

Sgen = @(rp) (1 - COP(rp)*(Th-Tc)/Tc).*Qh(rp)/Th;

obj = @(rp) -Qh(rp)./Wc(rp);

nonlcon = @(rp) deal(Sgen(rp)-0.05,[]);

rp0 = 2;
lb = 1.1;
ub = 6;

opts = optimoptions('fmincon','Display','off');

rp_opt = fmincon(obj,rp0,[],[],[],[],lb,ub,nonlcon,opts);

rp = linspace(1.1,6,500);

COPv = COP(rp);
Sgenv = Sgen(rp);
QW = Qh(rp)./Wc(rp);

feasible = Sgenv <= 0.05;

figure;
plot(rp,COPv,'LineWidth',2);
xlabel('r_p');
ylabel('COP');
grid on;

figure;
plot(rp,Sgenv,'LineWidth',2);
hold on;
yline(0.05,'r--');
xlabel('r_p');
ylabel('Entropy Generation (kJ/K)');
grid on;

figure;
plot(rp(feasible),QW(feasible),'LineWidth',2);
xlabel('r_p');
ylabel('Q_H / W');
grid on;

[RP,SG] = meshgrid(rp,linspace(0,0.1,200));
COPc = COP(RP);

figure;
contourf(RP,SG,COPc,20);
colorbar;
xlabel('r_p');
ylabel('Entropy Generation (kJ/K)');

rp_opt
COP(rp_opt)
Sgen(rp_opt)

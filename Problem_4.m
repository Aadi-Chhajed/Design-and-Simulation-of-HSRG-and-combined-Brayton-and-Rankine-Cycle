
T1 = 310;          
T2 = 670;          
Tb = 300;          

h = @(T) 300 + 2.5*T + 0.0007*T.^2;     
s = @(T) 2.0*log(T) + 0.001*T;           


dh = h(T2) - h(T1);        
ds = s(T2) - s(T1);        

Qdot = linspace(20,100,300);      
mdot = linspace(0.01,5,300);     

[Q,M] = meshgrid(Qdot, mdot);


Q_energy = M * dh;        


Sgen = M*ds - Q/Tb;      

feasible = (Sgen >= 0);


figure;
hold on;
box on;
scatter(Q(feasible), M(feasible), 8, 'b', 'filled');
mdot_energy = Qdot / dh;
plot(Qdot, mdot_energy, 'r', 'LineWidth', 2);
xlabel('$\dot Q\ \mathrm{(kW)}$','Interpreter','latex','FontSize',12);
ylabel('$\dot m\ \mathrm{(kg/s)}$','Interpreter','latex','FontSize',12);
title('Feasible Operating Region ($\dot S_{gen} \ge 0$)', ...
      'Interpreter','latex','FontSize',13);
legend({'Feasible points','Energy balance line'}, ...
       'Interpreter','latex','Location','northwest');
grid on;
hold off;

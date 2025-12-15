 T0= 298;
 cp_by_T= @(T) (1200./T+0.4-1.2e-4*T);
 ds=integral(cp_by_T,350,900)

N=50;
Tt=linspace(350,900,N);
c_vals=cp_by_T(Tt);
ds_trapz=trapz(Tt,c_vals)
%Exergy destruction
irr = [0.02 0.10];              % irreversibility levels
Sgen = irr * ds;                % entropy generation
Xdest = T0 * Sgen;              % exergy destruction

for i = 1:length(irr)
    fprintf('Irreversibility = %.0f%% → X_dest = %.2f J/kg\n', ...
            irr(i)*100, Xdest(i));
end
%Plot
irr_plot = linspace(0,0.15,100);
Sgen_plot = irr_plot * ds;
Xdest_plot = T0 * Sgen_plot;
figure
plot(irr_plot*100, Xdest_plot, 'LineWidth', 2)
xlabel('Irreversibility','Interpreter','latex')
ylabel('Exergy Destruction (J/kg)','Interpreter','latex')
title('Exergy Destruction vs Heater Irreversibility','Interpreter','latex')
grid on

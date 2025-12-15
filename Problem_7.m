
PA = 1;
PB = 10;
TA = 300;
m  = 1.25;
R  = 0.287;

u = @(T) 500 + 0.8*T + 1.5e-3*T.^2;

TB = TA * (PB/PA)^((m-1)/m);

Delta_u = u(TB) - u(TA);

vA = R*TA / PA;
vB = R*TB / PB;

C = PA * vA^m;
P = @(v) C * v.^(-m);

W_num = integral(@(v) P(v), vA, vB) * 100;

W_ana = (PB*vB - PA*vA) / (1 - m) * 100;

Q = Delta_u + W_num;

TB
Delta_u
W_num
W_ana
Q

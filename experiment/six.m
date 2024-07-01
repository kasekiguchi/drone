%Exercise1
Ac = [0,0,1.0000,0;
     0,0,0,1.0000;
     25.7552,-6.2818,0,0;
     -6.2818,44.6004,0,0];
Bc = [0;0;-23.0523;83.6713];
% c = [1,0,0,0;0,1,0,0];
% Uo = [c;c*Ac;c*A^2;c*A^3];
% K = place(Ac',c',)
Fc = place(Ac,Bc,[-1,-1.1,-0.9,-0.95]);
eig(Ac-Bc*Fc)
%uc = @(x) -Fc*(x)
%uc(x0)

Cc = [1,0,0,0;0,1,0,0];
Kc = place(Ac',Cc',[-9,-9.1,-8.9,-8.8])';
eig(Ac-Kc*Cc)

Ace = [Ac zeros(4);Kc*Cc Ac-Kc*Cc];
Bce = [Bc;Bc];

AX = [Ac -Bc*Fc;Kc*Cc, Ac-Bc*Fc-Kc*Cc];

%ideal situation
X0 = [x0;0*x0];
[Ta,Xa] = ode45(@(t,x)AX*x,[0,3],X0);
plot(Ta,Xa);
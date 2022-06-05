%% シグモイド関数とtanh
%% sigmoid
a = 2;
x = -2:0.01:2;
% I=ones(size(x));
sgmd = 1./(1+exp(-a*x));
dsgmd = a*sgmd.*(1-sgmd);
ddsgmd = a^2*sgmd.*(1-sgmd).*(1-2*sgmd);
ddsgmd1 = a*dsgmd.*(1-2*sgmd);
dddsgmd = a^3*sgmd.*(1-sgmd).*(1-6*sgmd+6*sgmd.^2);
%% sgmd
figure(1)
hold on
plot(x,sgmd);
plot(x,dsgmd);
plot(x,ddsgmd1);
plot(x,ddsgmd);
plot(x,dddsgmd);
legend('sgmd','d','dd','ddd');
grid on
%% tanh
at=2;
x2 = 2*x;
th = tanh(at*x);
sgmd2=1./(1+exp(-at*x2));%f(2x)の時のシグモイド関数
tanh2sg = 2*sgmd2-1;%tanhをシグモイドで表す
dtanh2sg = 4*at*sgmd2.*(1-sgmd2);
ddtanh2sg = 8*at^2*sgmd2.*(1-sgmd2).*(1-2*sgmd2);
dddtanh2sg = 16*at^3*sgmd2.*(1-sgmd2).*(1-6*sgmd2+6*sgmd2.^2);
%% tanh
figure(2)
hold on
plot(x,th);
plot(x,tanh2sg);
plot(x,dtanh2sg)
plot(x,ddtanh2sg)
plot(x,dddtanh2sg)
% plot(x,x);
% plot(x,-16*x);
legend('tanh','tanh2sg','d','dd','ddd');
grid on

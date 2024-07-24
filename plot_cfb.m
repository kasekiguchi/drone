
%%
log = simplifyLoggerForCoop(gui.logger,1);

q = log.estimator.q;
pT = log.estimator.pT;
wL = log.estimator.wL;

t = log.t;
theta = log.controller.theta';
C = log.controller.C';
u = log.controller.input;
a = log.controller.a(:,1);
ax = -10:10;

h0 = log.controller.h0';
ah0 = log.controller.ah0';
dh0 = log.controller.dh0';
% xlimit0=[min(h0),max(h0)];
% ylimit0=[min(dh0),max(dh0)];
xlimit0=[0,0.3/a(1)];
ylimit0=[-0.2/a(1),0.3/a(1)];


h1 = log.controller.h1';
ah1 = log.controller.ah1';
dh1 = log.controller.dh1';
% xlimit1=[min(h1),max(h1)];
% ylimit1=[min(dh1),max(dh1)];
xlimit1=[0,0.3/a(2)];
ylimit1=[-0.2/a(2),0.3/a(2)];

close all
tiledlayout(2,3);
i=1;
% figure("name",string(i));

nexttile
plot(t,theta);
grid on
hold on
plot(t,C);
xlabel("t")
ylabel("theta[deg]")
hold off
i=i+1;

% figure("name",string(i));
nexttile
plot(h0,dh0)
grid on
hold on
% plot(xlimit0,xlimit0*-100)
plot(ax,-a(1)*ax)
xlim(xlimit0)
ylim(ylimit0)
daspect([1 1 1])
xlabel("h0")
ylabel("dh0")
hold off
i=i+1;

% figure("name",string(i));
nexttile
plot(h1,dh1)
grid on
hold on
% plot(h1,-ah1)
plot(ax,-a(2)*ax)
xlim(xlimit1)
ylim(ylimit1)
daspect([1 1 1])
xlabel("h1")
ylabel("dh1")
hold off
i = i+1;


% figure("name",string(i));
nexttile
plot(t,[h0,dh0])
grid on
hold on
xlabel("t")
ylabel("h0dh0")
legend("h0","dh0")
hold off
i = i+1;

% figure("name",string(i));
nexttile
plot(t,[h1,dh1])
grid on
hold on
xlabel("t")
ylabel("h1dh1")
legend("h1","dh1")
hold off
i = i+1;

nexttile
plot(t,u)
grid on
hold on
xlabel("t")
ylabel("input")
legend("f","M1","M2","M3")
ylim([-10,20])
hold off

figure("name",string(i));
plot(t,pT)
grid on
hold on
plot(t,wL,"LineStyle","--")
plot(t,q,"LineStyle",":")
legend(["pT1","pT2","pT3","wL1","wL2","wL3","q1","q2","q3"])
xlabel("t")
ylabel("h1dh1")
hold off
i = i+1;
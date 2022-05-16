%%
clc
clear Time p q v w pL vL pT wL input xd F1 F2 F3 F4 d6pLMI d6pLPI d6pLM d6pLP P
%% Data Load
Time = logger.data("t",[],[]);
p = logger.data(1,"state.p","e");
q = logger.data(1,"state.q","e");
v = logger.data(1,"state.v","e");
w = logger.data(1,"state.w","e");
pL = logger.data(1,"state.pL","e");
vL = logger.data(1,"state.vL","e");
pT = logger.data(1,"state.pT","e");
wL = logger.data(1,"state.wL","e");
input = logger.data(1,[],'i');
%%
if fExp == 1
    fpha = 0;
    lpha = 0;
    pha = logger.Data.phase(1:logger.k,:);
    for i = 1:logger.k
        if pha(i) == 102 && fpha == 0
            fpha = i;
        elseif pha(i) == 108 && lpha == 0
            lpha = i;
        end
    end
    xd = zeros(length(pha),28);
    xd(fpha:lpha-1,:) = logger.data(1,"state.xd","r","time",[logger.Data.t(fpha) logger.Data.t(lpha)]);
else
    xd = logger.data(1,"state.xd","r");
end
%% Settings
F1 = agent.controller.hl_load.param.F1;
F2 = agent.controller.hl_load.param.F2;
F3 = agent.controller.hl_load.param.F3;
F4 = agent.controller.hl_load.param.F4;
First = 0;
End = length(Time)-1;
d6pLMI = zeros(length(Time),6);
d6pLPI = zeros(length(Time),6);
d6pLM = zeros(length(Time),6);
d6pLP = zeros(length(Time),6);
lims = [-5 5];
%% Savitzky-Golay Filter
% tmp = pL(:,1);
% [b,g] = sgolay(10,551);
% dpL = zeros(length(tmp),7);
% for k = 0:6
%   dpL(:,k+1) = conv(tmp, factorial(k)/(-dt)^k * g(:,k+1), 'same');
% end
% plot(Time,tmp,'.-')
% hold on
% plot(Time,dpL)
% ylim([-5 5])
% hold off
% legend('x','x (smoothed)','x''','x''''', 'x^{(3)}', 'x^{(4)}', 'x^{(5)}', 'x^{(6)}')
% title('Savitzky-Golay Derivative Estimates')
%% HL Model Input
P = agent.model.param;
for i = First+1:End+1
    x = [Eul2Quat(q(i,:)');w(i,:)';pL(i,:)';vL(i,:)';pT(i,:)';wL(i,:)'];
    vf = Vfd_SuspendedLoad(dt,x,xd(i-First,:),P,F1);
    d6pLMI(i,:) = d6pl1(x,xd(i-First,:),input(i,:)',vf,P);
end
figure(2)
plot(Time,d6pLMI)
ylim(lims)
%% HL Plant Input
P = agent.plant.param;
for i = First+1:End+1
    x = [Eul2Quat(q(i,:)');w(i,:)';pL(i,:)';vL(i,:)';pT(i,:)';wL(i,:)'];
    vf = Vfd_SuspendedLoad(dt,x,xd(i-First,:),P,F1);
    d6pLPI(i,:) = d6pl1(x,xd(i-First,:),input(i,:)',vf,P);
end
figure(3)
plot(Time,d6pLPI)
ylim(lims)
%% HL Model
P = agent.model.param;
for i = First+1:End+1
    x = [Eul2Quat(q(i,:)');w(i,:)';pL(i,:)';vL(i,:)';pT(i,:)';wL(i,:)'];
    vf = Vfd_SuspendedLoad(dt,x,xd(i-First,:),P,F1);
    vs = Vs_SuspendedLoad(x,xd(i-First,:),vf,P,F2,F3,F4);
    uf = Uf_SuspendedLoad(x,xd(i-First,:),vf,P);
    h234 = H234_SuspendedLoad(x,xd(i-First,:),vf,vs',P);
    invbeta2 = inv_beta2_SuspendedLoad(x,xd(i-First,:),vf,vs',P);
    a = v_SuspendedLoad(x,xd(i-First,:),vf,vs',P);
    us = h234*invbeta2*a;
    in = uf +[0;us(2:4)];
    d6pLM(i,:) = d6pl1(x,xd(i-First,:),in,vf,P);
end
figure(4)
plot(Time,d6pLM)
ylim(lims)
%% HL Plant
P = agent.plant.param;
for i = First+1:End+1
    x = [Eul2Quat(q(i,:)');w(i,:)';pL(i,:)';vL(i,:)';pT(i,:)';wL(i,:)'];
    vf = Vfd_SuspendedLoad(dt,x,xd(i-First,:),P,F1);
    vs = Vs_SuspendedLoad(x,xd(i-First,:),vf,P,F2,F3,F4);
    uf = Uf_SuspendedLoad(x,xd(i-First,:),vf,P);
    h234 = H234_SuspendedLoad(x,xd(i-First,:),vf,vs',P);
    invbeta2 = inv_beta2_SuspendedLoad(x,xd(i-First,:),vf,vs',P);
    a = v_SuspendedLoad(x,xd(i-First,:),vf,vs',P);
    us = h234*invbeta2*a;
    in = uf +[0;us(2:4)];
    d6pLP(i,:) = d6pl1(x,xd(i-First,:),in,vf,P);
end
figure(5)
plot(Time,d6pLP)
ylim(lims)
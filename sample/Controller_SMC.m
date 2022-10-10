function Controller= Controller_SMC(dt,~)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Controller_param.F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt);                                % 
Controller_param.F2=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller_param.F3=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 
syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));
Controller_param.Vf = matlabFunction([-sF1*sz1, -sF1*(Ad1-Bd1*sF1)*sz1, -sF1*(Ad1-Bd1*sF1)^2*sz1, -sF1*(Ad1-Bd1*sF1)^3*sz1],"Vars",{sz1,sF1});

syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller_param.Vs = matlabFunction([-sF2*sz2;-sF3*sz3;-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4});
 
%% スライディングモードSの設計
sn=1;
%極配置法
switch sn
    case 1
    A11=diag([1,1],1);
    A12=[0;0;1];
    K = lqrd(A11,A12,diag([100,10,10]),0.01,dt);
    [Ad2,Bd2,~,~] = ssdata(c2d(ss(Ac4,Bc4,[1,0,0,0],[0]),dt));
    S=[K 1];
%     sig0=S*[x1(1);x2(1)]
%     Ts=abs(sig0)/gaink
%     Tp=1/gaink*log(gaink*abs(sig0)/gaink+1)
%     Ta=sig0^(1-alp)/((1-alp)*gainqa)
    Controller_param.S=S;
%     Controller_param.SA=S*Ad2;
%     Controller_param.SB=S*Bd2;
    Controller_param.SA=S*Ac4;
    Controller_param.SB=S*Bc4; 
    case 2
        A11=diag([1,1],1);%A11-A12*inv(Q22)*Q12'
        A12=[0;0;1];
        Q11 = diag([100,10,10]);%Q11-Q12*inv(Q22)*Q12'
        Q22 = 0.01;
        Q12=0;%Q12=Q21
        [~,P,~] = lqrd(A11,A12,Q11,Q22,dt);%正準系のFBgain
        S=[A12'*P+Q12',Q22];
        Controller_param.S=S;
    %     Controller_param.SA=S*Ad2;
    %     Controller_param.SB=S*Bd2;
        Controller_param.SA=S*Ac4;
        Controller_param.SB=S*Bc4; 
end

%%
Controller.type="SMC";
Controller.name="hlc";
Controller.param=Controller_param;
end

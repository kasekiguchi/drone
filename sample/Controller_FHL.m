function Controller= Controller_FHL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Controller_param.F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt);                                % 
% Controller_param.F1 = place(Ac2,Bc2,[-8.2518 + 4.9876i,-8.2518 - 4.9876i]);%近似線形化と同じ極
Controller_param.F2=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller_param.F3=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 
% Controller_param.F2(1)=Controller_param.F2(1)*1.5;
% Controller_param.F3(1)=Controller_param.F3(1)*1.5; 
%approと一緒の極
% Controller_param.F1 = place(Ac2,Bc2,[-1.1283, -7.3476]);%appと同じgain
% Controller_param.F2 = place(Ac4,Bc4,[-37.6509 ,-1.3739 + 1.4255i,-1.3739 - 1.4255i,-0.7037]);%appと同じgain
% Controller_param.F3 = place(Ac4,Bc4,[-51.4247 ,-1.3739 + 1.4255i,-1.3739 - 1.4255i,-0.7037]);%appと同じgain
% Controller_param.F4 = place(Ac2,Bc2,[-1.0864,-27.0167]);%appと同じgain

syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));
Controller_param.Vf = matlabFunction([-sF1*sz1, -sF1*(Ad1-Bd1*sF1)*sz1, -sF1*(Ad1-Bd1*sF1)^2*sz1, -sF1*(Ad1-Bd1*sF1)^3*sz1],"Vars",{sz1,sF1});
% Controller_param.Vf = matlabFunction([-sF1*sz1, -sF1*(Ac2-Bc2*sF1)*sz1, -sF1*(Ac2-Bc2*sF1)^2*sz1, -sF1*(Ac2-Bc2*sF1)^3*sz1],"Vars",{sz1,sF1});

syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller_param.Vs = matlabFunction([-sF2*sz2;-sF3*sz3;-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4});

Controller.type="FUNCTIONAL_HLC";
Controller.name="hlc";
Controller.param=Controller_param;
end

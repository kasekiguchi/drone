function Controller= Controller_FHL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Controller_param.F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt);                                % 
Controller_param.F2=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller_param.F3=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 
syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));
Controller_param.Vf = matlabFunction([-sF1*sz1, -sF1*(Ad1-Bd1*sF1)*sz1, -sF1*(Ad1-Bd1*sF1)^2*sz1, -sF1*(Ad1-Bd1*sF1)^3*sz1],"Vars",{sz1,sF1});
%有限整定制御用のVfを書く
% Controller_param.Vf = matlabFunction([-sF1*sz1, -sF1*(Ad1-Bd1*sF1)*sz1, -sF1*(Ad1-Bd1*sF1)^2*sz1, -sF1*(Ad1-Bd1*sF1)^3*sz1],"Vars",{sz1,sF1});
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

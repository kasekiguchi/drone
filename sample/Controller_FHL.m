function Controller= Controller_FHL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % 
Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);                       % ヨー角 
syms sz1 [2 1] real
syms sF1 [1 2] real
[Ac1,Bc1,~,~] = ssdata(c2d(ss([0,1;0,0],[0;1],[1,0],[0]),dt));
Controller_param.Vf = matlabFunction([-sF1*sz1;-sF1*(Ac1-Bc1*sF1)*sz1;-sF1*(Ac1-Bc1*sF1)^2*sz1;-sF1*(Ac1-Bc1*sF1)^3*sz1],"Vars",{sz1,sF1});
syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
% [Ac2,Bc2,~,~] = ssdata(c2d(ss([0,1,0,0;0,0,1,0;0,0,0,1;0,0,0,0],[0;0;0;1],[1,0,0,0],[0]),dt));
% [Ac3,Bc3,~,~] = ssdata(c2d(ss([0,1,0,0;0,0,1,0;0,0,0,1;0,0,0,0],[0;0;0;1],[1,0,0,0],[0]),dt));
% [Ac4,Bc4,~,~] = ssdata(c2d(ss([0,1;0,0],[0;1],[1,0],[0]),dt));
Controller_param.Vs = matlabFunction([-sF2*sz2;-sF3*sz3;-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4});
 
Controller.type="HLC";
Controller.name="hlc";
Controller.param=Controller_param;
end

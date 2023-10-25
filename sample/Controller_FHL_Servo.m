function Controller= Controller_FHL_Servo(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Cc2 = [1 0];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Cc4 = [1 0 0 0];
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,Cc2,0),dt));
Controller.F1=lqrd([Ac2,zeros(2,1);-Cc2,0],[Bc2;0],diag([100,1,1]),0.1,dt);                                % 
Controller.F2=lqrd([Ac4,zeros(4,1);-Cc4,0],[Bc4;0],diag([100,100,10,1,0.01]),0.1,dt); % xdiag([100,10,10,1])
Controller.F3=lqrd([Ac4,zeros(4,1);-Cc4,0],[Bc4;0],diag([100,100,10,1,0.01]),0.1,dt); % ydiag([100,10,10,1])
Controller.F4=lqrd(Ac2,Bc2,diag([100,10]),0.1,dt);                       % ヨー角 
syms x [3 1] real % Model_EulerAngle_Servoを使う前提
syms sz1 [2 1] real
syms sF1 [1 3] real
Ad1 = [Ad1,zeros(2,1);-Cc2,1];
Bd1 = [Bd1;0];
Controller.Vf = matlabFunction([-sF1*[sz1;x(end)], -sF1*(Ad1-Bd1*sF1)*[sz1;x(end)], -sF1*(Ad1-Bd1*sF1)^2*[sz1;x(end)], -sF1*(Ad1-Bd1*sF1)^3*[sz1;x(end)]],"Vars",{sz1,sF1,x});
syms sz2 [4 1] real
syms sF2 [1 5] real
syms sz3 [4 1] real
syms sF3 [1 5] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller.Vs = matlabFunction([-sF2*[sz2;x(end-2)];-sF3*[sz3;x(end-1)];-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4,x});
Controller.type="FUNCTIONAL_HLC_SERVO";
Controller.name="hlc";
Controller.param=Controller;
end

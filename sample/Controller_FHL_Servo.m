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

%newsarvo
Controller_param.F1=[lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt),-0.25];                                % z 
Controller_param.F2=[lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,10,1]),[0.01],dt),-0.9]; % xdiag([100,10,10,1])
Controller_param.F3=[lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,10,1]),[0.01],dt),-0.9]; % ydiag([100,10,10,1])

% Controller_param.F1=lqrd([Ac2,zeros(2,1);-Cc2,0],[Bc2;0],diag([100,1,1]),0.1,dt);                                % 
% Controller_param.F2=lqrd([Ac4,zeros(4,1);-Cc4,0],[Bc4;0],diag([100,100,10,1,0.01]),0.1,dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd([Ac4,zeros(4,1);-Cc4,0],[Bc4;0],diag([100,100,10,1,0.01]),0.1,dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd(Ac2,Bc2,diag([100,10]),0.1,dt);                       % ヨー角 
syms x [3 1] real % Model_EulerAngle_Servoを使う前提
syms sz1 [2 1] real
syms sF1 [1 3] real
Ad1 = [Ad1,zeros(2,1);-Cc2,1];
Bd1 = [Bd1;0];
Controller_param.Vf = matlabFunction([-sF1*[sz1;x(end)], -sF1*(Ad1-Bd1*sF1)*[sz1;x(end)], -sF1*(Ad1-Bd1*sF1)^2*[sz1;x(end)], -sF1*(Ad1-Bd1*sF1)^3*[sz1;x(end)]],"Vars",{sz1,sF1,x});
syms sz2 [4 1] real
syms sF2 [1 5] real
syms sz3 [4 1] real
syms sF3 [1 5] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller_param.Vs = matlabFunction([-sF2*[sz2;x(end-2)];-sF3*[sz3;x(end-1)];-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4,x});

FT =0;%有限整定を使う場合1
if FT == 1
    % 入力のalphaを計算
    anum=4;%変数の数
    alpha=zeros(anum+1,1);
    alpha(anum+1)=1;
    alpha(anum)=0.9;%alphaの初期値

    for a=anum-1:-1:1
        alpha(a)=(alpha(a+2)*alpha(a+1))/(2*alpha(a+2)-alpha(a+1));
    end
    Controller_param.alpha=alpha(anum);
    Controller_param.ax=alpha;
    Controller_param.ay=alpha;
    % Controller_param.az=alpha(anum-1:anum,1);
    % Controller_param.apsi=alpha(anum-1:anum,1);
    %masui
    Controller_param.az=alpha(1:2,1);
    Controller_param.apsi=alpha(1:2,1);

    Controller_param.dt = dt;
     eig(diag([1,1,1],1)-[0;0;0;1]*Controller_param.F2)
    Controller.type="FT";
else
    Controller.type="FUNCTIONAL_HLC_SERVO";
end
    Controller.name="hlc";
    Controller.param=Controller_param;
end

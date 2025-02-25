function Controller = Controller_HL_Suspended_Load(dt,agent)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義
    % 線形化後のシステムの係数行列
        A2 = diag(1,1);
        B2 = [0;1];
        A6 = diag([1,1,1,1,1],1);
        B6 = [0;0;0;0;0;1];
        Controller.P=agent.parameter.get();
    % simとexpでゲインを変える
    if class(agent.plant)~="DRONE_EXP_MODEL"
        % sim用これでないと上手く飛ばない
        % 仮想状態の並び順番は微分階数が小さいものから([h,dh,ddh,...]')
        Controller.F1 = lqrd(A2,B2,diag([100,1]),1,dt);                        % z方向サブシステム, h1^(i) i = 0~1
        Controller.F2 = lqrd(A6,B6,diag([100000,1000,100,10,10,10]),0.01,dt);   % x方向サブシステム, h2^(i) i = 0~5 
        Controller.F3 = lqrd(A6,B6,diag([100000,1000,100,10,10,10]),0.01,dt);   % y方向サブシステム, h3^(i) i = 0~5
        Controller.F4 = lqrd(A2,B2,diag([10,1]),0.1,dt);                        % yaw方向サブシステム, h4^(i) i = 0~1
    else
        % exp用
        Controller.F1 = lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);             %位置z、速度z
        Controller.F2 = lqrd(A6,B6,diag([150000,250000,10000,1,0.001,0.001]),0.08,dt);%より制御周期速くなると0.008とかが良くなると思う．
        Controller.F3 = lqrd(A6,B6,diag([150000,250000,10000,1,0.001,0.001]),0.08,dt);
        Controller.F4 = lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                %yawの位置、速度、100,1,1

 %        %↓ゲイン調整・確認用
 %        At = A6;
 %        Bt = B6;
 %        f2 = lqr(At,Bt,diag([150000,250000,10000,1,0.001,0.001]),0.08);         %質量推定用
 %        pc = eig(At-Bt*f2);
 %        tt = 0.025;
 %        pd = exp(pc*tt);
 %        sysc = ss(At,Bt,eye(6),0);
 %        sysd = c2d(sysc,tt);
 %        [Ad,Bd, ~,~] = ssdata(sysd);
 %        Controller.F2 = place(Ad,Bd,pd);
 %        Controller.F3 = Controller.F2;
 %        %↑ゲイン調整・確認用
    end
    
    Controller.dt = dt;

end

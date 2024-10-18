function Controller = Controller_MPC_HLMC_HL(dt,agent)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    %% HL
    Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
    Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([400,200,10,1]),[0.01],dt); % xdiag([100,10,10,1])
    Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([400,200,10,1]),[0.01],dt); % ydiag([100,10,10,1])
    Controller.F4=lqrd([0 1;0 0],[0;1],diag([200,10]),[0.1],dt); % ヨー角
    Controller.dt = dt;
    eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2);

    %% MPC
    Controller.dt = 0.1; % MPCステップ幅
    Controller.H = 5;
    Controller.Maxparticle_num = 1000; % 100000
    Controller.particle_num = Controller.Maxparticle_num;
    Controller.Minparticle_num = Controller.Maxparticle_num; % 2000でも動く　怪しい

    % Controller.constParticle_num = 100000;
    Controller.input.Initsigma = 1*[2,1,1,1];
    Controller.input.Constsigma = 100 * [0.01, 1,1,1];
    Controller.input.Maxsigma = 10 * [0.1,1,1,1]; % 10 0.3452
    Controller.input.Minsigma = 0.5 * [0.1,1,1,1];
    Controller.input.Maxinput = 1.5;
    Controller.input.Constinput = 10;

    %% polynomial#############################
    z0 = agent.estimator.result.state.p(3); % z初期値
    ze = 0; % z収束値 -0.5
    v0 = 0; % 初期速度
    ve = 0; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1

    delayTime = 10; % かける時間 : 2sで落下＋移動
    t = 0:0.025:delayTime+1;
    Controller.reference.polynomial.Z = curve_interpolation_9order(t',delayTime,z0,v0,ze,ve);

    x0 = agent.estimator.result.state.p(1); % -1
    xe = 0;
    v0 = 0;
    ve = 0;
    % teref = 1.5;
    delay = 0;
    Controller.reference.polynomial.X = curve_interpolation_9order(t'-delay,delayTime,x0,v0,xe,ve);

    v0 = 0;
    y0 = agent.estimator.result.state.p(2);
    ye = 0;
    Controller.reference.polynomial.Y = curve_interpolation_9order(t',delayTime,y0,v0,ye,ve);
    %#########################################

    Controller.input.range = 50; % 50
    % Controller.input.Maxsigma = 5 * [0.01,1,1,1]; % 10
    % Controller.input.Minsigma = 0.1 * [0.001,1,1,1];

    Controller.ConstEval = 1e8; % / Controller.H;
     
    Controller.constX = 2;
    Controller.constY = 0;
    Controller.constZ = 0;

    % Controller.constX2 = 8;
    % Controller.constY2 = -1;
    % Controller.constZ2 = 0;

    Controller.obsX = 3;
    Controller.obsY = 0.1;

    Controller.total_size = 16;
    Controller.state_size = 12;
    Controller.input_size = 4;

    %% sekiguchi-komatsu new
    % Controller.Z = 1 * diag([100; 10]);% * 1e3; %2
    % Controller.X = 1e3 * diag([10000,1,1,1]);% * 1e3;%4
    % Controller.Y = Controller.X;% * 1e3;
    % Controller.PHI = 1e-1 * diag([10000; 100]);
    % Controller.Zf = Controller.Z;
    % Controller.Xf = Controller.X; % 制約時のみ * 1000
    % Controller.Yf = Controller.X;
    % Controller.PHIf = Controller.PHI;

    % 最新 2024/1/11　時点いい重み 
    % Controller.Z = 1 * diag([10; 10]);% * 1e3; %2
    % Controller.X = 1e3 * diag([1000,10000,1,1]);% 1e2でも結構いい感じ
    % Controller.Y = Controller.X;% * 1e3;
    % Controller.PHI = 1* diag([100; 1]);
    % 
    % Controller.Zf = 1e3 * diag([1000; 100]);
    % Controller.Xf = Controller.X; % 制約時のみ * 1000
    % Controller.Yf = Controller.X;
    % Controller.PHIf = Controller.PHI;

    %% 
    Controller.Z = 1e2 * diag([1000; 10]);% * 1e3; %2
    Controller.X = 1e5 * diag([1000;10;1;1]);% 1e2でも結構いい感じ
    Controller.Y = Controller.X;% * 1e3;
    Controller.PHI = 1* diag([100; 1]);

    Controller.Zf = 1e3 * diag([1000; 100]);
    Controller.Xf = Controller.X; % 制約時のみ * 1000
    Controller.Yf = Controller.X;
    Controller.PHIf = Controller.PHI;


    Controller.AP = 1e3; % どれくらい距離をとる必要があるか

    Controller.R = 1e-5 * diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller.RP = 1e-1 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    
    Controller.input.u = agent.parameter.mass * 9.81 * [0;0;0;0]; %  sekiguchi 
    Controller.ref_input = agent.parameter.mass * 9.81 * [0;0;0;0];

    Controller.const = 1e6;

    %%  

    Controller.name = "mcmpc"; % HLでもMCだから
    Controller.type = "HLMCMPC_CONTROLLER"; % file
    % Controller.param = Controller_param;
end
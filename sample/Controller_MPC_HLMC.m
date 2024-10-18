function Controller = Controller_MPC_HLMC(agent)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 5;
    Controller_param.Maxparticle_num = 5000; % 100000
    Controller_param.particle_num = Controller_param.Maxparticle_num;
    Controller_param.Minparticle_num = Controller_param.Maxparticle_num; % 2000でも動く　怪しい

    % Controller_param.constParticle_num = 100000;
    Controller_param.input.Initsigma = 1*[2,1,1,1];
    Controller_param.input.Constsigma = 100 * [0.01, 1,1,1];
    Controller_param.input.Maxsigma = 10 * [0.1,1,1,1]; % 10 0.3452
    Controller_param.input.Minsigma = 0.5 * [0.1,1,1,1];
    Controller_param.input.Maxinput = 1.5;
    Controller_param.input.Constinput = 10;

    %% polynomial#############################
    z0 = agent.estimator.result.state.p(3); % z初期値
    ze = 0; % z収束値 -0.5
    v0 = 0; % 初期速度
    ve = 0; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1

    delayTime = 10; % かける時間 : 2sで落下＋移動
    t = 0:0.025:delayTime+1;
    Controller_param.reference.polynomial.Z = curve_interpolation_9order(t',delayTime,z0,v0,ze,ve);

    x0 = agent.estimator.result.state.p(1); % -1
    xe = 0;
    v0 = 0;
    ve = 0;
    % teref = 1.5;
    delay = 0;
    Controller_param.reference.polynomial.X = curve_interpolation_9order(t'-delay,delayTime,x0,v0,xe,ve);

    v0 = 0;
    y0 = agent.estimator.result.state.p(2);
    ye = 0;
    Controller_param.reference.polynomial.Y = curve_interpolation_9order(t',delayTime,y0,v0,ye,ve);
    %#########################################

    Controller_param.input.range = 50; % 50
    % Controller_param.input.Maxsigma = 5 * [0.01,1,1,1]; % 10
    % Controller_param.input.Minsigma = 0.1 * [0.001,1,1,1];

    Controller_param.ConstEval = 1e8; % / Controller_param.H;
     
    Controller_param.constX = 2;
    Controller_param.constY = 0;
    Controller_param.constZ = 0;

    % Controller_param.constX2 = 8;
    % Controller_param.constY2 = -1;
    % Controller_param.constZ2 = 0;

    Controller_param.obsX = 3;
    Controller_param.obsY = 0.1;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% sekiguchi-komatsu new
    % Controller_param.Z = 1 * diag([100; 10]);% * 1e3; %2
    % Controller_param.X = 1e3 * diag([10000,1,1,1]);% * 1e3;%4
    % Controller_param.Y = Controller_param.X;% * 1e3;
    % Controller_param.PHI = 1e-1 * diag([10000; 100]);
    % Controller_param.Zf = Controller_param.Z;
    % Controller_param.Xf = Controller_param.X; % 制約時のみ * 1000
    % Controller_param.Yf = Controller_param.X;
    % Controller_param.PHIf = Controller_param.PHI;

    % 最新 2024/1/11　時点いい重み 
    % Controller_param.Z = 1 * diag([10; 10]);% * 1e3; %2
    % Controller_param.X = 1e3 * diag([1000,10000,1,1]);% 1e2でも結構いい感じ
    % Controller_param.Y = Controller_param.X;% * 1e3;
    % Controller_param.PHI = 1* diag([100; 1]);
    % 
    % Controller_param.Zf = 1e3 * diag([1000; 100]);
    % Controller_param.Xf = Controller_param.X; % 制約時のみ * 1000
    % Controller_param.Yf = Controller_param.X;
    % Controller_param.PHIf = Controller_param.PHI;

    %% 
    Controller_param.Z = 1e2 * diag([1000; 10]);% * 1e3; %2
    Controller_param.X = 1e5 * diag([1000;10;1;1]);% 1e2でも結構いい感じ
    Controller_param.Y = Controller_param.X;% * 1e3;
    Controller_param.PHI = 1* diag([100; 1]);

    Controller_param.Zf = 1e3 * diag([1000; 100]);
    Controller_param.Xf = Controller_param.X; % 制約時のみ * 1000
    Controller_param.Yf = Controller_param.X;
    Controller_param.PHIf = Controller_param.PHI;


    Controller_param.AP = 1e3; % どれくらい距離をとる必要があるか

    Controller_param.R = 1e-5 * diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller_param.RP = 1e-1 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    
    Controller_param.input.u = agent.parameter.mass * 9.81 * [0;0;0;0]; %  sekiguchi 
    Controller_param.ref_input = agent.parameter.mass * 9.81 * [0;0;0;0];

    Controller_param.const = 1e6;

    %%  

    Controller.name = "mcmpc"; % HLでもMCだから
    Controller.type = "HLMCMPC_CONTROLLER"; % file
    Controller.param = Controller_param;
end
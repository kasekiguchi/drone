function Controller = Controller_HLMCMPC(~)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;
    Controller_param.Maxparticle_num = 1000; % 100000
    Controller_param.particle_num = Controller_param.Maxparticle_num;
    Controller_param.Minparticle_num = Controller_param.Maxparticle_num; % 2000でも動く　怪しい

    % Controller_param.constParticle_num = 100000;
    Controller_param.input.Initsigma = 1*[2,1,1,1];
    Controller_param.input.Constsigma = 100 * [0.01, 1,1,1];
    Controller_param.input.Maxsigma = 10 * [0.1,1,1,1]; % 10 0.3452
    Controller_param.input.Minsigma = 5 * [0.1,1,1,1];
    Controller_param.input.Maxinput = 1.5;
    Controller_param.input.Constinput = 10;

    Controller_param.input.range = 50; % 50
    % Controller_param.input.Maxsigma = 5 * [0.01,1,1,1]; % 10
    % Controller_param.input.Minsigma = 0.1 * [0.001,1,1,1];

    Controller_param.ConstEval = 1e8; % / Controller_param.H;
     
    Controller_param.constX = 2;
    Controller_param.constY = 0;

    Controller_param.obsX = 3;
    Controller_param.obsY = 0.1;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% sekiguchi
    % z, x, y, yaw : 誤差、誤差の変化量、微分、微分、、、 
%     Controller_param.P = diag([10000;100]);   
%     Controller_param.V = diag([1,1,1,1,1,1,1,1])*100;   
%     Controller_param.QW = diag([1000 1]); 
%     Controller_param.Pf = diag([10000;100]);   
%     Controller_param.Vf = diag([1,1,1,1,1,1,1,1])*100;   
%     Controller_param.QWf = diag([1000 1]);  

    %% sekiguchi-komatsu new
    Controller_param.Z = diag([100; 1000]) * 1e3; %2
    Controller_param.X = diag([100,100,1,1]) * 1e0;%4
    Controller_param.Y = diag([100,100,1,1]) * 1e0;
    Controller_param.PHI = diag([10000; 100]);

    Controller_param.Zf = Controller_param.Z;
    Controller_param.Xf = Controller_param.X; % 制約時のみ * 1000
    Controller_param.Yf = Controller_param.Y;
    Controller_param.PHIf = Controller_param.PHI;

    Controller_param.AP = 1e3;

    % Controller_param.Zf = diag([1e6; 1]);
    % Controller_param.Xf = 1e6 * diag([1e5,1e2,1,1]);
    % Controller_param.Yf = diag([1e5,1,1,1]);
    % Controller_param.PHIf = diag([1; 1]);

    Controller_param.R = 1e-5 * diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller_param.RP = 1e-1 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    
    Controller_param.input.u = 0.269 * 9.81 * [0;0;0;0]; %  sekiguchi 
    Controller_param.ref_input = 0.269 * 9.81 * [0;0;0;0];

    Controller_param.const = 1e6;

    %%  

    Controller.name = "mcmpc"; % HLでもMCだから
    Controller.type = "HLMCMPC_controller";
    % Controller.type = "HLMCMPC_controller_mex"; % 1000万回計算用
    % Controller.type = "HLMCMPC_controller_gpu";
    % Controller.type = "HLMCMPC_controller_change"; % 複数回入力算出
    Controller.param = Controller_param;

end
function Controller = Controller_MPC_HLMC_fromN(dt)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    %% HL
    Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
    Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([5000,5000,2000,10]),0.001,dt); % xdiag([100,10,10,1])
    Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([5000,5000,2000,10]),0.001,dt); % ydiag([100,10,10,1])
    Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt); 
    Controller.dt = dt;
    eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2);

    Controller.dt = 0.1; % MPCステップ幅
    Controller.H = 10;
    Controller.particle_num = 2000;

    % Controller.constParticle_num = 100000;
    Controller.input.sigma = 1*[0.1,1,1,1];
    Controller.input.Maxsigma = 10 * [0.1,1,1,1]; % 10 0.3452
    Controller.input.Minsigma = 0.1 * [0.1,1,1,1];
    Controller.input.range = [[10;20;20;1], 1e-1*[0.1;1;1;0.1]]; % max min
    Controller.input.input_TH = Controller.input.range(:,1); % 初期値の設定
    Controller.input.Bestcost_now = [1e1, 1e-5, 1e-5, 1e-5, 1e-5];

    Controller.total_size = 16;
    Controller.state_size = 12;
    Controller.input_size = 4;

    Controller.input.lb = [0; -1; -1; -1];
    Controller.input.ub = [10; 1;  1;  1];

    %% 
    Controller.Z = 1e3 * diag([1000; 10]);% * 1e3; %2 %1e3 10
    Controller.X = 1e3 * diag([100;10;1;1]);% 1e2でも結構いい感じ %1e3 1e1
    Controller.Y = Controller.X;% * 1e3;
    Controller.PHI = 1* diag([100; 1]);

    Controller.Zf = 1e3 * diag([1000; 10]);
    Controller.Xf = Controller.X; % 制約時のみ * 1000
    Controller.Yf = Controller.X;
    Controller.PHIf = Controller.PHI;

    % Controller.Z = 1e1 * diag([1; 1]);% * 1e3; %2 %1e3 10
    % Controller.X = 1e1 * diag([10;1;1;1]);% 1e2でも結構いい感じ %1e3 1e1
    % Controller.Y = Controller.X;% * 1e3;
    % Controller.PHI = 1* diag([1; 1]);
    % 
    % Controller.Zf = 1e1 * diag([1; 1]);
    % Controller.Xf = Controller.X; % 制約時のみ * 1000
    % Controller.Yf = Controller.X;
    % Controller.PHIf = Controller.PHI;


    Controller.AP = 1e3; % どれくらい距離をとる必要があるか

    Controller.R = 1e-2 * diag([1.0; 1*[1.0; 1.0; 1.0]]); % -5
    % Controller.RP = 1e-1 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    Controller.RP = 1e1 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    
    Controller.input.u = [0;0;0;0]; %  sekiguchi 
    Controller.ref_input = [0;0;0;0];

    %%  
    disp('MCMPC using HL model')
    % 
    % Controller.name = "mcmpc"; % HLでもMCだから
    % Controller.type = "HLMCMPC_CONTROLLER"; % file
    % Controller.param = Controller;
end
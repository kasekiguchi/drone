function Controller = Controller_HLMPC(~)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;

    Controller_param.ConstEval = 100000;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    Controller_param.input_TH = 50;
    % Controller_param.input_max = 1;
    Controller_param.Z_max = 50;

    %% sekiguchi-komatsu new
    Controller_param.Z = 1e2*diag([100; 1]);
    Controller_param.X = 1e4*diag([100,10,1,1]);
    Controller_param.Y = 1e4*diag([100,10,1,1]);
    Controller_param.PHI = diag([1; 1]);

    Controller_param.Zf = diag([1; 1]);
    Controller_param.Xf = diag([1,1,1,1]);
    Controller_param.Yf = diag([10000,10000,1,1]);
    Controller_param.PHIf = diag([1; 1]);

    Controller_param.R = diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller_param.RP = 1e2 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    
    Controller_param.input.u = [0;0;0;0]; %  sekiguchi 
    Controller_param.ref_input = [0;0;0;0];

    % Controller.name = "mcmpc";
    Controller.name = "hlmpc";
    Controller.type = "HLMPC_controller";
    % Controller.type = "HLMPC_controller_QP";
    Controller.param = Controller_param;

end
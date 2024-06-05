function Controller = Controller_MPC_HL(~)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    Controller_param.dt = 0.1; % MPCステップ幅
    Controller_param.H = 10;

    Controller_param.ConstEval = 100000;

    Controller_param.total_size = 16;
    Controller_param.state_size = 12;
    Controller_param.input_size = 4;

    %% sekiguchi-komatsu new
    Controller_param.Z = 1e2*diag([100; 1]);
    Controller_param.X = 1e4*diag([1000,10,1,1]);
    Controller_param.Y = 1e4*diag([1000,10,1,1]);
    Controller_param.PHI = diag([1; 1]);

    Controller_param.Zf = diag([1; 1]);
    Controller_param.Xf = diag([1,1,1,1]);
    Controller_param.Yf = diag([1,1,1,1]);
    Controller_param.PHIf = diag([1; 1]);

    Controller_param.R = diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller_param.RP = 1e2 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 

    Controller_param.input.u = [0;0;0;0];  % 仮想入力
    input_th = 30;
    Controller_param.input_max = [ input_th; input_th; input_th; input_th];
    Controller_param.input_min = [-input_th;-input_th;-input_th;-input_th];
    % Controller_param.torque_TH = 2;
    
    Controller_param.input.u = [0;0;0;0]; %  sekiguchi 
    Controller_param.ref_input = [0;0;0;0];

    %% change equation 
    switch Controller_param.H
        case 10
            Controller_param.change_equation_func = @change_equation_mex_H10;
        case 20
            Controller_param.change_equation_func = @change_equation_mex_H20;
        otherwise
            error('No selected change_equation');
    end

%     Controller.name = "mcmpc";
    Controller.name = "hlmpc";
    Controller.type = "HLMPC_CONTROLLER";
    Controller.param = Controller_param;

end
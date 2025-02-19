function Controller = Controller_MPC_HL(dt)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
%% HL
    Controller = Controller_HL(dt);

    Controller.dt = 0.1; % MPCステップ幅
    Controller.H = 10;

    Controller.ConstEval = 100000;

    Controller.total_size = 16;
    Controller.state_size = 12;
    Controller.input_size = 4;

    %% sekiguchi-komatsu new
    Controller.Z = 1e2*diag([100; 1]);
    Controller.X = 1e4*diag([1000,10,1,1]);
    Controller.Y = 1e4*diag([1000,10,1,1]);
    Controller.PHI = diag([1; 1]);

    Controller.Zf = diag([1; 1]);
    Controller.Xf = diag([1,1,1,1]);
    Controller.Yf = diag([1,1,1,1]);
    Controller.PHIf = diag([1; 1]);

    Controller.R = diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller.RP = 1e2 * diag([1.0; 1*[1.0; 1.0; 1.0]]); 

    Controller.input.u = [0;0;0;0];  % 仮想入力
    input_th = 30;
    Controller.input.ub = [ input_th; input_th; input_th; input_th];
    Controller.input.lb = [-input_th;-input_th;-input_th;-input_th];
    % Controller.torque_TH = 2;
    
    Controller.input.u = [0;0;0;0]; %  sekiguchi 
    Controller.ref_input = [0;0;0;0];

    %% change equation 
    % switch Controller.H
    %     case 10
    %         Controller.change_equation_func = @change_equation_mex_H10;
    %     case 20
    %         Controller.change_equation_func = @change_equation_mex_H20;
    %     otherwise
    %         error('No selected change_equation');
    % end

%     Controller.name = "mcmpc";
    Controller.name = "hlmpc";
    Controller.type = "HLMPC_CONTROLLER";
    % Controller.param = Controller;

end
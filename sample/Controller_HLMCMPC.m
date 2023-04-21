function Controller = Controller_HLMCMPC(~)
%UNTITLED この関数の概要をここに記述
%   HLをモデルとしたMCMPC
    Controller_param.dt = 0.025; % MPCステップ幅
    Controller_param.H = 15;
    Controller_param.Maxparticle_num = 10000;
    Controller_param.particle_num = Controller_param.Maxparticle_num;
    Controller_param.Minparticle_num = 10000;
    Controller_param.input.Initsigma = 0.02*[1,1,1,1];
    Controller_param.input.Constsigma = 5.0;
    Controller_param.input.Maxsigma = 2.0;
    Controller_param.input.Minsigma = 1.0;
    Controller_param.input.Maxinput = 1.5;

    Controller_param.ConstEval = 100000;
     
    Controller_param.const.X = -0.5;
    Controller_param.const.Y = -0.5;

    Controller_param.obsX = 3;
    Controller_param.obsY = 0;

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
    Controller_param.Z = 1e2*diag([100; 1]);
    Controller_param.X = 1e4*diag([100,1,1,1]);
    Controller_param.Y = 1e4*diag([100,1,1,1]);
    Controller_param.PHI = diag([1; 1]);

    Controller_param.Zf = diag([1; 1]);
    Controller_param.Xf = diag([1,1,1,1]);
    Controller_param.Yf = diag([1,1,1,1]);
    Controller_param.PHIf = diag([1; 1]);

    Controller_param.R = diag([1.0; 1*[1.0; 1.0; 1.0]]);
    Controller_param.RP = diag([1.0; 1*[1.0; 1.0; 1.0]]); 
    
    Controller_param.input.u = [0;0;0;0]; %  sekiguchi 
    Controller_param.ref_input = [0;0;0;0];

    Controller.name = "mcmpc";
    Controller.type = "HLMCMPC_controller_change";
    Controller.param = Controller_param;

end
function Model = Model_EulerAngle_Expand(dt, initial, id)
% quadcopter model : euler angle
%         dt             % サンプリング間隔
%         param % 制御対象か制御モデルか
%         initial        % 初期値
%         id             % 個体識別番号
arguments
    dt             % サンプリング間隔
    initial        % 初期値
    id             % 個体識別番号
end
Model.id = id;
Model.type = "Euler_Angle_Expand_Model";                 % model name
Model.name = "Expand";                            % print name
Setting.dim = [14, 4, 17];
Setting.method = get_model_name("RPY 14"); % model dynamicsの実体名
Setting.state_list = ["p", "q", "v", "w","Trs"];
Setting.initial = initial;                 % struct('p', [0; 0; 0], 'q', [0; 0; 0], 'v', [0; 0; 0], 'w', [0; 0; 0]);
Setting.num_list = [3, 3, 3, 3, 2];
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","rotor_r"];
end

function Model = Model_EulerAngle(dt, initial, id)
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
Model.type = "EULER_ANGLE_MODEL";                 % model name
Model.name = "euler";                            % print name
Setting.dim = [12, 4, 17];
Setting.method = get_model_name("RPY 12"); % model dynamicsの実体名
Setting.state_list = ["p", "q", "v", "w"];
Setting.initial = initial;                 % struct('p', [0; 0; 0], 'q', [0; 0; 0], 'v', [0; 0; 0], 'w', [0; 0; 0]);
Setting.num_list = [3, 3, 3, 3];
Setting.dt = dt;
Model.parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","rotor_r"];
parameter = DRONE_PARAM("x");
Setting.param = parameter.get(Model.parameter_name);
Model.param = Setting;
end


function Model = Model_EulerAngle_Servo(dt, initial, id)
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
%Model.type = "MODEL_CLASS";                 % model name
Model.name = "euler_servo";                            % print name
Setting.dim = [15, 4, 17]; % number of [state, input, parameter]
Setting.input_channel = ["v", "w"];
method = str2func(get_model_name("RPY 12")); % model dynamicsの実体名
Setting.method = @(x,u,p) [method(x,u,p);x(1:3)]; % model dynamicsの実体名
Setting.state_list = ["p", "q", "v", "w", "z"];
Setting.initial = initial;
Setting.initial.z = [0;0;0];                 % struct('p', [0; 0; 0], 'q', [0; 0; 0], 'v', [0; 0; 0], 'w', [0; 0; 0]);
Setting.num_list = [3, 3, 3, 3, 3];
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","rotor_r"];
end

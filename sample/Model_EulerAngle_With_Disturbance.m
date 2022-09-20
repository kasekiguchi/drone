function Model = Model_EulerAngle_With_Disturbance(dt, initial, id)
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
    Model.name = "euler";                            % print name
    Setting.dim = [12, 4, 17];
    Setting.input_channel = ["v", "w"];
    Setting.method = get_model_name("RPYdst"); % model dynamicsの実体名
    Setting.state_list = ["p", "q", "v", "w"];
    Setting.initial = initial;                 % struct('p', [0; 0; 0], 'q', [0; 0; 0], 'v', [0; 0; 0], 'w', [0; 0; 0]);
    Setting.num_list = [3, 3, 3, 3];
    Setting.dt = dt;
    Model.param = Setting;
    Model.parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","rotor_r","B"];

end

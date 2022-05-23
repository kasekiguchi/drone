function Model = Model_EulerAngle(dt, plant_or_model, initial, id)
    % quadcopter model : euler angle
    %         dt             % サンプリング間隔
    %         plant_or_model % 制御対象か制御モデルか
    %         initial        % 初期値
    %         id             % 個体識別番号
    arguments
        dt             % サンプリング間隔
        plant_or_model % 制御対象か制御モデルか
        initial        % 初期値
        id             % 個体識別番号
    end
    Model.id = id;
    Model.type = "EULER_ANGLE_MODEL";                 % model name
    %Model.type = "MODEL_CLASS";                 % model name
    Model.name = "euler";                            % print name
    Setting.dim = [12, 4, 17];
    Setting.input_channel = ["v", "w"];
    Setting.method = get_model_name("RPY 12"); % model dynamicsの実体名
    Setting.state_list = ["p", "q", "v", "w"];
    Setting.initial = initial;                 % struct('p', [0; 0; 0], 'q', [0; 0; 0], 'v', [0; 0; 0], 'w', [0; 0; 0]);
    Setting.num_list = [3, 3, 3, 3];
    Setting.dt = dt;
    if strcmp(plant_or_model, "plant")
        Setting.param = getParameter("Plant"); % モデルの物理パラメータ設定
    else
        Setting.param = getParameter();        % モデルの物理パラメータ設定
    end
    Model.param = Setting;
end

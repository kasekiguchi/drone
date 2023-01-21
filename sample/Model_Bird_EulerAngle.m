function Model = Model_Bird_EulerAngle(dt,initial,id)
% bird model : euler angle
% dt        % サンプリング間隔
% param     % 制御対象か制御モデルか
% initial   % 初期値
% id        % 個体識別番号
arguments
    dt
    initial
    id
end
Model.type = "EULER_BIRD_MODEL"; % class name
Model.name = "bird"; % print name
Model.id = id;
Setting.dim = [12, 4, 17];
Setting.input_channel = ["v","w"];
Setting.method = get_model_name("Bird"); % model dynamicsの実体名
Setting.initial = initial;
Setting.state_list = ["p","q","v","w"];
Setting.num_list = [3,3,3,3];
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4","rotor_r"];
end


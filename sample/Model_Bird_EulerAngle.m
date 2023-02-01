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
Setting.dim = [6, 3, 6];
Setting.input_channel = ["v"];
Setting.method = get_model_name("Bird"); % model dynamicsの実体名
Setting.initial = initial;
Setting.state_list = ["p","v"];
Setting.num_list = [3,3];
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["Ax","Ay","Az","Avx","Avy","Avz"];
end


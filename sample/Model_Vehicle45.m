function Model = Model_Vehicle45(dt,initial,id)
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
Model.type="VEHICLE_MODEL"; % class name
%---For a alpha model---%
% Model.name="vehicle5"; % print name
% Setting.dim=[5,2,0];
% Setting.input_channel= ["a","aa"];
% Setting.method = 'vehicle_accel_angularacceleration_input_model'; % model dynamicsの実体名
% Setting.state_list =  ["p","q",'v','w'];
% Setting.num_list = [2,1,1,1];
%---------------------------%
%---入力がaとomegaのモデル---%
Model.name="vehicle4"; % print name
Setting.dim=[4,2,0];
Setting.input_channel= ["a","w"];
Setting.method = "vehicle_accel_omega_input_model"; % model dynamicsの実体名
Setting.state_list =  ["p","q",'v'];
Setting.num_list = [2,1,1];
%---------------------------%
Setting.initial = initial;
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Lx","Ly","lx","ly","jz","gravity"];


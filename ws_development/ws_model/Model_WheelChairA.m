function Model = Model_WheelChairA(dt,initial,id)
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
Model.type="Wheelchair_Model"; % class name
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
Setting.method = 'vehicle_accel_omega_input_model'; % model dynamicsの実体名
Setting.state_list =  ["p","q",'v'];
Setting.num_list = [2,1,1];
%---------------------------%
Setting.initial = initial;
Setting.dt = dt;
Model.param = Setting;
Model.parameter_name = ["mass","Lx","Ly","lx","ly","jz","gravity"];

if strcmp(type,"plant")
%     for i = 1:N
        Model.id = i;
%         Setting.initial.p = [0;0];
        Setting.param.K = diag([0.9,1]);%誤差の値
        Setting.param.D = 0.1;%0.1;%誤差の値
        Model.param=Setting;
%         assignin('base',"Plant",Model);
%         evalin('base',"agent(Plant.id) = Drone(Plant)");
%     end
else
%     for i = 1:N
        Setting.param.K = diag([1,1]);
        Setting.param.D = 0.1;%0.15;%誤差の値
        Model.param=Setting;
%         assignin('base',"Model",Model);
%         model_set_str=strcat("agent(",string(i),").set_model(Model)");
%         evalin('base',model_set_str);
%     end
end

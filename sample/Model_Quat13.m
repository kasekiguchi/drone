function Model_Quat13(N,dt,type,varargin)
% model class demo : quaternion model with 13 states
if ~isempty(varargin)
    Setting = varargin{1};
end
Model.type="Quat13_Model"; % class name
Model.name="quat"; % print name
Setting.dim=[13,4,10];
Setting.input_channel = ["v","w"];
Setting.method = get_model_name("Quat 13"); % model dynamicsの実体名
Setting.state_list =  ["q","p","v","w"];
Setting.initial = struct('p',[0;0;0],'q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0]);
Setting.num_list = [4,3,3,3];
Setting.dt = dt;
if strcmp(type,"plant")
    for i = 1:N
        Model.id = i;
        Setting.param = getParameter("Plant"); % モデルの物理パラメータ設定
        Setting.initial.p = 10*rand(3,1)+[40;20;0];
        Model.param=Setting;
        assignin('base',"Plant",Model);
        evalin('base',"agent(Plant.id) = Drone(Plant)");
    end
else
    for i = 1:N
        Setting.param = getParameter(); % モデルの物理パラメータ設定
        Model.param=Setting;
        assignin('base',"Model",Model);
        model_set_str=strcat("agent(",string(i),").set_model(Model)");
        evalin('base',model_set_str);
    end
end

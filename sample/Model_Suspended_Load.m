function Model_Suspended_Load(N,dt,type,varargin)
% model class demo : quaternion model with 13 states
if ~isempty(varargin)
    Setting = varargin{1};
end
Model.type="Suspended_Load_Model"; % class name
Model.name="load"; % print name
Setting.dim=[25,4,16];
Setting.input_channel = ["f","M"];
Setting.method = get_model_name("Load"); % model dynamicsの実体名
Setting.state_list =  ["p","q","v","w","pL","vL","pT","wL"];
Setting.initial = struct('p',[0;0;0],'q',[1;0;0;0],'v',[0;0;0],'w',[0;0;0],"pL",[0;0;0],"vL",[0;0;0],"pT",[0;0;-1],"wL",[0;0;0]);
Setting.num_list = [3,4,3,3,3,3,3,3];
% Setting.type="compact"; % unit quaternionr
Setting.dt = dt;
Setting.param = getParameter_withload; % モデルの物理パラメータ設定
if strcmp(type,"plant")
    for i = 1:N
        Model.id = i;
        Setting.param = getParameter_withload("Plant"); % モデルの物理パラメータ設定
        Setting.initial.p = 10*rand(3,1)+[40;20;0];
        Model.param=Setting;
        assignin('base',"Plant",Model);
        evalin('base',"agent(Plant.id) = Drone(Plant)");
    end
else
    for i = 1:N
        Model.param=Setting;
        assignin('base',"Model",Model);
        model_set_str=strcat("agent(",string(i),").set_model(Model)");
        evalin('base',model_set_str);
    end
end
%%%
Model.type="EulerAngle_Model"; % class name
%Model.name="euler"; % print name
Setting.dim=[12,4,10];
Setting.input_channel = ["v","w"];
Setting.method = get_model_name("RPY 12"); % model dynamicsの実体名
Setting.state_list =  ["p","q","v","w"];
Setting.initial = struct('p',[0;0;0],'q',[0;0;0],'v',[0;0;0],'w',[0;0;0]);
Setting.num_list = [3,3,3,3];
Setting.dt = dt;
if strcmp(type,"plant")
    for i = 1:N
        Model.id = i;
        Setting.param = getParameter("Plant"); % モデルの物理パラメータ設定
        Setting.initial.p = 10*rand(3,1)+[40;20;0];
        Model.param=Setting;
        assignin('base',"Plant",Model);
        evalin('base',"sload(Plant.id) = Drone(Plant);");
    end
else
    for i = 1:N
        Setting.param = getParameter(); % モデルの物理パラメータ設定
        Model.param=Setting;
        assignin('base',"Model",Model);
        model_set_str=strcat("sload(",string(i),").set_model(Model)");
        evalin('base',model_set_str);
    end
end
end

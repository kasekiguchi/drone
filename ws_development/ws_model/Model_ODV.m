function Model = Model_ODV(i,dt,type,initial,varargin)
% model class demo : quaternion model with 13 states
if ~isempty(varargin)
    Setting = varargin{1};
end
Model.type="ODV_Model"; % class name
%Model.name="euler"; % print name
Setting.dim=[3,3,0];
Setting.input_channel = ["vx","vy","w"];
Setting.method = 'OmniDirectionalVehicle_model'; % model dynamicsの実体名
Setting.initial = initial;
Setting.state_list =  ["p","q"];
Setting.num_list = [2,1];
Setting.dt = dt;
if strcmp(type,"plant")
        Model.id = i;
%         Setting.initial.p = [0;0];
        Setting.param.K = 1;
        Model.param=Setting;
%         assignin('base',"Plant",Model);
%         evalin('base',"agent(Plant.id) = Drone(Plant)");
else
        Setting.param.K = 0.9;
        Model.param=Setting;
%         assignin('base',"Model",Model);
%         model_set_str=strcat("agent(",string(i),").set_model(Model)");
%         evalin('base',model_set_str);
end

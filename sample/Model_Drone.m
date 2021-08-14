function Model = Model_Drone(id,dt,type,initial,varargin)
%% model class demo : 
% "Discrete" "Point mass"    "Quat 13"    "point2"    "RPY 12"    "R 18"    "Quat 17";
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
Setting.param.A =eye(3);             %離散かしたもの
Setting.param.B = eye(3);
Model.type="Drone_Model"; % class name
Model.name="discrete"; % print name
Setting.dim = [3,3,0];
Setting.input_channel = ["p","q"];
Setting.method = get_model_name("Drone_Pestbirds"); % model dynamicsの実体名
Setting.initial = initial;%struct('p',[0;0;0]);
Setting.state_list = ["p"];
Setting.num_list = [3];
Setting.input_channel = ["p"];
if strcmp(type,"plant")
        Model.id = id;
%         Setting.initial.p = 10*rand(3,1)+[40;20;0];
        Model.param=Setting;
%         assignin('base',"Plant",Model);
%         evalin('base',"agent(Plant.id) = Drone(Plant)");
else
%         Model.name=["dog"];
        Model.param=Setting;
%         assignin('base',"Model",Model);
%         model_set_str=strcat("agent(",string(i),").set_model(Model)");
%         evalin('base',model_set_str);      
end

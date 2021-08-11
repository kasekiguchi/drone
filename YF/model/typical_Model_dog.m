function typical_Model_dog(N,Na,dt,type,varargin)
%% model class demo : 
% "Discrete" "Point mass"    "Quat 13"    "point2"    "RPY 12"    "R 18"    "Quat 17";
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
Setting.param.A =eye(3);             %離散かしたもの
Setting.param.B = eye(3);
Model.type="dog_Model"; % class name
Model.name="discrete"; % print name
Setting.dim = [3,3,0];
Setting.method = get_model_name("Ydog"); % model dynamicsの実体名
Setting.initial = struct('p',[0;0;0]);
Setting.state_list = ["p"];
Setting.num_list = [3];
Setting.input_channel = ["p"];
if strcmp(type,"plant")
    for i = N-Na+1:N
        Model.id = i;
        Setting.initial.p = 10*rand(3,1)+[40;20;0];
        Model.param=Setting;
        assignin('base',"Plant",Model);
        evalin('base',"agent(Plant.id) = Drone(Plant)");
    end
else
    for i =  N-Na+1:N
%         Model.name=["dog"];
        Model.param=Setting;
        assignin('base',"Model",Model);
        model_set_str=strcat("agent(",string(i),").set_model(Model)");
        evalin('base',model_set_str);      
    end

end

function typical_Model_human_6para(N,dt,type,varargin)
%% model class demo : 
% "Discrete" "Point mass"    "Quat 13"    "point2"    "RPY 12"    "R 18"    "Quat 17";
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
A = [0 0 1 0 0 0;...
     0 0 0 1 0 0;...
     0 0 0 0 1 0;...
     0 0 0 0 0 1;...
     0 0 0 0 0 0;...
     0 0 0 0 0 0];
 
B = [1 0 1 0 0 0;...
     0 1 0 1 0 0;...
     0 0 1 0 0 0;...
     0 0 0 1 0 0;...
     0 0 0 0 1 0;...
     0 0 0 0 0 1];
 C = eye(6);D = eye(6);
  %%
 sysd = c2d(ss(A,B,A,0),dt);
 
Setting.param.A =sysd.A;             %離散かしたもの


Setting.param.B = sysd.B;
Model.type="human_Model"; % class name
Model.name="human"; % print name
Setting.dim = [2,2,2];
Setting.method = get_model_name("Yhuman"); % model dynamicsの実体名
Setting.initial = struct('p',[0;0],'v',[0;0],'a',[0;0]);
Setting.state_list = ["p","v","a"];
Setting.num_list = [2,2,2];
Setting.input_channel = ["a"];
if strcmp(type,"plant")
    for i = 1:N
    Model.id = i;
    Setting.initial.p = 10*rand(Setting.dim(1),1)+[40;20];
    Model.param=Setting;
    assignin('base',"Plant",Model);
    evalin('base',"agent(Plant.id) = Drone(Plant)");
    end
else
for i = 1:N
    Model.name=["discrete"];
    Model.param=Setting;
    assignin('base',"Model",Model);
    model_set_str=strcat("agent(",string(i),").set_model(Model)");
    evalin('base',model_set_str);
end

end

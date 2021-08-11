function Model = Model_human_6para(i,N,dt,type,initial,varargin)
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
Model.type="Discrete_Model"; % class name
Model.name="Discrete_human"; % print name
Setting.dim = [2,2,2];
Setting.method = get_model_name("Yhuman"); % model dynamicsの実体名
Setting.initial = initial;
Setting.state_list = ["p","v","a"];
Setting.num_list = [2,2,2];
Setting.input_channel = ['v',"a"];
if strcmp(type,"plant")
    Model.id = i;
  
    Model.param=Setting;
%     assignin('base',"Plant",Model);
%     evalin('base',"agent(Plant.id) = Drone(Plant)");
else


    Model.param=Setting;
%     assignin('base',"Model",Model);
%     model_set_str=strcat("agent(",string(i),").set_model(Model)");
%     evalin('base',model_set_str);

end

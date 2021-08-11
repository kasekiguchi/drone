function Model = Model_human_accelaration(i,N,dt,type,initial,varargin)
%% model class demo : 
% "Discrete" "Point mass"    "Quat 13"    "point2"    "RPY 12"    "R 18"    "Quat 17";
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
Vk = 0;
A = [0 0 1 0 0 0;...
     0 0 0 1 0 0;...
     0 0 -Vk 0 1 0;...
     0 0 0 -Vk 0 1;
     0 0 0 0 0 0;...
     0 0 0 0 0 0;];
a = 0.15;
b = 0.3;
r = (b-a).*rand(1,1) + a; 
B = [0 0 0 0 0 0;...
     0 0 0 0 0 0;...
     0 0 r 0 0 0;...
     0 0 0 r 0 0;...
     0 0 0 0 0 0;...
     0 0 0 0 0 0];
sysd = c2d(ss(A,B,eye(6),zeros(6,6)),0.1);
Setting.param.A =sysd.A;             %離散かしたもの
Setting.param.B = sysd.B;
% A2 = [0 0 1 0 ;...
%      0 0 0 1 ;...
%      0 0 -1 0;...
%      0 0 0 -1];
% B2 = [0 0 0 0;...
%      0 0 0 0;...
%      0 0 1 0;...
%      0 0 0 1];
%  sysd2 = c2d(ss(A2,B2,eye(4),zeros(4,4)),0.1);

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

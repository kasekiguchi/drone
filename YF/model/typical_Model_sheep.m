function typical_Model_sheep(N,dt,type,Nb,varargin)
%% model class demo : 
%%現状離散系で書いている
%%加速度次元入力モデル


% "Discrete" "Point mass"    "Quat 13"    "point2"    "RPY 12"    "R 18"    "Quat 17";
if ~isempty(varargin)
    Setting = varargin{1};
end
num_dim = 6;

Setting.dt = dt;
if num_dim==6
    A=[zeros(1,6);zeros(1,6);zeros(1,6);zeros(1,6);zeros(1,6);zeros(1,6)];
    B= eye(6);
    C= [1,1,1,0,0,0];
    D=0;
    sys=ss(A,B,C,D);
    sysd = c2d(sys,0.1);
    Setting.param.A =sysd.A;             %離散かしたもの
    Setting.param.B = sysd.B;
elseif num_dim==3
    Setting.param.A =zeros(3);             %離散かしたもの
    Setting.param.B = eye(3);
end
Model.type="sheep_Model"; % class name
Model.name="discrete"; % print name
Setting.dim = [3,3,0];
Setting.method = get_model_name("sheep"); % model dynamicsの実体名
if num_dim==6
    Setting.initial = struct('p',[0;0;0],'v',[0;0;0]);
    Setting.state_list = ["p","v"];
    Setting.num_list = [3,3];
    Setting.input_channel = ["v"];
else
    Setting.initial = struct('p',[0;0;0]);
    Setting.state_list = ["p"];
    Setting.num_list = [3];
    Setting.input_channel = ["p"];
end
% Setting.initial = struct('p',[0;0;0]);
% Setting.state_list = ["p"];
% Setting.num_list = [3];
% Setting.input_channel = ["p"];
if strcmp(type,"plant")
    for i = 1:N
    Model.id = i;
    Setting.initial.p = 10*rand(3,1)+[40;20;0];
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

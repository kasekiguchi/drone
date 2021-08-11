function Model = Mode_obstacles(i,N,dt,type,initial,varargin)
%% model class demo : 
% "Discrete" "Point mass"    "Quat 13"    "point2"    "RPY 12"    "R 18"    "Quat 17";
if ~isempty(varargin)
    Setting = varargin{1};
end
Setting.dt = dt;
A = eye(2);
B = eye(2);
sysd = c2d(ss(A,B,eye(2),zeros(2,2)),0.1);
Setting.param.A =A;             %離散かしたもの
Setting.param.B =B;
Model.type="Discrete_Model"; % class name
Model.name="Discrete_obstacle"; % print name
Setting.dim = [2];
Setting.method = get_model_name("Yobstacle"); % model dynamicsの実体名
Setting.initial = initial;
Setting.state_list = ["p"];
Setting.num_list = [2];
Setting.input_channel = ['v'];
if strcmp(type,"plant")
    Model.id = i;
    Model.param=Setting;
else
    Model.param=Setting;
end

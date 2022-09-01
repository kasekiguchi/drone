function Model = Model_Vehicle_AW(dt,initial,id)
% model class demo : quaternion model with 13 states
if ~isempty(varargin)
    Setting = varargin{1};
end
Model.type="Wheelchair_Model"; % class name
Model.name="vehicle"; % print name
%---For a alpha model---%
% Setting.dim=[5,2,0];
% Setting.input_channel= ["a","alpha"];
% Setting.method = 'WheelChair_AAlpha_model'; % model dynamicsの実体名
% Setting.state_list =  ["p","q",'v','w'];
% Setting.num_list = [2,1,1,1];
%---------------------------%
%---入力がaとomegaのモデル---%
Setting.dim=[4,2,0]; % [x,y,th,v], [a,w],[]
Setting.input_channel= ["a","w"];
Setting.method = 'vehicle_accel_angulvel_input_model'; % model dynamicsの実体名
Setting.state_list =  ["p","q",'v'];
Setting.num_list = [2,1,1];
%---------------------------%
Setting.initial = initial;
Setting.dt = dt;
Model.parameter_name = [];
Model.param=Setting;

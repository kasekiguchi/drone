function Model = Model_WheelChairA(i,dt,type,initial,varargin)
% model class demo : quaternion model with 13 states
if ~isempty(varargin)
    Setting = varargin{1};
end
Model.type="Wheelchair_Model"; % class name
Model.name="euler"; % print name
%---For a alpha model---%
% Setting.dim=[5,2,0];
% Setting.input_channel= ["a","alpha"];
% Setting.method = 'WheelChair_AAlpha_model'; % model dynamicsの実体名
% Setting.state_list =  ["p","q",'v','w'];
% Setting.num_list = [2,1,1,1];
%---------------------------%
%---入力がaとomegaのモデル---%
Setting.dim=[4,2,0];
Setting.input_channel= ["a","w"];
Setting.method = 'WheelChair_Aomega_model'; % model dynamicsの実体名
Setting.state_list =  ["p","q",'v'];
Setting.num_list = [2,1,1];
%---------------------------%
Setting.initial = initial;
Setting.dt = dt;
if strcmp(type,"plant")
%     for i = 1:N
        Model.id = i;
%         Setting.initial.p = [0;0];
        Setting.param.K = diag([0.9,1]);%誤差の値
        Setting.param.D = 0.1;%0.1;%誤差の値
        Model.param=Setting;
%         assignin('base',"Plant",Model);
%         evalin('base',"agent(Plant.id) = Drone(Plant)");
%     end
else
%     for i = 1:N
        Setting.param.K = diag([1,1]);
        Setting.param.D = 0.1;%0.15;%誤差の値
        Model.param=Setting;
%         assignin('base',"Model",Model);
%         model_set_str=strcat("agent(",string(i),").set_model(Model)");
%         evalin('base',model_set_str);
%     end
end

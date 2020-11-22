function Model_Whill_exp(N,dt,type,initial,varargin)
Setting.num=1;
if ~isempty(varargin)
    Setting.num = varargin{1};
end
Setting.dt = dt;
Model.type="Whill_exp"; % class name
Model.name="whill"; % print name

if strcmp(type,"plant")
    for i = 1:N
    Model.id = i;
    Setting.num = Setting.num+i-1;
    Model.param=Setting;
    assignin('base',"Plant",Model);
    evalin('base',"agent(Plant.id) = Drone(Plant)");
    end
else
    warning("ACSL : Whill_exp cannot set as a control model.")
end

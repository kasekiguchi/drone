function typical_Model_Lizard_exp(N,dt,type,varargin)
    evalin('base',"clear agent");
    if ~isempty(varargin)
        Setting.num = varargin{1}-1;
    end
    Setting.dt = dt;
    Model.type="Lizard_exp"; % class name
    Model.name="lizard"; % print name
    
    if strcmp(type,"plant")
        for i = 1:N
            Model.id = i;
            Setting.num = Setting.num+1;
            Model.param=Setting;
            assignin('base',"Plant",Model);
            evalin('base',"agent(Plant.id) = Drone(Plant);");
        end
    else
        warning("ACSL : Lizard_exp cannot set as a control model.")
    end

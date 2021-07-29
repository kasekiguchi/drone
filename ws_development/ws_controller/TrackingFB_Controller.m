classdef TrackingFB_Controller <CONTROLLER_CLASS
    %目標点が与えられた時の運動について考えるコントローラ
    %目標点を追跡する
    
    properties
        result
        self
        Param
        dt
        Gain
    end
    
    methods
        function obj = TrackingFB_Controller(self,param)
            obj.self = self;
            obj.dt = param.dt;
            obj.Gain = param.gain;
        end
        
        function result = do(obj,param,~)
            %param ={map, reference}
            %---ロボットの状態をとる---%
            RobotState = [obj.self.estimator.result.state.p(1) , obj.self.estimator.result.state.p(2) , obj.self.estimator.result.state.q];
            %-------------------------%
            
            %---Get Reference data---%
            Ref = obj.self.reference.(obj.self.reference.name(1)).result.state;
            %------------------------%
            
            %---subtract ref---%
            Subtheta = atan2(Ref(2) - RobotState(2),Ref(1) - RobotState(1));
            Subvel = sqrt((Ref(1)-RobotState(1))^2 + (Ref(2)-RobotState(2))^2) * cos(Subtheta - RobotState(3));
            %------------------%
            
            %---calculate vel dimension---%
            Targetw = (Subtheta - RobotState(3));
            Targetv = Subvel;
            %-----------------------------%
            
            %---calculate input---%
            RobotVW = [obj.self.estimator.result.state.v,obj.self.estimator.result.state.w];
            obj.result.input = (obj.Gain * [Targetv - RobotVW(1);Targetw - RobotVW(2)])';
            %---------------------%
            obj.self.input = obj.result.input;
            result = obj.result;
        end
        function show(obj)
            
        end
    end
    
end
classdef Motive_ros < SENSOR_CLASS
    %       self : agent
    properties
        name      = "YOLO";
        motive_ros
        result
        state
        self
        fState % subscribeにstate情報を含むか
        position
        orientation
        euler
    end
    
    methods
        function obj = Motive_ros(self,param)
            obj.motive_ros = ROS2_CONNECTOR(param);
            %  このクラスのインスタンスを作成
            obj.self = self;
            if isfield(param,'state_list')
                obj.fState = 1;
                if obj.fState
                    obj.result.state = STATE_CLASS(struct('state_list',param.state_list,"num_list",param.num_list));
                end
                if sum(contains(self.model.state.list,"q"))==1 && sum(contains(param.state_list,"q"))==1
                    obj.result.state.num_list(contains(param.state_list,"q")) = length(self.model.state.q); % modelと合わせる
                    obj.result.state.type = length(self.model.state.q);
                end
            end
            data = obj.motive_ros.getData; 
            obj.position= data.pose.position;
            obj.orientation  = data.pose.orientation;
            obj.euler = quat2eul([obj.orientation.w,obj.orientation.x,obj.orientation.y,obj.orientation.z]);
            
        end
        
        function result=do(obj,param)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object 
            data = obj.motive_ros.getData;
            data.orientation  = data.pose.orientation;
            data.Dxy = [data.data(3);data.data(4)];
            data.euler = quat2eul([obj.orientation.w,obj.orientation.x,obj.orientation.y,obj.orientation.z]);

            F=fieldnames(data);
            for i = 1: length(F)
                switch F{i}
                    case "q"
                        obj.result.state.set_state('q',data.q);
                    case "p"
                        obj.result.state.set_state('p',data.p);
                    case "v"
                        obj.result.state.set_state('v',data.v);
                    case "w"
                        obj.result.state.set_state('w',data.w);
                    otherwise
                        obj.result.(F{i}) = data.(F{i});
                end
            end
            result= obj.result;
        end
        
        function show(obj,varargin)
            if ~isempty(obj.result)
            else
                disp("do measure first.");
            end
        end
       
    end
end
classdef Motive_ros < SENSOR_CLASS
    %       self : agent
    properties
        name      = "MOTIVE";
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
            obj.self.plant.state=STATE_CLASS(struct('state_list',["p","q"],'num_list',[2,1]));
            obj.self.plant.state.p = [obj.position.z;obj.position.x];
            obj.self.plant.state.q = [obj.euler(1,2)];
            obj.self.plant.result.state=STATE_CLASS(struct('state_list',["p","q"],'num_list',[2,1]));
            obj.self.plant.result.state.p = [obj.position.z;obj.position.x];
            obj.self.plant.result.state.q = [obj.euler(1,2)];
        end
        
        function result=do(obj,param)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object 
            sensor = obj.motive_ros.getData;
            sensor.position= sensor.pose.position;
            sensor.orientation  = sensor.pose.orientation;
            sensor.euler = quat2eul([sensor.orientation.w,sensor.orientation.x,sensor.orientation.y,sensor.orientation.z]);
            obj.self.plant.state=STATE_CLASS(struct('state_list',["p","q"],'num_list',[2,1]));
            obj.self.plant.state.p = [sensor.position.z;sensor.position.x];
            obj.self.plant.state.q = [sensor.euler(1,2)];
            obj.self.plant.result.state=STATE_CLASS(struct('state_list',["p","q"],'num_list',[2,1]));
            obj.self.plant.result.state.p = [sensor.position.z;sensor.position.x];
            obj.self.plant.result.state.q = [sensor.euler(1,2)];
            data.motive = sensor;

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
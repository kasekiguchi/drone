classdef Flightcontroller < SENSOR_CLASS
    %       self : agent
    properties
        name      = "Flight";
        flightcontroller
        result
        state
        self
        fState % subscribeにstate情報を含むか
        flightdata
    end
    
    methods
        function obj = Flightcontroller(self,param)
            obj.flightcontroller = ROS2_CONNECTOR(param);
            %  このクラスのインスタンスを作成
            obj.self = self;
            if isfield(param,'state_list')
                obj.fState = 1;
            if obj.fState
                obj.result.state = STATE_CLASS(struct('state_list',param.state_list,"num_list",param.num_list));
            end
%             if sum(contains(self.model.state.list,"q"))==1 && sum(contains(param.state_list,"q"))==1
%                 obj.result.state.num_list(contains(param.state_list,"q")) = length(self.model.state.q); % modelと合わせる
%                 obj.result.state.type = length(self.model.state.q);
%             end
            end
        end
        
        function result=do(obj,~)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object
            obj.flightdata.time = 0;
            t = tic;
%             data=obj.flightcontroller.getData();
            data=obj.flightcontroller.getDataFC();
%             obj.flightdata.time = toc(t);
%             if isempty(data)
%                 data = obj.self.sensor.telemetry.flightdata.ros2;
%             end
            obj.flightdata.ros_t = data;
            obj.flightdata.ros_t.tem = data.data(1:4,1);
            obj.flightdata.ros_t.voltage = data.data(5:8,1);
            obj.flightdata.ros_t.current = data.data(9:12,1);
            obj.flightdata.ros_t.rpm = data.data(13:16,1);
            obj.flightdata.ros_t.layout = data.layout;
            obj.flightdata.ros_t.MessageType = data.MessageType;
%             F=fieldnames(data);
%             for i = 1: length(F)
%                 switch F{i}
%                     case "q"
%                         obj.result.state.set_state('q',data.q);
%                     case "p"
%                         obj.result.state.set_state('p',data.p);
%                     case "v"
%                         obj.result.state.set_state('v',data.v);
%                     case "w"
%                         obj.result.state.set_state('w',data.w);
%                     otherwise
%                         obj.result.(F{i}) = data.(F{i});
%                 end
%             end
            result= obj.flightdata;
        end
        function show(obj,varargin)
            if ~isempty(obj.result)
            else
                disp("do measure first.");
            end
        end
    end
end



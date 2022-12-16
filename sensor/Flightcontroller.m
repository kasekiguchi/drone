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
            end
        end
        
        function result=do(obj,~)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object 
            data=obj.flightcontroller.getData();
%             data=obj.flightcontroller.getDataFC();
            obj.flightdata.ros_t = data;
            obj.flightdata.ros_t.tem = data.data(1:4,1);
            obj.flightdata.ros_t.voltage = data.data(5:8,1);
            obj.flightdata.ros_t.current = data.data(9:12,1);
            obj.flightdata.ros_t.rpm = data.data(13:16,1);
%             obj.flightdata.ros_t.layout = data.layout;
%             obj.flightdata.ros_t.MessageType = data.MessageType;
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



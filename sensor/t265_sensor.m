classdef t265_sensor < SENSOR_CLASS
%T265のセンサ情報取得用class
properties
    name = "s_position"
    t265
    result
    state
    self
    fState % subscribeにstate情報を含むか
    t265data
end

methods
    function obj = t265_sensor(self,param)
        obj.t265 = ROS2_CONNECTOR(param);
        %このクラスのインスタンスを作成
        obj.self = self;%ドローンの状態
        if isfield(param,'state_list')
            obj.fState = 1;
            if obj.fState
                obj.result.state = STATE_CLASS(struct('state_list',param.state_list,"num_list",param.num_list));
            end
        end
    end
    
    function result = do(obj,~)
        % result=sensor.motive.do(motive)
        %   set obj.result.state : State_obj,  p : position, q : quaternion
        %   result : 
        % 【入力】motive ：NATNET_CONNECOTR object        
        data = obj.t265.getData();
        obj.t265data.posion(1) = data.pose.pose.position.x;
        obj.t265data.posion(2) = data.pose.pose.position.y;
        obj.t265data.posion(3) = data.pose.pose.position.z;
        result = obj.t265data;
    end
    function show(obj,varargin)
        if ~isempty(obj.result)
        else
            disp("do measure first.");
        end
    end
end
end
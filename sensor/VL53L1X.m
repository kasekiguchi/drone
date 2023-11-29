classdef VL53L1X < handle
    %       self : agent
    properties
%         name      = "VL";
        vl53l1x
        result
        state
        self
        fState % subscribeにstate情報を含むか
        vldata
    end
    
    methods
        function obj = VL53L1X(self,param)
            obj.vl53l1x = ROS2_CONNECTOR(param);
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
        
        function result=do(obj)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object 
            data=obj.vl53l1x.getData();
            obj.vldata = data;
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
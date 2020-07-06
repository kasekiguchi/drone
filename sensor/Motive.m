classdef Motive < SENSOR_CLASS
    % Motive用クラス：登録されたエージェントの位置と姿勢がわかる
    %  sensor.motive = Motive(self, ~)
    %       self : agent
    properties
        name      = "Motive";
        result
        state
        self
        interface = @(x) x;
        old_time
    end
    
    methods
        function obj = Motive(self,~)
            %  このクラスのインスタンスを作成
            %%% Output equation %%%
            obj.self = self;
            obj.result.state=state_copy(self.model.state); % STATE_CLASSとしてコピー
            if sum(contains(obj.result.state.list,"q"))==1
                obj.result.state.list=["p","q"];
                obj.result.state.num_list=[3,length(obj.result.state.q)]; % modelと合わせる
            end
        end
        
        function result=do(obj,motive)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object 
            data=motive{1}.result;
            if isempty(obj.old_time)
                obj.old_time = data.time;
            end
            id = obj.self.id;
            if sum(contains(obj.result.state.list,"q"))==1
                obj.result.state.set_state('q',data.rigid(id).q);
            end
            obj.result.state.set_state('p',data.rigid(id).p);
            obj.result.rigid=data.rigid;
            obj.result.feature = data.marker;
            obj.result.feature_num = data.marker_num;
            obj.result.local_feature = data.local_marker{id};
            obj.result.on_feature_num = data.local_marker_nums(id);
            obj.result.dt=data.time-obj.old_time;
            obj.old_time=data.time;
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

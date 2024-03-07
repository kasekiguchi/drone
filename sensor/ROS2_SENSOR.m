classdef ROS2_SENSOR < handle
%seonsor class for ros2
%This have multi sensor topic data
properties%common
    self    % agentを格納
    state   % have state
    result  % result save
end
properties
    ros        
    fState  % topicのstate分岐用フラグ（状態の計測データが送られてくるときに有効）
    Node    % ros2nodeを格納
    datatreat
end
methods
    function obj = ROS2_SENSOR(self, set_param)
        obj.self = self;
        obj.Node = self.plant.IP;
        % param = set_param;
        Topics = set_param.topics;
        topic.node = obj.Node;%CONNECTORに持っていく用
        for i = 1:set_param.num%sub,pubの生成
            if isfield(Topics,"subTopic")
                if i <= length(Topics.subTopic)
                    if ~isempty(Topics.subTopic(i,1))
                        topic.subTopic = Topics.subTopic(i, :);
                    end
                end
            end
            if isfield(Topics,"pubTopic")
                if i <= length(Topics.pubTopic)
                    if ~isempty(Topics.pubTopic(i,1))
                        topic.pubTopic = Topics.pubTopic(i, :);
                    end
                end
            end
            obj.ros{i} = ROS2_CONNECTOR(topic);
        end
        if isfield(set_param, 'pfunc')%生データの処理
            obj.datatreat = set_param.pfunc;
        end
        % if isfield(param, 'state_list')%T265のとき有効
        %     obj.fState = 1;
        %     if obj.fState
        %         obj.result.state = STATE_CLASS(struct('state_list', param.state_list, "num_list", param.num_list));
        %     end
        %     if sum(contains(self.model.state.list, "q")) == 1 && sum(contains(param.state_list, "q")) == 1
        %         obj.result.state.num_list(contains(param.state_list, "q")) = length(self.model.state.q); % modelと合わせる
        %         obj.result.state.type = length(self.model.state.q);
        %     end
        % end
    end

    function result = do(obj, varargin) 
        result.state = obj.state;
        for i = 1:length(obj.ros)
            data = obj.ros{i}.getData;
            result.(matlab.lang.makeValidName(obj.ros{i}.subName,'ReplacementStyle','delete')) = data;            
        end
        if ~isempty(obj.datatreat)
            [result.pc, result.detection] = obj.datatreat(result.scan_behind,result.scan_front);
        end
        obj.result = result;
    end

    function show(obj)
    end
end
end
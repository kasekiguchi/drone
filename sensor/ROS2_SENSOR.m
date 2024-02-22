classdef ROS2_SENSOR < handle
%seonsor class file for ros2
%have multi sensor topic data
properties%common
    self    % agentを格納
    state   % have state
    result  % result save
end
properties
    ros        
    fState  % topicのstate分岐用フラグ（状態の計測データが送られてくるときに有効）
    Node    % ros2nodeを格納
    % radius = 0;
    datatreat
end
methods
    function obj = ROS2_SENSOR(self, set_param)
        obj.self = self;
        obj.Node = self.plant.IP;
        % param = set_param;
        Topics = set_param.topics;
        topic.node = obj.Node;%CONNECTORに持っていく用
        for i = 1:length(Topics.subTopic)%sub,pubの生成
            topic.subTopic = Topics.subTopic(i, :);
            if isfield(Topics,"pubTopic")
                if isempty(Topics.pubTopic(i, :))
                    topic.pubTopic = Topics.pubTopic(i, :);
                end
            end
            obj.ros{i} = ROS2_CONNECTOR(topic);
        end
        if isfield(set_param, 'pfunc')%生データの処理
            obj.datatreat = set_param.pfunc;
        end
        % if isfield(param, 'state_list')%motive,T265のとき有効
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

    function show(obj, pq, q)

        % arguments
        %     % obj
        %     % pq
        %     % q = 0;
        % end

        p = pq(1:2);


        if length(pq) > 2
            q = pq(end);
        end

        if ~isempty(obj.result)
            points(1:2:2 * size(obj.result.sensor_points, 1), :) = obj.result.sensor_points;
            R = [cos(q), -sin(q); sin(q), cos(q)];
            %             points = (R'*(points'-p))';
            %             points = (R * points' + p)';
            points = (points' - p)';
            points = (points' + p)';
            pp = plot([points(:, 1); p(1)], [points(:, 2); p(2)]);
            %             set(pp,'EdgeAlpha',0.05);
            %             set(pp,'EdgeColor','g');
            hold on;
            text(points(1, 1), points(1, 2), '1', 'Color', 'b', 'FontSize', 10);
            %             region = polyshape((R * obj.result.region.Vertices' + p)');
            %             plot(region);%132,133 coment out
            %             head_dir = polyshape((R * obj.head_dir.Vertices' + p)');
            %             plot(head_dir);
            axis equal;
        else
            disp("do measure first.");
        end
    end
end
end

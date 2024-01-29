classdef ROS2_SENSOR < handle
  %       self : agent
  properties
    ros
    result
    state
    self
    fState % subscribeにstate情報を含むか

    % ros2param
    % prosesssfunc
    Node
    radius=0;
    getData
  end

  methods

    function obj = ROS2_SENSOR(self,param)
      obj.Node = self.plant.IP;
      topics = param.param;
      topics.node = obj.Node;
      subTopics = topics.subTopic;
      for i = 1:length(subTopics(:,1))
        topics.subTopic = subTopics(i,:);
        obj.ros{i} = ROS2_CONNECTOR(topics);
      end
      %  このクラスのインスタンスを作成
      obj.self = self;

      if isfield(param, 'state_list')
        obj.fState = 1;

        if obj.fState
          obj.result.state = STATE_CLASS(struct('state_list', param.state_list, "num_list", param.num_list));
        end

        if sum(contains(self.model.state.list, "q")) == 1 && sum(contains(param.state_list, "q")) == 1
          obj.result.state.num_list(contains(param.state_list, "q")) = length(self.model.state.q); % modelと合わせる
          obj.result.state.type = length(self.model.state.q);
        end
      end
      obj.getData = param.getData;
      % data = obj.ros.getData;
      % data = obj.ros{1}.getData;
      % obj.prosesssfunc = param.pfunc;%使わない場合はsampleで0を入れる
    end


    function result = do(obj, varargin)
      %   result : point cloud data
      %%%%%for PC2LDA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      result = obj.getData();
%      result = obj.result;
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

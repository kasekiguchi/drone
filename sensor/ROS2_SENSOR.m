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

    front_get
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
      % obj.getData = param.param.getData; 
      obj.getData = @getData_two_lidar_combine;      
      % data = obj.ros.getData;
      % data = obj.ros{1}.getData;
      % obj.prosesssfunc = param.pfunc;%使わない場合はsampleで0を入れる
    end


    function result = do(obj, varargin)
      %   result : point cloud data
      %%%%%for PC2LDA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % result = obj.front_get;
      result = obj.getData_two_lidar_combine;
      
      
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

    function pointcloud_out_roi = Pointcloud_manual_delete_roi(obj,pd,roi)
% extract data from pd within ROI
% ids = roi(1) < pd(inc,1) && pd(inc,1) < roi(2) && roi(3) < pd(inc,2) && pd(inc,2) < roi(4);
% pd(ids,:) = [];
% pointcloud_out_roi = pd;
    for inc = 1:length(pd)
        if roi(1) < pd(inc,1) && pd(inc,1) < roi(2)
            if roi(3) < pd(inc,2) && pd(inc,2) < roi(4)
                pd(inc,1) = nan;
                pd(inc,2) = nan;
                pd(inc,3) = nan;
            end
        end
    end
    R = rmmissing(pd);
    pd_B = R;
    pointcloud_out_roi = pd_B;
    end

    function result = getData_two_lidar_combine(obj)
data1 = obj.ros{2};
data2 = obj.ros{1};
% ２つのLiDARデータを結合しポイントクラウドデータに変換
% get Laser scan message
scanlidardata_b = data1.getData;
scanlidardata_f = data2.getData;
result = scanlidardata_f;                %前のlidarデータをobjにそのまま保存
result.odom_data = obj.ros{3}.getData;
result.angle = result.angle_min:result.angle_increment:result.angle_max;
result.length = result.ranges;
% trans n–by–2 matrix [m]
moving_f = rosReadCartesian(scanlidardata_f);
moving_b = rosReadCartesian(scanlidardata_b);
% add z axis data
moving_pc.f = [moving_f zeros(size(moving_f,1),1)];
moving_pc.b = [moving_b zeros(size(moving_b,1),1)];
% region of interest to be deleted
delete_roi = [0.1 0.35 -0.18 0.16 -0.1 0.1]; % TODO : region to be deleted due to the vehicle direction
% delete points in delete_roi
moving_pc.f = obj.Pointcloud_manual_delete_roi(moving_pc.f,delete_roi);
moving_pc.b = obj.Pointcloud_manual_delete_roi(moving_pc.b,delete_roi);

% transform back lidar data into front lidar coordinate
% Yaw axis rotation
rot = eul2rotm(deg2rad([0 0 180]),'XYZ');
% translational vector
Tb = [0.2900    0.0230         0]; % TODO : measure from back lidar to the vehicle's origin
Tf = [0.7 0 0]; % TODO : measure from front lidar to the vehicle's origin
%moving_pc2_m_b = tform_manual(moving_pc.b,rot,T);
moving_pc2_m_f = (rot*moving_pc.f' + Tf')'; % N x 3
moving_pc2_m_b = (moving_pc.b' + Tb')'; % N x 3
% merge and transform to point cloud data
result.pc = pointCloud([moving_pc2_m_f;moving_pc2_m_b]);
end

  end

end

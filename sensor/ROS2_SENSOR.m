classdef ROS2_SENSOR < handle
%       self : agent
properties
    ros
    result
    state
    self
    fState % subscribeにstate情報を含むか

    % ros2param
    prosesssfunc
    Node
    radius
end

methods

    function obj = ROS2_SENSOR(self,param)
        obj.Node = self.plant.IP;
        topics = param.param;
        topics.node = obj.Node;
        subTopics = topics.subTopic;
        for i = 1:length(subTopics)
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

        % data = obj.ros.getData;
        % data = obj.ros{1}.getData;
        obj.prosesssfunc = param.pfunc;%使わない場合はsampleで0を入れる
    end
        

    function result = do(obj, varargin)
        % result=sensor.motive.do(motive)
        %   set obj.result.state : State_obj,  p : position, q : quaternion
        %   result :
        % 【入力】motive ：NATNET_CONNECOTR object
        
        while(1)            
            for i = 1:length(obj.ros)
                data{i} = obj.ros{i}.getData;
            end
            if isempty(data{1})|isempty(data{2})
                % break
                disp("pointcloud lost")
            else
                break
            end
            pause(0.05)
        end
        
        % for i = 1:length(data)
        %     data2pcd = rosReadCartesian(data{i});
        %     moving_pc(i) = pointCloud([data2pcd zeros(size(data2pcd,1),1)]); % moving:m*3           
        % end

    % %% ローバー自身の点群認識
    %     roi = [0.1 0.35 -0.18 0.16 -0.1 0.1];
    % 
    %     indices_f = findPointsInROI(moving_pc(1),roi);
    %     Df = zeros(size(moving_pc(1).Location));
    % 
    %     indices_b = findPointsInROI(moving_pc(2),roi);
    %     Db = zeros(size(moving_pc(2).Location));
    % 
    %     Df(indices_f,3) = 5;
    %     Db(indices_b,3) = 5;
    %     ptCloud_tf = pctransform(moving_pc(1),Df);
    %     ptCloud_tb = pctransform(moving_pc(2),Db);
    %     % %%%%%%%%%ローバー自身の点群除去%%%%%%%%%%%%%%
    %     roi = [-10 10 -10 10 -1 1];%入力点群の x、y および z 座標の範囲内で直方体 ROI を定義
    % 
    % 
    %     indices_f = findPointsInROI(ptCloud_tf,roi);%直方体 ROI 内にある点のインデックスを検出
    %     moving_pc(1) = select(ptCloud_tf,indices_f);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納    
    % 
    %     indices_b = findPointsInROI(ptCloud_tb,roi);%直方体 ROI 内にある点のインデックスを検出
    %     moving_pc(2) = select(ptCloud_tb,indices_b);%直方体 ROI 内にある点を選択して、点群オブジェクトとして格納
    %     %% pcd合成
    %     rot = eul2rotm(deg2rad([0 0 180]),'XYZ'); %回転行列(roll,pitch,yaw)
    %     T = [0.46 0.023 0]; %並進方向(x,y,z)
    %     tform = rigidtform3d(rot,T);
    % 
    %     moving_pc2_m_b = pctransform(moving_pc(2),tform);
    % 
    %     ptCloudOut = pcmerge(moving_pc(1), moving_pc2_m_b, 0.001);
        % ptCloudOut = pcmerge(moving_pc.f, moving_pc2_m, 0.001);
        PCdata_use = obj.prosesssfunc(data);
        
        rot = eul2rotm(deg2rad([0 0 180]),'XYZ'); %回転行列(roll,pitch,yaw)
        T = [0.17 0 0]; %並進方向(x,y,z)
        tform = rigidtform3d(rot,T);
        % moving_pcm = pctransform(ptCloudOut,tform);

        obj.result = pctransform(PCdata_use,tform);
        % obj.result = scanpcplot_rov(moving_pc);
        result = obj.result;
    end

    %         function show(obj,varargin)
    %             if ~isempty(obj.result)
    %             else
    %                 disp("do measure first.");
    %             end
    %         end
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

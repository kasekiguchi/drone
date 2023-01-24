classdef ROS < SENSOR_CLASS
    %       self : agent
    properties
        name      = "LiDAR";
        ros
        result
        state
        self
        fState % subscribeにstate情報を含むか
        radius
        angle_range
        front
        sensor_point
    end
    
    methods
        function obj = ROS(self,param)
            obj.ros = ROS2_CONNECTOR(param);
            %  このクラスのインスタンスを作成
            obj.self = self;
            if isfield(param,'state_list')
                obj.fState = 1;
                if obj.fState
                    obj.result.state = STATE_CLASS(struct('state_list',param.state_list,"num_list",param.num_list));
                end
                if sum(contains(self.model.state.list,"q"))==1 && sum(contains(param.state_list,"q"))==1
                    obj.result.state.num_list(contains(param.state_list,"q")) = length(self.model.state.q); % modelと合わせる
                    obj.result.state.type = length(self.model.state.q);
                end
            end
            data = obj.ros.getData;
            obj.radius = data.range_max;
            angle_num  = size(data.ranges);
%             angle_num = data.angle_max/data.angle_increment;
            j = 1;
            data.angle(j,1) = data.angle_min;
            for j = 2:angle_num(1,1)
                data.angle(j,1) = data.angle(j-1) + data.angle_increment; 
            end
            obj.angle_range = double(data.angle');
%             data.ranges = filloutliers(data.ranges,"next");
%             data.intensities = ficclloutliers(data.intensities,"next");
            for i = 1:length(data.ranges)
                if ~isfinite(data.ranges(i,1)) == 1
                    if i == 1
                        data.ranges(i,1) = data.ranges(i+1,1);
                    else
                        data.ranges(i,1) = data.ranges(i-1,1);
                    end
                end
            end
            for i = 1:length(data.intensities)
                if ~isfinite(data.intensities(i,1)) == 1
                    if i == 1
                        data.intensities(i,1) = data.intensities(i+1,1);
                    else
                        data.intensities(i,1) = data.intensities(i-1,1);
                    end
                end
            end
%             data.ranges(~isfinite(data.ranges)) = 0;
%             data.intensities(~isfinite(data.intensities)) = 0;
%             data.ranges = fillmissing(data.ranges,'previous');
%             data.intensities = fillmissing(data.intensities,'previous');
            data.angle = double((data.angle)');
            data.length = double((data.ranges)');
            data.intensities = double((data.intensities)');
            data.radius = double((data.range_max)');
%             for i = 1:length(data.length)
%                 if data.length(i,1) > 3.0
%                     data.length = 0;
%                     data.intensities(i,1) = 0;
%                 end
%             end
        end
        
        function result=do(obj,param)
            % result=sensor.motive.do(motive)
            %   set obj.result.state : State_obj,  p : position, q : quaternion
            %   result : 
            % 【入力】motive ：NATNET_CONNECOTR object 
            data = obj.ros.getData;
            for i = 1:length(data.ranges)
                if ~isfinite(data.ranges(i,1)) == 1
                    if i == 1
                        data.ranges(i,1) = data.ranges(i+1,1);
                    else
                        data.ranges(i,1) = data.ranges(i-1,1);
                    end
                end
            end
            for i = 1:length(data.intensities)
                if ~isfinite(data.intensities(i,1)) == 1
                    if i == 1
                        data.intensities(i,1) = data.intensities(i+1,1);
                    else
                        data.intensities(i,1) = data.intensities(i-1,1);
                    end
                end
            end
            for i = 1:length(data.ranges)
                if data.ranges(i,1) >= 6.0
                    data.ranges(i,1) = 0;
%                     data.intensities(i,1) = 0;
                end
            end


%             data.ranges = filloutliers(data.ranges,"previous");
%             data.intensities = filloutliers(data.intensities,"previous");
            data.ranges = fillmissing(data.ranges,'previous');
            data.intensities = fillmissing(data.intensities,'previous');
            angle_num  = size(data.ranges);
%             angle_num = data.angle_max/data.angle_increment;
            j = 1;
            data.angle(j,1) = data.angle_min;
            for j = 2:angle_num(1,1)
                data.angle(j,1) = data.angle(j-1) + data.angle_increment; 
            end
            data.angle = double((data.angle)');
            data.length = double((data.ranges)');
            data.intensities = double((data.intensities)');
            data.radius = double((data.range_max)');
            if ~isempty(obj.self.estimator.ukfslam.result.state.q)
                front = obj.self.estimator.ukfslam.result.state.q;
            else
                front = 0;
            end
            tmp = data.angle +front;
            cric = [data.radius * cos(tmp);data.radius * sin(tmp)]';
            for i = 1:size(data.length,2)
                a = data.length(i)*sin(tmp(1,i));
                b = data.length(i)*cos(tmp(1,i));
                obj.result.sensor_points(i,:) = [b,a];
            end

            F=fieldnames(data);
            for i = 1: length(F)
                switch F{i}
                    case "q"
                        obj.result.state.set_state('q',data.q);
                    case "p"
                        obj.result.state.set_state('p',data.p);
                    case "v"
                        obj.result.state.set_state('v',data.v);
                    case "w"
                        obj.result.state.set_state('w',data.w);
                    otherwise
                        obj.result.(F{i}) = data.(F{i});
                end
            end
            result= obj.result;
        end
%         function show(obj,varargin)
%             if ~isempty(obj.result)
%             else
%                 disp("do measure first.");
%             end
%         end
        function show(obj, pq,q)
        arguments
            obj
            pq
            q = 0;
        end
        p = pq(1:2);
        if length(pq) >2
            q = pq(end);
        end

        if ~isempty(obj.result)
            points(1:2:2 * size(obj.result.sensor_points, 1), :) = obj.result.sensor_points;
            R = [cos(q), -sin(q); sin(q), cos(q)];
%             points = (R'*(points'-p))';
%             points = (R * points' + p)';
            points = (points'-p)';
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

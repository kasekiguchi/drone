classdef Whill_exp < MODEL_CLASS
    % Lizard ŽÀŒ±—pƒ‚ƒfƒ‹
    properties% (Access=private)
        ros % connector
        IP
        flight_phase % q : quit, s : stop, a : arming, t : take-off, h : hovering, f : flight, l : landing
        port=25000;
    end
    properties
        msg
    end
    
    
    methods
        function obj = Whill_exp(self,args)
            obj@MODEL_CLASS([],[]);
            param=args{2}; % args{1}‚Ítype
            obj.dt = 0.025;
            %% variable set
            obj.flight_phase        = 'f';
            obj.Whill_num = param.num;
            param.ROSHostIP=strcat('192.168.1.',string(100+obj.Whill_num));
            param.ROSClientIP=strcat();
            param.subTopicName = {'/wheelchair/odom', ...
                '/wheelchair/gyr', ...
                '/scan', ...
                '/velodyne_points', ...
                '/camera/depth/color/points', ...
                '/wheelchair/pose'};
            param.pubTopicName = {'/wheelchair/cmd_vel'};
            param.subMsgName = {'nav_msgs/Odometry', ...
                'geometry_msgs/Point', ...
                'sensor_msgs/LaserScan', ...
                'sensor_msgs/PointCloud2', ...
                'sensor_msgs/PointCloud2', ...
                'geometry_msgs/Pose'};
            param.pubMsgName = {'geometry_msgs/Twist'};
            obj.ros=ROS_CONNECTOR(param);
            self.connector=obj.espr;
            %disp('UDPs is ready.');
        end
        function do(obj,u,varargin)
            if ~isfield(varargin{1},'FH')
                error("ACSL : require figure window");
            else
                FH = varargin{1}.FH;% figure handle
            end
            cha = get(FH, 'currentcharacter')
            if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't')
                cha   = obj.flight_phase;
            end
            obj.flight_phase=cha;
            
            % quit
            if cha == 'q'
                %            if strcmp(get(FH,'currentcharacter'), 'q')
                error("quit experiment");
            end
            
            % stop propeller
            if cha   == 's'
                uroll   = 1100;     upitch  = 1100;     uthr    =  600;     uyaw    = 1100;
                AUX_1   =  600;     AUX_2   =  600;     AUX_3   =  600;     AUX_4   =  600;
                msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
            end
            
            % armnig
            if cha   == 'a'
                uroll   = 1100;     upitch  = 1100;     uthr    =  600;     uyaw    = 1100;
                AUX_1   = 1600;     AUX_2   =  600;     AUX_3   =  600;     AUX_4   =  600;
                msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
            end
            if cha   == 'f'
                msg(1,1:8) = u;
            end
            if cha   == 'l'
                msg(1,1:8) = u;
            end
            if cha   == 't'
                msg(1,1:8) = u;
            end
            % make udp data
            for j = 1:1:8
                pw(1, j + 0)   = fix(msg(1, j) / 100);
                pw(1, j + 8)   = rem(msg(1, j),  100);
            end
            
            Pw = uint8(pw);
            
            % send UDP
            obj.espr.sendData(Pw(1,1:16));
            obj.msg=Pw;
        end
    end
end



classdef Whill_exp < MODEL_CLASS
    % Whill 実験用モデル
    properties% (Access=private)
        ID
        connector
        phase % q : quit, s : stop, r : run
        conn_type
    end
    properties
        msg
    end
    
    methods
        function obj = Whill_exp(args)
            obj@MODEL_CLASS([],[]);
            param=args;
            obj.dt = 0.025; % check
            %% variable set
            obj.phase        = 's';
            obj.conn_type = param.conn_type;
            switch param.conn_type
                case "udp"
                    obj.IP = param.num;
                    [~,cmdout] = system("ipconfig");
                    ipp=regexp(cmdout,"192.168.");
                    cmdout2=cmdout(ipp(1)+8:ipp(1)+11);
                    param.IP=strcat('192.168.50','.',string(100+obj.IP));
                    %param.IP=strcat('192.168.',cmdout2(1:regexp(cmdout2,".")),'.',string(100+obj.IP));
                    %param.IP=strcat('192.168.50.',string(obj.IP));
                    param.port=8000+obj.IP;
                    obj.connector=UDP_CONNECTOR(param);
                    fprintf("Whill %s is ready\n",param.IP);
                case "serial"
                    obj.connector=SERIAL_CONNECTOR(param);
                    fprintf("Whill %d is ready\n",param.port);
                case "ros"
                    obj.ID  = param.param.DomainID;
                    param.DomainID = param.param.DomainID;
%                     param.subTopicName = {'/odom'};
%                     param.subMsgName = {'nav_msgs/Odometry' };

                        param.subTopicName = {'/Robot_1/pose'};
                        param.subMsgName = {'geometry_msgs/PoseStamped'};

                    param.pubTopicName = {'/cmd_vel'};
                    param.pubMsgName = {'geometry_msgs/Twist'};
                    subnum = length(param.subTopicName);
                    pubnum = length(param.pubTopicName);
                    for i = 1:subnum
                        param.subTopic(i) = ros2node("/submatlab",param.DomainID);
                    end
                    for i = 1:pubnum
                        param.pubTopic(i) = ros2node("/pubmatlab",param.DomainID);
                    end
                    obj.connector=ROS2_CONNECTOR(param);
            end
%             = obj.connector.getData;
        end
        function do(obj,u,varargin)
            if length(varargin)==1
                if ~isfield(varargin{1},'FH')
                    error("ACSL : require figure window");
                else
                    FH = varargin{1}.FH;% figure handle
                end
                cha = get(FH, 'currentcharacter');
                if (cha ~= 'q' && cha ~= 's' && cha ~= 'r')
                    cha   = obj.phase;
                end
                obj.phase=cha;
                obj.msg = ros2message('geometry_msgs/Twist');
                switch cha
                    case 'q' % quit
                        obj.msg.linear.x = 0.0;
                        obj.msg.angular.z = 0.0;
                        error("ACSL : quit experiment");
                    case's' % stop
                        obj.msg.linear.x = 0.0;
                        obj.msg.angular.z = 0.0;
                    case 'r' % run
                        obj.msg.linear.x = u(1);
                        obj.msg.angular.z = u(2);
%                          obj.msg.linear.x = 0;
%                          obj.msg.angular.z = 0;
                end
            else % 緊急時
                return;
            end
            
            % send
            obj.connector.sendData(obj);
        end
        function set_param(obj,param)
            obj.offset = param;   
        end
    end
end


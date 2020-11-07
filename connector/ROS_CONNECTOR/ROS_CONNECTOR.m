classdef ROS_CONNECTOR < CONNECTOR_CLASS
            % 【Input】info : require following fields
            %   subTopicName
            %   pubTopicName
            %   subMsgName
            %   pubMsgName
            %   ROSHostIP
            %   ROSClientIP
    properties
        result
        init_time  % first getData time
        Node
        subscriber
        publisher
        subMessage
        pubMessage
        %- Subscriber topic -%
        subTopicNum
        subTopicName
        subMsgName
        %- Publisher topic -%
        pubTopicNum
        pubTopicName
        pubMsgName
    end
    properties(SetAccess=private)
        TimeOut = 1.e-3; % この時間はどこから？必要？
        IP
        port
    end
    
    methods
        function obj = ROS_CONNECTOR(info)
            disp('Preparing connection to robot operating system...');
            %-- Configulations for ROS
            obj.subTopicName = info.subTopicName;
            obj.subTopicNum = length(obj.subTopicName);
            obj.subMsgName = info.subMsgName;
            obj.pubTopicName = info.pubTopicName;
            obj.pubTopicNum = length(obj.pubTopicName);
            obj.pubMsgName = info.pubMsgName;
            
            %-- Setting the environment variables to connect to ROS
            URI = strcat('http://', info.ROSHostIP, ':11311');
            setenv('ROS_MASTER_URI', URI);
            setenv('ROS_IP', info.ROSClientIP);
            
            %-- Connection of ROS core using "rosinit"
            rosshutdown;
            rosinit(URI);
            
            %-- Declaring the node, publishers and subscribers
            obj.Node	 = robotics.ros.Node('/matlab');
            for i = 1:obj.subTopicNum
                obj.subscriber.(obj.subTopicName(i)) = robotics.ros.Subscriber(obj.Node, obj.SubTopicName(i), obj.subMsgName(i));
                obj.subMessage.(obj.subTopicName(i)) = rosmessage(obj.subscriber.(obj.subTopicName(i)));
            end
            for i = 1: obj.pubTopicNum
                obj.publisher.(obj.pubTopicName(i)) = robotics.ros.Publisher(obj.Node, obj.pubTopicName(i), obj.pubMsgName(i));
                obj.pubMessage.(obj.pubTopicName(i)) = rosmessage(obj.publisher.(obj.pubTopicName(i)));
            end
        end
        function [ret] = getData(obj)
            %
            %   詳細説明をここに記述
            if isempty(obj.init_time)
                obj.init_time = rostime('now');
            end
            t = rostime('now') - obj.init_time;
            obj.result.time = double(t.Sec)+double(t.Nsec)*10^-9;
            %pause(obj.TimeOut); % 必要？
            obj.result  = arrayfun(@(i) obj.subscriber.(i).LatestMessage,obj.subTopicName,'UniformOutput',false);
            ret = obj.result;
        end
        function sendData(obj,msg)
            % send msg : msg is allowed to be following two forms
            % msg = {msg1, msg2, ...} : order corresponding to pubTopicName
            % or 
            % msg = struct('topic_name1',value1,'topic_name2',value2,...)
            if isstruct(msg)
                for i = 1:obj.pubTopicNum
                    send(obj.publisher.(obj.pubTopicName(i)), msg.(obj.pubTopicName(i))));
                end
            else
                for i = 1:obj.pubTopicNum
                    send(obj.publisher.(obj.pubTopicName(i)), msg{i});
                end
            end
        end
        function delete(obj)
            send(obj.pubTopic,obj.pubCloseMessage);
            rosshutdown;
        end
    end
end


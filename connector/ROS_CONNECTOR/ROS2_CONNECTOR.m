classdef ROS2_CONNECTOR < CONNECTOR_CLASS
            % 【Input】info : require following fields
            %   subTopic
            %   pubTopic
            %   subName
            %   pubName
            %   ROS2 DomeinID
            %　ここの拡張を行う
    properties
        DomainID
        result
        init_time  % first getData time
        subscriber
        publisher
        %- Subscriber topic -%
        subTopicNum
        subTopic
        subName % 受信msg を格納するresult構造体のフィールド（配列）
        %- Publisher topic -%
        pubTopicNum
        pubTopic
        pubName % 送信msgを格納するpubMsg構造体のフィールド名配列
%         pubMsg  % 送信msg
    end
    properties(SetAccess=private)
        TimeOut = 1.e-3; % この時間はどこから？必要？
        ID
        port
    end
    
    methods
        function obj = ROS2_CONNECTOR(info)
            disp('Preparing connection to robot operating system 2...');
            %-- Setting the environment variables to connect to ROS2
            obj.DomainID = info.DomainID;
            %-- Configulations for ROS2
            obj.subTopic = info.subTopic;
            obj.subName = info.subName;
            obj.subTopicNum = length(obj.subTopic);
            if isfield(info,'pubTopic')
                obj.pubTopic = info.pubTopic;
                obj.pubName = info.pubName;
                obj.pubTopicNum = length(obj.pubTopic);
            end
            %-- Setting the environment variables to connect to ROS2
            obj.DomainID = info.DomainID;
            
            %-- Connection of ROS core using "rosinit"
            %ROS2のトピック一覧
            ros2 topic list;
            
            %-- Declaring the node, publishers and subscribers
            for i = 1:obj.subTopicNum
                obj.subTopic(i) = ros2node("/obj.subName(i)",obj.DomainID);
                obj.subscriber.(obj.subName(i)) = ros2subscriber(obj.subTopic(i));
            end
            if isfield(info,'pubTopic')
                for i = 1: obj.pubTopicNum
                    obj.pubTopic = ros2node("/obj.pubTopic",obj.DomainID);
                    obj.publisher.(obj.pubTopic(i)) = ros2publisher(obj.pubTopic(i));
                end
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
            for i = 1:obj.subTopicNum
                obj.result.(obj.subName(i)) = receive(obj.subscriber.(obj.subName(i)),10);
            end
            ret = obj.result;
        end
        
        function sendData(obj,msg)
            % send msg : msg is allowed to be following two forms
            % msg = {msg1, msg2, ...} : order corresponding to pubTopic
            % or 
            % msg = struct('topic_name1',value1,'topic_name2',value2,...)
            if isstruct(msg)
                for i = 1:obj.pubTopicNum
                    send(obj.publisher.(obj.pubName(i)), msg.(obj.pubName(i)));
                end
            else
                for i = 1:obj.pubTopicNum
                    send(obj.publisher.(obj.pubName(i)), msg{i});
                end
            end
        end
        function delete(obj)
            
%             send(obj.pubTopic,obj.pubCloseMessage);
%             rosshutdown;
        end
    end
end
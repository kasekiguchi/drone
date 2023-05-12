classdef ROS2_CONNECTOR < CONNECTOR_CLASS
            % 【Input】info : require following fields
            %   subTopic
            %   pubTopic
            %   subName
            %   pubName
            %   DomainID
    properties
        DomainID
        init_time
        result
        subscriber
        publisher
        %- Subscriber topic -%
        subTopicNum
        subTopic 
        subName % 受信msg を格納するresult構造体のフィールド（配列）
        subMsg
        %- Publisher topic -%
        pubTopicNum
        pubTopic
        pubName % 送信msgを格納するpubMsg構造体のフィールド名配列
%         pubMsg  % 送信msg
%         callback
        pose
    end

    properties(SetAccess=private)
        TimeOut = 1.e-3; % この時間はどこから？必要？
        ID
    end

    methods
        function obj = ROS2_CONNECTOR(info)
            disp('Preparing connection to robot operating system...');
            %-- Configulations for ROS
            obj.subTopic = info.subTopic;
            obj.subName = info.subTopicName;
            obj.subTopicNum = length(obj.subTopic);
            obj.subMsg = info.subMsgName;
            if isfield(info,'pubTopic')
                obj.pubTopic = info.pubTopic;
                obj.pubName = info.pubTopicName;
                obj.pubTopicNum = length(obj.pubTopic);
            end
            %-- Setting the environment variables to connect to ROS
            obj.DomainID = info.DomainID;
            obj.pose = [];

            %ROS2のトピック一覧
%             ros2 topic list;
            ros2("topic","list","-t","DomainID",obj.DomainID)
            
            %-- Declaring the node, publishers and subscribers
            for i = 1:obj.subTopicNum
%                 obj.subscriber.subTopic(i) = ros2subscriber(obj.subTopic(i),obj.subName{1,i},obj.subMsg{1,i},...
%                     "History","keepall","Reliability","besteffort");
%                  obj.subscriber.subTopic(i) = ros2subscriber(obj.subTopic(i),obj.subName{1,i},obj.subMsg{1,i},{@ROS2Callback,obj},...
%                     "History","keepall","Reliability","besteffort"); %　変更
                  obj.subscriber.subtopic(i) = ros2subscriber(obj.subTopic(i),obj.subName(1,i),obj.subMsg(1,i),{@ROS2Callback,obj},...
                    "History","keepall","Reliability","besteffort");
            end
            if isfield(info,'pubTopic')
                for i = 1: obj.pubTopicNum 
                    obj.publisher.pubTopic(i) = ros2publisher(obj.pubTopic(i),obj.pubName{1,i});
                end
            end
        end

%         function ROS2Callback(obj,message)
%             obj.pose = message.subscriber.subtopic.LatestMessage;
%         end
        
        function [ret] = getData(obj)
            %
            %   詳細説明をここに記述
%             if isempty(obj.init_time)
%                 obj.init_time = rostime('now');
%             end
%             t = rostime('now') - obj.init_time;
%             obj.result.time = double(t.Sec)+double(t.Nsec)*10^-9;
            for i = 1:obj.subTopicNum
%                 obj.result.(obj.subName(i)) = receive(obj.subscriber.(obj.subName(i)),10);
%                 obj.result = receive(obj.subscriber.subTopic(i),10);
                obj.result = obj.subscriber.subtopic.LatestMessage; % 変更
            end
            ret = obj.result;
        end

        function ROS2Callback(obj,message)
            obj.pose = message.subscriber.subtopic.LatestMessage;
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
            clear obj.node
        end
    end
end


classdef ROS2_CONNECTOR < handle
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
        % subTopic%%%%%%%%%%%%%%%%%%%%%%%%yoshida消
        nodename%%%%%%%%%%%%%%%%%%%%%%%%%%yoshida増
        subName % 受信msg を格納するresult構造体のフィールド（配列）
        subMsg
        %- Publisher topic -%
        pubTopicNum
        pubTopic
        pubName % 送信msgを格納するpubMsg構造体のフィールド名配列
        pubMsg
%         pubMsg  % 送信msg
    end

    properties(SetAccess=private)
        TimeOut = 1.e-3; % この時間はどこから？必要？
        ID
    end

    methods
        function obj = ROS2_CONNECTOR(info)
            disp('Preparing connection to robot operating system...');
            %-- Configulations for ROS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%旧
            % setenv("ROS_DOMAIN_ID","30");
            % obj.subTopic = info.subTopic;
            % obj.subName = info.subTopicName;
            % obj.subTopicNum = length(obj.subName);
            % obj.subMsg = info.subMsgName;            
            % if isfield(info,'pubTopic')
            %     obj.pubMsg = info.pubMsgName;
            %     obj.pubTopic = info.pubTopic;
            %     obj.pubName = info.pubTopicName;
            %     obj.pubTopicNum = length(obj.pubTopic);
            % end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%旧
            %-- Configulations for ROS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%新規
            obj.nodename = info.nodename;
            obj.subName = info.subTopicName{1};
            obj.subMsg = info.subMsgName{1};
            obj.subTopicNum = length(obj.subName);
            if isfield(info,'pubTopicName')
                obj.pubMsg = info.pubMsgName;
                obj.pubName = info.pubTopicName;
                obj.pubTopicNum = length(obj.pubName);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%新規



            %-- Setting the environment variables to connect to ROS
            obj.DomainID = info.nodename.ID;

            %ROS2のトピック一覧
            % ros2("topic","list","DomainID",obj.DomainID);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ros2("topic","list","DomainID",25);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %-- Declaring the topics, publishers and subscribers
            % for i = 1:obj.subTopicNum
            %     % obj.subscriber.subtopic(i) = ros2subscriber(obj.nodename,obj.subName{1,i},obj.subMsg{1,i},"History","keepall","Reliability","besteffort");
            %     obj.subscriber.subtopic = ros2subscriber(obj.nodename,obj.subName,obj.subMsg, ...
            %         @obj.getData,"History","keepall","Reliability","besteffort");
            % end
            obj.subscriber.subtopic = ros2subscriber(obj.nodename,obj.subName,obj.subMsg,@obj.getData,"History","keepall","Reliability","besteffort");
            if isfield(info,'pubTopicName')
                for i = 1: obj.pubTopicNum
                    % obj.publisher.pubTopic(i) = ros2publisher(obj.pubTopic(i),obj.pubName{i,1});
                    obj.publisher.pubTopic(i) = ros2publisher(obj.nodename,obj.pubName{i,1},obj.pubMsg{1,i});
                end
            end
        end

        function getData(obj,message)%%%%%callbackに変更
            %
            %   詳細説明をここに記述
%             if isempty(obj.init_time)
%                 obj.init_time = rostime('now');
%             end
%             t = rostime('now') - obj.init_time;
%             obj.result.time = double(t.Sec)+double(t.Nsec)*10^-9;

            % for i = 1:obj.subTopicNum
            %     % receive(obj.subscriber.subtopic(i));
            %     obj.result{i} = message;
            % end
            obj.result = message;
        end

        function sendData(obj,msg)
            % send msg : msg is allowed to be following two forms
            % msg = {msg1, msg2, ...} : order corresponding to pubTopic
            % or 
            % msg = struct('topic_name1',value1,'topic_name2',value2,...)
            
            if isstruct(msg)
                for i = 1:obj.pubTopicNum
                    
                    send(obj.publisher.pubTopic(i), msg);
                end
            else
                for i = 1:obj.pubTopicNum
                    
                    send(obj.publisher.pubTopic(i), msg);
                end
            end
        end

        function delete(obj)
            clear obj.node
        end
    end
end


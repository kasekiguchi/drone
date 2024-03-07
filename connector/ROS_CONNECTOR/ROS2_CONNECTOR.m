classdef ROS2_CONNECTOR < handle
% 【Input】info : require following fields
%   node
%   subTopic.{\topicname,messagetype,Hz}
%   pubTopic.{\topicname,messagetype}
    properties        
        Nodename            %node名．表示用
        DomainID            %nodeのドメインID．表示用
        Node                %ros2node:subscriver, publisherを生成するのに必要

        subName             %subscriveするトピック名．表示用
        subMsg              %subscriveするトピックのメッセージタイプ．表示用
        subscriber          %生成したsubscriverを格納
        
        pubName             %publishするトピック名．表示用
        pubMsg              %publishするトピックのメッセージタイプ．表示用
        publisher           %生成したpublisherを格納
        
        Hz=1000             %データを受け取る周期:getDataでpauseする
        subtopicdata        %callbackで受け取ったデータを格納しておく変数:常時変わる
        result              %common
    end

    methods
        function obj = ROS2_CONNECTOR(info)
            %ros2用コネクタークラス
            %以下のように引き数を入れてください．subとpubは1つずつ入れてください
            %セットするnode        　　　:info.node
            %subscriveするトピックデータ：info.subTopic.{\topicname,messagetype,Hz}
            %publishするトピックデータ  ：info.pubTopic.{\topicname,messagetype}
            disp('Preparing connection to robot operating system...');
            %-- Configulations for ROS2 --%
            obj.Node = info.node;
            obj.DomainID = info.node.ID;
            obj.Nodename = info.node.Name;
            % obj.Nodename = Name;
            if isfield(info,'subTopic')
                if ~isempty(info.subTopic{1})
                obj.subName  = info.subTopic{1,1};
                obj.subMsg   = info.subTopic{1,2};
                if length(info.subTopic) > 2
                    obj.Hz  = info.subTopic{1,3}; 
                end
                obj.subscriber.subtopic = ros2subscriber(obj.Node,obj.subName,obj.subMsg,@obj.sub_callback,"History","keepall","Reliability","besteffort");
                end
            end
            if isfield(info,'pubTopic')
                if ~isempty(info.pubTopic{1})
                obj.pubName = info.pubTopic{1,1};
                obj.pubMsg  = info.pubTopic{1,2};
                obj.publisher.pubTopic = ros2publisher(obj.Node,obj.pubName,obj.pubMsg);
                obj.publisher.pubmsg   = ros2message(obj.pubMsg);
                end
            end

            % if isfield(info,'subTopic')
            %     obj.subscriber.subtopic = ros2subscriber(obj.nodename,obj.subName,obj.subMsg,@obj.sub_callback,"History","keepall","Reliability","besteffort");
            % end
            % if isfield(info,'pubTopic')
            %     obj.publisher.pubTopic = ros2publisher(obj.nodename,obj.pubName,obj.pubMsg);
            %     obj.publisher.pubmsg   = ros2message(obj.pubMsg);
            % end
        end

        function result = getData(obj)
            %Display warning message when there are no subscribers
            if isempty(obj.subName)
                warning("It isn't subscriber")
            end
            while(1)
                pause(1/obj.Hz)
                result = obj.subtopicdata;
                if ~isempty(result); break; end
                str = "toipic data " + obj.subName + " lost";
                disp(str)   
            end
            obj.result=result;
        end
        function sub_callback(obj,message)%%%%
            %callback function
            obj.subtopicdata = message;
        end

        function sendData(obj,msg)
            obj.publisher.pubmsg = msg;
            send(obj.publisher.pubTopic, msg);
        end

        function delete(obj)
            clear obj.node
        end
    end
end


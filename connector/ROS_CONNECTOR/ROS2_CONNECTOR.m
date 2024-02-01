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
        
        nodename            %ros2node:subscriver, publisherを生成するのに必要
        %- Subscriber topic -%        
        subName             %subscriveするトピック名
        subMsg              %subscriveするトピックのメッセージタイプ
        subscriber          %生成したsubscriverを格納
        %- Publisher topic -%
        pubName             %publishするトピック名
        pubMsg              %publishするトピックのメッセージタイプ
        publisher           %生成したpublisherを格納

        Hz=1000               %データを受け取る周期:getDataでpauseする
        subtopicdata        %callbackで受け取ったデータを格納しておく変数:常時変わる
    end

    properties(SetAccess=private)
        TimeOut = 1.e-3; % この時間はどこから？必要？
        ID
    end

    methods
        function obj = ROS2_CONNECTOR(info)
            %ros2のコネクタークラス
            %以下のように引き数を入れてください．subとpubは1つずつ入れてください
            %セットするnode        　　　:info.node
            %subscriveするトピックデータ：info.subTopic.{\topicname,messagetype,Hz}
            %publishするトピックデータ  ：info.pubTopic.{\topicname,messagetype}
            disp('Preparing connection to robot operating system...');
            %-- Configulations for ROS2 --%
            obj.nodename = info.node;
            if isfield(info,'subTopic')
                obj.subName  = info.subTopic{1,1};
                obj.subMsg   = info.subTopic{1,2};
                if length(info.subTopic) > 2
                    obj.Hz       = info.subTopic{1,3}; 
                end
            end
            if isfield(info,'pubTopic')
                obj.pubName = info.pubTopic{1,1};
                obj.pubMsg  = info.pubTopic{1,2};
            end

            if isfield(info,'subTopic')
                obj.subscriber.subtopic = ros2subscriber(obj.nodename,obj.subName,obj.subMsg,@obj.sub_callback,"History","keepall","Reliability","besteffort");
            end
            if isfield(info,'pubTopic')
                obj.publisher.pubTopic = ros2publisher(obj.nodename,obj.pubName,obj.pubMsg);
                obj.publisher.pubmsg   = ros2message(obj.pubMsg);
            end
        end

        function [ret] = getData(obj)
            %Display warning message when there are no subscribers
            if isempty(obj.subName)
                warning("It isn't subscriber")
            end
            while(1)
                pause(1/obj.Hz)
                ret = obj.subtopicdata;
                if ~isempty(ret); break; end
                str = "toipic data " + obj.subName + " lost";
                disp(str)   
            end
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


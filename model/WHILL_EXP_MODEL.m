classdef WHILL_EXP_MODEL < MODEL_CLASS
% Whill 実験用モデル->MODEL_CLASSをスーパークラスにもつ
% plantクラス：resultは持たない
properties % (Access=private)
    IP          %実機の持つ固定数値
    connector   %コネクタークラスの実体
    phase       %操作段階 % q : quit, s : stop, r : run
    conn_type   %実機との接続方法の指定
end

properties
    msg
end

methods

    function obj = WHILL_EXP_MODEL(varargin)
        obj@MODEL_CLASS(varargin{:});%スーパークラスのコンストラクタを呼び出し
        param = varargin{2}.param; 
        %% variable set
        obj.phase = 's';
        obj.conn_type = param.conn_type;

        switch obj.conn_type
            case "udp"
                obj.IP = param.num;
                [~, cmdout] = system("ipconfig");
                ipp = regexp(cmdout, "192.168.");
                cmdout2 = cmdout(ipp(1) + 8:ipp(1) + 11);
                param.IP = strcat('192.168.50', '.', string(100 + obj.IP));
                %param.IP=strcat('192.168.',cmdout2(1:regexp(cmdout2,".")),'.',string(100+obj.IP));
                %param.IP=strcat('192.168.50.',string(obj.IP));
                param.port = 8000 + obj.IP;
                obj.connector = UDP_CONNECTOR(param);
                fprintf("Whill %s is ready\n", param.IP);
            case "serial"
                obj.connector = SERIAL_CONNECTOR(param);
                fprintf("Whill %d is ready\n", param.port);
            case "ros"
                obj.IP = param.id;
                %[~, cmdout] = system("ipconfig");
                %ipp = regexp(cmdout, "192.168.");
                %cmdout2 = cmdout(ipp(1) + 8:ipp(1) + 11);
                %param.ROSHostIP = strcat('192.168.50', '.', string(100 + obj.IP));
                param.DomainID = obj.IP;
                param.subTopicName = {'/odom', ...
                                      '/scan'};
                param.pubTopicName = {'/cmd_vel'};
                param.subMsgName = {'nav_msgs/Odometry', ...
                                    'sensor_msgs/LaserScan'};
                param.pubMsgName = {'geometry_msgs/Twist'};
                subnum = length(param.subTopicName);
                pubnum = length(param.pubTopicName);

                for i = 1:subnum
                    param.subTopic(i) = ros2node("/submatlab", obj.IP);
                end

                for i = 1:pubnum
                    param.pubTopic(i) = ros2node("/pubmatlab", obj.IP);
                end

                obj.connector = ROS2_CONNECTOR(param);
                fprintf("Whill %d is ready\n", obj.IP);
                obj.state = obj.connector.result;
                %                 obj.result.state.p = [state.pose.position.z,state.pose.position.x];
                %                 obj.result.state.qq = [state.pose.orientation.w,state.pose.orientation.x,state.pose.orientation.y,state.pose.orientation.z];
                %                 obj.result.state.eq = quat2eul(obj.result.state.qq);
                % obj.state.p = [state.anguluar.z,state.linear.x];
                % obj.state.qq = [state.pose.orientation.w,state.pose.orientation.x,state.pose.orientation.y,state.pose.orientation.z];
                % obj.state.eq = quat2eul(obj.state.qq);
            case "ros2"
                obj.id = param.id;
                param.node = ros2node("/agent_"+string(obj.id), obj.id); % % % % % % % % % % % % %create node
                obj.IP = param.node;
                obj.connector = ROS2_CONNECTOR(param);
                obj.msg = obj.connector.publisher.pubmsg;
                fprintf("Whill %d is ready\n", obj.id);
        end

    end

    function do(obj, varargin)
        t = varargin{1}.t;
        cha = varargin{2};       
       
        u = obj.self.controller.result.input;%コントローラで生成した入力を持ってくる
        if abs(u(1))>2 || abs(u(2))>2
            cha = 'q';
        end

         obj.phase = cha;
        switch cha
            case 'q' % quit
                obj.msg.linear.x = 0.0;
                obj.msg.angular.z = 0.0;
                obj.connector.sendData(obj.msg);
                error("ACSL : quit experiment");
            case 's' % stop
                obj.msg.linear.x = 0.0;
                obj.msg.angular.z = 0.0;
                hold off
            case 'a' % stop
                % obj.self.controller.result.input = [0; 0];
                obj.self.input_transform.result = [];
                obj.msg.linear.x = 0.0;
                obj.msg.angular.z = 0.0;
                pause(0.5)
            case 't' % stop
                % obj.self.controller.result.input = [0; 0];
                obj.self.input_transform.result = [];
                obj.msg.linear.x = 0.0;
                obj.msg.angular.z = 0.0;
                % pause(0.25)
            case 'f' % run
                obj.msg.linear.x = u(1);
                obj.msg.angular.z = u(2);

        end


        obj.connector.sendData(obj.msg);
        if cha =='t'
            warning("input x is back")
        end
    end

    function set_param(obj, param)
        obj.offset = param;
    end

    function arming(obj)
        % obj.connector.sendData(gen_msg(obj.arming_msg));
    end

end

end

classdef WHILL_EXP_MODEL < MODEL_CLASS
% Whill 実験用モデル
properties % (Access=private)
    IP
    connector
    phase % q : quit, s : stop, r : run
    conn_type
    
end

properties
    msg
    data%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

methods

  function obj = WHILL_EXP_MODEL(varargin)
        obj@MODEL_CLASS(varargin{:});
        param = varargin{2}.param;
%        obj.dt = 0.2; % check
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
%                 param.subTopicName = {'/Robot_1/pose'};
                % param.subTopicName = {'/odom'};
                param.nodename = obj.self.node;
                subnum = length(param.subTopicName);
                pubnum = length(param.pubTopicName);

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
                param.node = ros2node("/agent_"+string(obj.id),obj.id);%%%%%%%%%%%%%create node
                obj.IP = param.node;
                obj.connector = ROS2_CONNECTOR(param);
                obj.state = obj.connector.result;
                fprintf("Whill %d is ready\n", obj.id);
        end
  end
  
  
function do(obj,varargin)
    t = varargin{1,1}.t; 
    % u = obj.self.controller.result.input;%%追記11/8%追追記11/9
    % u = obj.self.input_transform.result;
    cha = varargin{2};
        % if length(varargin) == 1

            % if ~isfield(varargin{1}, 'FH')
            %     error("ACSL : require figure window");
            % else
            %     FH = varargin{1}.FH; % figure handle
            % end

            % cha = get(FH, 'currentcharacter'); 
            % if (cha ~= 'q' && cha ~= 's' && cha ~= 'f')
            %     cha = obj.phase;
            % end

            obj.phase = cha;

            switch cha
                case 'q' % quit
                    obj.msg.linear.x = 0.0;
                    obj.msg.linear.y = 0.0;
                    obj.msg.linear.z = 0.0;
                    obj.msg.angular.x = 0.0;
                    obj.msg.angular.y = 0.0;
                    obj.msg.angular.z = 0.0;
                    obj.connector.sendData(obj.msg);
                    error("ACSL : quit experiment");
                case 's' % stop
                    obj.msg.linear.x = 0.0;
                    obj.msg.linearf.y = 0.0;
                    obj.msg.linear.z = 0.0;
                    obj.msg.angular.x = 0.0;
                    obj.msg.angular.y = 0.0;
                    obj.msg.angular.z = 0.0;
%                     state = obj.connector.getData();
%                     obj.result.state.p = [state.pose.position.z,state.pose.position.x];
%                     obj.result.state.qq = [state.pose.orientation.w,state.pose.orientation.x,state.pose.orientation.y,state.pose.orientation.z];
%                     obj.result.state.eq = quat2eul(obj.result.state.qq);
%                     obj.state.p = [state.pose.position.z,state.pose.position.x];
%                     obj.state.qq = [state.pose.orientation.w,state.pose.orientation.x,state.pose.orientation.y,state.pose.orientation.z];
%                     obj.state.eq = quat2eul(obj.state.qq);
                case 'f' % run
                    u = obj.self.controller.result.input;
                    % obj.self.input_transform.do(obj.self)
                    obj.msg.linear.x = u(1);
                    obj.msg.linear.y = 0.0;
                    obj.msg.linear.z = 0.0;
                    obj.msg.angular.x = 0.0;
                    obj.msg.angular.y = 0.0;
                    obj.msg.angular.z = u(2);
                case 'a'
                    obj.self.controller.result.input = [0;0];
                    obj.self.input_transform.result = 0;
                    obj.msg.linear.x = 0.0;
                    obj.msg.linear.y = 0.0;
                    obj.msg.linear.z = 0.0;
                    obj.msg.angular.x = 0.0;
                    obj.msg.angular.y = 0.0;
                    obj.msg.angular.z = 0.0;
            end

%         else % 緊急時
%             obj.msg.linear.x = 0.0;
%             obj.msg.linear.y = 0.0;
%             obj.msg.linear.z = 0.0;
%             obj.msg.angular.x = 0.0;
%             obj.msg.angular.y = 0.0;
%             obj.msg.angular.z = 0.0;
%             obj.connector.sendData(obj.msg);
% %             state = obj.connector.getData();
% %             obj.result.state.p = [state.pose.position.z,state.pose.position.x];
% %             obj.result.state.qq = [state.pose.orientation.w,state.pose.orientation.x,state.pose.orientation.y,state.pose.orientation.z];
% %             obj.result.state.eq = quat2eul(obj.result.state.qq);
% %             obj.state.p = [state.pose.position.z,state.pose.position.x];
% %             obj.state.qq = [state.pose.orientation.w,state.pose.orientation.x,state.pose.orientation.y,state.pose.orientation.z];
% %             obj.state.eq = quat2eul(obj.state.qq);
%             return;
%         end

        obj.connector.sendData(obj.msg);
    end

    function set_param(obj, param)
        obj.offset = param;
    end

end

end

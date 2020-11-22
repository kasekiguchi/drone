classdef Whill_exp < MODEL_CLASS
    % Whill 実験用モデル
    properties% (Access=private)
        IP
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
                    obj.IP = param.num;
                    [~,cmdout] = system("ipconfig");
                    ipp=regexp(cmdout,"192.168.");
                    cmdout2=cmdout(ipp(1)+8:ipp(1)+11);
                    param.ROSHostIP=strcat('192.168.50','.',string(100+obj.IP));
                    obj.connector=ROS_CONNECTOR(param);
                    fprintf("Whill %d is ready\n",param.port);
            end
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
                
                switch cha
                    case 'q' % quit
                    error("ACSL : quit experiment");
                    case's' % stop
                    case 'r' % run
                        obj.msg = u;
                end
            else % 緊急時
                return;
            end
            
            % send
            obj.connector.sendData(obj.msg);
        end
        function set_param(obj,param)
            obj.offset = param;
        end
    end
end


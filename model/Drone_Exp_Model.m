classdef Drone_Exp_Model < MODEL_CLASS
    % Lizard 実験用モデル
    properties% (Access=private)
        ESPr_num
        connector
        flight_phase % q : quit, s : stop, a : arming, t : take-off, h : hovering, f : flight, l : landing
    end
    properties
        msg
    end
    
    
    methods
        function obj = Drone_Exp_Model(args)
            obj@MODEL_CLASS([],[]);
            param=args;
            obj.dt = 0.025;
            %% variable set
            obj.flight_phase        = 's';
            switch param.conn_type
                case "udp"
                    obj.ESPr_num = param.num;
                    [~,cmdout] = system("ipconfig");
                    ipp=regexp(cmdout,"192.168.");
                    cmdout2=cmdout(ipp(1)+8:ipp(1)+11);
                    param.IP=strcat('192.168.50','.',string(100+obj.ESPr_num));
                    param.port=8000+obj.ESPr_num;
                    obj.connector=UDP_CONNECTOR(param);
                    fprintf("Drone %s is ready\n",param.IP);
                case "serial"
                    if isnumeric(param.port)
                        param.port = strcat("COM",string(param.port));
                    else
                        param.port = char(param.port);
                    end
                    obj.connector=SERIAL_CONNECTOR(param);
                    fprintf("Drone %s is ready\n",param.port);
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
                if (cha ~= 'q' && cha ~= 's' && cha ~= 'a' && cha ~= 'f'&& cha ~= 'l' && cha ~= 't')
                    cha   = obj.flight_phase;
                end
                obj.flight_phase=cha;
                switch cha
                    case 'q'  % quit
                        obj.connector.sendData(gen_msg([500 500 0 500 0 0 0 0]));
                        error("ACSL : quit experiment");
                    case 's' % stop pro
                        uroll   = 500;     upitch  = 500;     uthr    =  0;     uyaw    = 500;
                        AUX_1   =  0;     AUX_2   =  0;     AUX_3   =  0;     AUX_4   = 0;
                        msg(1,1:8) = [1100,1100,0,1100,0,0,0,0];% [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
                    case 'a' % arming
                        uroll   = 500;     upitch  = 500;     uthr    =  0;     uyaw    = 500;
                        AUX_1   = 1000;     AUX_2   =  0;     AUX_3   =  0;     AUX_4   =  0;
                        msg(1,1:8) = [1100,1100,0,1100,1000,0,0,0];%[ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
                    case 'f' % flight
                        msg(1,1:8) = u;
                    case 'l' % landing
                        msg(1,1:8) = u;
                    case 't' % take off
                        msg(1,1:8) = u;
                end
            else % 緊急時 プロペラストップ
                obj.msg=[1100 1100 0 1100 0 0 0 0];
                obj.connector.sendData(gen_msg(obj.msg));
                warning("ACSL : Emergency stop!!");
                return;
            end
            obj.connector.sendData(gen_msg(msg));
            obj.msg=msg;
        end
        function arming(obj)
            obj.connector.sendData(gen_msg([500 500 0 500 1000 0 0 0 0]));
        end
        function stop(obj)
            obj.connector.sendData(gen_msg([500 500 0 500 0 0 0 0 0]));
        end
    end
end


classdef Lizard_exp < MODEL_CLASS
    % Lizard 実験用モデル
    properties% (Access=private)
        ESPr_num
        connector
        flight_phase % q : quit, s : stop, a : arming, t : take-off, h : hovering, f : flight, l : landing
        offset = [ 1103, 1103,1103];
    end
    properties
        msg
    end
    
    
    methods
        function obj = Lizard_exp(args)
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
                    %param.IP=strcat('192.168.',cmdout2(1:regexp(cmdout2,".")),'.',string(100+obj.ESPr_num));
                    %param.IP=strcat('192.168.50.',string(obj.ESPr_num));
                    param.port=8000+obj.ESPr_num;
                    obj.connector=UDP_CONNECTOR(param);
                    fprintf("Drone %s is ready\n",param.IP);
                case "serial"
                    obj.connector=SERIAL_CONNECTOR(param);
                    fprintf("Drone %d is ready\n",param.port);
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
                        Pw = uint8([fix(obj.offset(1)/100),fix(obj.offset(2)/100),6,fix(obj.offset(3)/100),6,6,6,6,rem(obj.offset(1),100),rem(obj.offset(2),100),0,rem(obj.offset(3),100),0,0,0,0]);
                        obj.connector.sendData(Pw(1,1:16));
                        obj.msg=Pw;
                        error("ACSL : quit experiment");
                    case 's' % stop pro
                        uroll   = obj.offset(1);     upitch  = obj.offset(2);     uthr    =  600;     uyaw    = obj.offset(3);
                        AUX_1   =  600;     AUX_2   =  600;     AUX_3   =  600;     AUX_4   =  600;
                        msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
                    case 'a' % arming
                        uroll   = obj.offset(1);     upitch  = obj.offset(2);     uthr    =  600;     uyaw    = obj.offset(3);
                        AUX_1   = 1100;     AUX_2   =  1100;     AUX_3   =  600;     AUX_4   =  600;
                        msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
                    case 'f' % flight
                        msg(1,1:8) = u;
                    case 'l' % landing
                        msg(1,1:8) = u;
                    case 't' % take off
                        msg(1,1:8) = u;
                end
            else % 緊急時 プロペラストップ
                % warning("ACSL : Emergency stop!!");
                Pw = uint8([fix(obj.offset(1)/100),fix(obj.offset(2)/100),6,fix(obj.offset(3)/100),6,6,6,6,rem(obj.offset(1),100),rem(obj.offset(2),100),0,rem(obj.offset(3),100),0,0,0,0]);
                obj.connector.sendData(Pw(1,1:16));
                obj.msg=Pw;
                return;
            end
            
            % make udp data
            for j = 1:1:8
                pw(1, j + 0)   = fix(msg(1, j) / 100);
                pw(1, j + 8)   = rem(msg(1, j),  100);
            end
            
            Pw = uint8(pw);
            
            % send UDP
            obj.connector.sendData(Pw(1,1:16));
            obj.msg=Pw;
        end
        function set_param(obj,param)
            obj.offset = param;
        end
    end
end


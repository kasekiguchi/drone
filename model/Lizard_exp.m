classdef Lizard_exp < MODEL_CLASS
    % Lizard 実験用モデル
    properties% (Access=private)
        ESPr_num
        espr % connector
        IP
        flight_phase % q : quit, s : stop, a : arming, t : take-off, h : hovering, f : flight, l : landing
        %port=25000;
        port=8000;
    end
    properties
        msg
    end
    
    
    methods
        function obj = Lizard_exp(self,args)
            obj@MODEL_CLASS([],[]);
            param=args{2};
            obj.dt = 0.025;
            %% variable set
            obj.flight_phase        = 's';
            obj.ESPr_num = param.num;
            [~,cmdout] = system("ipconfig");
            ipp=regexp(cmdout,"192.168.");
            cmdout2=cmdout(ipp(1)+8:ipp(1)+11);
            param.IP=strcat('192.168.',cmdout2(1:regexp(cmdout2,".")),'.',string(100+obj.ESPr_num));
            obj.IP=param.IP;
            %obj.port=8000+obj.ESPr_num;
            param.port=obj.port;
            obj.espr=UDP_CONNECTOR(param);
            self.connector=obj.espr;
            fprintf("Drone %s is ready\n",obj.IP);
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
                
                % quit
                if cha == 'q'
                    %            if strcmp(get(FH,'currentcharacter'), 'q')
                    error("quit experiment");
                end
                
                % stop propeller
                if cha   == 's'
                    uroll   = 1100;     upitch  = 1100;     uthr    =  600;     uyaw    = 1100;
                    AUX_1   =  600;     AUX_2   =  600;     AUX_3   =  600;     AUX_4   =  600;
                    msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
                end
                
                % armnig
                if cha   == 'a'
                    uroll   = 1100;     upitch  = 1100;     uthr    =  600;     uyaw    = 1100;
                    AUX_1   = 1600;     AUX_2   =  600;     AUX_3   =  600;     AUX_4   =  600;
                    msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
                end
                if cha   == 'f'
                    msg(1,1:8) = u;
                end
                if cha   == 'l'
                    msg(1,1:8) = u;
                end
                if cha   == 't'
                    msg(1,1:8) = u;
                end
            else % 緊急時 プロペラストップ
               % warning("ACSL : Emergency stop!!");
                uroll   = 1100;     upitch  = 1100;     uthr    =  600;     uyaw    = 1100;
                AUX_1   =  600;     AUX_2   =  600;     AUX_3   =  600;     AUX_4   =  600;
                msg(1,1:8) = [ uroll, upitch, uthr, uyaw, AUX_1, AUX_2, AUX_3, AUX_4];
            end
            % make udp data
            for j = 1:1:8
                pw(1, j + 0)   = fix(msg(1, j) / 100);
                pw(1, j + 8)   = rem(msg(1, j),  100);
            end
            
            Pw = uint8(pw);
            
            % send UDP
            obj.espr.sendData(Pw(1,1:16));
            obj.msg=Pw;
        end
    end
end


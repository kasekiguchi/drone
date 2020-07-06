classdef From_ESPr < SENSOR_CLASS
    %UNTITLED5 このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        espr % connector
        IP
    end
    
    methods
        function obj = From_ESPr(self,param)
            % self : このセンサーを搭載している機体オブジェクト
            % param : 
            if isfield(self.plant,'espr')
                obj.espr = self.plant.espr;
                obj.IP = self.plant.IP;
            else
                ESPr_num = param.num;
                obj.IP=strcat('192.168.1.',string(100+ESPr_num));
                obj.espr=UDP_CONNECTOR(param);
            end
            espr.receiver.setup();
            %disp('UDPr is ready.');
        end
        
        function do(obj,param)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
                   
            % receive UDP
            %%%%%%%%%%% 9軸censorの値取得%%%%%%%%%%%
                RData = obj.espr.getData();
                msg = join(string(char(RData)),'');
                disp(msg);
%                tmp = strsplit(msg,',');
%                tmp2 = cell2mat(arrayfun(@(xx) str2double(xx), tmp, 'UniformOutput',false))
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
end


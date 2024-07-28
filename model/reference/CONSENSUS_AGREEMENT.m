classdef CONSENSUS_AGREEMENT < handle
    % 合意重心を指定して隊列を形成するクラス
    % 指定すれば各時刻における合意重心の算出も可能
    
    properties
        param
        self
        offset
        id
        result
    end
    
    methods
        %%　計算式
        function obj = CONSENSUS_AGREEMENT(self,param)
            obj.self = self;
            obj.offset = param;
            obj.result.state = STATE_CLASS(struct('state_list',["p","xd"],'num_list',[3]));
            obj.id = self.sensor.motive.rigid_num;
        end
        
        
        %% 目標位置
        function  result= do(obj,Param)
            sensor = obj.self.sensor.motive.result.rigid;%Param{1}.result;　%　他の機体の位置
            state = obj.self.estimator.result.state;%Param{2}.state; % 自己位置
            
            %             consensus_point = [0;0;0]; %合意重心
            if obj.id == 1
                x_0 = 0;
                y_0 = 0;
                t = Param{3};
                
                s = 4;
                
                x = x_0+sin(t/s);
                y = y_0+cos(t/s);
                z = 1;
                obj.result.state.xd = [x;y;z];
            else
                Wo = 0.1;
                Wd = 0.18;
                x_0 = 0;
                y_0 = 0;
                t = Param{3};
                
                s = 4; % s = 2 → period = 4*pi (12 sec)ハート1周
                
                P = obj.offset(:,obj.id)+sensor(1).p; %目標位置
                gradPx = 0;
                gradPy = 0;
                %                     if obj.self.sensor.motive.rigid_num == 2
                %                         gradPx = gradPx+Wd*(2*state.p(1)-2*P(1,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(1) - 2*sensor(1).p(1)))/(2*((state.p(1) - sensor(1).p(1))^2 + (state.p(2) - sensor(1).p(2))^2 + (state.p(3) - sensor(1).p(3))^2)^(3/2));
                %                         gradPy = gradPy+Wd*(2*state.p(2)-2*P(2,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(2) - 2*sensor(1).p(2)))/(2*((state.p(1) - sensor(1).p(1))^2 + (state.p(2) - sensor(1).p(2))^2 + (state.p(3) - sensor(1).p(3))^2)^(3/2));
                %                         gradPx = gradPx+Wd*(2*state.p(1)-2*P(1,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(1) - 2*sensor(3).p(1)))/(2*((state.p(1) - sensor(3).p(1))^2 + (state.p(2) - sensor(3).p(2))^2 + (state.p(3) - sensor(3).p(3))^2)^(3/2));
                %                         gradPy = gradPy+Wd*(2*state.p(2)-2*P(2,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(2) - 2*sensor(3).p(2)))/(2*((state.p(1) - sensor(3).p(1))^2 + (state.p(2) - sensor(3).p(2))^2 + (state.p(3) - sensor(3).p(3))^2)^(3/2));
                %                     else
                %                         gradPx = gradPx+Wd*(2*state.p(1)-2*P(1,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(1) - 2*sensor(1).p(1)))/(2*((state.p(1) - sensor(1).p(1))^2 + (state.p(2) - sensor(1).p(2))^2 + (state.p(3) - sensor(1).p(3))^2)^(3/2));
                %                         gradPy = gradPy+Wd*(2*state.p(2)-2*P(2,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(2) - 2*sensor(1).p(2)))/(2*((state.p(1) - sensor(1).p(1))^2 + (state.p(2) - sensor(1).p(2))^2 + (state.p(3) - sensor(1).p(3))^2)^(3/2));
                %                         gradPx = gradPx+Wd*(2*state.p(1)-2*P(1,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(1) - 2*sensor(2).p(1)))/(2*((state.p(1) - sensor(2).p(1))^2 + (state.p(2) - sensor(2).p(2))^2 + (state.p(3) - sensor(2).p(3))^2)^(3/2));
                %                         gradPy = gradPy+Wd*(2*state.p(2)-2*P(2,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(2) - 2*sensor(2).p(2)))/(2*((state.p(1) - sensor(2).p(1))^2 + (state.p(2) - sensor(2).p(2))^2 + (state.p(3) - sensor(2).p(3))^2)^(3/2));
                %                     end
                
                %obj.result.state.xd = P;%[state.p(1)-gradPx;state.p(2)-gradPy;0.5]; %フォロワー機の目標座標
                obj.result.state.p = P;%obj.result.state.xd;
            end
            
            result = obj.result; %返し値（次の目標位置）
        end
        
        function show(obj,param)
        end
    end
end
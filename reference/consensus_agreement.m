classdef consensus_agreement < REFERENCE_CLASS
    % 合意重心を指定して隊列を形成するクラス
    % 指定すれば各時刻における合意重心の算出も可能
    
    properties
        param
        self
        offset
    end
    
    methods
        %%　計算式
        function obj = consensus_agreement(self,param)
            obj.self = self;
            obj.offset = param;
            obj.result.state = STATE_CLASS(struct('state_list',["p"],'num_list',[3]));
        end

            
       %% 目標位置
        function  result= do(obj,Param)
            sensor = obj.self.sensor.result;%Param{1}.result;　%　他の機体の位置
            state = obj.self.estimator.result.state;%Param{2}.state; % 自己位置

            ni = size(sensor.neighbor,2);%センサレンジ内にある他機体の位置情報
%             consensus_point = [0;0;0]; %合意重心
            if obj.self.id == 1
                r=1;
                theta = linspace(0,2*pi,1000);
                x = r*cos(theta(Param{1}.i));
                y = r*sin(theta(Param{1}.i));
                z = 1;
                obj.result.state.p = [x;y;z];
            else
                if ni==0 %近くに他の機体がいない
                    obj.result.state.p = state.p;
                else
                    r=1;
                    theta = linspace(0,2*pi,1000);
                    x = r*cos(theta(Param{1}.i));
                    y = r*sin(theta(Param{1}.i));
                    z = 1;
                    for i=1:ni
                        Po(:,i) = 1/sqrt((state.p(1) - sensor.neighbor(1,i))^2+(state.p(3) - sensor.neighbor(3,i))^2+(state.p(3) - sensor.neighbor(3,i))^2); %障害物（他機体）のポテンシャル関数
                    end
                    Xd = [x;y;z]+obj.offset(:,obj.self.id); %目標座標
                    for i=2:Param{2}
                        Pd(:,i) = -1/sqrt((state.p(1) - Xd(1))^2+(state.p(2) - Xd(2))^2+(state.p(3) - Xd(3))^2); %目標値のポテンシャル関数
                    end
                    wo = 1;
                    wd = 1;
                    for i = 2:Param{2}
                        P(:,i) = wo*sum(Po,2) + wd*Pd(:,i);
                    end
                    obj.result.state.p = [x;y;z]+obj.offset(:,obj.self.id);;%-diff(P(:,obj.self.id)); %合意重心を設定して隊列を形成
                    
%                     obj.result.state.p = (state.p+(ni+1)*(obj.offset(:,obj.self.id))+sum(sensor.neighbor,2))/(ni+1); %逐次合意重心を算出
                end
            end

            result = obj.result; %返し値（次の目標位置）
        end
        
        function show(obj,param)
        end
    end
end
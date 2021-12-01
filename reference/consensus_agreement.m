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
            obj.result.state = STATE_CLASS(struct('state_list',["p","xd"],'num_list',[3]));
        end

            
       %% 目標位置
        function  result= do(obj,Param)
            sensor = obj.self.sensor.result;%Param{1}.result;　%　他の機体の位置
            state = obj.self.estimator.result.state;%Param{2}.state; % 自己位置

            ni = size(sensor.neighbor,2);%センサレンジ内にある他機体の位置情報
%             consensus_point = [0;0;0]; %合意重心
            if obj.self.id == 1
                r=1;
                theta= linspace(0,2*pi,1000);
                obj.result.state.xd = [r*cos(theta(Param{1}.i));r*sin(theta(Param{1}.i));0.5];
            else
                if ni==0 %近くに他の機体がいない
                    obj.result.state.xd = [state.p(1:2);0];
                else
                    r=1;
                    Wo = 0.1;
                    Wd = 0.1;
                    theta= linspace(0,2*pi,1000);
                    round=zeros(2,1);
                    P = obj.offset(:,obj.self.id)+[r*cos(theta(Param{1}.i));r*sin(theta(Param{1}.i));0.5]; %目標位置
                    for i=1:ni
                        for j=1:2
                        Ao=-((state.p(1,1)-sensor.neighbor(1,i))^2+(state.p(2,1)-sensor.neighbor(2,i))^2)^(-3/2)*(state.p(j,1)-sensor.neighbor(j,i));
                        Ad=((state.p(1,1)-P(1,1))^2+(state.p(2,1)-P(2,1))^2)^(-3/2)*(state.p(j,1)-P(j,1));
                        round(j,1)=round(j,1)+Wo*Ao+Wd*Ad;
                        end
                    end
                    gradPx = 0;
                    gradPy = 0;
                    gradPz = 0;
                    for i=1:ni
                        gradPx = gradPx+Wd*(2*state.p(1)-2*P(1,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(1) - 2*sensor.neighbor(1,i)))/(2*((state.p(1) - sensor.neighbor(1,i))^2 + (state.p(2) - sensor.neighbor(2,i))^2 + (state.p(3) - sensor.neighbor(3,i))^2)^(3/2));
                        gradPy = gradPy+Wd*(2*state.p(2)-2*P(2,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(2) - 2*sensor.neighbor(2,i)))/(2*((state.p(1) - sensor.neighbor(1,i))^2 + (state.p(2) - sensor.neighbor(2,i))^2 + (state.p(3) - sensor.neighbor(3,i))^2)^(3/2));
                        gradPz = gradPz+Wd*(2*state.p(3)-2*P(3,1))/(2*((state.p(1) - P(1,1))^2 + (state.p(2) - P(2,1))^2 + (state.p(3) - P(3,1))^2)^(3/2)) - (Wo*(2*state.p(3) - 2*sensor.neighbor(3,i)))/(2*((state.p(1) - sensor.neighbor(1,i))^2 + (state.p(2) - sensor.neighbor(2,i))^2 + (state.p(3) - sensor.neighbor(3,i))^2)^(3/2));
                    end
                    obj.result.state.xd = [state.p(1)-gradPx;state.p(2)-gradPy;0.5];%[state.p(1)+round(1);state.p(2)+round(2);0.5]; %合意重心を設定して隊列を形成
                end
            end
            
%             if obj.self.id == 1
%                 theta = linspace(0,2*pi,Param{3}/Param{4}+1);
%                 x = cos(theta(Param{1}.i));
%                 y = sin(theta(Param{1}.i));
%                 z = 1;
%                 round=zeros(2,1);
%                 for i=0:1:ni-1
%                     Ao=-((state.p(1,1)-sensor.neighbor(1,i))^2+(state.p(2,1)-sensor.neighbor(2,i))^2)^(-3/2);
%                     Ad=((state.p(1,1)-x)^2+(state.p(2,1)-y)^2)^(-3/2)*(state.p(1,1)-x);
%                 obj.result.state.xd = [x;y;z];
%             else
%                 if ni==0 %近くに他の機体がいない
%                     obj.result.state.xd = state.p;
%                 else
%                     theta = linspace(0,2*pi,Param{3}/Param{4}+1);
%                     x = cos(theta(Param{1}.i));
%                     y = sin(theta(Param{1}.i));
%                     z = 1;
% %                     for i=1:ni
% %                         Po(:,i) = 1/sqrt((state.p(1) - sensor.neighbor(1,i))^2+(state.p(3) - sensor.neighbor(3,i))^2+(state.p(3) - sensor.neighbor(3,i))^2); %障害物（他機体）のポテンシャル関数
% %                     end
% %                     Xd = [x;y;z]+obj.offset(:,obj.self.id); %目標座標
% %                     for i=2:Param{2}
% %                         Pd(:,i) = -1/sqrt((state.p(1) - Xd(1))^2+(state.p(2) - Xd(2))^2+(state.p(3) - Xd(3))^2); %目標値のポテンシャル関数
% %                     end
% %                     wo = 1;
% %                     wd = 1;
% %                     for i = 2:Param{2}
% %                         P(:,i) = wo*sum(Po,2) + wd*Pd(:,i);
% %                     end
%                     obj.result.state.xd = [x;y;z]+obj.offset(:,obj.self.id); %合意重心を設定して隊列を形成
%                     
% %                     obj.result.state.p = (state.p+(ni+1)*(obj.offset(:,obj.self.id))+sum(sensor.neighbor,2))/(ni+1); %逐次合意重心を算出
%                 end
%             end
%                 theta = linspace(0,2*pi,Param{3}/Param{4}+1);
%                 x = cos(theta(Param{1}.i));
%                 y = sin(theta(Param{1}.i));
%                 z = 1;
%                 obj.result.state.xd = [x;y;z];
            result = obj.result; %返し値（次の目標位置）
        end
        
        function show(obj,param)
        end
    end
end
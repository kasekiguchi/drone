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
        function  result= do(obj,param)
            sensor = obj.self.sensor.result;%Param{1}.result;　%　他の機体の位置
            state = obj.self.estimator.result.state;%Param{2}.state; % 自己位置

            ni = size(sensor.neighbor,2);%センサレンジ内にある他機体の位置情報
            consensus_point = [0;0;0]; %合意重心
            if ni==0 %近くに他の機体がいない
                obj.result.state.p = state.p;
            else
                obj.result.state.p = consensus_point+obj.offset(:,obj.self.id); %合意重心を設定して隊列を形成
%                 obj.result.state.p = (state.p+(ni+1)*(obj.offset(:,obj.self.id))+sum(sensor.neighbor,2))/(ni+1); %逐次合意重心を算出
            end
            result = obj.result;
        end
        
        function show(obj,param)
        end
    end
end
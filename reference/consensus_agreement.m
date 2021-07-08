classdef consensus_agreement < REFERENCE_CLASS
    % 合意重心を算出するクラス
    %   詳細説明をここに記述
    
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

            ni = size(sensor.neighbor,2);
            if ni==0
                obj.result.state.p = state.p;
            else
%                 obj.result.state.p = [1;0;0]+obj.offset(:,obj.self.id);
                obj.result.state.p = (state.p+(ni+1)*(obj.offset(:,obj.self.id))+sum(sensor.neighbor,2))/(ni+1); %逐次合意点を算出
            end
            result = obj.result;
        end
        
        function show(obj,param)
        end
    end
end
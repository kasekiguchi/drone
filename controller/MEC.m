classdef MEC <CONTROLLER_CLASS    
     properties
         self
         old_state
         old_input
     end
    methods
        function obj = MEC(self,~)
            obj.self = self;
            obj.old_state = state_copy(self.model.state);
        end
        
        function u = do(obj,param,varargin)
            % param = {...}
            % varargin : nominal input
            if isempty(varargin)
                error("ACSL : ");
            else
                input = varargin{1}.input;
            end
            if isempty(obj.old_input)
                obj.old_input = input;
            end
            obj.self.model.state.set_state(obj.old_state.get()); % １時刻前の推定結果にmodelの状態を変更
            obj.self.model.do(obj.old_input); % 現在状態をmodelと実際に印可した入力から予測（事前予測）

            obj.result.input = input;
            u = obj.result;

            obj.old_input= obj.result.input; % 実際に印可する入力を保存
            obj.old_state.set_state(obj.self.estimator.result.state.get());  % 推定器の推定結果を保存
            obj.self.model.state.set_state(obj.self.estimator.result.state.get());  % 推定器の推定結果に戻す
        end
        function show(obj)
            obj.result;
        end
    end
end


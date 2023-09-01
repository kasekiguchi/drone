classdef MEC < handle
%別のControllerと併用する実入力へ補償を行うMEC
     properties
         self
         old_state
         old_input
         K%補償ゲイン inputの次元に合わせる 参考 大石さん
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
            obj.self.model.state.set_state(obj.old_state.get()); % 1時刻前の推定結果にmodelの状態を変更
            obj.self.model.do(obj.old_input); % 現在状態をmodelと実際に印可した入力から予測（事前予測）
            
%             y = obj.self.model.state.p;
%             y_n = obj.old_state.p;

            %referenceの値を目標値,estimatorの値を現在値として回す
            y         = obj.self.estimator.result.state.p;  %１時刻前のestimatorの値をyに代入
            y_n     = obj.self.reference.result.state.p;  %１時刻前のreferenceの値をy_nに代入
            
            
            delta_y = y_n - y; %理想的な出力との誤差
            delta_u = obj.K*delta_y; %補償入力
            
            obj.result.input = input + delta_u;
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


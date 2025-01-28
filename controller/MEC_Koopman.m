classdef MEC_Koopman < handle
    % MCMPC_CONTROLLER MPCのコントローラー
    % Imai Case study 
    % 勾配MPCコントローラー

    properties
%         options
        param
        current_state
        previous_input
        previous_state
        input
        state
        const
        reference
        fRemove
        model
        result
        self
    end

    properties
        A
        B
        C
        old_state
        old_input
        K
        F
    end

    methods
        function obj = MEC_Koopman(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            obj.A = obj.param.A;
            obj.B = obj.param.B;
            obj.C = obj.param.C;
            obj.F = obj.param.F;

            obj.K = 1;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値
            obj.old_state = state_copy(self.plant.state);
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            % tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?

            if isempty(varargin)
                error("ACSL : ");
            else
                input = varargin{3}.controller.result.input;
            end
            if isempty(obj.old_input)
                obj.old_input = input;
            end 
            
            obj.self.plant.state.set_state(obj.old_state.get()); % 1時刻前の推定結果にmodelの状態を変更
            obj.self.controller.result.input = obj.old_input; % plant.doのために書き換え
            obj.self.plant.do(varargin{1}, varargin{2}, varargin{3}); % 現在状態をplantと実際に印可した入力から予測（事前予測） 微分方程式
            

            %referenceの値を目標値,estimatorの値を現在値として回す
            y         = obj.self.estimator.result.state.p;  %１時刻前のestimatorの値をyに代入
            y_n       = obj.self.reference.result.state.p;  %１時刻前のreferenceの値をy_nに代入
            
            % 
            % delta_y = y_n - y; %理想的な出力との誤差
            % delta_u = obj.K*delta_y; %補償入力

            %% delta_u を求めるためにクープマンモデルを用いる
            Koopman_state = update_state(); % クープマンモデルによるモデルの計算
            obj.result.input = input + delta_u;
            u = obj.result;

            obj.old_input= obj.result.input; % 実際に印可する入力を保存
            obj.old_state.set_state(obj.self.estimator.result.state.get());  % 推定器の推定結果を保存
            obj.self.model.state.set_state(obj.self.estimator.result.state.get());  % 推定器の推定結果に戻す
        end
        function show(obj)
            obj.result
        end
        function x = update_state(obj)
            z = obj.F(obj.old_state.get());
            x = obj.A*z+obj.B*obj.old_input;
        end
    end
end

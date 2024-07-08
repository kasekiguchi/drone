classdef MPC_CONTROLLER_KOOPMAN_quadprog_simulation < handle
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
        weight
        weightF
        weightR
        A
        B
        C
        H
        qpparam
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_quadprog_simulation(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存
            obj.H = obj.param.H;

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            obj.A = obj.param.A;
            obj.B = obj.param.B;
            obj.C = obj.param.C;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.H);
            obj.weight  = blkdiag(obj.param.weight.P, obj.param.weight.V, obj.param.weight.QW);
            obj.weightF = blkdiag(obj.param.weight.Pf,obj.param.weight.Vf,obj.param.weight.QWf);
            obj.weightR = obj.param.weight.R;

            %% QP change_equationの共通項をあらかじめ計算
            Param = struct('A',obj.param.A,'B',obj.param.B,'C',obj.param.C,'weight',obj.weight,'weightF',obj.weightF,'weightR',obj.weightR,'H',obj.H);
            [obj.qpparam.H, obj.qpparam.F] = change_equation_drone(Param);
            % H: 変数
            % F: fを生成するために必要な行列
            obj.result.setting.weight = struct('Q',obj.weight,'Qf',obj.weightF,'R',obj.weightR);
            obj.result.setting.A = obj.param.A;
            obj.result.setting.B = obj.param.B;
            obj.result.setting.C = obj.param.C;
        end

        %-- main()的な
        function result = do(obj,varargin)
            % profile on
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?

            obj.param.t = varargin{1}.t;
            rt = obj.param.t; %時間
            idx = round(rt/varargin{1}.dt+1); %プログラムの周回数
            obj.current_state = obj.self.estimator.result.state.get(); %実機のときコメントアウト
            obj.reference.xr = obj.Reference(rt); %リファレンスの更新
 
            obj.previous_state = repmat(obj.current_state, 1, obj.H);
      
            %% ------------------------------------------------------------
            % 最適化部分の関数化とmex化
            Param = struct('current_state',obj.current_state,'ref',obj.reference.xr,'qpH', obj.qpparam.H, 'qpF', obj.qpparam.F,'lb',obj.param.input.lb,'ub',obj.param.input.ub,'previous_input',obj.previous_input,'H',obj.H);
            [var, fval, exitflag] = quad_drone_mex(Param); %自PCでcontroller:0.6ms, 全体:2.7ms
            % [var, fval, exitflag] = quad_drone(Param);
                 
            %%
            obj.previous_input = var;
            obj.result.input = var(1:4, 1); % 印加する入力 4入力

            %% データ表示用
            obj.input.u = obj.result.input; 
            calT = toc
            obj.result.mpc.calt = calT; %計算時間保存したいときコメントイン
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;

            %% 保存するデータ
            result = obj.result; % controllerの値の保存

            %% 情報表示
            state_monte = obj.self.estimator.result.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1), state_monte.q(2), state_monte.q(3), ...
                    state_monte.w(1), state_monte.w(2), state_monte.w(3));       % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
                    obj.reference.xr(1,1), obj.reference.xr(2,1), obj.reference.xr(3,1),...
                    obj.reference.xr(7,1), obj.reference.xr(8,1), obj.reference.xr(9,1),...
                    obj.reference.xr(4,1), obj.reference.xr(5,1), obj.reference.xr(6,1), ...
                    obj.reference.xr(10,1), obj.reference.xr(11,1), obj.reference.xr(12,1))  % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
                rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
            fprintf("\n");
            % profile viewer

            %% z < 0で終了
            if obj.self.estimator.result.state < 0
                warning("墜落しました")
            end
            
        end
        function show(obj)
            obj.result
        end

        function [xr] = Reference(obj, T)
            % パラメータ取得
            % timevaryingをホライズンごとのreferenceに変換する
            % params.dt = 0.1;
            xr = zeros(obj.param.total_size, obj.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.H-1
                t = T + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            end
        end
    end
end

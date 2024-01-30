classdef MPC_CONTROLLER_KOOPMAN_quadprog < handle
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
        InputTransform
        time
        inifTime
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_quadprog(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存

            %%
            obj.input = obj.param.input;
            % obj.const = param.const;
            % obj.input.v = obj.input.u;   % 前ステップ入力の取得，評価計算用
%             obj.param.H = obj.param.H + 1;
            obj.model = self.plant;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.param.H);
            obj.InputTransform=THRUST2FORCE_TORQUE(self,1);
            obj.time = [];
            obj.inifTime =[];

        end

        %-- main()的な
        function result = do(obj,varargin)
          %実機でMPCを飛ばすときに必要(fから回すとき)-----------------------
          % var = varargin{1};
          % % if isempty(obj.inifTime) && var{2} =='f'
          % %     obj.inifTime = var{1}.t;
          % %     obj.result.fTime = 0;
          % % elseif var{2} =='f'
          % %     obj.result.fTime = var{1}.t - obj.inifTime;
          % % end
          % obj.param.t = var.t; %実機のときコメントイン
          %--------------------------------------------------
           
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?

            %シミュレーション時コメントイン--------------------------------
            obj.param.t = varargin{1}.t;
            rt = obj.param.t; %時間
            idx = round(rt/varargin{1}.dt+1); %プログラムの周回数
            obj.current_state = obj.self.estimator.result.state.get(); %実機のときコメントアウト
            obj.state.ref = obj.Reference(rt); %リファレンスの更新
            %-------------------------------------------------------------

            %実機のときコメントイン(aから回す)-----------------------------------------
            % vara = varargin{1};
            % obj.param.t = vara{1}.t;
            % rt = obj.param.t; %時間
            % % idx = round(rt/vara{1}.dt+1); %プログラムの周回数
            % 
            % if vara{2} == 'a'
            %     obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input],1,obj.param.H);
            %     obj.current_state = [0;0;1;0;0;0;0;0;0;0;0;0];
            % elseif vara{2} == 't'
            %     obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input],1,obj.param.H);
            %     obj.current_state = [0;0;1;0;0;0;0;0;0;0;0;0];
            %     fprintf('take off')
            % elseif vara{2} == 'f'
            %     obj.state.ref = obj.Reference(rt); %リファレンスの更新
            %     obj.current_state = obj.self.estimator.result.state.get(); %現在状態
            %     fprintf('flight')
            % end
            %-------------------------------------------------------------------------

            Param = obj.param;
            Param.current = obj.current_state;
            Param.ref = obj.state.ref;        
            obj.previous_state = repmat(obj.current_state, 1, obj.param.H);
            
            % MPC設定(problem)
            %-- fmincon 設定
            % options = optimoptions('quadprog','Algorithm','active-set');
            options = optimoptions('quadprog');
            %     options = optimoptions(options,'Diagnostics','off');
            %     options = optimoptions(options,'MaxFunctionEvaluations',1.e+12);     % 評価関数の最大値
            options = optimoptions(options,'MaxIterations',      1.e+9); % 最大反復回数
            options = optimoptions(options,'ConstraintTolerance',1.e-5);     % 制約違反に対する許容誤差

            %-- quadprog設定
            options.Display = 'none';   % 計算結果の表示
            problem.solver = 'quadprog'; % solver

            [H, f] = change_equation(Param);
            A = [];
            b = [];
            Aeq = [];
            beq = [];
            lb = [];
            ub = [];
            x0 = [obj.previous_input(:)];
              
            [var, fval, exitflag, ~, ~] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, options, problem); %最適化計算
      
            %%
            obj.previous_input = var;
            var;
            
            % 実機のときコメントイン--------------------------------------------
            % if vara{2} == 'a'
            %     obj.result.input = [0;0;0;0];
            % else
            %     obj.result.input = var(1:4, 1); % 印加する入力 4入力
            % end
            %------------------------------------------------------------------

            %シミュレーション時コメントイン--------------------------------------------
            obj.result.input = var(1:4, 1); % 印加する入力 4入力
            % obj.result.transformedInput = obj.InputTransform.do(obj.result.input); %4入力を総推力に変換(必要に応じて)
            %---------------------------------------------------------------------------

%-----------------実機で飛ばすときは総推力に変換した入力をobj.result.inputに代入する----------------------
            % obj.result.input = obj.InputTransform.do(var(1:4, 1)); %4入力を総推力に変換

            %% データ表示用
            obj.input.u = obj.result.input; 
            calT = toc
            % obj.result.t(1,idx) = calT; %計算時間保存したいときコメントイン

            %% 保存するデータ
            obj.result.weight = Param.weight;
            result = obj.result; % controllerの値の保存
            % profile viewer

            %% 情報表示
            state_monte = obj.self.estimator.result.state;
            % obj.input.u = T2T(obj.input.u(1,:),obj.input.u(2,:),obj.input.u(3,:),obj.input.u(4,:)); %総推力を4入力に変換して表示
            % state_monte = obj.self.plant.state;
            fprintf("==================================================================\n")
            fprintf("==================================================================\n")
            fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
                    state_monte.p(1), state_monte.p(2), state_monte.p(3),...
                    state_monte.v(1), state_monte.v(2), state_monte.v(3),...
                    state_monte.q(1), state_monte.q(2), state_monte.q(3), ...
                    state_monte.w(1), state_monte.w(2), state_monte.w(3));       % s:state 現在状態
            fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
                    obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
                    obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
                    obj.state.ref(4,1), obj.state.ref(5,1), obj.state.ref(6,1), ...
                    obj.state.ref(10,1), obj.state.ref(11,1), obj.state.ref(12,1))  % r:reference 目標状態
            fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
                rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
%             fprintf("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            fprintf("\n");

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
            xr = zeros(obj.param.total_size, obj.param.H);    % initialize
            % 時間関数の取得→時間を代入してリファレンス生成
            RefTime = obj.self.reference.func;    % 時間関数の取得
            for h = 0:obj.param.H-1
                t = T + obj.param.dt * h; % reference生成の時刻をずらす
                ref = RefTime(t);
                xr(1:3, h+1) = ref(1:3);
                xr(7:9, h+1) = ref(5:7);
                xr(4:6, h+1) =   [0;0;0]; % 姿勢角
                xr(10:12, h+1) = [0;0;0];
                xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            end

            % if obj.flag == 0
            % % 時間関数の取得→時間を代入してリファレンス生成
            %     RefTime = obj.self.reference.func;    % 時間関数の取得
            %     for h = 0:obj.param.H-1
            %         t = T + obj.param.dt * h; % reference生成の時刻をずらす
            %         ref = RefTime(t);
            %         xr(1:3, h+1) = ref(1:3);
            %         xr(7:9, h+1) = ref(5:7);
            %         xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            %         xr(10:12, h+1) = [0;0;0];
            %         xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            %     end
            % else
            %     for h = 0:obj.param.H-1
            %         if obj.current_state(3) <= 0.75 && obj.current_state(1) <= 0
            %             obj.changeflag = 1;
            %         elseif obj.current_state(3) >= 0.95 && obj.current_state(1) >= 0.5
            %             obj.changeflag = 0;
            %         end
            %         if obj.changeflag == 1
            %             xr(1:3, h+1) = [0.5,0,1];
            %             xr(7:9, h+1) = [0,0,0];
            %             xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            %             xr(10:12, h+1) = [0;0;0];
            %             xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            %         else
            %             xr(1:3, h+1) = [0,0,0.7];
            %             xr(7:9, h+1) = [0,0,0];
            %             xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            %             xr(10:12, h+1) = [0;0;0];
            %             xr(13:16, h+1) = obj.param.ref_input; % MC -> 0.6597,   HL -> 0
            %         end
            %     end
            % end
        end
    end
end

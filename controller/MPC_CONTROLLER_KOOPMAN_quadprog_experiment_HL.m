classdef MPC_CONTROLLER_KOOPMAN_quadprog_experiment_HL < handle
    % MCMPC_CONTROLLER MPCのコントローラー
    % Imai Case study 
    % 勾配MPCコントローラー

    properties
        self
        result
        param
        parameter_name = ["mass","Lx","Ly","lx","ly","jx","jy","jz","gravity","km1","km2","km3","km4","k1","k2","k3","k4"];
    end

    properties
%         options
        current_state
        previous_input
        previous_state
        input
        state
        const
        reference
        fRemove
        model
    end

    properties
        A
        B
        C
        H
        weight
        weightF
        weightR
        qpparam
    end

    methods
        function obj = MPC_CONTROLLER_KOOPMAN_quadprog_experiment_HL(self, param)
            %-- 変数定義
            obj.self = self; %agentへの接続
            obj.param.P = self.parameter.get(obj.parameter_name);

            %---MPCパラメータ設定---%
            obj.param = param.param; %Controller_MPC_Koopmanの値を保存
            obj.H = obj.param.H;
            obj.A = obj.param.A;
            obj.B = obj.param.B;
            obj.C = obj.param.C;

            %%
            obj.input = obj.param.input;
            obj.model = self.plant;
            
            %% 入力
            obj.result.input = zeros(self.estimator.model.dim(2),1); % 入力初期値

            %% 重み　統合         
            obj.previous_input = repmat(obj.input.u, 1, obj.H);
            obj.weight = blkdiag(obj.param.weight.P, obj.param.weight.Q, obj.param.weight.V, obj.param.weight.W);
            obj.weightF = blkdiag(obj.param.weight.Pf, obj.param.weight.Qf, obj.param.weight.Vf, obj.param.weight.Wf);
            obj.weightR = obj.param.weight.R;

            %% A行列にxyzの位置を加えた拡張係数行列とする
            A_1 = [eye(3), zeros(3), eye(3)*obj.param.dt, zeros(3, size(obj.A,1)-6)];
            A_2 = [zeros(size(obj.A,2), 3), obj.A];
            obj.param.A = [A_1; A_2];
            obj.param.B = [zeros(3, 4); obj.B];
            obj.param.C = blkdiag(eye(3), obj.C);

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
            tic
            %%initialize
            time = varargin{1};
            phase = varargin{2};
            obj.param.t = time.t;
            %% phaseによるcontrollerの選択
            % result: controllerで算出された入力
            if phase == 'a'
                obj.current_state = [0;0;1;0;0;0;0;0;0;0;0;0];
                obj.state.ref = repmat([0;0;1;0;0;0;0;0;0;0;0;0;obj.param.ref_input;0;0;0],1,obj.param.H);
                result = obj.controller_KMPC(varargin);
                disp('controller: MC,  phase: a');
            elseif phase == 't' || phase == 'l'
                obj.current_state = obj.self.estimator.result.state.get(); %現在状態
                result = obj.controller_HL(varargin);
                disp('controller: HL  phase: t or l');
            elseif phase == 'f'
                obj.current_state = obj.self.estimator.result.state.get(); %現在状態
                obj.state.ref = obj.generate_reference();
                result = obj.controller_KMPC(varargin);
                disp('controller: MC  phase: f');
            end 
            toc
        end


        function result = controller_KMPC(obj,varargin)
            tic
            % varargin 
            % 1:TIME,  2:flight phase,  3:LOGGER,  4:?,  5:agent,  6:1?
            obj.param.t = varargin{1}.t;
            obj.previous_state = repmat(obj.current_state, 1, obj.H);
            
            %% ------------------------------------------------------------
            % 最適化部分の関数化とmex化
            Param = struct('current_state',obj.current_state,'ref',obj.reference.xr,'qpH', obj.qpparam.H, 'qpF', obj.qpparam.F,'lb',obj.param.input.lb,'ub',obj.param.input.ub,'previous_input',obj.previous_input,'H',obj.H);
            [var, fval, exitflag] = obj.param.quad_drone(Param); %自PCでcontroller:0.6ms, 全体:2.7ms
            % [var, fval, exitflag] = quad_drone(Param);
      
            %%
            obj.previous_input = var;
            obj.result.input = var(1:4, 1); % 印加する入力 4入力

            %% データ表示用
            calT = toc;
            obj.input.u = obj.result.input; 
            obj.result.mpc.calt = calT; %計算時間保存したいときコメントイン
            obj.result.mpc.var = var;
            obj.result.mpc.exitflag = exitflag;
            obj.result.mpc.fval = fval;
            obj.result.mpc.xr = obj.reference.xr;

            %% 保存するデータ
            result = obj.result; % controllerの値の保存

            %% 情報表示
            % state_monte = obj.self.estimator.result.state;
            % fprintf("==================================================================\n")
            % fprintf("==================================================================\n")
            % fprintf("ps: %f %f %f \t vs: %f %f %f \t qs: %f %f %f \t ws: %f %f %f \n",...
            %         state_monte.p(1), state_monte.p(2), state_monte.p(3),...
            %         state_monte.v(1), state_monte.v(2), state_monte.v(3),...
            %         state_monte.q(1), state_monte.q(2), state_monte.q(3), ...
            %         state_monte.w(1), state_monte.w(2), state_monte.w(3));       % s:state 現在状態
            % fprintf("pr: %f %f %f \t vr: %f %f %f \t qr: %f %f %f \t wr: %f %f %f \n", ...
            %         obj.state.ref(1,1), obj.state.ref(2,1), obj.state.ref(3,1),...
            %         obj.state.ref(7,1), obj.state.ref(8,1), obj.state.ref(9,1),...
            %         obj.state.ref(4,1), obj.state.ref(5,1), obj.state.ref(6,1), ...
            %         obj.state.ref(10,1), obj.state.ref(11,1), obj.state.ref(12,1))  % r:reference 目標状態
            % fprintf("t: %f \t input: %f %f %f %f \t fval: %f \t flag: %d", ...
            %     rt, obj.input.u(1), obj.input.u(2), obj.input.u(3), obj.input.u(4), fval, exitflag);
            % fprintf("\n");
        end
        
        function result = controller_HL(obj,varargin)
            model = obj.self.estimator.result;
            ref = obj.self.reference.result;
            xd = ref.state.xd;
            xd0 =xd;
            P = obj.param.P;
            F1 = obj.param.F1;
            F2 = obj.param.F2;
            F3 = obj.param.F3;
            F4 = obj.param.F4;
            xd=[xd;zeros(20-size(xd,1),1)];% 足りない分は０で埋める．
    
            % yaw 角についてボディ座標に合わせることで目標姿勢と現在姿勢の間の2pi問題を緩和
            % TODO : 本質的にはx-xdを受け付ける関数にして，x-xdの状態で2pi問題を解決すれば良い．
            Rb0 = RodriguesQuaternion(Eul2Quat([0;0;xd(4)]));
            x = [R2q(Rb0'*model.state.getq("rotmat"));Rb0'*model.state.p;Rb0'*model.state.v;model.state.w]; % [q, p, v, w]に並べ替え
            xd(1:3)=Rb0'*xd(1:3);
            xd(4) = 0;
            xd(5:7)=Rb0'*xd(5:7);
            xd(9:11)=Rb0'*xd(9:11);
            xd(13:15)=Rb0'*xd(13:15);
            xd(17:19)=Rb0'*xd(17:19);
            %if isfield(obj.param,'dt')
            if isfield(varargin{1},'dt') && varargin{1}.dt <= obj.param.dt
                dt = varargin{1}.dt;
            else
                dt = obj.param.dt;
                % vf = Vf(x,xd',P,F1);
                % vs = Vs(x,xd',vf,P,F2,F3,F4);
            end
            vf = Vfd(dt,x,xd',P,F1);
            vs = Vsd(dt,x,xd',vf,P,F2,F3,F4);
            %disp([xd(1:3)',x(5:7)',xd(1:3)'-xd0(1:3)']);
            tmp = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
            % max,min are applied for the safty
            obj.result.input = [max(0,min(10,tmp(1)));max(-1,min(1,tmp(2)));max(-1,min(1,tmp(3)));max(-1,min(1,tmp(4)))];
            result = obj.result;
        end

        function [xr] = generate_reference(obj, T)
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

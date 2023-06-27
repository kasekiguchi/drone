classdef TRACKING_MPC < handle
    %MPC_CONTROLLER MPCのコントローラー
    %   fminiconで車両モデルに対するMPC
    %   目標点を追従する
    
    properties
        options
        param
        previous_input
        previous_state
        model
        NoiseR
        SensorRange
        RangeGain
        result
        self
        SolverName
    end
    
    methods
        function obj = TRACKING_MPC(self,param)
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param.H  = param.H;                  % モデル予測制御のホライゾン
            obj.param.dt = param.dt;                 % モデル予測制御の刻み時間
            obj.param.input_size = self.model.dim(2);
            obj.param.state_size = self.model.dim(1);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;
            obj.param.Num = obj.param.H+1; %初期状態とホライゾン数の合計
            %重み%
%             obj.param.Q = diag([10,10,0.1,1000]);%状態の重み 10,10,1,100
%             obj.param.R = 0.01*diag([1,10]);%入力の重み % 0.01*diag([1,1])
%             obj.param.Qf = diag([10,10,0.1,1000]);%終端状態の重み % 12,12,1,1
            obj.param.Q = diag([10,10,0.1,100]);%状態の重み 10,10,1,100
            obj.param.R = 0.01*diag([1,1]);%入力の重み % 0.01*diag([1,1])
            obj.param.Qf = diag([10,10,0.1,100]);%終端状態の重み % 12,12,1,1
%             obj.param.Qf = diag([17,17,1,1])
            obj.param.T = 1000*eye(param.H);%Fisherの重み
            obj.param.S = [1,1];%入力の上下限 % 1,0.7
            strs=self.reference.name;        
            obj.param.step = self.reference.(strs(contains(strs,"mpc"))).step;
            obj.NoiseR = 1e-2;%param of Fisher Information matrix % 1.0e-2
            obj.RangeGain = 10;%10;%gain of sigmoid function for sensor range logic
            obj.SensorRange = self.estimator.(self.estimator.name).constant.SensorRange;
            obj.previous_input = zeros(obj.param.input_size,obj.param.Num);
            obj.result.previous_state = [];
            obj.result.previous_input = obj.previous_input;
            obj.model = self.model;
        end
        
        function result = do(obj,varargin)
            tic
            %---ロボットの状態をとる---%
            RobotState = [obj.self.estimator.result.state.p(1) , obj.self.estimator.result.state.p(2) , obj.self.estimator.result.state.q];
            if ~isempty(obj.self.input)
                oldinput = obj.self.input;
            else
                oldinput=[1,0];
            end
            %---reference情報を取得---%
            ref = obj.self.reference.result.state;
            obj.param.Xr = [obj.self.estimator.result.state.get(),ref.xd];
            %-------------------------%
            %---マップ情報をとる---%
            LineParam = obj.CFMEX_ConvertLineParam();
%            AssociationInfo = obj.self.estimator.result.AssociationInfo;
            %---------------------%
            
            %---センサ情報をとる---%
            Sensor = obj.self.sensor.result;
            Measured.ranges = Sensor.length;
            Measured.angles = Sensor.angle;% - RobotState(3);%
            if iscolumn(Measured.ranges)
                Measured.ranges = Measured.ranges';% Transposition
            end
            if iscolumn(Measured.angles)
                Measured.angles = Measured.angles';% Transposition
            end
            %---------------------%
            
%             %---対応づけしたレーザ（壁にあたってるレーザ）の角度faiおよびその壁のdとalpahaを取得---%
%             AssociationAvailableIndex = find(AssociationInfo.index ~= 0);%Index corresponding to the measured value
% %             Flag = AssociationInfo.index';
% %             Flag(Flag~=0) = 1;%on off FLag Matrix
%             AssociationAvailableount = length(AssociationAvailableIndex);%Count
%             Dis = inf(1,length(Measured.angles));
%             Alpha = inf(1,length(Measured.angles));
%             for i = 1:AssociationAvailableount
%                 MesuredRef = AssociationAvailableIndex(i);
%                 idx = AssociationInfo.index(AssociationAvailableIndex(i));
%                 Dis(MesuredRef) = LineParam.d(idx);%対応付けした距離を代入
%                 Alpha(MesuredRef) = LineParam.delta(idx);%対応付けしたalphaを代入
%             end
%             Dis = Dis(Dis~=inf);
%             Alpha = Alpha(Alpha~=inf);

%             Dis = Dis(AssociationAvailableIndex);
%              Alpha = Alpha(AssociationAvailableIndex);
%             AssoFai = Measured.angles(AssociationAvailableIndex);
%             if isempty(Dis)
%                 error("ACSL: something wrong");
%             end

Dis = LineParam.d;
Alpha = LineParam.delta;
            %----------------------------------------------------------------------------------%
            %---各種パラメータを格納---%
            obj.param.dis = Dis;
            obj.param.alpha = Alpha;
            obj.param.phi = Measured.angles;
%             obj.param.NoiseR = obj.self.estimator.(obj.self.estimator.name).R;
            obj.param.X0 = obj.self.estimator.result.state.get();%[state.p;state.q;state.v;state.w];
            obj.param.U0 = oldinput;%obj.previous_input(:,1);%現在時刻の入力
            %obj.param.model_param = obj.self.model.param;
            obj.param.model_param = obj.self.parameter;
            %------------------------%
            if isempty(obj.result.previous_state)
                obj.previous_state = repmat(obj.param.X0,1,obj.param.Num);                
            else
                obj.previous_state = obj.result.previous_state;
                obj.previous_input = obj.result.previous_input;
            end
            obj.previous_state(:,1) = obj.param.X0;% 1時刻前の予測値から現在時刻だけ現在推定値に置き換え．
            problem.solver    = 'fmincon';
            problem.options   = obj.options;
            problem.x0		  = [obj.previous_state;obj.previous_input;zeros(2,obj.param.Num)]; % 最適化計算の初期状態
            % obj.options.PlotFcn                = [];
            obj.result.eachfvalp = obj.GetobjectiveFimEval(problem.x0);%評価関数の値の計算 for plot
            %---評価関数と制約条件を設定した関数MEX化するときはここをやる---%
            [var,fval,exitflag,~,~,~,~] = obj.fminconMEX_ObFimAndFimobjective(problem.x0,obj.param,obj.NoiseR,obj.SensorRange,obj.RangeGain);%観測値差分と観測値のFIMを用いたコントローラ，最終的な提案手法
            %[var,fval,exitflag,~,~,~,~] = obj.fminconMEX_Trackobjective(problem.x0,obj.param);%目標値追従のみのコントローラ，比較手法
            %------------------------------------%
            obj.result.input = var(obj.param.state_size + 1:obj.param.total_size, 1);
            obj.self.input = obj.result.input;
            obj.result.fval = fval;
            obj.result.exitflag = exitflag;
            obj.result.eachfval = obj.GetobjectiveFimEval(var);%評価関数の値の計算 for plot
%             disp(exitflag);
            %obj.previous_input = var(obj.param.state_size + 1:obj.param.total_size, :);  
            obj.previous_input = [var(obj.param.state_size + 1:obj.param.total_size, 2:end),var(obj.param.state_size + 1:obj.param.total_size, end)];  
            obj.previous_state = var(1:obj.param.state_size,1:end);%[var(1:obj.param.state_size,2:end),var(1:obj.param.state_size,end)]; % 次時刻の最適化計算の初期値：一時刻ずらし最後二つは同じ状態
%             obj.SolverName = func2str(problem.objective);
            obj.result.previous_state = obj.previous_state;
            obj.result.previous_input = obj.previous_input;
            obj.result.calc_time = toc;
            result = obj.result;
        end
        
        function show(obj)
            
        end
    end
    
    methods(Access = private)
        outStruct = CFMEX_ConvertLineParam(MapStruct);
        eval = TrackobjectiveMEX(x, params);
        eval = FimobjectiveMEX(x, params);
        [cineq, ceq] = constraintsMEX(x, params);
        [StageState,StageInput,stageevFim,terminalState] = GetobjectiveFimEval(var, params);
        [var,fval,exitflag,output,lambda,grad,hessian] = fminconMEX_Fimobjective(objective,x0,nonlcon,options,param);
        [var,fval,exitflag,output,lambda,grad,hessian] = fminconMEX_Trackobjective(objective,x0,nonlcon,options,param);
    end
end


classdef TrackingMPCMEX_Controller <CONTROLLER_CLASS
    %MPC_CONTROLLER MPCのコントローラー
    %   fminiconで車両モデルに対するMPC
    %   目標点を追従する
    
    properties
        options
        param
        previous_input
        previous_state
        model
        result
        self
        SolverName
    end
    
    methods
        function obj = TrackingMPCMEX_Controller(self,param)
            obj.self = self;
            %---MPCパラメータ設定---%
            obj.param.H  = param.H;                % モデル予測制御のホライゾン
            obj.param.dt = param.dt;              % モデル予測制御の刻み時間
            obj.param.input_size = self.model.dim(2);
            obj.param.state_size = self.model.dim(1);
            obj.param.total_size = obj.param.input_size + obj.param.state_size;
            obj.param.Num = obj.param.H+1; %初期状態とホライゾン数の合計
            %重み%
            obj.param.Q = diag([5,5,1,1,1]);
            obj.param.R = diag([1e-2,1e-5]);
            obj.param.Qf = diag([10,10,1,1,1]);
            obj.param.T = diag([10,5,5,5,5,5,5,5,5,5]);
%             obj.param.Th = diag([1,1]);
%             obj.param.LimFim = 1;
            obj.previous_input = zeros(obj.param.input_size,obj.param.Num);
            obj.model = self.model;
        end
        
        function result = do(obj,param,~)
            % param = {model, reference}
            % param{1}.state : 推定したstate構造体
            % param{2}.result.state : 参照状態の構造体 % n x Num :  n : number of state,  Num : horizon
            % param{3} : 構造体
            %---ロボットの状態をとる---%
            RobotState = [obj.self.estimator.result.state.p(1) , obj.self.estimator.result.state.p(2) , obj.self.estimator.result.state.q];
            if ~isempty(obj.self.input)
                oldinput = obj.self.input;
            else
                oldinput=[1,0];
            end
            %-------------------------%
            %state = state_copy(param{1}.state);
            %model = param{1};
            ref = obj.self.reference.result.state;
            obj.param.Xr = [obj.self.model.state.get(),ref.xd];
            %---マップ情報をとる---%
            LineParam = CFMEX_ConvertLineParam(obj.self.estimator.result.map_param);
            AssociationInfo = obj.self.estimator.result.AssociationInfo;
            %---------------------%
            
            %---センサ情報をとる---%
            Sensor = obj.self.sensor.result;
            Measured.ranges = Sensor.length;
            Measured.angles = Sensor.angle - RobotState(3);%
            if iscolumn(Measured.ranges)
                Measured.ranges = Measured.ranges';% Transposition
            end
            if iscolumn(Measured.angles)
                Measured.angles = Measured.angles';% Transposition
            end
            %---------------------%
            
            %---対応づけしたレーザ（壁にあたってるレーザ）の角度faiおよびその壁のdとalpahaを取得---%
            AssociationAvailableIndex = find(AssociationInfo.index ~= 0);%Index corresponding to the measured value
%             Flag = AssociationInfo.index';
%             Flag(Flag~=0) = 1;%on off FLag Matrix
            AssociationAvailableount = length(AssociationAvailableIndex);%Count
            Dis = zeros(1,length(Measured.angles));
            Alpha = zeros(1,length(Measured.angles));
            for i = 1:AssociationAvailableount
                MesuredRef = AssociationAvailableIndex(i);
                idx = AssociationInfo.index(AssociationAvailableIndex(i));
                Dis(MesuredRef) = LineParam.d(idx);%対応付けした距離を代入
                Alpha(MesuredRef) = LineParam.delta(idx);%対応付けしたalphaを代入
            end
            Dis = Dis(Dis~=0);
            Alpha = Alpha(Alpha~=0);
            AssoFai = Measured.angles(AssociationAvailableIndex);
            %----------------------------------------------------------------------------------%
            %obj.param.t = t;
            obj.param.dis = Dis;
            obj.param.alpha = Alpha;
            obj.param.phi = AssoFai;
%             obj.param.NoiseR = obj.self.estimator.(obj.self.estimator.name).R;
            obj.param.X0 = obj.self.model.state.get();%[state.p;state.q;state.v;state.w];
            obj.param.model_param = obj.self.model.param;
            obj.previous_state = repmat(obj.param.X0,1,obj.param.Num);
            problem.solver    = 'fmincon';
            problem.options   = obj.options;
%             problem.objective = @(x) obj.objectiveFim(x, obj.param);  % 評価関数
%             problem.nonlcon   = @(x) obj.constraintsOM(x, obj.param);% 制約条件OM = only model
            problem.x0		  = [obj.previous_state;obj.previous_input]; % 初期状態
            % obj.options.PlotFcn                = [];
            [var,fval,exitflag,~,~,~,~] = fminconMEX_Fimobjective(problem.x0,obj.param,obj.self.estimator.(obj.self.estimator.name).R);
%             [var,fval,exitflag,~,~,~,~] = fminconMEX_Trackobjective_mex(problem.x0,obj.param);
            obj.result.input = var(obj.param.state_size + 1:obj.param.total_size, 1);
            obj.self.input = obj.result.input;
            obj.result.fval = fval;
            obj.result.exitflag = exitflag;
            obj.result.eachfval = GetobjectiveFimEval(var, obj.param,obj.self.estimator.(obj.self.estimator.name).R);
%             disp(exitflag);
            obj.previous_input = var(obj.param.state_size + 1:obj.param.total_size, :);  
%             obj.SolverName = func2str(problem.objective);
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


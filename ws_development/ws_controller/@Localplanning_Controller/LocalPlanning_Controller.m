classdef LocalPlanning_Controller <CONTROLLER_CLASS
    %目標点が与えられた時の運動について考えるコントローラ
    %観測値が特異的にならないような動きを生成する．
    
    properties
        result
        self
        options
        Param
        t
    end
    
    methods
        function obj = LocalPlanning_Controller(self,param)
            obj.self = self;
            
            obj.t = param.dt;
            obj.options = optimoptions('fminunc');
            obj.options.UseParallel = false;
            obj.options.Algorithm			   ='quasi-newton';
            obj.options.Display                = 'none';
            obj.options.Diagnostics            = 'off';
            obj.options.MaxFunctionEvaluations = 1.e+12;%関数評価の最大回数
            obj.options.MaxIterations		   = Inf;%反復の最大許容回数
            % options.StepTolerance          = 1.e-12;%xに関する終了許容誤差
            % options.OptimalityTolerance    = 1.e-12;%1 次の最適性に関する終了許容誤差。
            % options.PlotFcn                = [];
            % obj.options.SpecifyConstraintGradient = true;
            % obj.options.SpecifyObjectiveGradient  = false;
        end
        
        function result = do(obj,param,~)
            %param ={map, reference}
            %---ロボットの状態をとる---%
            RobotState = [obj.self.estimator.result.state.p(1) , obj.self.estimator.result.state.p(2) , obj.self.estimator.result.state.q];
            if ~isempty(obj.self.input)
                oldinput = obj.self.input;
            else
                oldinput=[1,0];
            end
            %-------------------------%
            
            %---マップ情報をとる---%
            MapParam = obj.self.estimator.result.map_param;
            LineParam = CF_ConvertLineParam(obj);
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
            
            %Global planningから供給される目標位置のデータ
            Xd = obj.self.reference.result.state.xd;
            %目標位置までの角度差を出す．
            LineTheta = atan2(Xd(2) - RobotState(2),Xd(1) - RobotState(1));
            Theta = RobotState(3);
            DeltaTheta = LineTheta - Theta;
            Deltaomega = DeltaTheta/obj.t;%目標位置に向かうための角速度
            %---対応づけしたレーザ（壁にあたってるレーザ）の角度faiおよびその壁のdとalpahaを取得---%
            AssociationAvailableIndex = find(AssociationInfo.index ~= 0);%Index corresponding to the measured value
            AssociationAvailableount = length(AssociationAvailableIndex);%Count
            Dis = zeros(1,length(Measured.angles));
            Alpha = zeros(1,length(Measured.angles));
            for i = 1:AssociationAvailableount
                MesuredRef = AssociationAvailableIndex(i);
                idx = AssociationInfo.index(AssociationAvailableIndex(i));
                Dis(MesuredRef) = LineParam.d(idx);
                Alpha(MesuredRef) = LineParam.delta(idx);
            end
            Dis = Dis(Dis~=0);
            Alpha = Alpha(Alpha~=0);
            AssoFai = Measured.angles(AssociationAvailableIndex);
            %----------------------------------------------------------------------------------%
            
            %---Get Reference data---%
            Ref = obj.self.reference.(obj.self.reference.name(1)).result.state;
            %------------------------%
            
            %---subtract ref---%
            Subtheta = atan2(Ref(2) - RobotState(2),Ref(1) - RobotState(1));
            Subvel = sqrt((Ref(1)-RobotState(1))^2 + (Ref(2)-RobotState(2))^2) * cos(Subtheta - RobotState(3));
            %------------------%
            
            %---最適化計算用のパラメータを算出---%
            params.dis = Dis;%wall distanse
            params.alpha = Alpha;%wall angle
            params.phi = AssoFai;%raser angle
            params.pos = RobotState;%robot position [x y theta]
%             params.t = %control tic
            params.DeltaOmega = Deltaomega;
            params.t = obj.t;
%             params.v = Subvel;
            params.v = 1;
            params.k1 = 0.5;
            params.k2 = 1;
            params.k3 = 1;
            params.R = obj.self.estimator.(obj.self.estimator.name).R;
%             params.Oldw = oldinput(2);
            params.Oldw = obj.self.estimator.result.state.w;
            params.ipsiron = 1e-5;
            %----------------------------------%
%             if isfield(obj.result,'Solvex')
%             if abs(obj.self.estimator.result.state.w - obj.result.Solvex) > 0.1
%                 RobotVW = [obj.self.estimator.result.state.v,obj.self.estimator.result.state.w];
%                 obj.result.input = [(params.v - RobotVW(1)),(obj.result.Solvex - RobotVW(2))];
%             else
            %---最適な角速度の算出---%
            %観測値差分を評価値として計算
            problem.solver    = 'fminunc';
            problem.options   = obj.options;
            problem.objective = @(x) LMPobjective(obj,x, params);  % 評価関数
            problem.x0		  = oldinput;
            [Solvex, fval, exitflag, output, grad, hessian] = fminunc(problem);
            
            %入力に印加
%             if isfield(obj.self.model.state,'v')
                %加速度次元入力
                RobotVW = [obj.self.estimator.result.state.v,obj.self.estimator.result.state.w];
                obj.result.input = [(Solvex(1) - RobotVW(1)),(Solvex(2) - RobotVW(2))];
%             else
                %速度次元入力
%                 obj.result.input = [params.v,Solvex];
%             end

            %---For analysis---%
            obj.result.Fval = fval;
            obj.result.Exitflag = exitflag;
            obj.result.Solvex = Solvex;
            %------------------%
%             end
%             else
%                 %---最適な角速度の算出---%
%             %観測値差分を評価値として計算
%             problem.solver    = 'fminunc';
%             problem.options   = obj.options;
%             problem.objective = @(x) LMPobjective(x, params);  % 評価関数
%             problem.x0		  = oldinput(2);
%             [Solvex, fval, exitflag, output, grad, hessian] = fminunc(problem);
%             
%             %入力に印加
% %             if isfield(obj.self.model.state,'v')
%                 %加速度次元入力
%                 RobotVW = [obj.self.estimator.result.state.v,obj.self.estimator.result.state.w];
%                 obj.result.input = [(params.v - RobotVW(1))/obj.Param.t,(Solvex - RobotVW(2))/obj.Param.t];
% %             else
%                 %速度次元入力
% %                 obj.result.input = [params.v,Solvex];
% %             end
% 
%             %---For analysis---%
%             obj.result.Fval = fval;
%             obj.result.Exitflag = exitflag;
%             obj.result.Solvex = Solvex;
            %------------------%
%             end
            obj.self.input = obj.result.input;
            obj.result.Eval = EvalResult(Solvex, params);
            result = obj.result;
            obj.Param = params;
        end
        function show(obj)
            
        end
    end
    
    methods(Access = private)
        outStruct = CF_ConvertLineParam(obj);
        eval = LMPobjective(obj,x, params);
    end
    
end
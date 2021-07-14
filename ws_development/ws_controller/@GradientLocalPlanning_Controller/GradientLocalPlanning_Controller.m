classdef GradientLocalPlanning_Controller <CONTROLLER_CLASS
    %目標点が与えられた時の運動について考えるコントローラ
    %観測値が特異的にならないような動きを生成する．
    
    properties
        result
        self
        options
        Param
    end
    
    methods
        function obj = GradientLocalPlanning_Controller(self,param)
            obj.self = self;
            
            obj.Param.t = param.dt;
        end
        
        function result = do(obj,param,~)
            %param ={map, reference}
            %---ロボットの状態をとる---%
            RobotState = [obj.self.estimator.result.state.p(1) , obj.self.estimator.result.state.p(2) , obj.self.estimator.result.state.q];
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
            Deltaomega = DeltaTheta/obj.Param.t;%目標位置に向かうための角速度
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
            %---最適化計算用のパラメータを算出---%
                params.dis = Dis;%wall distanse
                params.alpha = Alpha;%wall angle
                params.phi = AssoFai;%raser angle
                params.pos = RobotState;%robot position [x y theta]
                %             params.t = %control tic
                params.DeltaOmega = Deltaomega;
                params.t = obj.Param.t;
                params.k1 = 1;
                params.k2 = 1;
                params.k3 = 1;
                params.v = 1 + rand;
                %             params.Oldw = oldinput(2);
                params.Oldw = obj.self.estimator.result.state.w;
                params.ipsiron = 1e-5;
                %----------------------------------%
                Gain = -1;

            %---最適な角速度の算出---%
            if ~isempty(obj.self.input)
%                 oldinput = obj.self.input;
                
                %観測値差分を評価値として計算
                tmpdiff = arrayfun(@(N) DeltahDiff(params.pos(1), params.pos(2), params.pos(3), params.v, params.Oldw, params.t, params.dis(N), params.alpha(N), params.phi(N)), 1:AssociationAvailableount);
                tmppow  = arrayfun(@(N) DeltahPower2(params.pos(1), params.pos(2), params.pos(3), params.v, params.Oldw, params.t, params.dis(N), params.alpha(N), params.phi(N)), 1:AssociationAvailableount);
                dJ1 = params.k1 * (sum(tmpdiff)/ sum(tmppow) + params.ipsiron);
                dJ2 = params.k2 * 2 * (params.Oldw - Deltaomega);
                %             dJ3 = params.u * -sign(a - omega);
                D = dJ1 + dJ2;
                SolveOmega = params.Oldw + Gain * D * params.t;
            else
                oldinput=[1,0];
                SolveOmega = oldinput;
            end
            
            %入力に印加
            %加速度次元入力
            RobotVW = [obj.self.estimator.result.state.v,obj.self.estimator.result.state.w];
            obj.result.input = [(params.v - RobotVW(1)),(SolveOmega - RobotVW(2))];
            %             else
            %速度次元入力
            %                 obj.result.input = [params.v,Solvex];
            %             end
            
            obj.self.input = obj.result.input;
            obj.result.Eval = EvalResult([params.v,SolveOmega], params);
            result = obj.result;
        end
        function show(obj)
            
        end
    end
    
    methods(Access = private)
        outStruct = CF_ConvertLineParam(obj);
        eval = LMPobjective(obj,x, params);
    end
    
end
classdef TrackWpointPathForMPC < REFERENCE_CLASS
    % リファレンスを生成するクラス,
    % TrackingWayPointPathForMPC
    % 目標点に向かって一定速度で移動する軌道を生成
    % mpcのホライゾンすうと合わせる必要あり．
    properties
        WayPoint
        Targetv
        Targetw
        ConvergencejudgeV
        ConvergencejudgeW
        TrackingPoint
        InitialPoint
        PointFlag
        Flag
        PreTrack
        dt
        WayPointNum
        Holizon
        self
    end
    
    methods
        function obj = TrackWpointPathForMPC(self,varargin)
            % 【Input】 map_param ,
            %  目標点の行列を受け取る．それに対応した目標速度を受け取る．
            %　目標点と速度に応じて参照軌道を作成，estimatorの値から収束判定をする．
            %  we make target of new section by convergence judgement
            obj.self = self;
            param = varargin{1};
            obj.WayPoint = param{1,1};% line is flag num
            obj.Targetv = param{1,2};
            obj.Targetw = param{1,3};
            obj.PointFlag = 0;
            obj.Flag = 1;%WayPointのFlag管理
            obj.ConvergencejudgeV = param{1,4};
            obj.ConvergencejudgeW = param{1,5};
%             obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v;param{1,6}.w];
            obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v];
            obj.Holizon = param{1,7};
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd"],'num_list',[4]));%x,y,theta,v
        end
        
        function  result= do(obj,param)
            %---推定器からデータを取得---%
            EstData = ...
                [obj.self.estimator.(obj.self.estimator.name).result.state.p;obj.self.estimator.(obj.self.estimator.name).result.state.q;...
                obj.self.estimator.(obj.self.estimator.name).result.state.v];%treat as a colmn vector 
            %----------------------------%
            
            %---judgement of convergence for estimate position---%
            % convergence point check
            if (EstData(1) - obj.WayPoint(obj.Flag,1))^2 + (EstData(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && obj.PointFlag == 0
                obj.PointFlag = 1;
            end
            
            if obj.PointFlag == 1 && abs(EstData(4) - obj.WayPoint(obj.Flag,4)) < 0.05
                obj.PointFlag =2;
            end
            
            if (EstData(1) - obj.WayPoint(obj.Flag,1))^2 + (EstData(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && abs(EstData(3) - obj.WayPoint(obj.Flag,3)) < obj.ConvergencejudgeW && obj.PointFlag ==2
                obj.Flag = obj.Flag+1;
                obj.PointFlag = 0;
                if obj.Flag >= obj.WayPointNum
                    obj.Flag = obj.WayPointNum;
                end
            end
            %----------------------------------------------------%
            obj.TrackingPoint = zeros(4,obj.Holizon);%set data size[x ;y ;theta;v]

            %---judgement of covergence for Target Position---%
            if (obj.PreTrack(1) - obj.WayPoint(obj.Flag,1))^2 + (obj.PreTrack(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && abs(EstData(3) - obj.WayPoint(obj.Flag,3)) < obj.ConvergencejudgeW
                obj.TrackingPoint(:,1) = obj.WayPoint(obj.Flag,:)';
            %-------------------------------------------------%
            else
                %---Make first Tracking Point---%
                Tracktheta = atan2(obj.WayPoint(obj.Flag,2)- obj.PreTrack(2),obj.WayPoint(obj.Flag,1) - obj.PreTrack(1));
                obj.TrackingPoint(1:2,1) = obj.PreTrack(1:2,1) + [obj.Targetv*obj.dt*cos(Tracktheta);obj.Targetv*obj.dt*sin(Tracktheta)];
                if (EstData(1) - obj.WayPoint(obj.Flag,1))^2 + (EstData(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && abs(EstData(3) - obj.WayPoint(obj.Flag,3)) > obj.ConvergencejudgeW
                    obj.TrackingPoint(3,1) = EstData(3) + (obj.WayPoint(obj.Flag,3) - EstData(3)) * obj.Targetw;
                else
                    obj.TrackingPoint(3,1) = obj.WayPoint(obj.Flag,3);
                end
                if obj.PointFlag ==0
                    obj.TrackingPoint(4,1) = obj.Targetv;
                else
                    obj.TrackingPoint(4,1) = 0;
                end
                %-------------------------%
            end
            
            %---Tracking point of after 2steps---%
            for i = 2:obj.Holizon
                if (obj.TrackingPoint(1,i-1) - obj.WayPoint(obj.Flag,1))^2 + (obj.TrackingPoint(2,i-1) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && abs(obj.TrackingPoint(3,i-1) - obj.WayPoint(obj.Flag,3)) < obj.ConvergencejudgeW
                    obj.TrackingPoint(:,i) = obj.WayPoint(obj.Flag,:)';
                    %-------------------------------------------------%
                else
                    %---Make first Tracking Point---%
                    Tracktheta = atan2(obj.WayPoint(obj.Flag,2)- obj.TrackingPoint(2,i-1),obj.WayPoint(obj.Flag,1) - obj.TrackingPoint(1,i-1));
                    obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(Tracktheta);obj.Targetv*obj.dt*sin(Tracktheta)];
                    if (EstData(1) - obj.WayPoint(obj.Flag,1))^2 + (EstData(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && abs(obj.TrackingPoint(3,i-1) - obj.WayPoint(obj.Flag,3)) > obj.ConvergencejudgeW
                        obj.TrackingPoint(3,i) = obj.TrackingPoint(3,i-1) + (obj.WayPoint(obj.Flag,3) - obj.TrackingPoint(3,i-1)) * obj.Targetw;
                    else
                        obj.TrackingPoint(3,i) = obj.WayPoint(obj.Flag,3);
                    end
                    if obj.PointFlag ==0
                        obj.TrackingPoint(4,1) = obj.Targetv;
                    else
                        obj.TrackingPoint(4,1) = 0;
                    end
                    %-------------------------%
                end
            end
            %------------------------------------%
            
            obj.result.state = obj.TrackingPoint;%treat as a colmn vector
            obj.self.reference.result.state = obj.TrackingPoint;
            %---Get Data of previous step---%
            obj.PreTrack = obj.TrackingPoint(:,1);
            %-------------------------------%
            %resultに代入
            result=obj.result;
        end
        
        function show(obj,logger)
         
        end
    end
end


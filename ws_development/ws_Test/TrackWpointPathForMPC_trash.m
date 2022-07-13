classdef TrackWpointPathForMPC_trash < REFERENCE_CLASS
    % リファレンスを生成するクラス,
    % TrackingWayPointPathForMPC
    % 目標点に向かって一定速度で移動する軌道を生成
    % mpcのホライゾンすうと合わせる必要あり．
    properties
        WayPoint
        Targetv
        Convergencejudge
        TrackingPoint
        InitialPoint
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
            obj.Flag = 1;%WayPointのFlag管理
            obj.Convergencejudge = param{1,3};
            obj.PreTrack = [param{1,4}.p;param{1,4}.q;param{1,4}.v;param{1,4}.w];
            obj.Holizon = param{1,5};
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd"],'num_list',[5]));%x,y,theta,v,w
        end
        
        function  result= do(obj,param)
            %---推定器からデータを取得---%
            EstData = ...
                [obj.self.estimator.(obj.self.estimator.name).result.state.p;obj.self.estimator.(obj.self.estimator.name).result.state.q;...
                obj.self.estimator.(obj.self.estimator.name).result.state.v;obj.self.estimator.(obj.self.estimator.name).result.state.w];%treat as a colmn vector 
            %----------------------------%
            
            %---judgement of convergence for estimate position---%
            if (EstData(1) - obj.WayPoint(obj.Flag,1))^2 + (EstData(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.Convergencejudge
                obj.Flag = obj.Flag+1;
                if obj.Flag >= obj.WayPointNum
                    obj.Flag = obj.WayPointNum;
                end
            end
            %----------------------------------------------------%
            
            obj.TrackingPoint = zeros(length(EstData),obj.Holizon);%set data size[x ;y ;theta]
            RefFlag = obj.Flag;%in decided reference roop 

            %---judgement of covergence for Target Position---%
            if (EstData(1) - obj.WayPoint(RefFlag,1))^2 + (EstData(2) - obj.WayPoint(RefFlag,2))^2 <= obj.Convergencejudge
                obj.TrackingPoint(:,1) = obj.WayPoint(obj.Flag,:)';
                RefFlag = RefFlag+1;
                if RefFlag >= obj.WayPointNum
                    RefFlag = obj.WayPointNum;
                end
            %-------------------------------------------------%
            else
                %---Make first Tracking Point---%
                Tracktheta = atan2(obj.WayPoint(RefFlag,2)- EstData(2),obj.WayPoint(RefFlag,1) - EstData(1));
                obj.TrackingPoint(1:2,1) = EstData(1:2,1) + [obj.Targetv*obj.dt*cos(Tracktheta);obj.Targetv*obj.dt*sin(Tracktheta)];
                obj.TrackingPoint(3:5,1) = [obj.WayPoint(RefFlag,3);obj.Targetv;obj.WayPoint(RefFlag,5)];
                %-------------------------%
            end
            
            %---Tracking point of after 2steps---%
            for i = 2:obj.Holizon
                if (obj.TrackingPoint(1,i-1) - obj.WayPoint(RefFlag,1))^2 + (obj.TrackingPoint(2,i-1) - obj.WayPoint(RefFlag,2))^2 <= obj.Convergencejudge
                obj.TrackingPoint(:,i) = obj.WayPoint(RefFlag,:)';
                RefFlag = RefFlag+1;
                if RefFlag >= obj.WayPointNum
                    RefFlag = obj.WayPointNum;
                end
            %-------------------------------------------------%
            else
                %---Make first Tracking Point---%
                Tracktheta = atan2(obj.WayPoint(RefFlag,2) - obj.TrackingPoint(2,i-1),obj.WayPoint(RefFlag,1) - obj.TrackingPoint(1,i-1));
                obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(Tracktheta);obj.Targetv*obj.dt*sin(Tracktheta)];
                obj.TrackingPoint(3:5,i) = [obj.WayPoint(RefFlag,3);obj.Targetv;obj.WayPoint(RefFlag,5)];
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
            rp=strcmp(logger.items,"reference.result.state.p");
            heart = cell2mat(logger.Data.agent(:,rp)'); % reference.result.state.p
            plot(heart(1,:),heart(2,:)); % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on
            ep=strcmp(logger.items,"estimator.result.state.p");
            heart_result = cell2mat(logger.Data.agent(:,ep)'); % estimator.result.state.p
            plot(heart_result(1,:),heart_result(2,:)); % xy平面の軌道を描く
            legend(["reference","estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off
        end
    end
end


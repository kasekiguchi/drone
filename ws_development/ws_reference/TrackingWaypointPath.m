classdef TrackingWaypointPath < REFERENCE_CLASS
    % リファレンスを生成するクラス
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
        self
    end
    
    methods
        function obj = TrackingWaypointPath(self,varargin)
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
            obj.PreTrack = param{1,4}.p;
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd"],'num_list',[2]));%x,y
        end
        
        function  result= do(obj,param)
            %---推定器からデータを取得---%
            EstData = obj.self.estimator.(obj.self.estimator.name).result.state.p;%treat as a colmn vector 
            %----------------------------%
            
            %---judgement of convergence for estimate position---%
            if (EstData(1) - obj.WayPoint(obj.Flag,1))^2 + (EstData(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.Convergencejudge
                obj.Flag = obj.Flag+1;
                if obj.Flag >= obj.WayPointNum
                    obj.Flag = obj.WayPointNum;
                end
            end
            %----------------------------------------------------%
            
            %---judgement of covergence for Target Position---%
            if (obj.PreTrack(1) - obj.WayPoint(obj.Flag,1))^2 + (obj.PreTrack(2) - obj.WayPoint(obj.Flag,2))^2 <= obj.Convergencejudge
                obj.TrackingPoint = obj.WayPoint(obj.Flag)';
            %-------------------------------------------------%
            else
                %---Make Tracking Point---%
                Tracktheta = atan2(obj.WayPoint(obj.Flag,2)- obj.PreTrack(2),obj.WayPoint(obj.Flag,1) - obj.PreTrack(1));
                obj.TrackingPoint = obj.PreTrack + [obj.Targetv*obj.dt*cos(Tracktheta);obj.Targetv*obj.dt*sin(Tracktheta)];
                %-------------------------%
            end

            obj.result.state = obj.TrackingPoint;%treat as a colmn vector
            %---Get Data of previous step---%
            obj.PreTrack = obj.TrackingPoint;
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


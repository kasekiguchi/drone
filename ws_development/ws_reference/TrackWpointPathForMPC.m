classdef TrackWpointPathForMPC < REFERENCE_CLASS
    % リファレンスを生成するクラス,
    % TrackingWayPointPathForMPC
    % 目標点に向かって一定速度で移動する軌道を生成
    % mpcのホライゾンすうと合わせる必要あり．
    %PointFlag =0;端点なしただ動く
    %PpintFlag = 1;端点を見つけたとき
    %PointFlag = 2;
    properties
        WayPoint
        Targetv
        TargetGainw
        ConvergencejudgeV
        ConvergencejudgeW
        ConvA
        TrackingPoint
        Tracktheta
        Rolltheta
        PointFlag
        Flag
        PreTrack
        Crossbuffer
        dt
        SensorRange
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
            obj.WayPoint = [0,0,0,0];% line is flag num
            obj.Targetv = param{1,2};
            obj.TargetGainw = param{1,3};
            obj.PointFlag = 0;
            obj.Tracktheta = 0;
            obj.Rolltheta = pi/2;
            obj.ConvA = 0.05;
            obj.Crossbuffer = 2;
            obj.Flag = 1;%WayPointのFlag管理
            obj.ConvergencejudgeV = param{1,4};
            obj.ConvergencejudgeW = param{1,5};
            %             obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v;param{1,6}.w];
            obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v];
            obj.Holizon = param{1,7};
            obj.SensorRange = 20;
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd"],'num_list',[4]));%x,y,theta,v
        end
        
        function  result= do(obj,param)
            %---推定器からデータを取得---%
            EstData = ...
                [obj.self.estimator.(obj.self.estimator.name).result.state.p;obj.self.estimator.(obj.self.estimator.name).result.state.q;...
                obj.self.estimator.(obj.self.estimator.name).result.state.v];%treat as a colmn vector
            LineXs = obj.self.estimator.result.map_param.x(:,1);
            LineXe = obj.self.estimator.result.map_param.x(:,2);
            LineYs = obj.self.estimator.result.map_param.y(:,1);
            LineYe = obj.self.estimator.result.map_param.y(:,2);
            %----------------------------%
            %---SensorRange内に端点が入っているかを判定---%
            JudgeSRs = (EstData(1) - LineXs).^2 + (EstData(2) - LineYs).^2 <= obj.SensorRange^2;
            JudgeSRe = (EstData(1) - LineXe).^2 + (EstData(2) - LineYe).^2 <= obj.SensorRange^2;
            InRange = JudgeSRs|JudgeSRe;
            MatchA = obj.self.estimator.result.map_param.a(InRange);MatchB = obj.self.estimator.result.map_param.b(InRange);MatchC = obj.self.estimator.result.map_param.c(InRange);
            MatchXs = obj.self.estimator.result.map_param.x(InRange,1);MatchXe = obj.self.estimator.result.map_param.x(InRange,2);
            MatchYs = obj.self.estimator.result.map_param.y(InRange,1);MatchYe = obj.self.estimator.result.map_param.y(InRange,2);
            %-------------------------------------------%
            
            obj.TrackingPoint = zeros(4,obj.Holizon);%set data size[x ;y ;theta;v]
            
            %---judgement of convergence for estimate position---%
            switch obj.PointFlag
                case 0
                    NextPoint = obj.PreTrack(1:2,1) + [obj.SensorRange*cos(obj.Tracktheta);obj.SensorRange*sin(obj.Tracktheta)];
                    [OverWall,~,CrossPoint] = judgeingOverWall(EstData(1:2,:),NextPoint,MatchXs,MatchXe,MatchYs,MatchYe,MatchA,MatchB,MatchC);
                    if OverWall == true
                        obj.PointFlag = 1;
                        NextWayPoint = CrossPoint + [obj.Crossbuffer*cos(obj.Tracktheta+pi);obj.Crossbuffer*sin(obj.Tracktheta+pi)];%目標点の手前obj.Crossbuffer分
                        obj.WayPoint = [NextWayPoint;obj.Tracktheta+obj.Rolltheta;0];%収束すべき目標位置
                    end
                    obj.TrackingPoint(1:2,1) = obj.PreTrack(1:2,1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                    obj.TrackingPoint(3,1) = obj.Tracktheta;
                    obj.TrackingPoint(4,1) = obj.Targetv;
                    for i = 2:obj.Holizon
                        obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                        obj.TrackingPoint(3,i) = obj.Tracktheta;
                        obj.TrackingPoint(4,i) = obj.Targetv;
                    end
                case 1
                    %見つけた目標点に収束しているかを判定,位置と速度の収束判定
                    if (EstData(1) - obj.WayPoint(1))^2 + (EstData(2) - obj.WayPoint(2))^2 <= obj.ConvergencejudgeV && abs(EstData(4) - obj.WayPoint(4)) < obj.ConvA && abs(EstData(3) - obj.WayPoint(3)) < obj.ConvergencejudgeW
                        obj.PointFlag = 2;
                    end
                    if (obj.PreTrack(1) - obj.WayPoint(1))^2 + (obj.PreTrack(2) - obj.WayPoint(2))^2 <= obj.ConvergencejudgeV && abs(EstData(3) - obj.WayPoint(3)) < obj.ConvergencejudgeW
                        obj.TrackingPoint(:,1) = obj.WayPoint;
                        %-------------------------------------------------%
                    else
                        %---Make first Tracking Point---%
                        obj.TrackingPoint(1:2,1) = obj.PreTrack(1:2,1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                        obj.TrackingPoint(3,1) = obj.WayPoint(3);
                        if obj.PointFlag == 0 || obj.PointFlag == 1
                            obj.TrackingPoint(4,1) = obj.Targetv;
                        else
                            obj.TrackingPoint(4,1) = 0;
                        end
                        %-------------------------%
                    end
                    
                    %---Tracking point of after 2steps---%
                    for i = 2:obj.Holizon
                        if (obj.TrackingPoint(1,i-1) - obj.WayPoint(obj.Flag,1))^2 + (obj.TrackingPoint(2,i-1) - obj.WayPoint(obj.Flag,2))^2 <= obj.ConvergencejudgeV && abs(obj.TrackingPoint(3,i-1) - obj.WayPoint(obj.Flag,3)) < obj.ConvergencejudgeW
                            obj.TrackingPoint(:,i) = obj.WayPoint;
                        else
                            obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                            obj.TrackingPoint(3,i) = obj.WayPoint(3);
                            if obj.PointFlag ==0 || obj.PointFlag == 1
                                obj.TrackingPoint(4,i) = obj.Targetv;
                            else
                                obj.TrackingPoint(4,i) = 0;
                            end
                        end
                    end
                    %------------------------------------%
                case 2
                    %convergence judge
                    if abs(EstData(3) - (obj.WayPoint(3) + obj.Rolltheta)) < obj.ConvergencejudgeW
                        obj.PointFlag = 0;
                        obj.Tracktheta = obj.Tracktheta + obj.Rolltheta;
                    end
                    %make reference
                    obj.TrackingPoint(1:2,1) = obj.WayPoint(1:2,:);
                    if abs(EstData(3) - (obj.WayPoint(3) + obj.Rolltheta)) > obj.ConvergencejudgeW
                        obj.TrackingPoint(3,1) = EstData(3) + (obj.WayPoint(obj.Flag,3) - EstData(3)) * obj.TargetGainw;
                    else
                        obj.TrackingPoint(3,1) = obj.WayPoint(obj.Flag,3);
                    end
                    obj.TrackingPoint(4,1) = 0;
                    
                    %---Tracking point of after 2steps---%
                    for i = 2:obj.Holizon
                        obj.TrackingPoint(1:2,i) = obj.WayPoint(1:2,:);
                        obj.TrackingPoint(4,i) = 0;
                        if abs(obj.TrackingPoint(3,i-1) - (obj.WayPoint(3) + obj.Rolltheta)) > obj.ConvergencejudgeW
                            obj.TrackingPoint(3,i) = obj.TrackingPoint(3,i-1) + (obj.WayPoint(obj.Flag,3) - obj.TrackingPoint(3,i-1)) * obj.TargetGainw;
                        else
                            obj.TrackingPoint(3,i) = obj.WayPoint(obj.Flag,3);
                        end
                    end
                    %------------------------------------%
                otherwise
            end
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
function [OverWall,tt,CrossPoint] = judgeingOverWall(NowPoint,NextPoint,MatchXs,MatchXe,MatchYs,MatchYe,MatchA,MatchB,MatchC)
%Linecheck
checklist = zeros(size(MatchXs,1),1);
for i = 1:size(MatchXs,1)
    tmpC = [MatchXs(i,1);MatchYs(i,1)];
    tmpD = [MatchXe(i,1);MatchYe(i,1)];
    tc = (NowPoint(1) - NextPoint(1))*(tmpC(2) - NowPoint(2))+ (NowPoint(2) - NextPoint(2))*(NowPoint(1) - tmpC(1));
    td = (NowPoint(1) - NextPoint(1))*(tmpD(2) - NowPoint(2))+ (NowPoint(2) - NextPoint(2))*(NowPoint(1) - tmpD(1));
    tt1 = tc*td;
    ta = (tmpC(1) - tmpD(1))*(NowPoint(2) - tmpC(2))+ (tmpC(2) - tmpD(2))*(tmpC(1) - NowPoint(1));
    tb = (tmpC(1) - tmpD(1))*(NextPoint(2) - tmpC(2))+ (tmpC(2) - tmpD(2))*(tmpC(1) - NextPoint(1));
    tt2 = ta*tb;
    if tt1<0 &&tt2<0
        checklist(i) = 1;
    end
end
%NowPointとNextPointを結んだ直線
PreA = (NextPoint(2) - NowPoint(2)) / (NextPoint(1) - NowPoint(1));
% Calculation of "ax + by + c = 0"
if PreA > -1 && PreA < 1
    % Calculation of each coeffient in "y = ax + c"
    b = -1;
    a = PreA;
    c = -a* NowPoint(1) + NowPoint(2);
else
    % Calculation of each coeffient in "x = by + c"
    a = -1;
    b = (NextPoint(1) - NowPoint(1))/(NextPoint(2) - NowPoint(2));
    c = -b * NowPoint(2) + NowPoint(1);
end
%---a,b,cを使って判定---%
tt = find(checklist>0);
if ~isempty(tt(:))
    OverWall = true;
    a2 = MatchA(tt);
    b2 = MatchB(tt);
    c2 = MatchC(tt);
    y = (a2*c - a*c2)/(a*b2 - a2*b);
    x = (-b*y-c)/a;
    CrossPoint = [x;y];
else
    OverWall = false;
    CrossPoint = [0;0];
end
%-----------------------%
end


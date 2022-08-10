classdef TrackWpointPathForMPC < REFERENCE_CLASS
    % リファレンスを生成するクラス,
    % TrackingWayPointPathForMPC
    % 目標点に向かって一定速度で移動する軌道を生成
    % mpcのホライゾンすうと合わせる必要あり．
    %PointFlag =0;端点なしただ動く
    %PpintFlag = 1;端点を見つけたとき
    %PointFlag = 2;%目標位置に入ったあと
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
        w
    end
    
    methods
        function obj = TrackWpointPathForMPC(self,varargin)
            % 【Input】 map_param ,
            %  目標点の行列を受け取る．それに対応した目標速度を受け取る．
            %　目標点と速度に応じて参照軌道を作成，estimatorの値から収束判定をする．
            %  we make target of new section by convergence judgement
            %paramはReference.param
            obj.self = self;
            param = varargin{1};
            obj.WayPoint = param{1,1}; %WayPoint
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
            obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v];%pは位置,qは姿勢,vは速さ
            obj.Holizon = param{1,7};
            obj.SensorRange = 20;
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd"],'num_list',[4]));%x,y,theta,v
            obj.Flag = 0;
        end
        
        function  result= do(obj,param)
            %---推定器からデータを取得---%
            EstData = ...
                [obj.self.estimator.(obj.self.estimator.name).result.state.p;obj.self.estimator.(obj.self.estimator.name).result.state.q;...
                obj.self.estimator.(obj.self.estimator.name).result.state.v];%treat as a colmn vector
            LineXs = obj.self.estimator.result.map_param.x(:,1); %lineの始点のx座標
            LineXe = obj.self.estimator.result.map_param.x(:,2); %lineの終点のx座標
            LineYs = obj.self.estimator.result.map_param.y(:,1); %lineの始点のy座標
            LineYe = obj.self.estimator.result.map_param.y(:,2); %lineの終点のy座標
            %----------------------------%
            %EstDataは推定のロボットの位置
            %EstData(1)は推定のロボットのX座標、EstDAta(2)は推定のロボットのy座標
            %---SensorRange内に端点が入っているかを判定---%%今のセンサレンジで見える壁を引っ張て来ている
            JudgeSRs = (EstData(1) - LineXs).^2 + (EstData(2) - LineYs).^2 <= obj.SensorRange^2; %円の公式を使い始点がセンサレンジ内にあるかの判定
            JudgeSRe = (EstData(1) - LineXe).^2 + (EstData(2) - LineYe).^2 <= obj.SensorRange^2; %円の公式を使い終点がセンサレンジ内にあるかの判定
            InRange = JudgeSRs|JudgeSRe; %レンジ内なら1、レンジ外なら0
            MatchA = obj.self.estimator.result.map_param.a(InRange); %端点がレンジ内に入っている直線の方程式a
            MatchB = obj.self.estimator.result.map_param.b(InRange); %端点がレンジ内に入っている直線の方程式b
            MatchC = obj.self.estimator.result.map_param.c(InRange); %端点がレンジ内に入っている直線の方程式c
            MatchXs = obj.self.estimator.result.map_param.x(InRange,1);
            MatchXe = obj.self.estimator.result.map_param.x(InRange,2); %センサレンジ内に入っているlineの始点・終点のx座標を持ってきている
            MatchYs = obj.self.estimator.result.map_param.y(InRange,1);
            MatchYe = obj.self.estimator.result.map_param.y(InRange,2); %センサレンジ内に入っているlineの始点・終点のy座標を持ってきている

            %-------------------------------------------%
            
            obj.TrackingPoint = zeros(4,obj.Holizon);%set data size[x ;y ;theta;v] 
            
            %---judgement of convergence for estimate position---%
            switch obj.PointFlag
                case 0
                    %一定姿勢角，一定速度でreferenceを生成
                    NextPoint = obj.PreTrack(1:2,1) + [obj.SensorRange*cos(obj.Tracktheta);obj.SensorRange*sin(obj.Tracktheta)]; %obj.PreTrack(1:2,1)は現在位置
                    [OverWall,~,CrossPoint] = judgeingOverWall(obj.PreTrack(1:2,1),NextPoint,MatchXs,MatchXe,MatchYs,MatchYe,MatchA,MatchB,MatchC);
                    
                    if OverWall == true
                        obj.PointFlag = 1;
                        NextWayPoint = CrossPoint + [obj.Crossbuffer*cos(obj.Tracktheta+pi);obj.Crossbuffer*sin(obj.Tracktheta+pi)];%目標点の手前obj.Crossbuffer分
                        obj.WayPoint = [NextWayPoint;obj.Tracktheta;0];%収束すべき目標位置
                    end
                    obj.TrackingPoint(1:2,1) = obj.PreTrack(1:2,1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                    obj.TrackingPoint(3,1) = obj.Tracktheta;
                    obj.TrackingPoint(4,1) = obj.Targetv;
                    disp(obj.Tracktheta)
                    for i = 2:obj.Holizon
                        obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                        obj.TrackingPoint(3,i) = obj.Tracktheta;
                        obj.TrackingPoint(4,i) = obj.Targetv;
                    end
                case 1
                    %見つけた目標点に収束しているかを判定,位置と速度の収束判定
                    disp(obj.Tracktheta)
                    if (obj.PreTrack(1) - obj.WayPoint(1))^2 + (obj.PreTrack(2) - obj.WayPoint(2))^2 <= obj.ConvergencejudgeV
                        
                        Flag2track = obj.Tracktheta + obj.Rolltheta;
                        obj.Tracktheta = obj.Tracktheta + obj.Rolltheta;
                        obj.TrackingPoint(1:2,1) = obj.PreTrack(1:2,1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                        obj.PointFlag = 0;

                        if abs(EstData(3) - Flag2track) > obj.ConvergencejudgeW
                            obj.TrackingPoint(3,1) = EstData(3) + (Flag2track - EstData(3)) * obj.TargetGainw;
                        else
                             obj.TrackingPoint(3,1) = Flag2track;
                        end
                        

%                         %-------------------------------------------------%
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
                        if (obj.TrackingPoint(1,i-1) - obj.WayPoint(1,1))^2 + (obj.TrackingPoint(2,i-1) - obj.WayPoint(2,1))^2 <= obj.ConvergencejudgeV %円の公式を使っての収束判定
                            Flag2track = obj.Tracktheta + obj.Rolltheta; 
                            obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                             if abs(obj.TrackingPoint(3,i-1) - Flag2track) > obj.ConvergencejudgeW
                                obj.TrackingPoint(3,i) = obj.TrackingPoint(3,i-1) + (Flag2track - obj.TrackingPoint(3,i-1)) * obj.TargetGainw;
                             else
                                obj.TrackingPoint(3,i) = Flag2track;
                             end

                            else
                                obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.Tracktheta);obj.Targetv*obj.dt*sin(obj.Tracktheta)];
                                obj.TrackingPoint(3,i) = obj.Tracktheta;
                        end
                    end
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
%NowPointとNextPointを結んだ直線　基本的に0
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
if ~isempty(tt(:)) %ttが空ではないとき1,ttが空のとき0
    OverWall = true;
    a2 = MatchA(tt); %MatchA(1)
    b2 = MatchB(tt); %MatchB(1)
    c2 = MatchC(tt); %MatchC(1)
    y = (a2*c - a*c2)/(a*b2 - a2*b);
    x = (-b2*y-c2)/a2;
    CrossPoint = [x;y];
else
    OverWall = false;
    CrossPoint = [0;0];
end
%-----------------------%
end


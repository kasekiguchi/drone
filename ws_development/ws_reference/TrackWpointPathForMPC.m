classdef TrackWpointPathForMPC < REFERENCE_CLASS
    % リファレンスを生成するクラス,
    % TrackingWayPointPathForMPC
    % 目標点に向かって一定速度で移動する軌道を生成
    %廊下の真ん中を走行
    %最初に進む方向を指定．あとは左回りで動く
    % mpcのホライゾン数と合わせる必要あり．
    properties
        WayPoint
        Targetv
        Targetw
        ConvergencejudgeV
        ConvergencejudgeW
        TrackingPoint
        InitialPoint
        SensorRange
        Rsize
        Flag
        ChangeFlag
        NextMapParamidx
        CrossPoint
        RaneChangePoint
        zerojudge
        TargetAngle
        MapParamidx
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
            obj.Flag = 0;%WayPointのFlag管理
            obj.ChangeFlag = 0;%曲がる時のフラグ
            obj.zerojudge = 0.1;
            obj.ConvergencejudgeV = param{1,4};
            obj.ConvergencejudgeW = param{1,5};
            %             obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v;param{1,6}.w];
            obj.PreTrack = [param{1,6}.p;param{1,6}.q;param{1,6}.v];
            obj.Holizon = param{1,7};
            obj.SensorRange = 20;
            obj.Rsize = 0.1;
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
            if obj.Flag == 0
                %start running
                %---端点のデータ取得---%
                LineXs = obj.self.estimator.result.map_param.x(:,1);
                LineXe = obj.self.estimator.result.map_param.x(:,2);
                LineYs = obj.self.estimator.result.map_param.y(:,1);
                LineYe = obj.self.estimator.result.map_param.y(:,2);
                %---------------------%
                %---SensorRange内に端点が入っているかを判定---%
                JudgeSRs = (EstData(1) - LineXs).^2 + (EstData(2) - LineYs).^2 <= obj.SensorRange^2;
                JudgeSRe = (EstData(1) - LineXe).^2 + (EstData(2) - LineYe).^2 <= obj.SensorRange^2;
                InRange = JudgeSRs|JudgeSRe;
                MatchA = obj.self.estimator.result.map_param.a(InRange);MatchB = obj.self.estimator.result.map_param.b(InRange);MatchC = obj.self.estimator.result.map_param.c(InRange);
                MatchXs = obj.self.estimator.result.map_param.x(InRange,1);MatchXe = obj.self.estimator.result.map_param.x(InRange,2);
                MatchYs = obj.self.estimator.result.map_param.y(InRange,1);MatchYe = obj.self.estimator.result.map_param.y(InRange,2);
                %-------------------------------------------%
                Team = JudgingTeamOfLines(MatchA,MatchB,MatchC,MatchXs,MatchXe,MatchYs,MatchYe,obj.zerojudge);%線の組を判断
                mpXY = MidlePoint(EstData,obj.SensorRange,obj.Rsize,Team,MatchA,MatchB,MatchC);%真ん中の点群を出力
                %---姿勢角で判別していいほうの線に乗る---%
                Choised = zeros(1,size(Team,2));
                for i = 1:size(Team,2)
                    AngleChoiceA = atan2(mpXY{1,i}(2,1)- mpXY{1,i}(2,end),mpXY{1,i}(1,1)- mpXY{1,1}(1,end));
                    AngleChoiceB = atan2(mpXY{1,i}(2,end)- mpXY{1,i}(2,1),mpXY{1,i}(1,end)- mpXY{1,1}(1,1));
                    Choised(1,i) = min([abs(AngleChoiceA - EstData(3));[abs(AngleChoiceB - EstData(3))]]);
                end
                [m,Selectedidx] = min(abs(Choised));
                obj.TargetAngle = m;
                %----------------------------------------%
                %---線に乗ったreferenceを吐き出す---%
                obj.TrackingPoint = zeros(4,obj.Holizon);
                [~,idx] = min(vecnorm([EstData(1) - mpXY{1,Selectedidx}(1,:);EstData(2) - mpXY{1,Selectedidx}(2,:)],2,1));
                obj.TrackingPoint(:,1) = [mpXY{1,Selectedidx}(1,idx);mpXY{1,Selectedidx}(2,idx);obj.TargetAngle;obj.Targetv];
                for i = 2:obj.Holizon
                    obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.TargetAngle);obj.Targetv*obj.dt*sin(obj.TargetAngle)];
                    obj.TrackingPoint(3,i) = obj.TargetAngle;
                    obj.TrackingPoint(4,i) = obj.Targetv;
                end
                %-----------------------------------%
                obj.Flag =1;
                tmp = find(InRange);
                obj.MapParamidx = tmp(Team(:,Selectedidx));
            else
                %% running or curve
                if obj.ChangeFlag == 1
                    if (EstData(1) - obj.CrossPoint(1))^2 + (EstData(2) - obj.CrossPoint(2))^2 <= obj.ConvergencejudgeV
                        %収束してる
                        obj.MapParamidx = obj.NextMapParamidx;
                        obj.TargetAngle = obj.TargetAngle + (pi/2);
                        %---線に乗ったreferenceを吐き出す---%
                        obj.TrackingPoint = zeros(4,obj.Holizon);%ホライゾン数分の目標値
                        NmpXY = MidlePoint(EstData,obj.SensorRange,obj.Rsize,obj.MapParamidx,...
                            obj.self.estimator.result.map_param.a,obj.self.estimator.result.map_param.b,obj.self.estimator.result.map_param.c);%今乗っている線の中線
                        [~,idx] = min(vecnorm([EstData(1) - NmpXY{1,1}(1,:);EstData(2) - NmpXY{1,1}(2,:)],2,1));%
                        obj.TrackingPoint(:,1) = [NmpXY{1,1}(1,idx);NmpXY{1,1}(2,idx);obj.TargetAngle;obj.Targetv];%
                        %----------------------------------%
                        %---reference掃き出し---%
                        for i = 2:obj.Holizon
                                obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.TargetAngle);obj.Targetv*obj.dt*sin(obj.TargetAngle)];
                                obj.TrackingPoint(3,i) = obj.TargetAngle;
                                obj.TrackingPoint(4,i) = obj.Targetv;
                        end
                    else
                        %収束してない
                        %---線に乗ったreferenceを吐き出す---%
                        obj.TrackingPoint = zeros(4,obj.Holizon);%ホライゾン数分の目標値
                        NmpXY = MidlePoint(EstData,obj.SensorRange,obj.Rsize,obj.MapParamidx,...
                            obj.self.estimator.result.map_param.a,obj.self.estimator.result.map_param.b,obj.self.estimator.result.map_param.c);%今乗っている線の中線
                        [~,idx] = min(vecnorm([EstData(1) - NmpXY{1,1}(1,:);EstData(2) - NmpXY{1,1}(2,:)],2,1));%
                        obj.TrackingPoint(:,1) = [NmpXY{1,1}(1,idx);NmpXY{1,1}(2,idx);obj.TargetAngle;obj.Targetv];%
                        %----------------------------------%
                        dotPointX = [obj.TrackingPoint(1,1):obj.Rsize:obj.CrossPoint(1)];
                        dotPointY = [obj.TrackingPoint(2,1):obj.Rsize:obj.CrossPoint(2)];
                        for i = 2:obj.Holizon
                            tmp = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.TargetAngle);obj.Targetv*obj.dt*sin(obj.TargetAngle)];
                            [~,idx] = min(vecnorm([tmp(1) - dotPointX;tmp(2) - dotPointY],2,1));
                            if idx ==length(dotPointX)
                                obj.TrackingPoint(:,i) = [dotPointX(idx);dotPointX(idx);obj.TargetAngle;0];%収束するまで括りつける
                            else
                                obj.TrackingPoint(:,i) = [dotPointX(idx);dotPointX(idx);obj.TargetAngle;obj.Targetv];%まだ収束点まで到達していない
                            end
                        end
                    end
                else
                    %直進するとき
                    %---端点のデータ取得---%
                    LineXs = obj.self.estimator.result.map_param.x(:,1);
                    LineXe = obj.self.estimator.result.map_param.x(:,2);
                    LineYs = obj.self.estimator.result.map_param.y(:,1);
                    LineYe = obj.self.estimator.result.map_param.y(:,2);
                    %---------------------%
                    %---今乗っている線以外の線を探す---%
                    [MatchA,MatchB,MatchC,MatchXs,MatchXe,MatchYs,MatchYe,InRange]...
                        = SearchLine(EstData,LineXs,LineXe,LineYs,LineYe,obj.SensorRange,obj.MapParamidx,obj.self.estimator.result.map_param);
                    %-------------------------------------------%
                    %---今乗っている線以外の線の中線を探しその端点を返す---%
                    Team = JudgingTeamOfLines(MatchA,MatchB,MatchC,MatchXs,MatchXe,MatchYs,MatchYe,obj.zerojudge);%線の組を判断
                    mpXY = MidlePoint(EstData,obj.SensorRange,obj.Rsize,Team,MatchA,MatchB,MatchC);%真ん中の点群を出力
                    mXs = zeros(1,size(mpXY,2));mXe = zeros(1,size(mpXY,2));mYs = zeros(1,size(mpXY,2));mYe = zeros(1,size(mpXY,2));%格納配列を確保
                    for i = 1:size(mpXY,2)
                        mXs(1,i) = mpXY{1,i}(1,1);
                        mXe(1,i) = mpXY{1,i}(1,end);
                        mYs(1,i) = mpXY{1,i}(2,1);
                        mYe(1,i) = mpXY{1,i}(2,end);
                    end
                    %----------------------------------------%
                    %---線に乗ったreferenceを吐き出す---%
                    obj.TrackingPoint = zeros(4,obj.Holizon);%ホライゾン数分の目標値
                    NmpXY = MidlePoint(EstData,obj.SensorRange,obj.Rsize,obj.MapParamidx,...
                        obj.self.estimator.result.map_param.a,obj.self.estimator.result.map_param.b,obj.self.estimator.result.map_param.c);%今乗っている線の中線
                    [~,idx] = min(vecnorm([EstData(1) - NmpXY{1,1}(1,:);EstData(2) - NmpXY{1,1}(2,:)],2,1));%
                    obj.TrackingPoint(:,1) = [NmpXY{1,1}(1,idx);NmpXY{1,1}(2,idx);obj.TargetAngle;obj.Targetv];%
                    %----------------------------------%
                    %---reference掃き出し---%
                    for i = 2:obj.Holizon
                        if obj.ChangeFlag == 1
                            obj.TrackingPoint(1:2,i) = obj.CrossPoint;
                            obj.TrackingPoint(3,i) = obj.TargetAngle;
                            obj.TrackingPoint(4,i) = 0;
                        else
                            obj.TrackingPoint(1:2,i) = obj.TrackingPoint(1:2,i-1) + [obj.Targetv*obj.dt*cos(obj.TargetAngle);obj.Targetv*obj.dt*sin(obj.TargetAngle)];
                            obj.TrackingPoint(3,i) = obj.TargetAngle;
                            obj.TrackingPoint(4,i) = obj.Targetv;
                            [obj.ChangeFlag,TeamNum,obj.CrossPoint] = judgeingOverWall(obj.TrackingPoint(:,i),obj.TrackingPoint(:,i-1),mXs,mXe,mYs,mYe,MatchA,MatchB,MatchC);
                            if obj.ChangeFlag == 1
                                tmp = find(InRange);
                                obj.NextMapParamidx = tmp(Team(:,TeamNum));
                                obj.TrackingPoint(1:2,i) = obj.CrossPoint;
                                obj.TrackingPoint(3,i) = obj.TargetAngle;
                                obj.TrackingPoint(4,i) = 0;%収束させる
                                %
                            end
                        end
                    end
                    %-----------------------------------------%
                end
            end
            obj.result.state = obj.TrackingPoint;%treat as a colmn vector
            obj.self.reference.result.state = obj.TrackingPoint;
            %resultに代入
            result=obj.result;
        end
        
        function show(obj,logger)
            
        end
    end
end

function Team = JudgingTeamOfLines(MatchA,MatchB,MatchC,MatchXs,MatchXe,MatchYs,MatchYe,zerojudge)
%---線の組を判定---%
TeamA = MatchA;TeamB = MatchB;TeamC = MatchC;
Team = [];
while length(TeamA) > 1
    AA = (TeamA(1) - MatchA(:)).^2 < zerojudge;
    BB = (TeamB(1) - MatchB(:)).^2 < zerojudge;
    CC = (TeamC(1) - MatchC(:)).^2 < zerojudge;
    AABB = AA & BB;
    AABBCC = AABB & CC;
    AABBNCC = AABB & ~CC;
    if length(find(AABBCC))>1
        SearNea = vecnorm([MatchXs(AABBCC) - MatchXe(AABBCC),MatchYs(AABBCC) - MatchYe(AABBCC)],2,2);%長い線を残す
        [~,idx] = max(SearNea);
        SS = find(AABBCC);
        AABBCC(SS) = 0;AABBCC(SS(idx)) = 1;
    end
    
    if length(find(AABBNCC)) > 1
        SearNea = vecnorm([MatchXs(AABBNCC) - MatchXe(AABBNCC),MatchYs(AABBNCC) - MatchYe(AABBNCC)],2,2);
        [~,idx] = max(SearNea);
        SS = find(AABBNCC);
        AABBNCC(SS) = 0;AABBNCC(SS(idx)) = 1;
    end
    if isempty(find(AABBCC,1)) || isempty(find(AABBNCC,1))
        TeamA((TeamA(1) - TeamA(:)).^2 < zerojudge) = [];
        TeamB((TeamB(1) - TeamB(:)).^2 < zerojudge) = [];
        TeamC((TeamC(1) - TeamC(:)).^2 < zerojudge) = [];
    else
        Team = [Team,[find(AABBCC);find(AABBNCC)]];
        TeamA((TeamA(1) - TeamA(:)).^2 < zerojudge) = [];
        TeamB((TeamB(1) - TeamB(:)).^2 < zerojudge) = [];
        TeamC((TeamC(1) - TeamC(:)).^2 < zerojudge) = [];
    end
    
end
%-----------------%
end
function [mpXY] = MidlePoint(EstData,SensorRange,Rsize,Team,MatchA,MatchB,MatchC)
%---inレンジに入っている線同士の中点を引く---%
[MX,MY] = meshgrid(EstData(1)-SensorRange:Rsize:EstData(1)+SensorRange,EstData(2)-SensorRange:Rsize:EstData(2)+SensorRange);
MX = reshape(MX,1,[]);
MY = reshape(MY,1,[]);
mpXY = cell(1,size(Team,2));
for i = 1:size(Team,2)
    %                 MatchXs(Team(1,i));MatchYs(Team(1,i));
    %                 MatchXe(Team(1,i));MatchYe(Team(1,i));
    DisA = arrayfun(@(L) abs(MatchA(Team(1,i)) * MX(L) + MatchB(Team(1,i)) * MY(L) + MatchC(Team(1,i)))/sqrt(MatchA(Team(1,i))^2 + MatchB(Team(1,i))^2),1:length(MX));
    DisB = arrayfun(@(L) abs(MatchA(Team(2,i)) * MX(L) + MatchB(Team(2,i)) * MY(L) + MatchC(Team(2,i)))/sqrt(MatchA(Team(2,i))^2 + MatchB(Team(2,i))^2),1:length(MX));
    Midlejudge = abs(DisA - DisB) < Rsize;
    mpXY{1,i} = [MX(Midlejudge);MY(Midlejudge)];
end
%------------------------------------------%
end

function [MatchA,MatchB,MatchC,MatchXs,MatchXe,MatchYs,MatchYe,InRange] = SearchLine(EstData,LineXs,LineXe,LineYs,LineYe,SensorRange,MapParamidx,MapParam)
JudgeSRs = (EstData(1) - LineXs).^2 + (EstData(2) - LineYs).^2 <= SensorRange^2;
JudgeSRe = (EstData(1) - LineXe).^2 + (EstData(2) - LineYe).^2 <= SensorRange^2;
OnLine = true(length(JudgeSRe),1);
OnLine(MapParamidx) = false;
InRange = (JudgeSRs | JudgeSRe) & OnLine;
MatchA = MapParam.a(InRange);%線のパラメータ
MatchB = MapParam.b(InRange);
MatchC = MapParam.c(InRange);
MatchXs = MapParam.x(InRange,1);%端点データ
MatchXe = MapParam.x(InRange,2);
MatchYs = MapParam.y(InRange,1);
MatchYe = MapParam.y(InRange,2);
end

function [OverWall,tt,CrossPoint] = judgeingOverWall(NowPoint,NextPoint,MatchXs,MatchXe,MatchYs,MatchYe,MatchA,MatchB,MatchC)
%NowPointとNextPointを結んだ直線
PreA = (NextPoint(2) - NowPoint(2)) / (NextPoint(1) - NowPoint(1));
% Calculation of "ax + by + c = 0"
if PreA > -1 && PreA < 1
    % Calculation of each coeffient in "y = ax + c"
    b = -1;
    a = PreA;
    c = -a* (NowPoint(1)) + NowPoint(2);
else
    % Calculation of each coeffient in "x = by + c"
    a = -1;
    b = (NextPoint(1) - NowPoint(1))/(NextPoint(2) - NowPoint(2));
    c = -b * NowPoint(2) + NowPoint(1);
end
%---a,b,cを使って判定---%
% ts = a * MatchXs + b * MatchYs + c;
% te = a * MatchXe + b * MatchYe + c;
ts = MatchA *NowPoint(1)  + MatchB * NowPoint(2) + MatchC;
te = MatchA *NextPoint(1)  + MatchB * NextPoint(2) + MatchC;
tt = ts.*te;
tt = find(tt < 0);
if ~isempty(tt(:))
    OverWall = true;
    y = (MatchA(tt)*c - a*MatchC(tt))/(a*MatchB(tt) - MatchA(tt)*b);
    x = (-b/a)*y - c;
    CrossPoint = [x,y];
else
    OverWall = false;
    CrossPoint = [0,0];
end
%-----------------------%
end

classdef PathReferenceForMPC < REFERENCE_CLASS
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
        step
        self
        w
        O = []
        R = eye(2)
        th = [];
    end
    
    methods
        function obj = PathReferenceForMPC(self,varargin)
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
            obj.step = 1;
            obj.SensorRange = self.sensor.LiDAR.radius;
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[4,4,1,1]));%x,y,theta,v
            obj.Flag = 0;
        end
        
        function  result= do(obj,param)
            %---推定器からデータを取得---%
%             EstData = ...
%                 [obj.self.estimator.(obj.self.estimator.name).result.state.p;obj.self.estimator.(obj.self.estimator.name).result.state.q;...
%                 obj.self.estimator.(obj.self.estimator.name).result.state.v];%treat as a colmn vector
            EstData = obj.self.estimator.result.state.get();
            LineXs = obj.self.estimator.result.map_param.x(:,1); %lineの始点のx座標
            LineXe = obj.self.estimator.result.map_param.x(:,2); %lineの終点のx座標
            LineYs = obj.self.estimator.result.map_param.y(:,1); %lineの始点のy座標
            LineYe = obj.self.estimator.result.map_param.y(:,2); %lineの終点のy座標
            lineids = abs(LineXe - LineXs) + abs(LineYe - LineYs) > 0.1; % lineと認識する長さ：約1.4cm 以上ないとlineとみなさないようにする．TODO
            %----------------------------%
            %EstDataは推定のロボットの位置
            %EstData(1)は推定のロボットのX座標、EstDAta(2)は推定のロボットのy座標
            %---SensorRange内に端点が入っているかを判定---%%今のセンサレンジで見える壁を引っ張て来ている
            JudgeSRs = (EstData(1) - LineXs).^2 + (EstData(2) - LineYs).^2 <= obj.SensorRange^2; %円の公式を使い始点がセンサレンジ内にあるかの判定
            JudgeSRe = (EstData(1) - LineXe).^2 + (EstData(2) - LineYe).^2 <= obj.SensorRange^2; %円の公式を使い終点がセンサレンジ内にあるかの判定
            InRange = (JudgeSRs|JudgeSRe)&lineids; %レンジ内なら1、レンジ外なら0
            MatchA = obj.self.estimator.result.map_param.a(InRange); %端点がレンジ内に入っている直線の方程式a
            MatchB = obj.self.estimator.result.map_param.b(InRange); %端点がレンジ内に入っている直線の方程式b
            MatchC = obj.self.estimator.result.map_param.c(InRange); %端点がレンジ内に入っている直線の方程式c
            MatchXs = obj.self.estimator.result.map_param.x(InRange,1);
            MatchXe = obj.self.estimator.result.map_param.x(InRange,2); %センサレンジ内に入っているlineの始点・終点のx座標を持ってきている
            MatchYs = obj.self.estimator.result.map_param.y(InRange,1);
            MatchYe = obj.self.estimator.result.map_param.y(InRange,2); %センサレンジ内に入っているlineの始点・終点のy座標を持ってきている
            %-------------------------------------------%
            
            obj.TrackingPoint = zeros(4,obj.Holizon);%set data size[x ;y ;theta;v] 
            %wvec=[MatchXe-MatchXs,MatchYe-MatchYs]; % wall vector
            % Current time reference position calced at previous time
            x = EstData(1);
            y = EstData(2);
%plot(reshape([MatchXs,MatchXe,NaN(size(MatchXs,1),1)]',[3*size(MatchXs,1),1]),reshape([MatchYs,MatchYe,NaN(size(MatchYs,1),1)]',[3*size(MatchYs,1),1]),x,y,'ro');
            % estimated lines
            a = MatchA;
            b = MatchB;
            c = MatchC;           
            k = (a.^2 - b.^2);% tmp const
            X= -(x.*b.^2 + a.*y.*b + a.*c); % ./(a.^2 - b.^2) % 垂線の足*k a=bの特異性を除くため
            Y= (y.*a.^2 + b.*x.*a + b.*c); % ./(a.^2 - b.^2)
            del=[X - k.*x,Y - k.*y]; % (垂線の足への相対ベクトル)*k
            ds = [MatchXs-x,MatchYs-y].*k; % wall 始点への相対ベクトル
            de = [MatchXe-x,MatchYe-y].*k; % wall 終点への相対ベクトル
            ip = sum((ds - del).*(de - del),2); % 内積
            wid = find(ip < 1e-1); % 垂線の足が壁面内にある壁面インデックス
            d = sum(del.^2,2);%abs(MatchC)./sqrt(MatchA.^2+MatchB.^2);
%[ip,d,MatchXs,MatchYs,MatchXe,MatchYe]
            [~,ids]=mink(d(wid),2);
            ids=wid(ids);
            l1 = [a(ids(1)),b(ids(1)),c(ids(1))]*sign(b(ids(1))); % y係数を正とする
            l2 = [a(ids(2)),b(ids(2)),c(ids(2))]*sign(b(ids(2)));
            if l1*l2'<0
                l2 = -l2;
            end
            % Current time reference position calced at previous time
            rx = obj.PreTrack(1);
            ry = obj.PreTrack(2);

            O = [x;y];
            th = EstData(3);
            if abs(prod(a(ids)+prod(b(ids))))<1e-2 % ほぼ直交している場合（傾きの積が-1の式より）
                % 入りと出で同じ幅の通路を前提としてしまっている．
                % 初期値が垂直二等分線上でもその場で回転するだけになる．
                %p12 = cr(l1,l2);
                if isempty(obj.O)
                if (l1*[x;y;1])*(l2*[x;y;1])<0 % 相対で見たとき ax+by+c=0 のcの符号が異なる状態で足せば機体側の2等分線になる
                    l3 = (l1+l2)/2;
                else
                    l3 = (l1-l2)/2;
                end
                l4 = perp(l1,[rx;ry]);
                obj.O = cr(l4,l3);
                obj.R = vecnorm(obj.O-[rx;ry]);
                obj.th = obj.step*obj.Targetv/obj.R;
                end
                th = obj.th;
                O = obj.O;
                R = obj.R;
                Rmat = [cos(th),-sin(th);sin(th),cos(th)];
                tmp0 = [x;y]-O;
                tmp0 = tmp0/vecnorm(tmp0);
                tmp = cross([0;0;1],[tmp0;0]);
                tmpt0 = atan2(tmp(2),tmp(1));
                tmp0 = R*tmp0;
                tmp(:,1) = [tmp0+O;tmpt0];
                for i = 2:obj.Holizon
                    tmp0 = Rmat*tmp0;
                    tmpt0 = tmpt0 + th;
                    tmp(:,i) = [tmp0+O;tmpt0];
                end
                obj.TrackingPoint = [tmp;obj.Targetv*ones(1,size(tmp,2))];
            else % ほぼ平行な場合
                obj.O = [];
                rl = (l1+l2)/2; % reference line
                tmpl = perp(rl,[x;y]); % 機体を通るrl の垂線
                tmp0 = cr(rl,tmpl); % 機体からrlへの垂線の足
                %tmp0 = [x;y];
                rl = rl*sign([rl(2),-rl(1)]*[cos(th);sin(th)]); % 機体の向いている向きが[rl(2),-rl(1)]で正となるように             
                tmpt0 = atan2(-rl(1),rl(2));
                tmp(:,1) = [tmp0;tmpt0];
                for i = 2:obj.Holizon
                    tmp0 = tmp0+obj.step*obj.Targetv*[rl(2);-rl(1)]/vecnorm(rl(1:2));
                    tmp(:,i) = [tmp0;tmpt0];
                end
                obj.TrackingPoint = [tmp;obj.Targetv*ones(1,size(tmp,2))];
            end
            q = EstData(3);
            qr = obj.TrackingPoint(3,:);
            tmp = q - qr > 4;
            qr(tmp) = qr(tmp)+2*pi;
            tmp = q - qr < -4;
            qr(tmp) = qr(tmp)-2*pi;      
            obj.TrackingPoint(3,:) = qr;

            obj.result.state.set_state("xd",obj.TrackingPoint);%treat as a colmn vector
            obj.result.state.set_state("p",obj.TrackingPoint);%treat as a colmn vector
            obj.result.state.set_state("q",obj.TrackingPoint(3,1));%treat as a colmn vector
            obj.result.state.set_state("v",obj.TrackingPoint(4,1));%treat as a colmn vector
            %obj.self.reference.result.state = obj.TrackingPoint;
            %---Get Data of previous step---%
            obj.PreTrack = obj.TrackingPoint(:,1);
            %-------------------------------%
            %resultに代入
            obj.result.focusedLine = [[MatchXs(ids(1));MatchXe(ids(1));NaN;MatchXs(ids(2));MatchXe(ids(2))],[MatchYs(ids(1));MatchYe(ids(1));NaN;MatchYs(ids(2));MatchYe(ids(2))]];
            obj.result.O = O;
            obj.result.th = th;
            obj.result.step = obj.step;
            result=obj.result;            
        end
        
        function show(obj,result)
            arguments
                obj
                result = []
            end
            if isempty(result)
                result = obj.result;
            end
            l = result.focusedLine;
            p = result.O;
            th = result.th;
            rp = result.state.p(1:2,:);
            rth = result.state.p(3,:);
            plot(l(1:2,1),l(1:2,2),'LineWidth',3,'Color','b');
            plot(l(4:5,1),l(4:5,2),'LineWidth',2,'Color','r');
            hold on            
            plot(rp(1,:),rp(2,:),'yo','LineWidth',1);
            quiver(rp(1,:),rp(2,:),2*cos(rth),2*sin(rth),'Color','y');         
            plot(p(1),p(2),'ro');
            quiver(p(1),p(2),cos(th),sin(th),'Color','r');  
            hold off
        end
    end
end
function L = perp(l,p)
% pを通るlと垂直な直線
L = [-l(2), l(1), l(2)*p(1)-l(1)*p(2)];
end
function p = cr(l1,l2)
% l1 と l2の交点
 a1 = l1(1);
 b1 = l1(2);
 c1 = l1(3);
 a2 = l2(1);
 b2 = l2(2);
 c2 = l2(3);
 d = (a1*b2 - a2*b1);
 if d == 0
     error("ACSL : l1 and l2 are parallel");
 else
    p(1,1) = (b1*c2 - b2*c1)/d;
    p(2,1) = -(a1*c2 - a2*c1)/d;
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


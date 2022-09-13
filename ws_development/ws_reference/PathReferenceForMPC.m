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
        O = [] % 回転中心
        r  % 回転半径
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
            obj.result.PreTrack = obj.PreTrack;
            obj.Holizon = param{1,7};
            obj.step = 1;
            obj.SensorRange = self.sensor.LiDAR.radius;
            obj.dt = obj.self.model.dt;
            obj.WayPointNum = length(obj.WayPoint);
            obj.result.state=STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[4,4,1,1]));%x,y,theta,v
            obj.Flag = 0;
        end

        function  result= do(obj,param)
             EstData = obj.self.estimator.result.state.get();
             pe = EstData(1:2);
             the = EstData(3);
             R = [cos(the), -sin(the);sin(the), cos(the)];

%% そもそも推定値を使わずリファレンスを作る．
            sensor = obj.self.sensor.result;
            LP = UKFPointCloudToLine(sensor.length, sensor.angle, [0;0;0], obj.self.estimator.ukfslam_WC.constant);
            % x, y が全て０のLPを削除 UKFCombiningLinesで使っているフィールドだけ削除
            tmpid=sum([LP.x,LP.y],2)==0; 
            LP.x(tmpid,:) = [];
            LP.y(tmpid,:) = [];
            LP.a(tmpid,:) = [];
            LP.b(tmpid,:) = [];
            LP.c(tmpid,:) = [];
            LP.index(tmpid,:) = [];
            %tl=size(LP.x,1);
            %plot(reshape([LP.x,NaN(tl,1)],[3*tl,1]),reshape([LP.y,NaN(tl,1)],[3*tl,1]));axis equal;

            % 同一直線を統合
%             ABC = [LP.a,LP.b,LP.c];
%             X = LP.x;
%             Y = LP.y;
%             %[~,ia,ic] = uniquetol(ABC,'ByRows',true);
%             [~,ia,ic] = uniquetol(sign(ABC(:,3)).*ABC./vecnorm(ABC(:,1:2),2,2),'ByRows',true);
%             LP.index = LP.index(ia,:);
%             LP.a = LP.a(ia);
%             LP.b = LP.b(ia);
%             LP.c = LP.c(ia);
%             LP.x = LP.x(ia,:);
%             LP.y = LP.y(ia,:);
%             for i = 1:length(ia)
%                 did = find(ic==i); % duplicated ids
%                 LP.x(i,1) = min(X(did,:),[],'all');
%                 LP.x(i,2) = max(X(did,:),[],'all');
%                 if LP.a(i)*LP.b(i) > 0 % 右下がり
%                     LP.y(i,1) = max(Y(did,:),[],'all');
%                     LP.y(i,2) = min(Y(did,:),[],'all');
%                 else % 右上がり
%                     LP.y(i,1) = min(Y(did,:),[],'all');
%                     LP.y(i,2) = max(Y(did,:),[],'all');
%                 end
%             end

            a = LP.a;
            b = LP.b;
            c = LP.c;
            Xs = LP.x(:,1);
            Xe = LP.x(:,2);
            Ys = LP.y(:,1);
            Ye = LP.y(:,2);
            lineids = abs(Xe - Xs) + abs(Ye - Ys) > 1; % lineと認識する長さ：約1.4cm 以上ないとlineとみなさないようにする．TODO
            a = a(lineids);
            b = b(lineids);
            c = c(lineids);
            Xs = Xs(lineids);
            Xe = Xe(lineids);
            Ys = Ys(lineids);
            Ye = Ye(lineids);
            x = 0;
            y = 0;

            obj.TrackingPoint = zeros(4,obj.Holizon);%set data size[x ;y ;theta;v]
            
<<<<<<< HEAD
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
=======
%            k = (a.^2 + b.^2);% tmp const
%            aeqbids=abs(k)< 1E-4; % k が０となるインデックス
%             X= -(x.*b.^2 + a.*y.*b + a.*c); % ./(a.^2 - b.^2) % 垂線の足*k a=bの特異性を除くため
%             Y= (y.*a.^2 + b.*x.*a + b.*c); % ./(a.^2 - b.^2)
%             X(~aeqbids) = X(~aeqbids)./k(~aeqbids);
%             Y(~aeqbids) = Y(~aeqbids)./k(~aeqbids);
%             X(aeqbids) = (x(aeqbids)+y(aeqbids)-c(aeqbids)/a(aeqbids))/2;
%             Y(aeqbids) = (x(aeqbids)+y(aeqbids)+c(aeqbids)/a(aeqbids))/2;
            del = [-a.*c,-b.*c]./(a.^2+b.^2); % 垂線の足

            %del=[X - x,Y - y]; % (垂線の足への相対ベクトル)
%             ds = [Xs-x,Ys-y]; % wall 始点への相対ベクトル
%             de = [Xe-x,Ye-y]; % wall 終点への相対ベクトル
            ds = [Xs,Ys]; % wall 始点への相対ベクトル
            de = [Xe,Ye]; % wall 終点への相対ベクトル
            ip = sum((ds - del).*(de - del),2); % 垂線の足から始点，終点それぞれへのベクトルの内積
            wid = find(ip < 1e-1); % 垂線の足が壁面内にある壁面インデックス：内積が負になる．（少し緩和している）
            d = vecnorm(del,2,2); % 壁面までの距離
            %[ip,d,Xs,Ys,Xe,Ye]
            [~,idm]=min(d(wid)); % 一番近い壁面
            [~,idm2]=min(del(wid(idm),:)*del(wid,:)');
            ids=[idm,idm2];
>>>>>>> 5a034dc90909376735318d154576aa3dbe38f996
            ids=wid(ids);
%             l1 = [a(ids(1)),b(ids(1)),c(ids(1))]*sign(b(ids(1))); % y係数を正とする
%             l2 = [a(ids(2)),b(ids(2)),c(ids(2))]*sign(b(ids(2)));
            l1 = [a(ids(1)),b(ids(1)),c(ids(1))]/vecnorm([a(ids(1)),b(ids(1))]);%*sign(b(ids(1)));
            l2 = [a(ids(2)),b(ids(2)),c(ids(2))]/vecnorm([a(ids(2)),b(ids(2))]);%*sign(b(ids(2)));
            if l1*l2'<0
                l2 = -l2;
            end
            % Current time reference position calced at previous time
            rx = obj.result.PreTrack(1) - pe(1); % relative position
            ry = obj.result.PreTrack(2) - pe(2);

            if abs(prod(a(ids))+prod(b(ids)))<1e-1 % ほぼ直交している場合（傾きの積が-1の式より）
                % 入りと出で同じ幅の通路を前提としてしまっている．
                % 初期値が垂直二等分線上でもその場で回転するだけになる．
                %p12 = cr(l1,l2);
                if isempty(obj.O)
                    e1=[ds(ids(1),:);de(ids(1),:)];% line1 edge
                    e2=[ds(ids(2),:);de(ids(2),:)];% line2 edge
                    p = cr(l1,l2);
                    tmp=[e1;e2]-p';
                    if sum(vecnorm(tmp,2,2) < 0.5) % lineの近い方の距離が近い => 直交して交わる
                        %if (l1*[x;y;1])*(l2*[x;y;1])<0 % l*[x;y;1]がロボットから見た直線の位置（符号付き）
                        if l1(3)*l2(3) < 0 % l*[x;y;1]がロボットから見た直線の位置（符号付き）
                            % 相対で見たとき ax+by+c=0 のcの符号が異なる状態で足せば機体側の2等分線になる
                            l3 = (l1+l2)/2;
                        else
                            l3 = (l1-l2)/2;
                        end
                        l4 = perp(l1,[rx;ry]);
                        obj.O = cr(l4,l3);% 回転中心：相対座標
                        obj.r = vecnorm(obj.O-[rx;ry]);
                    else % 遠い => 交わらない線分：推定が失敗してくると生じる
                        [~,id1]=min(vecnorm(e1,2,2)); % 近いedgeのインデックス
                        [~,id2]=min(vecnorm(e2-e1(id1,:),2,2));
                        de1 = vecnorm(e1(id1,:)'-[rx;ry]);
                        de2 = vecnorm(e2(id2,:)'-[rx;ry]);
                        if de1 < de2
                            obj.O = (e1(id1,:) + [x y])';
                            obj.r = de1;
                        else
                            obj.O = (e2(id2,:) + [x y])';
                            obj.r = de2;
                        end
                    end
                    obj.th = obj.step*obj.Targetv/obj.r;
                    obj.O = R*obj.O + pe; % 絶対座標位置
                end
                th = obj.th;
                O = R'*(obj.O-pe);%ボディから見た回転中心位置ベクトルの位置に変換
                r = obj.r;
                Rmat = [cos(th),-sin(th);sin(th),cos(th)];
                tmp0 = -O;%[x;y]-O;
                tmp0 = tmp0/vecnorm(tmp0);% 回転中心から機体の位置方向の単位ベクトル
                tmp = cross([0;0;1],[tmp0;0]);% 機体の進むべき向き
                tmpt0 = atan2(tmp(2),tmp(1));% 現在時刻の目標姿勢角
                tmp0 = r*tmp0; % Oから見た現在時刻の目標位置
                tmp(:,1) = [tmp0 + O;tmpt0];
                for i = 2:obj.Holizon
                    tmp0 = Rmat*tmp0;
                    tmpt0 = tmpt0 + th;
                    tmp(:,i) = [tmp0+O;tmpt0];
                end
                obj.TrackingPoint = [tmp;obj.Targetv*ones(1,size(tmp,2))]; %　相対座標
            else % ほぼ平行な場合
                %if check_line_validity([Xs(ids);Xe(ids)],[Ys(ids);Ye(ids)])
                obj.O = []; th = [];
                %if (l1*[x;y;1])*(l2*[x;y;1])<0 % l*[x;y;1]がロボットから見た直線の位置（符号付き）
                if l1(3)*l2(3)<0 % l*[x;y;1]がロボットから見た直線の位置（符号付き）
                    % 相対で見たとき ax+by+c=0 のcの符号が異なる状態で足せば機体側の2等分線になる
                    rl = (l1+l2)/2;
                else
                    rl = (l1-l2)/2;
                end
                %rl = (l1+l2)/2; % reference line
                tmpl = perp(rl,[0;0]); % 機体を通るrl の垂線
                if sum(tmpl) == 0
                    rl;
                end
                tmp0 = cr(rl,tmpl); % 機体からrlへの垂線の足
                %tmp0 = [x;y];
                rl = rl*sign([rl(2),-rl(1)]*[1;0]);%[cos(th);sin(th)]); % 機体の向いている向きが[rl(2),-rl(1)]で正となるように
                tmpt0 = atan2(-rl(1),rl(2));
                tmp(:,1) = [tmp0;tmpt0];
                for i = 2:obj.Holizon
                    tmp0 = tmp0+obj.step*obj.Targetv*[rl(2);-rl(1)]/vecnorm(rl(1:2));
                    tmp(:,i) = [tmp0;tmpt0];
                end
                obj.TrackingPoint = [tmp;obj.Targetv*ones(1,size(tmp,2))];
                %end
            end

            % ここから絶対座標に戻す．
            R = [cos(the),-sin(the);sin(the),cos(the)];
            obj.TrackingPoint(1:2,:) = R*obj.TrackingPoint(1:2,:) + pe;
            obj.TrackingPoint(3,:) = obj.TrackingPoint(3,:) + the;

            qr = obj.TrackingPoint(3,:);
            tmp = the - qr > 4;
            qr(tmp) = qr(tmp)+2*pi;
            tmp = the - qr < -4;
            qr(tmp) = qr(tmp)-2*pi;
            obj.TrackingPoint(3,:) = qr;

            obj.result.state.set_state("xd",obj.TrackingPoint);%treat as a colmn vector
            obj.result.state.set_state("p",obj.TrackingPoint);%treat as a colmn vector
            obj.result.state.set_state("q",obj.TrackingPoint(3,1));%treat as a colmn vector
            obj.result.state.set_state("v",obj.TrackingPoint(4,1));%treat as a colmn vector
            if vecnorm(obj.result.PreTrack - obj.TrackingPoint(:,1))>3
                obj.O;
            end
            obj.PreTrack = obj.TrackingPoint(:,1);
            obj.result.PreTrack = obj.TrackingPoint(:,1);
            %obj.self.reference.result.state = obj.TrackingPoint;
            %---Get Data of previous step---%
            %-------------------------------%
            %resultに代入
            if isempty(obj.O)                
                obj.result.O = pe;
            else
                obj.result.O = obj.O;% 回転中心（絶対座標）
            end
            if obj.TrackingPoint(3,1) > 3
                th
            end
            obj.result.th = th; % 回転角
            obj.result.focusedLine = (R*[[Xs(ids(1));Xe(ids(1));NaN;Xs(ids(2));Xe(ids(2))],[Ys(ids(1));Ye(ids(1));NaN;Ys(ids(2));Ye(ids(2))]]')'+pe';
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
            rp = result.state.p(1:2,:);
            rth = result.state.p(3,:);
            plot(l(1:2,1),l(1:2,2),'LineWidth',3,'Color','b');
            hold on
            plot(l(4:5,1),l(4:5,2),'LineWidth',2,'Color','r');
            plot(rp(1,:),rp(2,:),'yo','LineWidth',1);
            quiver(rp(1,:),rp(2,:),2*cos(rth),2*sin(rth),'Color','y');
            p = result.O;
            plot(p(1),p(2),'r*');
            p = obj.self.estimator.result.state.p;
            th = obj.self.estimator.result.state.q;
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
function [OverWall,tt,CrossPoint] = judgeingOverWall(NowPoint,NextPoint,Xs,Xe,Ys,Ye,A,B,C)
%Linecheck
checklist = zeros(size(Xs,1),1);
for i = 1:size(Xs,1)
    tmpC = [Xs(i,1);Ys(i,1)];
    tmpD = [Xe(i,1);Ye(i,1)];
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
    a2 = A(tt); %A(1)
    b2 = B(tt); %B(1)
    c2 = C(tt); %C(1)
    y = (a2*c - a*c2)/(a*b2 - a2*b);
    x = (-b2*y-c2)/a2;
    CrossPoint = [x;y];
else
    OverWall = false;
    CrossPoint = [0;0];
end
%-----------------------%
end
function t_or_f = check_line_validity(x,y)
% x = [x1,x3,x2,x4]', y = [y1,y3,y2,y4]'
% 線分：X1-X2, X3-X4　が交点を持つ場合０　無ければ１を返す．
X1 = [x(1);y(1)];
X2 = [x(3);y(3)];
X3 = [x(2);y(2)];
X4 = [x(4);y(4)];
X31=X3-X1; X31 = [X31(2);-X31(1)];
X41=X4-X1; X41 = [X41(2);-X41(1)];
X13=X1-X3; X13 = [X13(2);-X13(1)];
X23=X2-X3; X23 = [X23(2);-X23(1)];
t_or_f = ~(((X2-X1)'*X31*X41'*(X2-X1) < 0) & ((X4-X3)'*X13*X23'*(X4-X3)<0));
end
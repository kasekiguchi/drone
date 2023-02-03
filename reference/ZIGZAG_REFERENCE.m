classdef ZIGZAG_REFERENCE < REFERENCE_CLASS
    % 通路の中心を通るリファレンスを生成するクラス
    % 曲がり角では外側の二本の壁面の中線と曲がり角に進入時の位置から近い壁面に下した垂線の交点を中心とした回転をする．
    properties
        refv
        PreTrack
        dt
        SensorRange
        Horizon
        ztheta
        step % horizon step
        self
        w
        O = [] % 回転中心
        r  % 回転半径
        th = [];
        constant
        trackcase
        count
    end

    methods
        function obj = ZIGZAG_REFERENCE(self,varargin)
            % 【Input】 map_param ,
            %  目標点の行列を受け取る．それに対応した目標速度を受け取る．
            %　目標点と速度に応じて参照軌道を作成，estimatorの値から収束判定をする．
            %  we make target of new section by convergence judgement
            %paramはReference.param
            obj.self = self;
            param = varargin{1};
            obj.refv = param{1,1};
            obj.PreTrack = obj.self.model.state.get();%位置,姿勢,速さ
            obj.result.PreTrack = obj.PreTrack;
            obj.Horizon = param{1,2};
            obj.step = 3;
            obj.SensorRange = param{1,3};
            obj.dt = obj.self.model.dt;
            obj.result.state=STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[4,4,1,1]));%x,y,theta,v
            obj.constant = param{1,4};
            obj.ztheta = param{1,5};
            obj.trackcase = 0;
            obj.count = 0;
        end

        function  result= do(obj,param)
            EstData = obj.self.estimator.result.state.get();
            pe = EstData(1:2);
            the = EstData(3);
            R = [cos(the), -sin(the);sin(the), cos(the)];

            % ここから相対座標上での議論
            sensor = obj.self.sensor.result;
            % 相対座標でのline parameterを算出
            LP = PC2LDA(sensor.length, sensor.angle, [0;0;0],obj.constant);
            % x, y が全て０のLPを削除 UKFCombiningLinesで使っているフィールドだけ削除
            tmpid=sum([LP.x,LP.y],2)==0;
            LP.x(tmpid,:) = [];
            LP.y(tmpid,:) = [];
            LP.a(tmpid,:) = [];
            LP.b(tmpid,:) = [];
            LP.c(tmpid,:) = [];
            LP.id(tmpid,:) = [];

            a = LP.a;
            b = LP.b;
            c = LP.c;
            Xs = LP.x(:,1);
            Xe = LP.x(:,2);
            Ys = LP.y(:,1);
            Ye = LP.y(:,2);
            lineids = abs(Xe - Xs) + abs(Ye - Ys) > 1; % lineと認識する長さ：1m 以上ないとlineとみなさないようにする．TODO
            a = a(lineids);
            b = b(lineids);
            c = c(lineids);
            Xs = Xs(lineids);
            Xe = Xe(lineids);
            Ys = Ys(lineids);
            Ye = Ye(lineids);
            x = 0;
            y = 0;

            ref = zeros(3,obj.Horizon);%set data size[x ;y ;theta]

            del = -[a.*c,b.*c]./sqrt(a.^2+b.^2); % 垂線の足

            ds = [Xs,Ys]; % wall 始点
            de = [Xe,Ye]; % wall 終点
            ip = sum((ds - del).*(de - del),2); % 垂線の足から始点，終点それぞれへのベクトルの内積
            wid = find(ip < 1e-1); % 垂線の足が壁面内にある壁面インデックス：内積が負になる．（少し緩和している）
            d = vecnorm(del(wid,:),2,2); % wid の壁面までの距離
            %[ip,d,Xs,Ys,Xe,Ye]
            [~,idx]=mink(d,2); % 近い２つの壁面
            ids=wid(idx); % 対象とする２つの壁面
            l1 = [a(ids(1)),b(ids(1)),c(ids(1))]/vecnorm([a(ids(1)),b(ids(1))]); %一番近い壁面のパラメータ
            l2 = [a(ids(2)),b(ids(2)),c(ids(2))]/vecnorm([a(ids(2)),b(ids(2))]);
            if l1*l2'<0
                l2 = -l2;
            end
            % Current time reference position calced at previous time
            rp = R'*(obj.result.PreTrack(1:2) - pe);

            if abs(prod(a(ids))+prod(b(ids)))<1e-1 % ほぼ直交している場合（傾きの積が-1の式より）
                % TODO : 入りと出で同じ幅の通路を前提としてしまっている．
                % 初期値が垂直二等分線上の場合その場で回転するだけのリファレンスになる．
                if isempty(obj.O)
                    e1=[ds(ids(1),:);de(ids(1),:)];% line1 edge
                    e2=[ds(ids(2),:);de(ids(2),:)];% line2 edge
                    p = cr(l1,l2);
                    tmp=[e1;e2]-p';
                    if sum(vecnorm(tmp,2,2) < 0.5) % lineの近い方の距離が近い => 直交して交わる
                        if l1(3)*l2(3) < 0 % l*[x;y;1]がロボットから見た直線の位置（符号付き）
                            % 相対で見たとき ax+by+c=0 のcの符号が異なる状態で足せば機体側の2等分線になる
                            l3 = (l1+l2)/2;
                        else
                            l3 = (l1-l2)/2;
                        end
                        l4 = perp(l1,rp);
                        obj.O = cr(l4,l3);% 回転中心：相対座標
                        obj.r = vecnorm(obj.O-rp);
                    else % 遠い => 交わらない線分：推定が失敗してくると生じる
                        [~,id1]=min(vecnorm(e1,2,2)); % 近いedgeのインデックス
                        [~,id2]=min(vecnorm(e2-e1(id1,:),2,2));
                        de1 = vecnorm(e1(id1,:)'-rp);
                        de2 = vecnorm(e2(id2,:)'-rp);
                        if de1 < de2
                            obj.O = (e1(id1,:) + [x y])';
                            obj.r = de1;
                        else
                            obj.O = (e2(id2,:) + [x y])';
                            obj.r = de2;
                        end
                    end
                    tmp = cross([0;0;1],[-obj.O;0]);% 相対座標系における機体の進むべき向き
                    % tmp(1)が正：Oが機体の左にあり反時計回りに回転
                    % tmp(2)が負：Oが機体の右にあり時計回りに回転
                    obj.th = sign(tmp(1))*obj.step*obj.dt*obj.refv/obj.r;
                    obj.O = R*obj.O + pe; % 絶対座標位置
                end
                th = obj.th;
                O = R'*(obj.O-pe);%ボディから見た回転中心位置ベクトルの位置に変換
                r = obj.r;
                Rmat = [cos(th),-sin(th);sin(th),cos(th)];
                tmp0 = -O;
                tmp0 = tmp0/vecnorm(tmp0);% 回転中心から機体の位置方向の単位ベクトル
                tmp = cross([0;0;1],[tmp0;0]);% 機体の進むべき向き
                tmpt0 = atan2(tmp(2),tmp(1));% 現在時刻の目標姿勢角
                if sign(tmp(1))<0
                    tmpt0 = tmpt0+pi;
                end
                tmp0 = r*tmp0; % Oから見た現在時刻の目標位置
                tmp(:,1) = [tmp0 + O;tmpt0];
                for i = 2:obj.Horizon
                    tmp0 = Rmat*tmp0;
                    tmpt0 = tmpt0 + th;
                    tmp(:,i) = [tmp0+O;tmpt0];
                end
                ref = [tmp;obj.refv*ones(1,size(tmp,2))]; %　相対座標
                if obj.trackcase == 0|| obj.trackcase == 1
                    obj.trackcase = 2;
                elseif obj.trackcase == 2|| obj.trackcase == 3
                    obj.trackcase = 0;
                end
                if obj.count1 == 1
                    obj.count = 1;
                end

            else % ほぼ平行な場合
%                 obj.self.model.param.Lx  = -0.008;
                obj.O = []; th = [];
                if l1(3)*l2(3)<0 % l*[x;y;1]がロボットから見た直線の位置（符号付き）
                    % 相対で見たとき ax+by+c=0 のcの符号が異なる状態で足せば機体側の2等分線になる
                    rl = (l1+l2)/2;
                else
                    rl = (l1-l2)/2;
                end
                tmpl = perp(rl,[0;0]); % 機体を通るrl の垂線
                if sum(tmpl) == 0
                    rl;
                end
                tmp0 = cr(rl,tmpl); % 機体からrlへの垂線の足
                rl = rl*sign([rl(2),-rl(1)]*[1;0]);%[cos(th);sin(th)]); % 機体の向いている向きが[rl(2),-rl(1)]で正となるよう
                tmpt0 = atan2(-rl(1),rl(2));
                tmpdl = perp(l1,[0,0]);
                ld = cr(l1,tmpdl);
                if obj.count == 1
                    if abs(l1(1)) < abs(l1(2)) 
                        obj.trackcase = 2;
                    elseif abs(l1(1)) > abs(l1(2))
                        obj.trackcase = 0;
                    end
                end
                if abs(l1(3)) <= 0.9 && ld(2) >= 0
                    obj.trackcase = 1
                elseif abs(l1(3)) >= 0.9 && ld(2) <= 0
                    obj.trackcase = 0
%                 elseif abs(l1(3)) >= 0.9 && ld(1) >= 0
%                     obj.trackcase = 3
%                 elseif abs(l1(3)) >= 0.9 && ld(1) <= 0
%                     obj.trackcase = 2
                end
%                 dxz = tmp0(2)*sin(tmpt0);
%                 dyz = dxz*tan(obj.ztheta);
%                 tmp1 = [dxz;dyz]; 
%                 tmpt1 = atan2(dxz,dyz);
%                 if obj.ztheta < 0
%                     obj.ztheta = -obj.ztheta;
%                 end
                switch obj.trackcase
                    case 0
                    %-case0-%
                    if obj.ztheta < 0
                        obj.ztheta = -obj.ztheta;
                    end

                    dy1 = l1(3);
                    dy2 = l2(3);
                    dx1 = dy1/tan(obj.ztheta);
                    dx2 = dy2/tan(obj.ztheta);
                    tmpz1 = [dx1,dy1];
                    tmpz2 = [dx2,dy2];
                    al = tmpz2(2) - tmpz1(2);
                    bl = -(tmpz2(1) - tmpz1(1));
                    cl = tmpz2(1)*tmpz1(2) - tmpz1(1)*tmpz2(2);
                    zl = [al,bl,cl]+[0,0,-al*tmp0(1)-tmp0(2)];
                    zl = [al,bl,cl]/vecnorm([al,bl,cl]);
                    zl = zl*sign([zl(2),-zl(1)]*[1;0]);
                    tmpzl = perp(zl,[0;0]);
                    tmpz0 = cr(zl,tmpzl);
                    ltheta = atan2(-zl(1),zl(2));
                    tmp = [tmpz0;ltheta-the];
                    %--%
                    case 1
                        if obj.ztheta > 0
                            obj.ztheta = -obj.ztheta;
                        end
            
                        dy1 = l1(3);
                        dy2 = l2(3);
                        dx1 = dy1/tan(obj.ztheta);
                        dx2 = dy2/tan(obj.ztheta);
                        tmpz1 = [dx1,dy1];
                        tmpz2 = [dx2,dy2];
                        al = tmpz2(2) - tmpz1(2);
                        bl = -(tmpz2(1) - tmpz1(1));
                        cl = tmpz2(1)*tmpz1(2) - tmpz1(1)*tmpz2(2);
                        zl = [al,bl,cl]+[0,0,-al*tmp0(1)-tmp0(2)];
                        zl = [al,bl,cl]/vecnorm([al,bl,cl]);
                        zl = zl*sign([zl(2),-zl(1)]*[1;0]);
                        tmpzl = perp(zl,[0;0]);
                        tmpz0 = cr(zl,tmpzl);
                        ltheta = atan2(-zl(1),zl(2));
                        tmp = [tmpz0;ltheta-the];
                    case 2
                        if obj.ztheta < 0
                            obj.ztheta = -obj.ztheta;
                        end
    
                        dy1 = l1(3);
                        dy2 = l2(3);
                        dx1 = dy1/tan(obj.ztheta);
                        dx2 = dy2/tan(obj.ztheta);
                        tmpz1 = [dx1,dy1];
                        tmpz2 = [dx2,dy2];
                        al = tmpz2(2) - tmpz1(2);
                        bl = -(tmpz2(1) - tmpz1(1));
                        cl = tmpz2(1)*tmpz1(2) - tmpz1(1)*tmpz2(2);
                        zl = [al,bl,cl]+[0,0,-al*tmp0(1)-tmp0(2)];
                        zl = [al,bl,cl]/vecnorm([al,bl,cl]);
                        zl = zl*sign([zl(2),-zl(1)]*[1;0]);
                        tmpzl = perp(zl,[0;0]);
                        tmpz0 = cr(zl,tmpzl);
                        ltheta = atan2(-zl(1),zl(2));
                        tmp = [tmpz0;ltheta-the+pi/2];
                        case 3
                        if obj.ztheta > 0
                            obj.ztheta = -obj.ztheta;
                        end
    
                        dy1 = l1(3);
                        dy2 = l2(3);
                        dx1 = dy1/tan(obj.ztheta);
                        dx2 = dy2/tan(obj.ztheta);
                        tmpz1 = [dx1,dy1];
                        tmpz2 = [dx2,dy2];
                        al = tmpz2(2) - tmpz1(2);
                        bl = -(tmpz2(1) - tmpz1(1));
                        cl = tmpz2(1)*tmpz1(2) - tmpz1(1)*tmpz2(2);
                        zl = [al,bl,cl]+[0,0,-al*tmp0(1)-tmp0(2)];
                        zl = [al,bl,cl]/vecnorm([al,bl,cl]);
                        zl = zl*sign([zl(2),-zl(1)]*[1;0]);
                        tmpzl = perp(zl,[0;0]);
                        tmpz0 = cr(zl,tmpzl);
                        ltheta = atan2(-zl(1),zl(2));
                        tmp = [tmpz0;ltheta-the+pi/2];
                        
                end
                
%                 for i = 2:obj.Horizon
%                     tmp0 = tmp0+obj.step*obj.dt*obj.refv*[rl(2);-rl(1)]/vecnorm(rl(1:2));
%                     tmp(:,i) = [tmp0;tmpt0];
%                 end
                ref = [tmp;obj.refv*ones(1,size(tmp,2))];
            end

        % ここから絶対座標に戻す．

            ref(1:2,:) = R*ref(1:2,:) + pe;
            ref(3,:) = ref(3,:) + the;

            qr = ref(3,:);
            tmp = the - qr > 4;
            qr(tmp) = qr(tmp)+2*pi;
            tmp = the - qr < -4;
            qr(tmp) = qr(tmp)-2*pi;
            ref(3,:) = qr;

            obj.result.state.set_state("xd",ref);%treat as a colmn vector
            obj.result.state.set_state("p",ref);%treat as a colmn vector
            obj.result.state.set_state("q",ref(3,1));%treat as a colmn vector
            obj.result.state.set_state("v",ref(4,1));%treat as a colmn vector
            
            if vecnorm(obj.result.PreTrack - ref(1:3,1))>3
                obj.O;
            end
            if count0 == 1
                obj.count1 = 0;
            end
            obj.PreTrack = ref(1:3,1);
            obj.result.PreTrack = ref(1:3,1);
%             if vecnorm(obj.result.PreTrack - ref(:,1))>3
%                 obj.O;
%             end
%             obj.PreTrack = ref(:,1);
%             obj.result.PreTrack = ref(:,1);
            if isempty(obj.O)
                obj.result.O = pe;
            else
                obj.result.O = obj.O;% 回転中心（絶対座標）
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

        function [] = FHPlot(obj,Env,FH,flag)
            agent = obj.self;
            MapIdx = size(Env.floor.Vertices,3);
            for ei = 1:MapIdx
                tmpenv(ei) = polyshape(Env.floor.Vertices(:,:,ei));
            end
            p_Area = union(tmpenv(:));
            %plantFinalState
%             pstate = agent.plant.state.p(:,end);
%             pstateq = agent.plant.state.q(:,end);
%             pstate = agent.estimator.result.state.p(:,end);
%             pstateq = agent.estimator.result.state.q(:,end);
%             pstatesquare = pstate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
%             pstatesquare =  polyshape(pstatesquare');
%             pstatesquare =  rotate(pstatesquare,180 * pstateq / pi, pstate');

            %modelFinalState
            estate = agent.estimator.result.state.p(:,end);
            estateq = agent.estimator.result.state.q(:,end);
            estatesquare = estate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
            estatesquare =  polyshape( estatesquare');
            estatesquare =  rotate(estatesquare,180 * estateq / pi, estate');
            if isfield(agent.estimator.result,'map_param')
            Ewall = agent.estimator.result.map_param;
            Ewallx = reshape([Ewall.x,NaN(size(Ewall.x,1),1)]',3*size(Ewall.x,1),1);
            Ewally = reshape([Ewall.y,NaN(size(Ewall.y,1),1)]',3*size(Ewall.y,1),1);
            else
                Ewallx = nan;
                Ewally = nan;
            end
            %reference state
            RefState = agent.reference.result.state.p(1:3,:);
            fWall = agent.reference.result.focusedLine;

            figure(FH)

            clf(FH)
            grid on
            axis equal
%             obj.self.show(["sensor","lrf"],[pstate;pstateq]);
            hold on
%             plot(pstatesquare,'FaceColor',[0.5020,0.5020,0.5020],'FaceAlpha',0.5);
%                agent.sensor.LiDAR.show();
            plot(estatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);

            plot(RefState(1,:),RefState(2,:),'ro','LineWidth',1);
%             plot(p_Area,'FaceColor','blue','FaceAlpha',0.5);
            plot(Ewallx,Ewally,'r-');
            plot(fWall(:,1),fWall(:,2),'g-','LineWidth',2);
%             plot(fWall(:,1),'g-','LineWidth',2);
            O = agent.reference.result.O;
            plot(O(1),O(2),'r*');
            quiver(RefState(1,:),RefState(2,:),2*cos(RefState(3,:)),2*sin(RefState(3,:)));
            if isstring(flag)
                xmin = min(-5,min(Ewallx));
                xmax = max(95,max(Ewallx));
                ymin = min(-5,min(Ewally));
                ymax = max(95,max(Ewally));
                xlim([xmin-5, xmax+5]);
                ylim([ymin-5,ymax+5]);
            else
                xlim([estate(1)-7, estate(1)+7]);
                ylim([estate(2)-5,estate(2)+5]);
            end
            xlabel("$x$ [m]","Interpreter","latex");
            ylabel("$y$ [m]","Interpreter","latex");
            % pbaspect([20 20 1])
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
d = (a1*b2 - a2*b1); %2直線が水平ではないかの確認
if d == 0
    error("ACSL : l1 and l2 are parallel");
else
    p(1,1) = (b1*c2 - b2*c1)/d;
    p(2,1) = -(a1*c2 - a2*c1)/d;
end
end
classdef PATH_REFERENCE < handle
  % 通路の中心を通るリファレンスを生成するクラス
  % 曲がり角では外側の二本の壁面の中線と曲がり角に進入時の位置から近い壁面に下した垂線の交点を中心とした回転をする．
  properties
    refv
    PreTrack
    dt
    SensorRange
    Horizon
    step % horizon step
    self
    w
    O = [] % 回転中心
    r  % 回転半径
    th = [];
    constant
    result
    ol % selected line in previous time
  end

  methods
    function obj = PATH_REFERENCE(self,varargin)
      % 【Input】 map_param ,
      %  目標点の行列を受け取る．それに対応した目標速度を受け取る．
      %　目標点と速度に応じて参照軌道を作成，estimatorの値から収束判定をする．
      %  we make target of new section by convergence judgement
      %paramはReference.param
      obj.self = self;
      param = varargin{1};
      obj.refv = param{1,1};
      obj.PreTrack = [obj.self.estimator.model.state.p(1:2);obj.self.estimator.model.state.q(3)];%位置,姿勢,速さ
      obj.result.PreTrack = obj.PreTrack;
      %obj.Horizon = param{1,2};
      obj.step = 3;
      obj.SensorRange = param{1,3};
      obj.dt = obj.self.estimator.model.dt;
      obj.result.state=STATE_CLASS(struct('state_list',["xd","p","q","v"],'num_list',[4,4,1,1]));%x,y,theta,v
      initial_state = struct('xd',[0;0;0;0],'p',[0;0;0;0],'q',0,'v',0);
      obj.result.state.set_state(initial_state);
      obj.constant = param{1,4};
    end

    function  result= do(obj,varargin)
      estate = obj.self.estimator.result.state;
      pe = estate.p(1:2);
      the = estate.q(3);
      R = [cos(the), -sin(the);sin(the), cos(the)];

      % ここから相対座標上での議論
      sensor = obj.self.sensor.result;
      % 相対座標でのline parameterを算出
      LP = PC2LDA(sensor.length, sensor.angle, [0;0;0],obj.constant);
      % 以降ではline parameter = (a, b, c) として [a b]の大きさ１、c < 0 を前提とする。
      % see assets/line_functions/readme.md
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
      lineids = abs(Xe - Xs) + abs(Ye - Ys) > 1; % lineと認識する長さ：1m 以上ないとlineとみなさないようにする．TODO : チューニングできるようにする
      a = a(lineids);
      b = b(lineids);
      c = c(lineids);
      Xs = Xs(lineids);
      Xe = Xe(lineids);
      Ys = Ys(lineids);
      Ye = Ye(lineids);
      x = 0;
      y = 0;

      del = -[a.*c,b.*c]; % 垂線の足

      ds = [Xs,Ys]; % wall 始点
      de = [Xe,Ye]; % wall 終点
      ip = sum((ds - del).*(de - del),2); % 垂線の足から始点，終点それぞれへのベクトルの内積
      widb = (ip <=0.3); % 垂線の足が壁面内にある壁面インデックス：内積が負になる．（少し緩和している）
      d = abs(c(widb)); % wid の壁面までの距離
      [~,idx]=mink(d,2); % 近い２つの壁面
      wid = find(widb);
      ids=wid(idx); % 近い２つの壁面インデックス
      [~,mincid]=mink(abs(c),4);% 近い４つの壁面
      aperp = abs(a) < 0.35; % 進行方向との内積が直角に近い壁
      aperp = intersect(find(aperp),mincid); % 近くて進行方向に平行な壁
      if length(aperp) == 2 % 進行方向との内積が直角に近い左右の壁が存在
        insec = intersect(ids ,aperp);
        if length(insec) == 1
          idbf = setxor(aperp,[ids;aperp]); % 左右ではない壁のインデックス
          if a(idbf) < 0 % 後ろの壁面が近い場合 (c < 0 が前提)
            ids = aperp;
          else % 前の壁面が近い場合は何もしない
          end
        end
      else  % 進行方向との内積が直角に近い左右の壁が存在しない場合
      end
      l1 = [a(ids(1)),b(ids(1)),c(ids(1))];
      l2 = [a(ids(2)),b(ids(2)),c(ids(2))];
      % Current time reference position calced at previous time
      rp = R'*(obj.result.PreTrack(1:2) - pe);

      if abs(l1(1)*l2(1)+l1(2)*l2(2))<1e-1  % ほぼ直交している場合（傾きの積が-1の式より）
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
            [~,I]=mink(abs(c),3); % 近い３つの壁のインデックスを抽出
            I = setxor([ids;I],ids); % 注目している２本ではない壁が曲がる方向の壁
            l4 = [a(I),b(I),c(I)]; % 曲がる方向の壁のline parameter
            tmpcenter = cr(l4,l3);% 回転中心候補：相対座標
            [~,tmpid] = min(abs(tmpcenter(2,:))); % 相対座標ｙで近い方
            obj.O=tmpcenter(:,tmpid);% 回転中心：相対座標
            if obj.O(1)>0 % 回転中心が前に有るとき（広い通路に出る場合）は回転中心を真横に引き戻す
              obj.O(1) = 0;
            end
            obj.r = vecnorm(obj.O); % 回転半径
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
        O = R'*(obj.O-pe);%ボディから見た回転中心位置ベクトル
        r = obj.r; % 回転半径
        tmp0 = -O;
        tmp0 = tmp0/vecnorm(tmp0);% 回転中心から機体の位置方向の単位ベクトル
        tmp = cross([0;0;1],[tmp0;0]);% 機体の進むべき向き
        tmpt0 = atan2(tmp(2),tmp(1));% 現在時刻の目標姿勢角
        if sign(tmp(1))<0
          tmpt0 = tmpt0+pi;
        end
        tmp0 = r*tmp0; % Oから見た現在時刻の目標位置
        tmp(:,1) = [tmp0 + O;tmpt0];

        th = obj.th;
        Rmat = [cos(th),-sin(th);sin(th),cos(th)];
        for i = 2:obj.Horizon
          tmp0 = Rmat*tmp0;
          tmpt0 = tmpt0 + th;
          tmp(:,i) = [tmp0+O;tmpt0];
        end
        ref = [tmp;obj.refv*ones(1,size(tmp,2))]; %　相対座標
      else % ほぼ平行な場合
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
        rl = rl*sign([rl(2),-rl(1)]*[1;0]);%[cos(th);sin(th)]); % 機体の向いている向きが[rl(2),-rl(1)]で正となるように
        tmpt0 = atan2(-rl(1),rl(2));
        tmp(:,1) = [min(obj.refv,tmp0(1));tmp0(2);tmpt0];
        for i = 2:obj.Horizon
          tmp0 = tmp0+obj.step*obj.dt*obj.refv*[rl(2);-rl(1)]/vecnorm(rl(1:2));
          tmp(:,i) = [tmp0;tmpt0];
        end
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

      ref(4,:) = min(1,min(abs(l1(3)),abs(l2(3))));% 目標速度を２直線までの距離の和で決定

      obj.result.state.set_state("xd",ref);%treat as a colmn vector
      obj.result.state.set_state("p",ref(1:2));%treat as a colmn vector
      obj.result.state.set_state("q",ref(3,1));%treat as a colmn vector
      obj.result.state.set_state("v",ref(4,1));%treat as a colmn vector
      obj.PreTrack = ref(:,1);
      obj.result.PreTrack = ref(:,1);
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

    function [] = FHPlot(obj,varargin)
      % arguments
      %   obj
      %   Env
      %   FH
      %   flag
      %   varargin
      % end
      opts = struct(varargin{:});
      Env = opts.Env;
      if ~isfield(opts,'ax') || isempty(opts.ax)
        FH = opts.FH;
        fh = figure(opts.FH);
        % fh.WindowState = 'maximized';
      else
        ax = opts.ax;
      end

      flag = opts.flag;
      agent = obj.self;
      if isa(Env,'triangulation')
        h = trimesh(Env);
        if isfield(opts,'ax')
          fhtmp = h.Parent.Parent;
          h.Parent = ax;
          close(fhtmp);
        else
          ax = gca;
        end
      else
        MapIdx = size(Env.param.Vertices,3);
        for ei = 1:MapIdx
          tmpenv(ei) = polyshape(Env.param.Vertices(:,:,ei));
        end
        p_Area = union(tmpenv(:));
        if isfield(opts,'ax')
          plot(ax,p_Area,'FaceColor','blue','FaceAlpha',0.5); % true environment
        else
          plot(p_Area,'FaceColor','blue','FaceAlpha',0.5); % true environment
        end
      end
      daspect(ax,[1 1 1]);
      pstate = agent.plant.state;
      pstatesquare = vehicle_outline(pstate);

      estatesquare = vehicle_outline(agent.estimator.result.state);

      if isfield(agent.estimator.result,'map_param')
        Ewall = agent.estimator.result.map_param;
        Ewallx = reshape([Ewall.x,NaN(size(Ewall.x,1),1)]',3*size(Ewall.x,1),1);
        Ewally = reshape([Ewall.y,NaN(size(Ewall.y,1),1)]',3*size(Ewall.y,1),1);
      else
        Ewallx = nan;
        Ewally = nan;
      end
      %reference state
      RefState = obj.result.state.xd;
      fWall = agent.reference.result.focusedLine;

      if isfield(opts,'ax')
        inputs_for_show = varargin(:)';
      else
        inputs_for_show = [{'ax'},{ax},varargin(:)'];
      end
      obj.self.show(["sensor","lrf"],inputs_for_show{:});
      view(ax,[0 0 1]);
      hold(ax,'on')
      plot(ax,pstatesquare,'FaceColor',[0.5020,0.5020,0.5020],'FaceAlpha',0.5);
      plot(ax,estatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);

      plot(ax,RefState(1,:),RefState(2,:),'ro','LineWidth',1);
      plot(ax,Ewallx,Ewally,'r-'); % estimated wall
      plot(ax,fWall(:,1),fWall(:,2),'g-','LineWidth',2); % wall for reference
      O = agent.reference.result.O;
      plot(ax,O(1),O(2),'r*');
      quiver(ax,RefState(1,:),RefState(2,:),2*cos(RefState(3,:)),2*sin(RefState(3,:)));
      if isstring(flag)
        xmin = min(ax,-5,min(Ewallx));
        xmax = max(ax,95,max(Ewallx));
        ymin = min(ax,-5,min(Ewally));
        ymax = max(ax,95,max(Ewally));
        xlim(ax,[xmin-5, xmax+5]);
        ylim(ax,[ymin-5,ymax+5]);
      elseif(flag==1)
        xlim(ax,[estate(1)-25, estate(1)+25]);
        ylim(ax,[estate(2)-25,estate(2)+25]);

      end
      xlabel(ax,"$x$ [m]","Interpreter","latex");
      ylabel(ax,"$y$ [m]","Interpreter","latex");
      text(ax,ax.XLim(1),ax.YLim(2)+0.6,0,"* : rotation center in curve motion");
      text(ax,ax.XLim(1),ax.YLim(2)+0.2,0,"o : reference point");
      text(ax,(ax.XLim(1)+ax.XLim(2))/2,ax.YLim(2)+0.6,0,"red points : measured lidar points");
      text(ax,(ax.XLim(1)+ax.XLim(2))/2,ax.YLim(2)+0.2,0,"green line : forcused line for ref gen");
      hold(ax,'off')
    end

  end
end
function L = perp(l,p)
% pを通るlと垂直な直線
L = [-l(2), l(1), l(2)*p(1)-l(1)*p(2)];
end
function p = cr(l1,l2)
% l1 と l2の交点
a1 = l1(:,1);
b1 = l1(:,2);
c1 = l1(:,3);
a2 = l2(:,1);
b2 = l2(:,2);
c2 = l2(:,3);
d = (a1.*b2 - a2.*b1);
if d == 0
  error("ACSL : l1 and l2 are parallel");
else
  p(1,:) = ((b1.*c2 - b2.*c1)./d)';
  p(2,:) = (-(a1.*c2 - a2.*c1)./d)';
end
end
function square = vehicle_outline(state)
pstate = state.p(1:2,end);
pstateq = state.q(end,end);
pstatesquare = pstate + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1];
pstatesquare =  polyshape(pstatesquare');
square =  rotate(pstatesquare,180 * pstateq / pi, pstate');
end
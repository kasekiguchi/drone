classdef LiDAR3D_SIM < SENSOR_CLASS
  %   3次元LiDAR（全方位センサー）のsimulation用クラス
  %   lidar = LiDAR3D_SIM(param)
  %   (optional) radius = 1 default 40 m
  properties
    name = "lidar";
    result
    self
    noise = 0;
    seed = [] % noise 用
    theta_range
    phi_range
    front
  end

  properties (SetAccess = private)
    radius = 40;     % active distance
    dead_zone = 0.2; % minimum range
    fp               % face points : [x1 y1 z1 x2 y2 z2 x3 y3 z3; ...];
    TR               % triangulation
    cn               % TR.ConnectivityLists
    ps               % TR.Points
    ic               % incenter
    fn               % face normal
    constant         % constant matrix for detect the cross to walls
    E                % laser direction 3xN : N :number of laser
  end

  methods

    function obj = LiDAR3D_SIM(self, param)
      % 【required input】 
      % param.env : environment : assumes stlread output
      % param.theta_range : laser dir : pi/2 + [-1:0.1:1];
      % param.phi_range : laser dir : -pi:0.1:pi;
      %   (theta,phi) : spherical coordinate position
      % 【optional input】
      % param.radius
      % param.noise : noise : standard deviation
      % param.seed : random seed for noise
      obj.self = self;
      if isfield(param, 'radius'); obj.radius = param.radius; end
      if isfield(param, 'noise'); obj.noise = param.noise; end
      if isfield(param, 'seed'); obj.seed = param.seed; end
        TR = param.env;                                               % env : TR = stlread(STL);
        cn = TR.ConnectivityList;
        ps = TR.Points;
        obj.fp = [ps(cn(:, 1), :), ps(cn(:, 2), :), ps(cn(:, 3), :)]; % face points : [x1 y1 z1 x2 y2 z2 x3 y3 z3; ...];
        obj.constant = obj.Fp2mat_for_matrix_inverse(obj.fp);
        obj.TR = TR;
        obj.cn = obj.TR.ConnectivityList;
        obj.ps = obj.TR.Points;
        obj.ic = incenter(TR);                                        % 三角形の内心
        obj.fn = faceNormal(TR);                                      % 法線ベクトル（外向き）
      obj.phi_range = param.phi_range;
      obj.theta_range = param.theta_range;
      th = obj.theta_range;
      phi = obj.phi_range;
      obj.E = [kron(cos(phi), sin(th)); kron(sin(phi), sin(th)); kron(ones(1, size(phi, 2)), cos(th))];
      % E : 3 x (th x phi)
      obj.front = knnsearch(obj.E', [1; 0; 0]');
    end

    function result = do(obj, param)
      % result=lidar.do(param)
      %   result.region : センサー領域（センサー位置を原点とした）polyshape
      %   result.length : 測距距離 : size(length) = size(obj.E) obj.Eの向きに対応した距離
      % 【入力】param = {Env}        Plant ：制御対象， Env：環境真値
      Plant = obj.self.plant;
      %             if param.env % 環境変化に対応する用：実装まだ TODO
      %                 env = param.env;
      %             else
      %                 env = obj.env;
      %             end
      p = Plant.state.p;              % 実状態
      R = Plant.state.getq('rotmat'); % 実状態
      %% ここは工夫の余地あり．idsを絞れればそれだけ早くなる．
      rp = obj.ic - p';               % 内心への相対位置
      ip1 = sum(rp .* obj.fn, 2) < 0; % 「内積が負の壁」が見える向きの壁面
      Pi = obj.inverse_matrices(p, ip1);
      e = R * obj.E;
      %ip2 = rp*e > 0; % 「内積が正の壁」がレーザー方向にある壁
      ids = ip1;                      % & ip2;

      %% cell array形式 : for よりは早い
      d = cell2mat(arrayfun(@(i) obj.cross_point(e(:, i), Pi), 1:size(e, 2), 'UniformOutput', false));

      if isempty(obj.seed)
        rng('shuffle');
      else
        rng(2 * obj.seed);
        obj.seed = obj.seed + 0.1;
      end

      result.length = d + obj.noise * randn(size(d)); % .*sign(result.angle); % レーザー点までの距離
      del_ids = find((result.length < obj.dead_zone) | (result.length > obj.radius));
      result.length(del_ids) = NaN;
      result.sensor_points = p + result.length .* e;
      result.sensor_points(:, del_ids) = NaN(3, length(del_ids));
      loc = reshape((result.length .* obj.E)', [size(obj.theta_range, 2), size(obj.phi_range, 2), 3]);
      result.Location = loc;
      result.Count = length(result.length);
      result.XLimits = [min(loc(:, :, 1), [], "all"), max(loc(:, :, 1), [], "all")];
      result.YLimits = [min(loc(:, :, 2), [], "all"), max(loc(:, :, 2), [], "all")];
      result.ZLimits = [min(loc(:, :, 3), [], "all"), max(loc(:, :, 3), [], "all")];
      result.Color = [];
      result.Normal = [];
      result.Intensity = uint8(255 * (1 - result.length / obj.radius)); % 距離に応じて減衰するというモデル
      obj.result = result;
    end

    function fh = show(obj, opt)
      arguments
        obj
        opt.fField = true;
        opt.fLocal = true; % ボディ座標から見たセンサー情報
        opt.FH = [];
        opt.logger = [];
        opt.t = 1;
        opt.p = obj.self.plant.state.p;
        opt.R = obj.self.plant.state.q;
        opt.po = obj.result.sensor_points;
        opt.param = [];
      end
      if ~isempty(opt.logger)
        fh = figure(opt.FH);
        logger = opt.logger;
        p = logger.Data.agent.plant.result{opt.t}.state.p;
        r = logger.Data.agent.reference.result{opt.t}.state.p;
        R = logger.Data.agent.plant.result{opt.t}.state.q;
        po = logger.Data.agent.sensor.result{opt.t}.sensor_points;
        if isfield(opt.param, "fField")
          opt.fField = opt.param.fField;
        end
        opt.fLocal = false;
      else
        p = opt.p;
        R = opt.R;
        po = opt.po;
        fh = figure(opt.FH);
      end
      if ~isempty(opt.param)
        fn = fieldnames(opt.param);
        for i = 1:length(fn)
          opt.(fn{i}) = opt.param.(fn{i});
        end
      end
      switch length(R)
        case 4
          R = rotmat(quaternion(R(:)'), 'frame');
        case 3
          R = RodriguesQuaternion(Eul2Quat(R(:)'));%rotmat(quaternion(R(:)', 'euler', 'ZYX', 'frame'), 'point'); <- XYZでは？
      end
      ax = fh.CurrentAxes;
      fh.WindowState = 'maximized';
      clf(fh);
      hold on
      axis equal
      daspect([1 1 1]);
%       view([-1 -1 1]);   
      view([-2 2]); 
%       view(2);
%       view(-10,30); 
%       
      xlabel("x");
      ylabel("y");
      zlabel("z");
      axis vis3d
      if opt.fLocal % ボディ座標系
        p = [0; 0; 0];
        po = R' * po - p(:);
        %po = obj.result.Location
        bx = 5 * [1; 0; 0];
        %campos(p-bx);%% - 1 * bx);%+[0;-1;1]);
        %camtarget(p+bx);% + 5*bx);
      else
        bx = 5 * R * [1; 0; 0];
        if opt.fField
          bld.Faces = obj.cn;
          bld.Vertices = obj.ps;
          bld.FaceAlpha = 0.05; % remove the transparency
          bld.FaceColor = 'b'; %
          bld.LineStyle = '-'; % 'none'; % remove the lines
          bld.EdgeAlpha = 0.1;
          bld.EdgeColor = [0 0 0];
%           trisurf(bld,'EdgeColor',[0 0 0],'EdgeAlpha',0.1,'FaceAlpha',0.05,'FaceColor',[0 0 1]);
          patch(bld);
        end
        %campos(p +10*[-1;-0.2;0.2]);
        %camtarget(p);
      end
      quiver3(p(1), p(2), p(3), bx(1), bx(2), bx(3)); % 前
      plot3(p(1), p(2), p(3), 'bx');
%       plot3(po(1, :), po(2, :), po(3, :), "ro", 'MarkerSize', 3);
      plot3(r(1), r(2), r(3),'ro');%referenceの表示
%       scatter3(r(1),r(2),r(3),70,'filled','LineWidth',0.1);%目標軌跡
      ref_plot.MarkerEdgeColor = 'b';
      xlim([p(1) - 3, p(1) + 8]);
      ylim([p(2) - 5, p(2) + 5]);
      zlim([p(3) - 5, p(3) + 5]);
    end
    function Qpi = inverse_matrices(obj, p, ids)
      % Qpi : inv(Q-p) = [r1;r2;r3] に対して 各行が [r1,r2,r3] となっている．
      % det(Q-p) : detP + dP1*p1 + dP2*p2 + dP3*p3;
      % Ar = [Pi3*p2-Pi2*p3,Pi1*p3-Pi3*p1,Pi2*p1-Pi1*p2];
      % adj(Q-r) : Pi + [Ar(:,1:3:end),Ar(:,2:3:end),Asr(:,3:3:end)];
      Pi = obj.constant(ids, 1:9); i = 10;
      Pi1 = obj.constant(ids, i:i + 2); i = i + 3;
      Pi2 = obj.constant(ids, i:i + 2); i = i + 3;
      Pi3 = obj.constant(ids, i:i + 2); i = i + 3;
      detP = obj.constant(ids, i); i = i + 1;
      dP1 = obj.constant(ids, i); i = i + 1;
      dP2 = obj.constant(ids, i); i = i + 1;
      dP3 = obj.constant(ids, i);
      detP = detP + dP1 * p(1) + dP2 * p(2) + dP3 * p(3);
      Ar = [Pi3 * p(2) - Pi2 * p(3), Pi1 * p(3) - Pi3 * p(1), Pi2 * p(1) - Pi1 * p(2)];
      adjP = Pi + [Ar(:, 1:3:end), Ar(:, 2:3:end), Ar(:, 3:3:end)];
      Qpi = adjP ./ detP;
      %%  verification
      %       i = 10;
      %       Qir = Qpi(i, :);
      %       Qec1 = obj.fp(i, 1:3) - p';
      %       Qec2 = obj.fp(i, 4:6) - p';
      %       Qec3 = obj.fp(i, 7:9) - p';
      %       Ans = [sum(Qec1 .* Qir(:, 1:3), 2), sum(Qec1 .* Qir(:, 4:6), 2), sum(Qec1 .* Qir(:, 7:9), 2), ...
      %             sum(Qec2 .* Qir(:, 1:3), 2), sum(Qec2 .* Qir(:, 4:6), 2), sum(Qec2 .* Qir(:, 7:9), 2), ...
      %             sum(Qec3 .* Qir(:, 1:3), 2), sum(Qec3 .* Qir(:, 4:6), 2), sum(Qec3 .* Qir(:, 7:9), 2)]
    end
    function [d, P, W] = cross_point(obj, e, Pi)
      % e2PLparam_cross_point のPL 行ベクトル版
      % Pi = [inv(P1);inv(P2);...] : triangleの逆行列が行ベクトルとして縦に並んだ行列
      %tmp = [-Pi(:,1:3:end)*e,-Pi(:,2:3:end)*e,-Pi(:,3:3:end)*e];
      tmp = [-Pi(:, 1:3) * e, -Pi(:, 4:6) * e, -Pi(:, 7:9) * e];
      P = sum(tmp, 2);
      W = tmp ./ P;
      ids = (W >= 0 & W <= 1) * [1; 1; 1] == 3; % 交点が面分内にある平面インデックス
      if isempty(find(ids, 1))
        d = nan;
      else
        d = -1 ./ min(P(ids));
        %p = d*e; % 最近壁面上の交点
      end
    end

  end

end

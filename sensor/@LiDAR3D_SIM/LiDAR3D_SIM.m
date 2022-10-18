classdef LiDAR3D_SIM < SENSOR_CLASS
    %   3次元LiDAR（全方位センサー）のsimulation用クラス
    %   lidar = LiDAR3D_SIM(param)
    %   (optional) radius = 1 default 40 m
    %   (optional) angle_range = -pi/2:0.1:pi/2 default -pi:0.1:pi
    properties
        name = "lidar";
        result
        self
        noise
        seed = [] % noise 用
        interface = @(x) x;
    end

    properties (SetAccess = private) % construct したら変えない．
        radius = 40;
        pitch = 0.01;
        angle_range
        dead_zone = 0.2;
        head_dir = nsidedpoly(3, 'Center', [0, 0], 'SideLength', 0.5);
        fp
        TR
        cn
        ps
        ic % incenter
        fn % face normal
        constant
        E        
    end

    methods

        function obj = LiDAR3D_SIM(self, param)
            obj.self = self;
            %  このクラスのインスタンスを作成
            % radius, angle_range
            if isfield(param, 'interface'); obj.interface = Interface(param.interface); end
            if isfield(param, 'radius'); obj.radius = param.radius; end
            if isfield(param, 'pitch'); obj.pitch = param.pitch; end
            obj.angle_range = -pi:obj.pitch:pi;
            obj.head_dir.Vertices = ([0 1; -1 0] * obj.head_dir.Vertices')';
            if isfield(param, 'noise'); obj.noise = param.noise; end
            if isfield(param, 'seed'); obj.seed = param.seed; end
            if isfield(param, 'env')
                TR = param.env; % env : TR = stlread(STL);
                cn = TR.ConnectivityList;
                ps = TR.Points;
                obj.fp=[ps(cn(:,1),:),ps(cn(:,2),:),ps(cn(:,3),:)]; % face points : [x1 y1 z1 x2 y2 z2 x3 y3 z3; ...];
                obj.constant = obj.Fp2mat_for_matrix_inverse(obj.fp);
                obj.TR = TR;
                obj.cn = obj.TR.ConnectivityList;
                obj.ps = obj.TR.Points;
                obj.ic = incenter(TR); % 三角形の内心
                obj.fn = faceNormal(TR);  % 法線ベクトル（外向き）
            end
            %phi = 0:0.1:2*pi;
            phi = -pi:0.1:pi;
            th =pi/2 +(-pi/12:0.034:pi/12);
            %e = [sin(th);sin(th);cos(th)].*[cos(phi);sin(phi);ones(1,size(phi,2))]
            obj.E = [kron(sin(th),cos(phi));kron(sin(th),sin(phi));kron(cos(th),ones(1,size(phi,2)))];
        end

        function result = do(obj, param)
            % result=lidar.do(param)
            %   result.region : センサー領域（センサー位置を原点とした）polyshape
            %   result.length : [1 0]からの角度がangle,
            %   angle_range で規定される方向の距離を並べたベクトル：単相LiDARの出力を模擬
            % 【入力】param = {Env}        Plant ：制御対象， Env：環境真値
            Plant = obj.self.plant;
%             if param.env % 実装まだ TODO
%                 env = param.env;
%             else
%                 env = obj.env;
%             end
            p = Plant.state.p; % 実状態
            R = Plant.state.getq('rotmat'); % 実状態
            %%
            rp = obj.ic - p'; % 内心への相対位置
            ip1 = sum(rp.*obj.fn,2) < 0; % 「内積が負の壁」が見える向きの壁面
            Pi = obj.inverse_matrices(p,ip1);
            e = R*obj.E;
            %ip2 = rp*e > 0; % 「内積が正の壁」がレーザー方向にある壁
            %dw = vecnorm(rp(ip,:),2,2); % 壁までの距離 : TODO : 長い壁面の場合棄却されてしまう
            %in = dw < obj.L ; % in range
            %Ip = find(ip);
            %ids = Ip(in); % 候補の壁面インデックス
            ids = ip1;% & ip2;

            %% cell array形式：0.22s
            d=cell2mat(arrayfun(@(i) obj.cross_point(e(:,i),Pi),1:size(e,2),'UniformOutput',false));
            result.sensor_points = p + d.*e;

            if isempty(obj.seed)
                rng('shuffle');
            else
                rng(2 * obj.seed);
                obj.seed = obj.seed + 0.1;
            end

            result.length = d + obj.noise * randn(size(d)); %.*sign(result.angle); % レーザー点までの距離
            del_ids = find((result.length < obj.dead_zone) | (result.length > obj.radius));
            result.length(del_ids) = 0;
            result.sensor_points(:,del_ids) = zeros(3,length(del_ids));
            obj.result = result;
        end

        function fh=show(obj, FH,p,R,po,fField)
            arguments
                obj
                FH
                p = obj.self.plant.state.p;
                R = [];
                po = obj.result.sensor_points;
                fField = true;
            end
            if isstruct(FH)
                p = FH.p;
                R = FH.R;
                po = FH.po;
                fh = figure(FH.fig_num);
            elseif isa(FH,"LOGGER")
                logger = FH;
                fh = figure(p);
                t = R;
                p = logger.Data.agent.plant.result{t}.state.p;
                R = logger.Data.agent.plant.result{t}.state.q;
                po = logger.Data.agent.sensor.result{t}.sensor_points;
            else
                fh=figure(FH);
            end
            ax = fh.CurrentAxes;
            fh.WindowState = 'maximized';
            clf(fh);
            hold on
            axis equal
            daspect([1 1 1]);
            view([-3 1 2]);
            xlabel("x");
            ylabel("y");
            zlabel("z");
            e = obj.E(:,32);
            d = obj.result.length(32);
            quiver3(p(1),p(2),p(3),0.5*d*e(1),0.5*d*e(2),0.5*d*e(3)); % ほぼ前
            if fField
                bld.Faces=obj.cn;
                bld.Vertices=obj.ps;
                bld.FaceAlpha = 0.5;           % remove the transparency
                bld.FaceColor = 'b'; %;'interp';    % set the face colors to be interpolated
                bld.LineStyle = '-'; %'none';      % remove the lines
                patch(bld);
            end
            if ~isempty(R) % ボディ座標系
                po = R'*po-p(:);
            end
            plot3(p(1),p(2),p(3),'bx');
            plot3(po(1,:),po(2,:),po(3,:),"ro",'MarkerSize',1);
            xlim([p(1)-10, p(1)+10]);
            ylim([p(2)-10, p(2)+10]);
            zlim([p(3)-10, p(3)+10]);
%                 pp = pplot([points(:, 1); p(1)], [points(:, 2); p(2)]);
%                 set(pp,'EdgeAlpha',0.05);
%                 set(pp,'EdgeColor','g');

        end
        function Qpi = inverse_matrices(obj,p,ids)
            % Qpi : inv(Q-p) = [r1;r2;r3] に対して 各行が [r1,r2,r3] となっている．
            % det(Q-p) : detP + dP1*p1 + dP2*p2 + dP3*p3;
            % Ar = [Pi3*p2-Pi2*p3,Pi1*p3-Pi3*p1,Pi2*p1-Pi1*p2];
            % adj(Q-r) : Pi + [Ar(:,1:3:end),Ar(:,2:3:end),Asr(:,3:3:end)];
            Pi = obj.constant(ids,1:9); i = 10;
            Pi1 = obj.constant(ids,i:i+2); i = i+3;
            Pi2 = obj.constant(ids,i:i+2); i = i+3;
            Pi3 = obj.constant(ids,i:i+2); i = i+3;
            detP = obj.constant(ids,i); i = i+1;
            dP1 = obj.constant(ids,i); i = i+1;
            dP2 = obj.constant(ids,i); i = i+1;
            dP3 = obj.constant(ids,i);
            detP = detP + dP1*p(1) + dP2*p(2) + dP3*p(3);
            Ar = [Pi3*p(2)-Pi2*p(3),Pi1*p(3)-Pi3*p(1),Pi2*p(1)-Pi1*p(2)];
            adjP = Pi + [Ar(:,1:3:end),Ar(:,2:3:end),Ar(:,3:3:end)];
            Qpi = adjP./detP;
            %%  verification
%             i = 10;
%             Qir = Qpi(i,:);
%             Qec1 = obj.fp(i,1:3)-p';
%             Qec2 = obj.fp(i,4:6)-p';
%             Qec3 = obj.fp(i,7:9)-p';
%             Ans=[sum(Qec1.*Qir(:,1:3),2),sum(Qec1.*Qir(:,4:6),2),sum(Qec1.*Qir(:,7:9),2),...
%                 sum(Qec2.*Qir(:,1:3),2),sum(Qec2.*Qir(:,4:6),2),sum(Qec2.*Qir(:,7:9),2),...
%                 sum(Qec3.*Qir(:,1:3),2),sum(Qec3.*Qir(:,4:6),2),sum(Qec3.*Qir(:,7:9),2)]
        end
        function [d, P, W] = cross_point(obj,e, Pi)
            % e2PLparam_cross_point のPL 行ベクトル版
            % Pi = [inv(P1);inv(P2);...] : triangleの逆行列が行ベクトルとして縦に並んだ行列
            %tmp = [-Pi(:,1:3:end)*e,-Pi(:,2:3:end)*e,-Pi(:,3:3:end)*e];
            tmp = [-Pi(:,1:3)*e,-Pi(:,4:6)*e,-Pi(:,7:9)*e];
            P = sum(tmp,2);
            W = tmp./P;
            ids = (W>=0 & W<=1)*[1;1;1]==3; % 交点が面分内にある平面インデックス
            if isempty(find(ids, 1))
                d = nan;
            else
                d = -1./min(P(ids));
                %p = d*e; % 最近壁面上の交点
            end
        end

    end

end

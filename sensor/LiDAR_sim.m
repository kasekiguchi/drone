classdef LiDAR_SIM < SENSOR_CLASS
% 未検証：単相LiDAR（全方位センサー）のsimulation用クラス
%   lidar = LiDAR(param)
%   (optional) radius = 1 default 40 m
%   (optional) angle_range = -pi/2:0.1:pi/2 default -pi:0.1:pi
properties
    name = "LiDAR";
    result
    self
    noise
    seed = [] % noise 用
    interface = @(x) x;
end

properties (SetAccess = private) % construct したら変えない．
    radius = 20;
    pitch = 0.01;
    angle_range
    dead_zone = 0.2;
    head_dir = nsidedpoly(3, 'Center', [0, 0], 'SideLength', 0.5);
end

methods

    function obj = LiDAR_SIM(self, param)        
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
    end

    function result = do(obj, param)
        % result=lidar.do(param)
        %   result.region : センサー領域（センサー位置を原点とした）polyshape
        %   result.length : [1 0]からの角度がangle,
        %   angle_range で規定される方向の距離を並べたベクトル：単相LiDARの出力を模擬
        % 【入力】param = {Env}        Plant ：制御対象， Env：環境真値
        Plant = obj.self.plant;
        Env = param{1};
        pos = Plant.state.p; % 実状態

        if isprop(Plant.state, "q")
            front = Plant.state.q(end); % オイラー角を想定
            R = [cos(front), -sin(front); sin(front), cos(front)]'; % ボディ座標から見るため転置
        else
            front = 0;
            R = eye(2);
        end

        tmp = obj.angle_range + front;
        circ = [obj.radius * cos(tmp); obj.radius * sin(tmp)]';

        if tmp(end) - tmp(1) > pi
            sensor_range = polyshape(circ(:, 1), circ(:, 2)); % エージェントの位置を中心とした円
        else
            sensor_range = polyshape([0; circ(:, 1)], [0; circ(:, 2)]); % エージェントの位置を中心とした円
        end

        SOE = size(Env.param.Vertices, 3); %polyshapeの数
        %複数のpolyshapeに対応
        for ei = 1:SOE
            tmpenv(ei) = polyshape(Env.param.Vertices(:, :, ei) - pos(1:2)'); %相対的な環境
        end

        env = union(tmpenv(:)); %polyshapeを結合

        result.region = intersect(sensor_range, env);
        %% 出力として整形
        %result.region.Vertices=result.region.Vertices-pos(1:2)'; % 相対的な測距領域

        result.angle = zeros(1, length(obj.angle_range));

        for i = 1:length(circ)
            in = intersect(result.region, [circ(i, :); 0 0]);

            if ~isempty(in)
                in = setdiff(in(~isnan(in(:, 1)), :), [0 0], 'rows'); % レーザーと領域の交点
                [~, mini] = min(vecnorm(in')');
                result.sensor_points(i, :) = in(mini, :);
                result.angle(i) = obj.angle_range(i);
            else
                result.sensor_points(i, :) = [0 0];
            end

        end

        result.region.Vertices = (R * result.region.Vertices')';
        result.sensor_points = (R * result.sensor_points')';

        if isempty(obj.seed)
            rng('shuffle');
        else
            rng(2 * obj.seed);
            obj.seed = obj.seed + 0.1;
        end

        result.length = vecnorm(result.sensor_points') + obj.noise * randn(1, length(result.sensor_points)); %.*sign(result.angle); % レーザー点までの距離
        del_ids = find((abs(result.length) < obj.dead_zone));
        result.length(del_ids) = 0;
        result.sensor_points(del_ids, :) = zeros(length(del_ids), 2);
        result.angle(del_ids) = 0;
        obj.result = result;
    end

    function show(obj, pq,q)
        arguments
            obj
            pq
            q = 0;
        end
        p = pq(1:2);
        if length(pq) >2
            q = pq(end);
        end

        if ~isempty(obj.result)
            points(1:2:2 * size(obj.result.sensor_points, 1), :) = obj.result.sensor_points;
            R = [cos(q), -sin(q); sin(q), cos(q)];
            %points = (R'*(points'-p))';
            points = (R * points' + p)';
            pp = pplot([points(:, 1); p(1)], [points(:, 2); p(2)]);
            set(pp,'EdgeAlpha',0.05);
            set(pp,'EdgeColor','g');
            hold on;
            text(points(1, 1), points(1, 2), '1', 'Color', 'b', 'FontSize', 10);
            region = polyshape((R * obj.result.region.Vertices' + p)');
            plot(region);
            head_dir = polyshape((R * obj.head_dir.Vertices' + p)');
            plot(head_dir);
            axis equal;
        else
            disp("do measure first.");
        end

    end

end

end
function [ p ] = pplot(x,y,z)
%PPLOT Draw line as patch

if nargin==2
    z=0;
end

x=reshape(x,[],1);
y=reshape(y,[],1);

p=patch([x;flipud(x)],[y;flipud(y)],z*ones(2*size(x,1),1),'b');

end
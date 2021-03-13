classdef LiDAR_sim < SENSOR_CLASS
    % 未検証：単相LiDAR（全方位センサー）のsimulation用クラス
    %   lidar = LiDAR(param)
    %   (optional) radius = 1 default 40 m
    %   (optional) angle_range = -pi/2:0.1:pi/2 default -pi:0.1:pi
    properties
        name = "LiDAR";
        result
        self
        interface = @(x) x;
    end
    properties (Access = private) % construct したら変えない．
        radius = 40;
        angle_range = -pi:0.01:pi;
        noise = 0;
    end
    
    methods
        function obj = LiDAR_sim(self,param)
            obj.self=self;
            %  このクラスのインスタンスを作成
            % radius, angle_range
            if isfield(param,'interface'); obj.interface = Interface(param.interface);end
            if isfield(param,'radius'); obj.radius = param.radius;         end
            if isfield(param,'angle_range');  obj.angle_range = param.angle_range;end
            if isfield(param,'noise');  obj.noise = param.noise;end
        end
        
        function result = do(obj,param)
            % result=lidar.do(param)
            %   result.region : センサー領域（センサー位置を原点とした）polyshape
            %   result.length : [1 0]からの角度がangle,
            %   angle_range で規定される方向の距離を並べたベクトル：単相LiDARの出力を模擬
            % 【入力】param = {Env}        Plant ：制御対象， Env：環境真値
            rng('shuffle');
            Plant=obj.self.plant;
            Env=param{1};
            tmp = obj.angle_range;            
            pos=Plant.state.p; % 実状態
            circ=[obj.radius*cos(tmp);obj.radius*sin(tmp)]';
            if tmp(end)-tmp(1) > pi
                %sensor_range=polyshape(circ(:,1)+pos(1),circ(:,2)+pos(2)); % エージェントの位置を中心とした円
                sensor_range=polyshape(circ(:,1),circ(:,2)); % エージェントの位置を中心とした円
            else
                %sensor_range=polyshape([pos(1);circ(:,1)+pos(1)],[pos(2);circ(:,2)+pos(2)]); % エージェントの位置を中心とした円
                sensor_range=polyshape([0;circ(:,1)],[0;circ(:,2)]); % エージェントの位置を中心とした円
            end
            SOE = size(Env.param.Vertices,3);
%             tmpenv = zeros(1,SOE);
            for ei = 1:SOE
                tmpenv(ei) = polyshape(Env.param.Vertices(:,:,ei)-pos(1:2)'); %相対的な環境
            end
            env = union(tmpenv(:));
            
            result.region=intersect(sensor_range,env);
            %% 出力として整形
            %result.region.Vertices=result.region.Vertices-pos(1:2)'; % 相対的な測距領域
            
            %lineseg(1:2:size(circ,1)*2,:)=circ;
            %in=intersect(result.region,[lineseg;0 0]);
%             index = zeros(length(circ),1);
            result.angle = obj.angle_range;
            for i = 1:length(circ)
                in=intersect(result.region,[circ(i,:);0 0]);
                if ~isempty(in)
                    in=setdiff(in(~isnan(in(:,1)),:),[0 0],'rows'); % レーザーと領域の交点
                    [~,mini]=min(vecnorm(in')');
                    result.sensor_points(i,:)=in(mini,:);
                    result.sensor_points(i,:) = result.sensor_points(i,:) + (obj.noise).*randn(1,2);
                    result.angle(i) = obj.angle_range(i);
%                     index(i) = 1;
                else
                    result.sensor_points(i,:) = [0 0];
                end
            end
            result.length=vecnorm(result.sensor_points'); % レーザー点までの距離
%             result.angle = obj.angle_range;%レーザー点の角度
            %result.region=intersect(polyshape(result.sensor_points(:,1),result.sensor_points(:,2)),env); % 
            result.state = {};
            obj.result=result;
        end
        function show(obj,~)
            if ~isempty(obj.result)
                points(1:2:2*size(obj.result.sensor_points,1),:)=obj.result.sensor_points;
                plot([points(:,1);0],[points(:,2);0],'r-');hold on; plot(obj.result.region);axis equal;
            else
                disp("do measure first.");
            end
        end
    end
end

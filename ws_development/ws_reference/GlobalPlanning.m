classdef GlobalPlanning < REFERENCE_CLASS
    % リファレンスを生成するクラス
    % obj =
    properties
        PolyArea
        OldGrid
        GridData
        Flontier
        MapParam
        self
    end
    
    properties(Constant)
        RobotSize = 1;
        WallThick = 1;
    end
    
    methods
        function obj = GlobalPlanning(self,varargin)
            % 【Input】 map_param ,
            obj.self = self;
            obj.MapParam = varargin{1};%MapParam
            %             obj.RobotSize = varargin{2};%
            %             obj.WallThick = varargin{3};%
            obj.result.state=STATE_CLASS(struct('state_list',["xd"],'num_list',[3]));%x,y,theta
            obj.PolyArea = polyshape();
        end
        
        function  result= do(obj,Param)
            %---Sensor data からpolyshapeを作成---%
            SensorData = obj.self.sensor.result;%sensor dataを引き出す
            EstData = obj.self.estimator.result.state;
            
            %ロボットの現在位置を格納した配列をつくる．
            State = [];
            for i = 1:length(EstData.list)
                if iscolumn(EstData.(EstData.list(i)))
                    State = [State;EstData.(EstData.list(i))];
                else
                    State = [State; EstData.(EstData.list(i))'];
                end
            end
            %観測値0を出してる点をSensorの最大rangeで置き換え
            LaserRangeidx = SensorData.length>0.1;
            
            %観測点を算出
            SensorPointX = State(1) + SensorData.length(LaserRangeidx).*cos(SensorData.angle(LaserRangeidx));
            if ~iscolumn(SensorPointX)
                SensorPointX = SensorPointX';
            end
            SensorPointY = State(2) + SensorData.length(LaserRangeidx).*sin(SensorData.angle(LaserRangeidx));
            if ~iscolumn(SensorPointY)
                SensorPointY = SensorPointY';
            end
            SensorPoint = [SensorPointX,SensorPointY];
            
            PolySensor = polyshape(SensorPoint);
            %-------------------------------------------
            %unionにより旧データと結合%
            obj.PolyArea = union(obj.PolyArea,PolySensor);
            %poly bufferで広げ，flontier作成準備
            PolyBufferArea = polybuffer(obj.PolyArea,obj.WallThick);
            %---壁面データからpolyshapeを作成---%
            PolyWall = polyshape();
            WallPoint = zeros(2,2,size(obj.self.estimator.result.map_param.x,1));
            for i = 1:size(obj.self.estimator.result.map_param.x,1)
                WallPoint(1,1,i) = obj.self.estimator.result.map_param.x(i,1);%startのx
                WallPoint(1,2,i) = obj.self.estimator.result.map_param.y(i,1);%startのy
                WallPoint(2,1,i) = obj.self.estimator.result.map_param.x(i,2);%endのx
                WallPoint(2,2,i) = obj.self.estimator.result.map_param.y(i,2);%endのy
                WallLine = polybuffer(WallPoint(:,:,i),'lines',obj.WallThick,'JointType','miter');
                PolyWall = union(PolyWall,WallLine);
            end
            %--------------------------------%
            %polybufferで広げたデータと壁面データで差分をとる
            PolyFnt = subtract(PolyBufferArea,PolyWall);
            %polybufferで広げる前と広げた後で差分をとる．残った部分をフロンティア候補とする．
            PolyFnt = subtract(PolyFnt,obj.PolyArea);
            %---Polyshapeのデータからフロンティアを計算---%
            MaxX = max(PolyFnt.Vertices(:,1));
            MaxY = max(PolyFnt.Vertices(:,2));
            MinX = min(PolyFnt.Vertices(:,1));
            MinY = min(PolyFnt.Vertices(:,2));
            
            [MapGridX,MapGridY] = meshgrid(MinX:obj.RobotSize:MaxX,MinY:obj.RobotSize:MaxY); 
            FntGrid =cell2mat(arrayfun(@(idx) isinterior(PolyFnt,MapGridX(idx,:),MapGridY(idx,:)),1:size(MapGridX,1),'UniformOutput',false));
            
            FntGridX = MapGridX(FntGrid);
            FntGridY = MapGridY(FntGrid);
            %-----------------------------------------% 
            %フロンティアの情報利得を計算
            
            %フロンティアの移動コストを計算
            Dis = sqrt( (FntGridX - State(1)).^2 + (FntGridY - State(2)).^2 ); 
            %最終コストを計算
            
            %minして決定する．
            [MinDis,MinDisidx] = min(Dis);
            obj.result.state = [FntGridX(MinDisidx),FntGridY(MinDisidx)];
            %resultに代入
            result=obj.result;
        end
        function show(obj,logger)
            rp=strcmp(logger.items,"reference.result.state.p");
            heart = cell2mat(logger.Data.agent(:,rp)'); % reference.result.state.p
            plot(heart(1,:),heart(2,:)); % xy平面の軌道を描く
            daspect([1 1 1]);
            hold on
            ep=strcmp(logger.items,"estimator.result.state.p");
            heart_result = cell2mat(logger.Data.agent(:,ep)'); % estimator.result.state.p
            plot(heart_result(1,:),heart_result(2,:)); % xy平面の軌道を描く
            legend(["reference","estimate"]);
            title('reference and estimated trajectories');
            xlabel("x [m]");
            ylabel("y [m]");
            hold off
        end
    end
end


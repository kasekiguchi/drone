classdef VORONOI_BARYCENTER_3D < REFERENCE_CLASS
    %3次元ボロノイ重心を算出するクラス
    %   詳細説明をここに記述
    
    properties
        param
        self
        fShow
        id
    end
    
    methods
        function obj = VORONOI_BARYCENTER_3D(self,param)
            arguments
                self
                param
            end
            obj.self = self;
            obj.param = param;
            obj.result.state = STATE_CLASS(struct('state_list',"p",'num_list',3));
            obj.id = self.sensor.motive.rigid_num;
        end
        
        function result = do(obj,~)
            % param = range, pos_range, d, void
            % 【Output】 result = 目標値（グローバル座標）
            %% 共通設定１：ボロノイセル確定
            sensor = obj.self.sensor.result;
            state = obj.self.estimator.result.state;
            if isfield(sensor,'neighbor') && isfield(sensor,'cent')
                neighbor = sensor.neighbor; % 通信領域内の他機体位置　グローバル座標
                xd = sensor.cent;
            elseif isfield(sensor,'rigid')
                neighbor = [sensor.rigid(1:size(sensor.rigid,2) ~= obj.id).p];
            else
                xd = [0;0;0]; % 環境が見えてない時の目標地点
            end

            % 描画用変数
            obj.result.state.p = xd';
            result = obj.result;
            if obj.fShow
                obj.show();
            end
        end

        function show(obj,Env)
        end
    end
end


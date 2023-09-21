classdef wall_distance_ref < REFERENCE_CLASS
    % 既知である環境に対し，目標位置(x,y)，目標姿勢角(yaw)を生成するクラス
    % obj = WALL_REFERENCE()
    properties % objの中に何が欲しいか決める所
        param
        func % 時間関数のハンドル
        self
        area_params
        region0
        region1
        region2
        area1
        area2
        fShow
        vrtx_len_limit
        result
    end
    methods
        function obj = wall_distance_ref(self,param)
            obj.self = self; %現在の機体の位置
            d = 1.5; %マージン
            if isempty(region2.Vertices)
                error("ACSL : the region is too narrow to flight.");%狭すぎるとこのエラー
            end
            if length(region1.Vertices(:,1))~=length(region2.Vertices(:,1))
                error("ACSL : The number of vertices is different between regions 1 and 2.");%頂点の数が違うエラー
            end
        end
    end
end

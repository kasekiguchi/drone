classdef wall_distance_ref < handle
    % vl53l1x 取得ファイル
    properties % objの中に何が欲しいか決める所
        self
        distance
        result
    end
    methods
        function obj = wall_distance_ref(self,param)
            obj.self = self; %現在の機体の位置
            d = 1.5; %マージン
%             if isempty(region2.Vertices)
%                 error("ACSL : the region is too narrow to flight.");%狭すぎるとこのエラー
%             end
%             if length(region1.Vertices(:,1))~=length(region2.Vertices(:,1))
%                 error("ACSL : The number of vertices is different between regions 1 and 2.");%頂点の数が違うエラー
%             end
        end
        function result = do (obj,VL53L1X)
            obj.distance = obj.vldata;
            printf("%d mm"\n,obj.distance)
        end
    end
end
function Vo = voronoi_region(pos, region,span)
% 【Input】 pos : [x;y;z]を横に並べた行列，
%           region : 対象領域の4隅(x,y)を縦に並べた行列，
%           span : 対象のインデックス
% 【Output】ボロノイセルのpolyshape セル配列
% 位置，ベクトル，インデックスそれぞれで記号を使い分けたほうが良い
%voronoi(pos(1,:),pos(2,:));
in=inpolygon(pos(1,:),pos(2,:),region(:,1),region(:,2));
if sum(in) ~= size(pos,2)
    error("ACSL ERROR : some agents are outside of the region.")
else
r_max=max(region);
r_min=min(region);
dr=r_max-r_min;
R_max = r_max + dr;
R_min = r_min - dr;
R = [R_max;R_min(1),R_max(2);R_min;R_max(1),R_min(2)];
DT = delaunayTriangulation([pos(1:2,:)';R]);
[V,r]=voronoiDiagram(DT);
Vo=arrayfun(@(i) polyshape(V(r{i},:)),span,'UniformOutput',false);
end
end


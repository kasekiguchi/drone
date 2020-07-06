function Vo = voronoi_region(pos, region,span)
% �yInput�z pos : [x;y;z]�����ɕ��ׂ��s��Cregion : �Ώۗ̈��4��(x,y)���c�ɕ��ׂ��s��Cspan :
% �Ώۂ̃C���f�b�N�X
% �yOutput�z�{���m�C�Z����polyshape �Z���z��
% �ʒu�C�x�N�g���C�C���f�b�N�X���ꂼ��ŋL�����g���������ق����ǂ�
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


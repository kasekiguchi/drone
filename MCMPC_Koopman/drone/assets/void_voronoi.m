function V=void_voronoi(V00,VOID,span)
% 【Input】V00 : polyshape セル，VOID : void 幅， span : 対象のインデックス
% 【Output】polyshapeセル
% 頂点A，B，Cからなる２辺について角ABCの半角をthetaとすると
% sin(theta) = sqrt(1- (e,E(BA))^2/|e|^2)
% e ： e13 = E(BA)+E(BC) : 角ABCの二等分線方向のベクトル
% E(BA) : 単位BAベクトル，E(BC)も同様
% VOID領域縮めたB点の更新点は
% B' = B + (VOID/sin(theta)) e/|e|
% V00の各polyshape Vに対して　polybuffer(V,-void) をやっているのと等価
V={V00{span}};
for i = span
    V0 = V00{i}.Vertices;
    V1 = V0;
    for j = 1:size(V0,1)
        if j==1
            p2=V0(1,:);
            p21=V0(end,:)-p2;
            p23=V0(2,:)-p2;
        elseif j == size(V0,1)
            p2=V0(end,:);
            p21=V0(end-1,:)-p2;
            p23=V0(1,:)-p2;
        else
            p2=V0(j,:);
            p21=V0(j-1,:)-p2;
            p23=V0(j+1,:)-p2;
        end
        ep21=p21/norm(p21);
        e13 = ep21+p23/norm(p23);
        V1(j,:)=p2+VOID*e13/sqrt(norm(e13)^2-(e13*ep21')^2);
    end
    V{i}=simplify(polyshape(V1));
end
end
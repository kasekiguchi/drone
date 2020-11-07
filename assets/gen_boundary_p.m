function [V1,Vi]= gen_boundary_p(Infp,ccp,ccpidc,V0num,region)
% 領域と半直線　ccp- Infp の交点 V1 と追加した点とccp 点の対応をViにまとめ返す関数
% Infp : Inf点
% ccp : 対応点
% ccpidc : ccpのV0の中でのインデックスセル配列
% region : 矩形領域の頂点座標
% いずれも(x,y)を縦に並べたもの
% V1 ：Vに追加する点の座標
% Vi ：[ccpのインデックス, V1のV内でのインデックス]

%%cv がSに含まれていなくても考える必要があるInf点はある．
%%in = inpolygon(cv(:,1),cv(:,2),S(:,1),S(:,2)); % cvのうちS内のインデックス
tmpnum = [1:V0num]';
V1=[];
Vi=[];
for i = 1:size(ccp,1)
tmpid=tmpnum(ccpidc{i});
for j = 1:size(tmpid,1)
    vnumtmp=size(V1,1);
    vtmp=[intersection_ray_segment([ccp(i,:);Infp(i,:);region([1,2],:)]);
        intersection_ray_segment([ccp(i,:);Infp(i,:);region([2,3],:)]);
        intersection_ray_segment([ccp(i,:);Infp(i,:);region([3,4],:)]);
        intersection_ray_segment([ccp(i,:);Infp(i,:);region([4,1],:)])];
    if ~isempty(vtmp)
        V1=[V1;vtmp];
        Vi=[Vi;tmpid(j)*[1 0]+[0 1].*(V0num+vnumtmp+[1:size(vtmp,1)]')];
    end
end
end
end

function v = intersection_ray_segment(X)
% X = [A;B;C;D]
%A = [a1 b1]：半直線の起点
%B = [a2 b2]：半直線の方向を規定する点
%C = [x1 y1]：対象線分の端点１
%D = [x2 y2]：対象線分の端点２
a1=X(1,1);
b1=X(1,2);
a2=X(2,1);
b2=X(2,2);
x1=X(3,1);
y1=X(3,2);
x2=X(4,1);
y2=X(4,2);
A=[a1 b1];
v = [a2 b2]-A;
if (a1*y1 - b1*x1 - a1*y2 - a2*y1 + b1*x2 + b2*x1 + a2*y2 - b2*x2)==0 %  交点が存在するためにはこの値が非零
    v=[];
else
    t = (a1*y1 - b1*x1 - a1*y2 + b1*x2 + x1*y2 - x2*y1)/(a1*y1 - b1*x1 - a1*y2 - a2*y1 + b1*x2 + b2*x1 + a2*y2 - b2*x2);
    if t <0
        v=[];
    else
        B = A+t*v;
        C=[x1 y1];
        D=[x2 y2];
        BC=C-B;
        BD=D-B;
        CD=D-C;
        if BC*CD'<=0 && BD*CD'>0 %線分内に交点を持つ条件
            v = B;
        else
            v=[];
        end
    end
end
end
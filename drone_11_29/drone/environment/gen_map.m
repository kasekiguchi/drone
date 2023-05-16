function [grid_density,map_max,map_min,xq,yq] = gen_map(Vertex,d,q,sigma)
% Vertex : 対象領域
% d : グリッド幅
% q : 重要度の位置 [xi yi] を縦に並べる
% sigma : 正規分布の分散の逆数　dでスケールされる
% map : 実スケールマップ
% grid : 行列マップ  grid(1,1)=map(0,0),  grid(end,1)=map(map_max(1),1)
% グラフ表示するときに工夫する
map_max=max(Vertex); % 領域を囲う長方形の右上座標
map_min=min(Vertex); % 領域を囲う長方形の左下座標
[xq,yq]=meshgrid(map_min(1):d:map_max(1),map_min(2):d:map_max(2)); %
% 領域が (-1,-1) から(2,1)の場合
% xq = [-1,0,1,2;-1,0,1,2;-1,0,1,2],  yq = [-1,-1,-1,-1;0,0,0,0;1,1,1,1];
xq=xq';
yq=yq';
[row,col]=size(xq);
xv=Vertex(:,1); % 領域 頂点x座標
yv=Vertex(:,2); % 領域 頂点y座標
in= inpolygon(xq,yq,xv,yv); % map 座標が領域に含まれるかの判別  ：領域内1 領域外0
%% 重要度
if isempty(q) % q = []  => 一様分布
    grid_density= ones(size(xq));
else
normal_k = sigma/d; % 重み用正規分布のexp内の係数  0.04
normal_mat = exp(-normal_k*((reshape(xq,[row*col,1])-q(:,1)').^2+(reshape(yq,[row*col,1])-q(:,2)').^2)); % 各重要度（列）の各グリッド（行）への影響（値）
normal_map = reshape(sum(normal_mat,2),[row,col]).*in; % 各グリッド（行）の重要度を行列に変形：inをかけ領域外は０
%grid_density = 255*normal_map/(max(normal_map,[],'all'))+1-50*(~in); % 正規化し1〜256の値へ．領域外は -50
grid_density = 255*normal_map/(max(normal_map,[],'all'))-50*(~in); % 正規化し0〜255の値へ．領域外は -50
end
end
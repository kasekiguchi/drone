function result = load_setting2(state_p,state_r,spone_area)
%通路の設定
[~,N] = size(state_p);
new_point = [];
for i=1:N
    new_point = [new_point;state_p(:,i)';state_r(:,i)';nan nan];
end
% point = [0 10;0 0;nan nan;4 0;4 5;7 5;7 0;nan nan;9 0;9 8;4 8;4 10];%あとで使うから一筆書きになるように設定
point = [0 10;0 0;nan nan;4 0;4 10;nan nan;new_point];%あとで使うから一筆書きになるように設定
%% 柱の重心から正方形の円柱作成
use_node = Cov_environment_setting(point);%wallの始点終点から0.5刻みでてんを作成
%最小射影のアルゴリズム
node_r = 1;
nodex = 0:node_r:11;
nodey = nodex;
[GXnode,GYnode] = meshgrid(nodex,nodey);%%χ

%`障害物の短点たち
ob = fix(use_node.wall)';
initial_node = cell(length(nodex),length(nodey));

for i = 1:length(nodex)
    for j = 1:length(nodey)
        initial_node{i,j} = [GXnode(i,j),GYnode(i,j)];
    end
end
%円盤の作成(ノードを新たに作っている)
node.point = create_node(initial_node,node_r,ob);
tmp = node.point;

    index = isinterior(polyshape(spone_area),node.point(1,:),node.point(2,:));
    node.point = tmp(:,index) ;


%ダイストラ方，各ノードに対する有効グラフを考えている．
[~,m]=size(node.point);
b = nchoosek(1:m,2);%ノード全てのコンビネーションをとってる．
s =[];
t = [];
weights =[];
for i = 1:length(b)
    dis = norm([node.point(1:2,b(i,1))-node.point(1:2,b(i,2))],2);
%     disp(node.point(1:3,b(i,1)))
%     disp(node.point(1:3,b(i,2)))
%     disp(dis)
%     disp('a')
    if dis<=node.point(3,b(i,1))||dis<=node.point(3,b(i,2))%距離が最初に考えていた円盤のサイズ以下ならば矢印の作成．
       s = [s b(i,1)];
       t = [t b(i,2)];
       weights = [weights dis];
    end
end
node.s = s;
node.t = t;
node.weights = weights;
result =node;

end
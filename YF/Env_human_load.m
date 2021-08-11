function env = Env_human_load(id)
%% environment class demo
% env property をEnv classのインスタンス配列として定義
%通路の設定
load.pillar_cog = [];
load.pollar_width = 0.5;
load.txt = 'conplex';
disp(load.txt);
point = [1 10;1 0;nan nan;3 0;3 5;7 5;7 0;nan nan;9 0;9 9;3 9;3 10];%あとで使うから一筆書きになるように設定

% load.txt = 'straight';
% disp(load.txt);
% point = [0 10;0 0;nan nan;2 0;2 10];%あとで使うから一筆書きになるように設定
%十字路
% load.txt = 'intersection';
% disp(load.txt);
% point = [0 4;4 4;4 0;nan nan;6 0;6 4;10 4;nan nan;10 6;6 6;6 10;4 10;4 6;0 6];%あとで使うから一筆書きになるように設定


load = Cov_auto_wallpoint(point,0.1,load);
load.endofwall = point;
%% 柱の重心から正方形の円柱作成
if isempty(load.pillar_cog)
else
    [num,~]=size(load.pillar_cog);
    for i = 1:num
        temp = cell2mat({load.pillar_cog(i,:)-[load.pollar_width,0]+[0,load.pollar_width];...
            load.pillar_cog(i,:)-[load.pollar_width,0]-[0,load.pollar_width];...
            load.pillar_cog(i,:)+[load.pollar_width,0]-[0,load.pollar_width];...
            load.pillar_cog(i,:)+[load.pollar_width,0]+[0,load.pollar_width]});
        load.poly = addboundary(load.poly, temp);
    end
end
use_node = Cov_environment_setting(point);%wallの始点終点から0.5刻みでてんを作成
%最小射影のアルゴリズム
node_r = 2.4;
nodex = 0:1.:11;
nodey = nodex;
[GXnode,GYnode] = meshgrid(nodex,nodey);%%χ

%`障害物の短点たち
ob = (use_node.wall)';
initial_node = cell(length(nodex),length(nodey));

for i = 1:length(nodex)
    for j = 1:length(nodey)
        initial_node{i,j} = [GXnode(i,j),GYnode(i,j)];
        if ~isinterior(load.spone_area,initial_node{i,j}(1),initial_node{i,j}(2))
            initial_node{i,j}=[];
        end
    end
end
%円盤の作成(ノードを新たに作っている)
node.point = create_node(initial_node,node_r,ob,load.spone_area);
tmp = node.point;

index = isinterior(load.spone_area,node.point(1,:),node.point(2,:));
node.point = tmp(:,index) ;


%ダイストラ方，各ノードに対する有効グラフを考えている．
[~,m]=size(node.point);
b = nchoosek(1:m,2);%ノード全てのコンビネーションをとってる．
s =[];
t = [];
weights =[];
s2 =[];
t2 = [];
weights2 =[];
parfor i = 1:length(b)
    dis = norm([node.point(1:2,b(i,1))-node.point(1:2,b(i,2))],inf);
    dis2=norm([node.point(1:2,b(i,1))-node.point(1:2,b(i,2))],2);
    %     disp(node.point(1:3,b(i,1)))
    %     disp(node.point(1:3,b(i,2)))
    %     disp(dis)
    %     disp('a')
    if dis<=node.point(3,b(i,1))||dis<=node.point(3,b(i,2))%距離が最初に考えていた円盤のサイズ以下ならば矢印の作成．
        s = [s b(i,1)];
        t = [t b(i,2)];
        weights = [weights dis];
    end
    if dis2<=node.point(3,b(i,1))||dis2<=node.point(3,b(i,2))%距離が最初に考えていた円盤のサイズ以下ならば矢印の作成．
        s2 = [s2 b(i,1)];
        t2 = [t2 b(i,2)];
        weights2 = [weights2 dis2];
    end
end
% node.s = [s,t];
% node.t = [t,s];
% node.weights = [weights,weights];
node.s = s;
node.t = t;
node.weights = weights;
node.s2 = s2;
node.t2 = t2;
node.weights2 = weights2;

% plot(AAA,'FaceAlpha',0)
%曲がり角の点を算出．
[m,~] = size(point);
AA = 1;
BB= 1;
ttt= 0;
wall_point{1}(1,:) = point(1,:);

%ここで壁のポイントとベックとるを各セル内に分割
for noderoop=2:m
    TorF =double(isnan(point(noderoop,:)))+double(isnan(point(noderoop-1,:)));
    if sum(TorF)~=0
        if ttt~=0
        else
        AA = AA+1;
        BB =1;
        ttt=1;
        end
    else
        vector_wall{AA}(BB,:) = point(noderoop,:)-point(noderoop-1,:);
        BB=BB+1;
        ttt=0;
    end
    if ~isnan(point(noderoop,:))
        wall_point{AA}(BB,:) = point(noderoop,:);
    end
end
%曲がり角の点を算出
curve_pointy =[];
for i=1:AA
    [n,~] = size(vector_wall{i});
    if n == 1
        
    else
        for j = 1:n-1
            if cross([vector_wall{i}(j,:),1],[vector_wall{i}(j+1,:),1])~=0
                %外積を利用して直角を算出
              curve_pointy{i,1}(j,:) = wall_point{i}(j+1,:);
            end
        end
    end 
end
%曲がり角の点を保存

load.curve_point = cell2mat(curve_pointy);

% node_tmp = rmmissing(node_tmp);
% nodex = node_tmp(:,1);nodey = node_tmp(:,2);
% node = cell2mat(arrayfun(@(i) cell2mat(arrayfun(@(j) [nodex(j,1);nodey(i,1)],1:length(nodex),'uniformoutput',false)),1:length(nodey),'uniformoutput',false));
% [a,~,~] = unique(node','rows');
% AAA = polyshape(load.spone_area.Vertices);
% BBB = polybuffer(AAA,-0.5,'JointType','miter','MiterLimit',2);
% TFin = arrayfun(@(i) isinterior(BBB,a(i,1),a(i,2)),1:length(a));
% %             cilcle_P = cell2mat(arrayfun(@(i) state.p+2*[cos(i*pi/180);sin(i*pi/180)],0:360,'uniformoutput',false));
% QQQ = a(TFin,:);
% load.node.p = QQQ;
% [n,~] = size(load.node.p);
% [np,~] = size(load.spone_area.Vertices);
% EEE = (arrayfun(@(i) cell2mat(arrayfun(@(j) 1/norm(load.spone_area.Vertices(j,:)-load.node.p(i,:),2),1:np,'uniformoutput',false)),1:n,'uniformoutput',false));
% load.node.buff = arrayfun(@(i) sum(EEE{i},2),1:length(EEE));
load.node = node;
env.param.load =load;

% env_param.name="";
% assignin('base',"env_param",env_param);
% evalin('base',"Env = DensityMap_sim([],env_param);");

    env.name = "huma_load";
    env.type = "huma_load_sim";
    env.param.id=id;
end

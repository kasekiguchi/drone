%% 最小射影の多層バージョン
%最小射影のやつの例をそのまま作る．
clear all
close all
grid_x = 0:0.1:10;
grid_y = 0:0.1:10;
node_r = 1;
nodex = 0:node_r:10;
nodey = nodex;
grid_z = grid_y;
[GX,GY] = meshgrid(grid_x,grid_y);%%χ
[GXnode,GYnode] = meshgrid(nodex,nodey);%%χ

%`障害物の短点たち
initial_ob = [5,0;5,5];
% initial_ob = [(use_node.wall)];

obx = linspace(initial_ob(1,1),initial_ob(2,1),6);
oby = linspace(initial_ob(1,2),initial_ob(2,2),6);
ob = vertcat(obx,oby);
initial_node = cell(length(nodex),length(nodey));

for i = 1:length(nodex)
    for j = 1:length(nodey)
        initial_node{i,j} = [GXnode(i,j),GYnode(i,j)];
    end
end
% 円盤の作成(ノードを新たに作っている)
node = create_node(initial_node,node_r,ob);
scatter(node(1,:),node(2,:))
hold on
grid on
% ダイストラ方，各ノードに対する有効グラフを考えている．
[~,m]=size(node);
b = nchoosek(1:m,2);%ノード全てのコンビネーションをとってる．
s =[];
t = [];
weights =[];
parfor i = 1:length(b)
    dis = norm([node(1:2,b(i,1))-node(1:2,b(i,2))],2);
    if dis<=node(3,b(i,1))||dis<=node(3,b(i,2))%距離が最初に考えていた円盤のサイズ以下ならば矢印の作成．
       s = [s b(i,1)];
       t = [t b(i,2)];
       weights = [weights dis];
    end
end
% 有効グラフの最小距離を作成．

[sizeX,~]=size(GX);
[~,sizeY]=size(GY);
syms symx symy


% nodeごとのポテンシャル関数
%
map = zeros(sizeX,sizeY);
Vp = zeros(1,m);

parfor k=1:sizeX
    for j=1:sizeY
        x = GX(k,j);
        y = GY(k,j);
        Vp = zeros(1,m);
        Vp2 = zeros(1,m);
        Vp3 = zeros(1,m);
        
%         if x>=2&&y>=1
%            disp(x)
%            disp(y)
%         end
        for i = 1:m
            P = shortestpath(digraph([s t],[t s],[weights weights]),1,i);
            C = weights(P);
%             if pi*sqrt((x-node(1,i))^2+(y-node(2,i))^2)/(2*node(3,i))<pi/2
%             Vp(i) = (2*node(3,i)/pi) * (tan(pi*sqrt((x-node(1,i))^2+(y-node(2,i))^2)/(2*node(3,i))))+sum(C);
%             Vp(i) = [x-node(1,i);y-node(2,i)]'*[x-node(1,i);y-node(2,i)]/2+sum(C);
            Vp(i) = 1*exp(1*(norm([x;y]-node(1:2,i))/node(3,i)))+1*sum(C);
            Vp2(i) =1*exp(1*(norm([x;y]-node(1:2,i))/node(3,i)))+1*sum(C);
            Vp3(i) =0.1*exp(1*(norm([x;y]-node(1:2,i))/node(3,i)))+0.5*sum(C);

%             else
%                Vp(i) = sum(C);
%             end
        end
        M = min(Vp);
        map(k,j) = M;
        M2 = min(Vp2);
        map2(k,j) = M2;
        M3 = min(Vp3);
        map3(k,j) = M3;
    end
end
%
figure;  surf(GX,GY,map,'EdgeColor','none');
 figure;  surf(GX,GY,map2,'EdgeColor','none');
figure;  surf(GX,GY,map3,'EdgeColor','none');
% zlim([0 100])
%%
syms symx symy symnodex symnodey symnoder
symVp = 0.1*exp(1*(norm([symx;symy]-[symnodex;symnodey])/symnoder));
diffx = diff(symVp,symx);
diffy = diff(symVp,symy);
p = [7.5;2];

save=[];
for k=1:0.1:50%シミュレーションタイム
    
    x = p(1);
    y = p(2);
    for i = 1:m
        P = shortestpath(digraph([s t],[t s],[weights weights]),1,i);
        C = weights(P);
%         Vp(i) =  double(subs(symVp,[symx symy symnodex symnodey symnoder],[x y node(1,i) node(2,i) node(3,i)]))+0.5*sum(C);
        Vp(i) = Cov_Vp(x,y,node(1,i),node(2,i),node(3,i))+0.5*sum(C);
    end
    [~,index]= min(Vp);
%     vx = double(subs(diffx,[symx symy symnodex symnodey symnoder],[x y node(1,index) node(2,index) node(3,index)]));
    vx = Cov_diffx_Vp(x,y,node(1,index),node(2,index),node(3,index));
%     vy = double(subs(diffy,[symx symy symnodex symnodey symnoder],[x y node(1,index) node(2,index) node(3,index)]));
    vy = Cov_diffy_Vp(x,y,node(1,index),node(2,index),node(3,index));

    u = -[vx;vy];
    p = eye(2)*p + 0.1*eye(2)*(u/norm(u,2));
    
    save = [save,p];
    scatter(save(1,:),save(2,:),'r');
    xlim([-1 9]);ylim([-1 9]);
    grid on;
end


%%
close all
figure(4)
surf(GX,GY,map,'EdgeColor','none');
% contour(map)
hold on
z = 30*ones(1,length(save));
scatter3(save(1,:),save(2,:),z(:),'r')
%                 scatter3(save(1,:)*10+20,save(2,:)*10,z(:),'r')

axis equal;
grid on
view(2)
%%
function result = create_node(initial_node,node_r,ob)
[n,m]= size(initial_node);
[~,om]= size(ob);
ok_node = [];
for i = 1:n
    for j = 1:m
        %         for ok = 1:on
%         for ol = 1:om
%             disp(initial_node{i,j});
            dis = arrayfun(@(ol) norm([initial_node{i,j}-ob(:,ol)'],2),1:om);
            aa = dis<=node_r;
            if sum(aa)==0
                ok_node = [ok_node,[initial_node{i,j}';node_r]];
%                 break;
            else%こっちで4個の円盤を作成．
                mini_disc = fnew_node(initial_node{i,j}',ob,node_r);
                ok_node = [ok_node mini_disc];
%                 break;
            end
%         end
        %         end
    end
    result = ok_node;
end
end
function result = fnew_node(node,ob,r)
%nodeは障害物と被っている点，obは障害物上の点,rは円盤の半径
result = [];
[~,om] = size(ob);
r2 = 1.1*r/2;
d = r/2;
pul = node+[-d;d];

dis = arrayfun(@(jj) norm([pul-ob(jj)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    pul = fnew_node(pul,ob,r2);
%         [~,nodem] = size(pul);
% rpi = r2*ones(1,nodem);
% pul = vertcat(pul,rpi);
else
    pul = [pul;r2];
end
pur = node+[d;d];
dis = arrayfun(@(jj) norm([pur-ob(jj)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    pur = fnew_node(pur,ob,r2);
%         [~,nodem] = size(pur);
% rpi = r2*ones(1,nodem);
% pur = vertcat(pur,rpi);
else
    pur = [pur;r2];
end
pbl = node+[-d;-d];
dis = arrayfun(@(jj) norm([pbl-ob(jj)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    pbl = fnew_node(pbl,ob,r2);
%         [~,nodem] = size(pbl);
% rpi = r2*ones(1,nodem);
% pbl = vertcat(pbl,rpi);
else
    pbl = [pbl;r2];
end
pbr = node+[d;-d];
dis = arrayfun(@(jj) norm([pbr-ob(jj)],2),1:om);
AA = dis<=r2;

if sum(AA)~=0
    pbr = fnew_node(pbr,ob,r2);
%     [~,nodem] = size(pbr);
% rpi = r2*ones(1,nodem);
% pbr = vertcat(pbr,rpi);
else
    pbr = [pbr;r2];
end
%再帰関数でどうだろう．
result = [pul pur pbl pbr result];

% end
end
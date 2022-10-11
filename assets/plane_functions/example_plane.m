% 直線，平面のプロット
t = [1,1,0];
t = t/vecnorm(t);
l.pl = [t,-1]';
l.e = [0;1;1];
l.e = l.e - (t*l.e)*t';
l.e = l.e/vecnorm(l.e);
line_plot3(l);
hold on 
plane_plot3(l.pl);
hold off

% 交点確認
l2pl_cross_point(l,l.pl+[0;0;0;1]); % 交点を持たない場合

line_plot3(l);
hold on 
t = [1,1,-1];
t = t/vecnorm(t);
pl = [t,0]';
plane_plot3(pl);
[p,q,e1,e2] = l2pl_cross_point(l,pl);% 
plot3(p(1),p(2),p(3),'o')
n=[[0;0;0],-pl(4)*pl(1:3),-pl(4)*pl(1:3)];
m=[[0;0;0],q(1)*e1,q(2)*e2]
quiver3(n(1,:),n(2,:),n(3,:),m(1,:),m(2,:),m(3,:));
hold off
%%
pl = [1 0 0 -5];
e1 = [3 1 1]'; e1 = e1/vecnorm(e1);
e2 = [2 1 -2]';e2 = e2/vecnorm(e2);
e3 = [3 -1 -2]';e3 = e3/vecnorm(e3);
e4 = [4 -2 1]';e4 = e4/vecnorm(e4);
l1 = line_through_p([0 0 0],e1);
p1 = l2pl_cross_point(l1,pl);
l2 = line_through_p([0 0 0],e2);
p2 = l2pl_cross_point(l2,pl);
l3 = line_through_p([0 0 0],e3);
p3 = l2pl_cross_point(l3,pl);
l4 = line_through_p([0 0 0],e4);
p4 = l2pl_cross_point(l4,pl)
P = [p1,p2,p3,p4]
e = [1;2;0];
l = line_through_p([0 0 0]',e);
p = l2pl_cross_point(l,pl);
plane_plot3(pl);
hold on
plot3(P(1,:),P(2,:),P(3,:),'o');
daspect([1 1 1]);
view([-1 -2 1]);
grid on
hold off
solve(p==a*p1+b*p2+c*p3+d*p4,[a,b,c,d])
(pinv(P)*p)
%%
syms p1 [3 1] real
syms p2 [3 1] real
syms p3 [3 1] real
syms p4 [3 1] real
syms P [3 1] real
syms a b c d real
tmp=pinv([p1,p2,p3,p4])*P;
sol=solve([P==a*p1+b*p2+c*p3+d*p4;1 == a+b+c+d],[a,b,c,d]);
%% 部屋を模擬
close all
xm = 0;
xM = 100;
ym = -5;
yM = 5;
zm = 0;
zM = 3;
pl = [1,0,0,-xM;1,0,0,-xm;0,1,0,-yM;0,1,0,-ym;0,0,1,-zM;0,0,1,zm];
%pl = [1,0,0,-10;1,0,0,0;0,1,0,-5;0,-1,0,-5];
%plane_plot3(pl,"xlim",[0,10],"ylim",[-5,5],"zlim",[0,3]);
hold on
th = 0:0.1:2*pi;
P = [4;0;1];
R = Rodrigues([1,1,1]/6,0.1);
alpha = -pi/12:0.034:pi/12;
for k = alpha
Ra = [cos(k);0;sin(k)];%Rodrigues([0;1;0],k);
for i = th
    Rth = [cos(i),-sin(i),0;sin(i),cos(i),0;0,0,1];%Rodrigues([0;0;1],i);
%e = R*[cos(i);sin(i);0];
e = R*Rth*Ra;
l = line_through_p(P,e);
for j = 1:size(pl,1)
p = l2pl_cross_point(l,pl(j,:));
if (p-P)'*e > 0
 plot3(p(1),p(2),p(3),'xg');
%             pp = pplot([p(1); P(1)], [p(2); P(2)], [p(3); P(3)]);
%             set(pp,'EdgeAlpha',0.5);
%             set(pp,'EdgeColor','g');
end
end
end
end
xlim([xm,xM]);
ylim([ym,yM]);
zlim([zm,zM]);
daspect([1 1 1]);
view([1 -2 1]);
hold off

%% 
STL = '3F.stl';
[TR,fileformat,attributes,solidID] = stlread(STL);
%triplot(TR)
P = incenter(TR);
F = faceNormal(TR);  
% trisurf(T,Xb(:,1),Xb(:,2),Xb(:,3), ...
%      'FaceColor','cyan','FaceAlpha',0.8);
quiver3(P(:,1),P(:,2),P(:,3), ...
     F(:,1),F(:,2),F(:,3),0.5,'color','r');
axis equal
hold on  

bld.Faces=TR.ConnectivityList;
bld.Vertices=TR.Points;  
%CData=linspace(0,1,249970);   %%stlファイルには色データーははいっていないので、自分でつくる。頂点の数と一緒ならOK
%bld.CData=CData;

bld.FaceAlpha = 0.5;           % remove the transparency
bld.FaceColor = 'b'%;'interp';    % set the face colors to be interpolated
bld.LineStyle = '-';%'none';      % remove the lines
%bld.CDataMapping='scaled'
patch(bld)
xlabel("x");
ylabel("y");
zlabel("z");
%%
p = [0;20;0]; % LiDARの位置
q = [1;0;0]; % LiDARの姿勢（オイラー角）
L = 20; % LiDAR センサレンジ
rp = P - p'; % 相対位置
ip = sum(rp.*F,2) < 0; % 内積が負の壁が見えている壁面
dw = vecnorm(rp(ip,:),2,2); % 壁までの距離 : TODO : 長い壁面の場合棄却されてしまう
in = dw < L ; % in range 
Ip = find(ip);
ids = Ip(in); % 候補の壁面インデックス
Face = TR.ConnectivityList(ids,:);
P = TR.Points(Face,:);
size(P)
Sp=P2USp(P);
%%
F = featureEdges(TR,pi/110)';
size(F)
XYZ = [TR.Points(F(1,:),:),TR.Points(F(2,:),:),nan(size(TR.Points(F(1,:),:)))];
x = reshape(XYZ(:,1:3:end),[],1);
y = reshape(XYZ(:,2:3:end),[],1);
z = reshape(XYZ(:,3:3:end),[],1);
plot3(x,y,z,'k','LineWidth',1.5); 
axis equal

%%
ID = edgeAttachments(TR,F');

%% 等距離射影
 p = [1;0;0];
 e=[0;1;1];
t= -100:1:100;
P = p+t.*e;
XY=P2USp(P')
plot(XY(:,1),XY(:,2))
%% 等距離射影
clear t
 p = [1;0;0];
 e=[0;1;1];
syms t real
P = p+t.*e;
E = P./sqrt(P'*P); % unit sphere
DXY = E(1:2)'*E(1:2);
Sp = [sign(E(2)).*acos(E(1)./DXY),acos(E(3))]
%% 円筒射影
p = [1;0;0];
e = [0;1;2];
t = -100:0.1:100;
P = (p+t.*e)';
DXY = vecnorm(P(:,1:2),2,2);
P = P./DXY;
Cp = [atan2(P(:,2),P(:,1)),P(:,3)];
plot(Cp(:,1),Cp(:,2))
%% 中心射影
p = [1;0;0];
e = [0;1;2];
t = -100:0.1:100;
P = (p+t.*e)';
perp = [1;0;0];
d = P*perp;
rp = P - perp';
ey = [0;1;0];
ez = [0;0;1];
XY = [rp*ey,rp*ez]./(d+1);
plot(P(:,2),P(:,3),XY(:,1),XY(:,2));
legend("org","pr")

% 直線，平面のプロット
t = [1,1,0];
t = t/vecnorm(t);
l.pl = [t,-1]';
l.e = [0;1;1];
l.e = l.e - (t*l.e)*t';
l.e = l.e/vecnorm(l.e);
lineplot3(l);
hold on 
planeplot3(l.pl);
hold off

% 交点確認
l2plcrosspoint(l,l.pl+[0;0;0;1]); % 交点を持たない場合

lineplot3(l);
hold on 
t = [1,1,-1];
t = t/vecnorm(t);
pl = [t,0]';
planeplot3(pl);
[p,q,e1,e2] = l2plcrosspoint(l,pl);% 
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
l1 = linethroughp([0 0 0],e1);
p1 = l2plcrosspoint(l1,pl);
l2 = linethroughp([0 0 0],e2);
p2 = l2plcrosspoint(l2,pl);
l3 = linethroughp([0 0 0],e3);
p3 = l2plcrosspoint(l3,pl);
l4 = linethroughp([0 0 0],e4);
p4 = l2plcrosspoint(l4,pl)
P = [p1,p2,p3,p4]
e = [1;2;0];
l = linethroughp([0 0 0]',e);
p = l2plcrosspoint(l,pl);
planeplot3(pl);
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
%planeplot3(pl,"xlim",[0,10],"ylim",[-5,5],"zlim",[0,3]);
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
l = linethroughp(P,e);
for j = 1:size(pl,1)
p = l2plcrosspoint(l,pl(j,:));
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
P = incenter(TR); % 三角形の内心
F = faceNormal(TR);  % 法線ベクトル（外向き） 
% quiver3(P(:,1),P(:,2),P(:,3), ...
%      F(:,1),F(:,2),F(:,3),0.5,'color','r');
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
daspect([1 1 1]);
view([-3 1 2]);
xlabel("x");
ylabel("y");
zlabel("z");
%%
p = [0;5;-5]; % LiDARの位置
%q = [0;0;0]; % LiDARの姿勢（オイラー角）
R = Rodrigues([1,0,0],pi/12);
R = eye(3);
%e = [1, 2, -1;1,0,0]'; % レーザーの向き

phi = 0:0.1:2*pi;
th =pi/2 +(-pi/12:0.034:pi/12);
%e = [sin(th);sin(th);cos(th)].*[cos(phi);sin(phi);ones(1,size(phi,2))]
e = [kron(sin(th),cos(phi));kron(sin(th),sin(phi));kron(cos(th),ones(1,size(phi,2)))];
e = R*e;
%e = e(:,1:25);
L = 20; % LiDAR センサレンジ
rp = P - p'; % 相対位置
ip1 = sum(rp.*F,2) < 0; % 「内積が負の壁」が見えている壁面
ip2 = rp*e > 0; % 「内積が正の壁」がレーザー方向にある壁
%dw = vecnorm(rp(ip,:),2,2); % 壁までの距離 : TODO : 長い壁面の場合棄却されてしまう
%in = dw < L ; % in range 
%Ip = find(ip);
%ids = Ip(in); % 候補の壁面インデックス
ids = ip1 & ip2;
cn = TR.ConnectivityList;
ps = TR.Points;
fp=[ps(cn(:,1),:),ps(cn(:,2),:),ps(cn(:,3),:)]; % face points : [x1 y1 z1 x2 y2 z2 x3 y3 z3; ...];
%%
pn = ps-p';
pns=pn*e<0;
%%
% % 1 : laser id, 2 : wall id, 3 : x,y,z, 4 : p1,p2,p3
% K = zeros(size(e,2),size(cn,1),3,3);
% i = 1;
% for l = e % laser
%     j = 1;
%     for w = cn' % wall
%         K(i,j,:,:) = pn(w,:)';
%         j = j+1;
%     end
%     i = i+1;
% end
%%
facei = arrayfun(@(i) cn(ids(:,i),:)*e,1:size(ids,2),'UniformOutput',false);
%%
% syms P [3 3] real
% syms e [3 1] real
% ipe = inv(P-e);
% simplify(ipe(:,1)-[Skew(P(3,:)')*[1;1;1],Skew(P(2,:)')*[1;1;1],Skew(P(2,:)')*P(3,:)']*[e2;-e3;1]);
% simplify(ipe(:,2)-[Skew(P(1,:)')*[1;1;1],Skew(P(3,:)')*[1;1;1],Skew(P(3,:)')*P(1,:)']*[e3;-e1;1]);
% simplify(ipe(:,3)-[Skew(P(1,:)')*[1;1;1],Skew(P(2,:)')*[1;1;1],Skew(P(1,:)')*P(2,:)']*[-e2;e1;1]);
% simplify(det(P-e)-det(P)-sum(cross(P(2,:),P(1,:)))*e3-sum(cross(P(1,:),P(3,:)))*e2-sum(cross(P(3,:),P(2,:)))*e1);
% tpi= {[Skew(P(3,:)')*[1;1;1],Skew(P(2,:)')*[1;1;1],Skew(P(2,:)')*P(3,:)'],[Skew(P(1,:)')*[1;1;1],Skew(P(3,:)')*[1;1;1],Skew(P(3,:)')*P(1,:)'],[Skew(P(1,:)')*[1;1;1],Skew(P(2,:)')*[1;1;1],Skew(P(1,:)')*P(2,:)']};
% adjPe = [tpi{1}*[e2 -e3 1]', tpi{2}*[e3 -e1 1]', tpi{3}*[-e2 e1 1]'];
% detPe = det(P)+[1 1 1]*[cross(P(2,:),P(1,:));cross(P(1,:),P(3,:));cross(P(3,:),P(2,:))]'*[e3;e2;e1];
% simplify((P-e)*adjPe/detPe)
% %% 検証用
% clear P p
% syms P [3 3] real
% syms p [3 1] real
% Qi = inv(P-p);
% 
% Q  = P(1:3,1:3);
% e1 = p(1);
% e2 = p(2);
% e3 = p(3);
% E1 = [e2 -e3]';%
% E2 = [e3 -e1]';%
% E3 = [e1 -e2]';%
% 
% Pi0  = [cross(Q(2,:),Q(3,:));cross(Q(3,:),Q(1,:));cross(Q(1,:),Q(2,:))]';
% tpi1 = [sum(Skew(Q(3,:)'),2),sum(Skew(Q(2,:)'),2)];
% tpi2 = [sum(Skew(Q(1,:)'),2),sum(Skew(Q(3,:)'),2)];
% tpi3 = [sum(Skew(Q(2,:)'),2),sum(Skew(Q(1,:)'),2)];
% At = [tpi1*E1,tpi2*E2,tpi3*E3];
% At = Pi0 + At;
% detAt = det(Q)-sum(Pi0*p);
% II=At./detAt;
% simplify((Q-p)*II)

%% ベクトル化されたデータに対する逆行列算出
%Q = P;
%fp = [Q(:,1:3),Q(:,4:6),Q(:,7:9)];
Q11=fp(:,1);Q12=fp(:,4);Q13=fp(:,7);
Q21=fp(:,2);Q22=fp(:,5);Q23=fp(:,8);
Q31=fp(:,3);Q32=fp(:,6);Q33=fp(:,9);
Qr1 = [Q11,Q12,Q13];
Qr2 = [Q21,Q22,Q23];
Qr3 = [Q31,Q32,Q33];
Qc1 = [Q11,Q21,Q31];
Qc2 = [Q12,Q22,Q32];
Qc3 = [Q13,Q23,Q33];
e1 = p(1);
e2 = p(2);
e3 = p(3);

%3x3
%P0c = [cross(fp(:,4:6),fp(:,7:9)),cross(fp(:,7:9),fp(:,1:3)),cross(fp(:,1:3),fp(:,4:6))];% n-face x 9 : = [Pc1', Pc2', Pc3'] : P = Q^(-1)*det(Q) 
P0r = [cross(Qc2,Qc3),cross(Qc3,Qc1),cross(Qc1,Qc2)];% n-face x 9 : = [Pr1, Pr2, Pr3] : P = Q^(-1)*det(Q) 

% original
% Ar1 = [Q32*e2-Q33*e2+Q23*e3-Q22*e3, Q12*e3-Q13*e3+Q33*e1-Q32*e1, Q22*e1-Q23*e1+Q13*e2-Q12*e2];
% Ar2 = [Q33*e2-Q31*e2+Q21*e3-Q23*e3, Q13*e3-Q11*e3+Q31*e1-Q33*e1, Q23*e1-Q21*e1+Q11*e2-Q13*e2];
% Ar3 = [Q31*e2-Q32*e2+Q22*e3-Q21*e3, Q11*e3-Q12*e3+Q32*e1-Q31*e1, Q21*e1-Q22*e1+Q12*e2-Q11*e2];
% reduce multiply number
Q11e2 = Q11*e2; Q12e2 = Q12*e2; Q13e2 = Q13*e2;
Q31e2 = Q31*e2; Q32e2 = Q32*e2; Q33e2 = Q33*e2;
Q21e1 = Q21*e1; Q22e1 = Q22*e1; Q23e1 = Q23*e1;
Q31e1 = Q31*e1; Q32e1 = Q32*e1; Q33e1 = Q33*e1;
Q11e3 = Q11*e3; Q12e3 = Q12*e3; Q13e3 = Q13*e3;
Q21e3 = Q21*e3; Q22e3 = Q22*e3; Q23e3 = Q23*e3;
Ar1 = [Q32e2-Q33e2+Q23e3-Q22e3, Q12e3-Q13e3+Q33e1-Q32e1, Q22e1-Q23e1+Q13e2-Q12e2];
Ar2 = [Q33e2-Q31e2+Q21e3-Q23e3, Q13e3-Q11e3+Q31e1-Q33e1, Q23e1-Q21e1+Q11e2-Q13e2];
Ar3 = [Q31e2-Q32e2+Q22e3-Q21e3, Q11e3-Q12e3+Q32e1-Q31e1, Q21e1-Q22e1+Q12e2-Q11e2];
% 
tic
Ar = [Ar1,Ar2,Ar3];  
toc
%At = shiftdim(pagemtimes(tp,et),2)';
Pr = P0r + Ar;

%Pi0r = [Q22.*Q33 - Q23.*Q32, Q13.*Q32 - Q12.*Q33, Q12.*Q23 - Q13.*Q22,Q23.*Q31 - Q21.*Q33, Q11.*Q33 - Q13.*Q31, Q13.*Q21 - Q11.*Q23,Q21.*Q32 - Q22.*Q31, Q12.*Q31 - Q11.*Q32, Q11.*Q22 - Q12.*Q21];
%detAt= detP-Pi0r*[p;p;p];
%[Q2_2*Q3_3 - Q2_3*Q3_2, Q1_3*Q3_2 - Q1_2*Q3_3, Q1_2*Q2_3 - Q1_3*Q2_2]
%[Q2_3*Q3_1 - Q2_1*Q3_3, Q1_1*Q3_3 - Q1_3*Q3_1, Q1_3*Q2_1 - Q1_1*Q2_3]
%[Q2_1*Q3_2 - Q2_2*Q3_1, Q1_2*Q3_1 - Q1_1*Q3_2, Q1_1*Q2_2 - Q1_2*Q2_1]

% det(Q-k) = (k'*cross(Q(:,3),Q(:,2)) + k'*cross(Q(:,1),Q(:,3)) + k'*cross(Q(:,2),Q(:,1)) + det(Q))
%Pi0  = [cross(Q(2,:),Q(3,:));cross(Q(3,:),Q(1,:));cross(Q(1,:),Q(2,:))]';
dQ3 = Q12.*Q21 - Q11.*Q22 + Q11.*Q23 - Q13.*Q21 - Q12.*Q23 + Q13.*Q22;
dQ2 = Q11.*Q32 - Q12.*Q31 - Q11.*Q33 + Q13.*Q31 + Q12.*Q33 - Q13.*Q32;
dQ1 = - Q21.*Q32 + Q22.*Q31 + Q21.*Q33 - Q23.*Q31 - Q22.*Q33 + Q23.*Q32;
detQ = Q11.*Q22.*Q33 - Q11.*Q23.*Q32 - Q12.*Q21.*Q33 + Q12.*Q23.*Q31 + Q13.*Q21.*Q32 - Q13.*Q22.*Q31;
detQet= detQ + sum([dQ1,dQ2,dQ3].*[e1,e2,e3],2);
Qir = Pr./detQet; % 逆行列 = [r1 r2 r3]
% 検証
Qec1 = Qc1 - p';
Qec2 = Qc2 - p';
Qec3 = Qc3 - p';
Ans=[sum(Qec1.*Qir(:,1:3),2),sum(Qec1.*Qir(:,4:6),2),sum(Qec1.*Qir(:,7:9),2),...
sum(Qec2.*Qir(:,1:3),2),sum(Qec2.*Qir(:,4:6),2),sum(Qec2.*Qir(:,7:9),2),...
sum(Qec3.*Qir(:,1:3),2),sum(Qec3.*Qir(:,4:6),2),sum(Qec3.*Qir(:,7:9),2)];
Ans(1,:)

%% cell array形式：0.22s
tic
Face = arrayfun(@(i) cn(ids(:,i),:),1:size(ids,2),'UniformOutput',false);
%Ps = [TR.Points(Face(:,1),:),TR.Points(Face(:,2),:),TR.Points(Face(:,3),:)];
Ps = cellfun(@(Face) [TR.Points(Face(:,1),:)-p',TR.Points(Face(:,2),:)-p',TR.Points(Face(:,3),:)-p'],Face,'UniformOutput',false);
%[a,b]=e2plcrosspoint(e,[F(ids(1),:)',Ps(1,1:3)',Ps(1,4:6)',Ps(1,7:9)'])
%[d,~,W]=e2PLparamcrosspoint(e,Pi)
%plot3(d*e(1),d*e(2),d*e(3),"ro")
Pi = cellfun(@(Ps) cell2mat(arrayfun(@(i)inv([Ps(i,1:3);Ps(i,4:6);Ps(i,7:9)]')',1:size(Ps,1),'UniformOutput',false))',Ps,'UniformOutput',false);

d=cell2mat(arrayfun(@(i) e2PLparamcrosspoint(e(:,i),Pi{i}),1:length(Pi),'UniformOutput',false));
po = p + d.*e;
plot3(po(1,:),po(2,:),po(3,:),"ro")
toc
%% for 文形式 : 0.72s
tic
for i = 1:size(e,2)
Face = cn(ids(:,i),:);
Ps = [pn(Face(:,1),:),pn(Face(:,2),:),pn(Face(:,3),:)];
%Pi = cell2mat(arrayfun(@(i)inv([Ps(i,1:3);Ps(i,4:6);Ps(i,7:9)]')',1:size(Ps,1),'UniformOutput',false))';
d=e2PLparamcrosspoint(e(:,i),Pi{i});
po = p + d.*e(:,i);
plot3(po(1,:),po(2,:),po(3,:),"ro")
end
toc
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

%% 

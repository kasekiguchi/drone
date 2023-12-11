%% スプライン曲線
close all
clear 
pointN = 3;%点の数
n = 5;%スプライン曲線の次数(寄関数の方がいいよ)
dt = 3;%各点の間の移動時間
ticksDelta = 0.15; %格子の間隔(m)
t = 0:dt:dt*(pointN-1);

%x-y平面を描画
i=1;
f(i)=figure(i);
f(i).WindowState = 'maximized';
grid on
xticks(-1.5:ticksDelta:1.5)
yticks(-1.5:ticksDelta :1.5)
xlim([-1.5 1.5])
ylim([-1.5 1.5])
xline(0);
yline(0);
xlabel('x','Interpreter','latex')
ylabel('y','Interpreter','latex')
daspect([1 1 1]);
% gca()
hold on
posi = zeros(pointN,3);
for j = 1:pointN
    [gx,gy] = ginput(1);
    gx=max(min(gx,1.5),-1.5);
    gy=max(min(gy,1.5),-1.5);
    gxy = [gx,gy];
    %どちらの隣の格子点に判別して最も近い格子点に配置
    qb = ticksDelta*fix(gxy./ticksDelta);%商を求める
    r = gxy - qb;%余りを求める
    posi(j,1:2) = qb + ticksDelta*round(r./ticksDelta);%余りをticksDeltaで割って四捨五入し，ticksDelta倍したものを商に加える

    % posi(j,1:2) = round([gx,gy],1);
    plot(posi(j,1),posi(j,2),'Marker','.','MarkerSize',12);
    str = ['  p',num2str(j),' (',num2str(posi(j,1)),', ',num2str(posi(j,2)),')'];
    text(posi(j,1),posi(j,2),str)
end
i=i+1;

rxy=MY_WAY_POINT_REFERENCE.way_point_ref([t',posi],n,1,0);

f(i)=figure(i);
f(i).WindowState = 'maximized';
tiledlayout("horizontal")
nexttile
plot(rxy.xyz(1,:),rxy.xyz(2,:))
xlabel('x')
ylabel('y')
daspect([1,1,1])
pbaspect( [1,0.78084714548803,0.78084714548803]);
hold on
plot(posi(:,1),posi(:,2),'Marker','o','LineStyle','none')
grid on
nexttile
plot(rxy.xyz(1,:),rxy.xyz(3,:))
xlabel('x')
ylabel('z')
daspect([1,1,1])
pbaspect( [1,0.78084714548803,0.78084714548803]);
hold on
plot(posi(:,1),posi(:,3),'Marker','o','LineStyle','none')
grid on
nexttile
plot(rxy.xyz(2,:),rxy.xyz(3,:))
xlabel('y')
ylabel('z')
daspect([1,1,1])
pbaspect( [1,0.78084714548803,0.78084714548803]);
hold on
plot(posi(:,2),posi(:,3),'Marker','o','LineStyle','none')
grid on
i=i+1;
while 1
    k = input("If you use 'x-z' codinate, input '1' \nIf you use 'y-z' codinate, input '2' \nFill in : ");
    if k==1||k==2
        break
    end
end
f(i)=figure(i);
f(i).WindowState = 'maximized';
grid on
xticks(-1.5:ticksDelta:1.5)
yticks(-0.1:ticksDelta:2)
xlim([-1.5 1.5])
ylim([-0.1 2])
xline(0);
yline(0);
if k==1
    xlabel('x','Interpreter','latex')
else
    xlabel('y','Interpreter','latex')
end
ylabel('z','Interpreter','latex')
daspect([1 1 1]);
hold on
plot(posi(:,k),zeros(pointN,k),'Marker','.','MarkerSize',12,'LineStyle','none');
str = "  px" + num2str((1:pointN)') + " (" + num2str(posi(:,k)) + ")";
text(posi(:,k),zeros(pointN,1),str)
for j = 1:pointN
    [~,gz] = ginput(1);
    gz=max(min(gz,2),0);
    %どちらの隣の格子点に判別して最も近い格子点に配置
    qb = ticksDelta*fix(gz./ticksDelta);%商を求める
    r = gz - qb;%余りを求める
    posi(j,3) = qb + ticksDelta*round(r./ticksDelta);%余りをticksDeltaで割って四捨五入し，ticksDelta倍したものを商に加える

    plot(posi(j,k),posi(j,3),'Marker','.','MarkerSize',12);
    str = ['  p',num2str(j),' (',num2str(posi(j,k)),', ',num2str(posi(j,3)),')'];
    text(posi(j,k),posi(j,3),str)
end
fprintf("If you confirmed points, push the Enter key.");
input("");
ref=MY_WAY_POINT_REFERENCE.way_point_ref([t',posi],n,1);

% f(i)=figure(i);
% plot3(rz.xyz(1,:),rz.xyz(2,:),rz.xyz(3,:));
% hold on
% plot3(posi(:,1),posi(:,2),posi(:,3),"LineStyle","none","Marker","o")
% grid on
% hold off
% i=i+1;
% 
% f(i)=figure(i);
% plot([0,rz.t],rz.xyz)
% grid on
% i=i+1;

%% リー微分
clear;close all
syms x1(t) x2(t) 
syms xx1 xx2 real
X = [xx1 xx2]';
A = [0 1;-2 -1];
dX = A*X;

eq1=diff(x1,t) ==x2;
eq2=diff(x2,t) ==-2*x1-x2;
cond =[x1(0)==1,x2(0)==1];
SX = dsolve([eq1,eq2],cond);

f = symfun(dX,X);
h = symfun(-xx1 + 5*xx2^2 ,X);
dh =symfun(jacobian(h,X)*ones(2,1),X);
Lfh =symfun(jacobian(h,X)*dX,X);
[rx1,rx2] = meshgrid(-1.5:0.1:1.5,-1.5:0.1:1.5);
SXx = subs(SX.x1,t,0:0.1:10);
SXy = subs(SX.x2,t,0:0.1:10);

fh = h(rx1,rx2);
fhsx = h(SXx,SXy);
fdh = dh(rx1,rx2);
fdx =  f(rx1,rx2);
fLfh = Lfh(rx1,rx2);
dx1=double(fdx{1});
dx2=double(fdx{2});
quiver(rx1,rx2,dx1,dx2,"b","LineWidth",1.5)
hold on
surf(rx1,rx2,double(fh),'FaceColor',"g", 'FaceAlpha',0.1)
surf(rx1,rx2,double(fLfh),'FaceColor',"r",'FaceAlpha',0.2)
plot3(SXx,SXy,fhsx,"LineWidth",2,"color","m")
legend("ベクトル場","h","Lfh")
%%
syms t positive
syms x(t) [4 1] 
syms k [1 4] real
syms alp real
anum = 4; %最大の変数の個数
% alpha = zeros(anum + 1, 1);
alpha(anum,:) = 0.8; %alphaの初期値
alpha(anum + 1,:) = 1;
for a = anum-1 :-1:1
    alpha(a,:) = (alpha(a + 2,:) .* alpha(a + 1,:)) ./ (2 .* alpha(a + 2,:) - alpha(a + 1,:));
end

% k = [3,1];
A = [0,1;0,0];
B = [0;1];
% u = -k*x(t);
u = -k'.*x(t).^alpha(1:4,1);
double(subs(u,[x(t),k'],[ones(4,1),[1,2,3,4]']))
% dequ = diff(x) == A*x(t) + B*u;
% S = dsolve(dequ);
% S = simplify([S.x1;S.x2]);
% S = double([S.x1;S.x2]);
%% 角加速度外乱
syms t real
% syms g a

g = 9.81;
a = 1.5;
w = 1.5;

th = a*t^2/2;
d2x = g*tan(th)
d3x = simplify(diff(d2x,t))
d4x = simplify(diff(d3x,t))
d2z = -(g - g*cos(th))

i=1;
figure(i)
fplot(d2x,[-1,1])
hold on
fplot(d3x,[-1,1])
fplot(d4x,[-1,1])
% fplot(d2z,[-1,1])
hold off
legend("d2x","d3x","d4x","d2z")
i=i+1;

d2x = g*sin(th)
d3x = simplify(diff(d2x,t))
d4x = simplify(diff(d3x,t))
% d2z = -(g - g*cos(th))

figure(i)
fplot(d2x,[-1,1])
hold on
fplot(d3x,[-1,1])
fplot(d4x,[-1,1])
% fplot(d2z,[-1,1])
hold off
legend("d2x","d3x","d4x","d2z")
i=i+1;

th = w*t;
d2x = g*sin(th)
d3x = simplify(diff(d2x,t))
d4x = simplify(diff(d3x,t))
d2z = -(g - g*cos(th))

figure(i)
fplot(d2x,[-1,1])
hold on
fplot(d3x,[-1,1])
fplot(d4x,[-1,1])
% fplot(d2z,[-1,1])
hold off
legend("d2x","d3x","d4x","d2z")
i=i+1;
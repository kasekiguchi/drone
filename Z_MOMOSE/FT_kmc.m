%% kmc
t=20;
dt=0.01;
time=(0:dt:t);

x1 = zeros(1,length(time));
x2 = zeros(1,length(time));
sigma = zeros(1,length(time));
u = zeros(1,length(time));
v = zeros(1,length(time));
%初期値
x1(1)=2;
x2(1)=0;
x1f(1)=x1(1);
x2f(1)=x2(1);
% X0=[-0.5;-6];
%ゲイン
anum = 2; %変数の数
alpha = zeros(anum + 1, 1);
alpha(anum + 1) = 1;
alp=0.75;
alpha(anum) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a) = (alpha(a + 2) * alpha(a + 1)) / (2 * alpha(a + 2) - alpha(a + 1));
end

%状態方程式
%ma=-kx-cv-f
c=0.2;m=16;k=1;
A=[0 1;-c/m -k/m];
B=[0;1/m];
A2 = [0 1 0;0 1 0;0 0 0];
B2 =[0;0;1];
a1 =-c/m;
a2 = -k/m;
b1 = 1/m;
[K,~,~] = lqr(A,[0;1],diag([10,1]),0.1);

T1=abs(x1f(1))^(1-alpha(1))/((1-alpha(1))*K(1))
T2=abs(x2f(1))^(1-alpha(2))/((1-alpha(2))*K(2))
T = T1+T2
%% 外乱 最終的に位置の項の入力で釣り合わないといけない,位置のゲインとの関係を調査する必要がある
dist=9;%外乱の大きさ
disf=8/dt;%開始時間
dise=12/dt;%終了時間
%%
[K,~,~] = lqr(A,B,diag([10,1]),0.1);
for i=1:length(time)
%     rng("shuffle");
    dist = 10*randn(1);
    x = [x1(i);x2(i)];
    xf = [x1f(i);x2f(i)];
    v(i) = -K*x;
    vf(i) = -K(1)*sign(xf(1))*abs(xf(1))^alpha(1) -K(2)*sign(xf(2))*abs(xf(2))^alpha(2);
    u(i) = (v(i) - (a1*x(1) +a2*x(2)))/b1;
    uf(i) = (vf(i) - (a1*x(1) +a2*x(2)))/b1;
%     disf=2/dt;
%     dise=3/dt;
     if disf<i&&i<dise
        [T,X]=ode45(@(t,x) A*x+B*u(i)+[0;dist],[0 dt],x);
        [Tf,Xf]=ode45(@(t,x) A*x+B*uf(i)+[0;dist],[0 dt],xf);
            
    else
         [T,X]=ode45(@(t,x) A*x+B*u(i),[0 dt],x);
         [Tf,Xf]=ode45(@(t,x) A*x+B*uf(i),[0 dt],xf);
      
     end
     if i<length(time)
                x1(i+1)=X(end,1);
                x2(i+1)=X(end,2);
                x1f(i+1)=Xf(end,1);
                x2f(i+1)=Xf(end,2);
     end
end
j=1;
figure(j)
hold on
grid on
plot(time,[x1;x2]);
title('LS')
hold off
j=j+1;

% figure(j)
% hold on
% grid on
% plot(x1,x2);
% title('LS')
% hold off
% j=j+1;
% 
figure(j)
hold on
grid on
plot(time,v);
title('LSv')
hold off
j=j+1;
% 
% figure(j)
% grid on
% hold on
% plot(time,u);
% title('LSu')
% hold off
% j=j+1;

figure(j)
hold on
grid on
plot(time,[x1f;x2f]);
title('FT')
hold off
j=j+1;

% figure(j)
% grid on
% hold on
% plot(x1f,x2f);
% title('FT')
% hold off
% j=j+1;
% 
figure(j)
grid on
hold on
plot(time,vf);
title('FTv')
hold off
j=j+1;

% figure(j)
% grid on
% hold on
% plot(time,uf);
% title('FTu')
% hold off
% j=j+1;

figure(j)
hold on
grid on
plot(time,[x1;x1f]);
title('LSvsFT')
legend('LS','FT');
hold off
j=j+1;
%% 2状態 FT
t=40;
dt=0.01;
time=(0:dt:t);

x1 = zeros(1,length(time));
x2 = zeros(1,length(time));
v = zeros(1,length(time));
%初期値
x1(1)= 2;
x2(1)= 0;
xl1(1)= x1(1);
xl2(1)= x2(1);
% X0=[-0.5;-6];
%ゲイン
anum = 4; %変数の数
alpha = zeros(anum + 1, 1);
alpha(anum + 1) = 1;
alp=0.8;%論文と同じ0.75
alpha(anum) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a) = (alpha(a + 2) * alpha(a + 1)) / (2 * alpha(a + 2) - alpha(a + 1));
end

%状態方程式
A2 = [0 1 ;0 0];
B2 =[0;1];
[K,~,~] = lqr(A2,B2,diag([100,1]),0.1);
dist=0;%外乱の大きさ
disf=0/dt;%開始時間
dise=80/dt;%終了時間
for i=1:length(time)
%     dist = 10*randn(1);
    dist1=0;
    dist2=1;
    x = [x1(i);x2(i)];
    xl = [xl1(i);xl2(i)];
    v(i) = -K(1)*sign(x(1))*abs(x(1))^alpha(1) -K(2)*sign(x(2))*abs(x(2))^alpha(2);
    vl(i) = -K*xl;

     if disf<i&&i<dise
        [T,X]=ode45(@(t,x) A2*x+B2*v(i)+[dist1;dist2],[0 dt],x);
        [Tl,Xl]=ode45(@(t,x) A2*x+B2*vl(i)+[dist1;dist2],[0 dt],xl);
            
    else
         [T,X]=ode45(@(t,x) A2*x+B2*v(i),[0 dt],x);
         [Tl,Xl]=ode45(@(t,x) A2*x+B2*vl(i),[0 dt],xl);
      
     end
     if i<length(time)
                x1(i+1)=X(end,1);
                x2(i+1)=X(end,2);
                xl1(i+1)=Xl(end,1);
                xl2(i+1)=Xl(end,2);
     end
end
j=1;

figure(j)
hold on
grid on
plot(time,[xl1;xl2]);
title('LS');
legend('x1','x2')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,vl);
title('LSinput');
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,[x1;x2]);
title('FT');
legend('x1','x2')
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,v);
title('FTinput');
hold off
j=j+1;

figure(j)
hold on
grid on
plot(time,[xl1;x1]);
title('LSvsFT')
legend('LSx1','FTx1');
hold off
j=j+1;
%% 3状態
t=20;
dt=0.01;
time=(0:dt:t);

x1 = zeros(1,length(time));
x2 = zeros(1,length(time));
x3 = zeros(1,length(time));
sigma = zeros(1,length(time));
v = zeros(1,length(time));
%初期値
x1(1)= 1;
x2(1)= 0;
x3(1)= 0;
% X0=[-0.5;-6];
%ゲイン
anum = 3; %変数の数
alpha = zeros(anum + 1, 1);
alpha(anum + 1) = 1;
alp=0.75;%論文と同じ0.75
alpha(anum) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a) = (alpha(a + 2) * alpha(a + 1)) / (2 * alpha(a + 2) - alpha(a + 1));
end

%状態方程式
%ma=-kx-cv-f
A2 = [0 1 0;0 0 1;0 0 0];
B2 =[0;0;1];
[K,~,~] = lqr(A2,B2,diag([100,1,1]),0.1);
% K = [1.5,1.5,5];%論文と同じ
for i=1:length(time)
    x = [x1(i);x2(i);x3(i)];
    v(i) = -K(1)*sign(x(1))*abs(x(1))^alpha(1) -K(2)*sign(x(2))*abs(x(2))^alpha(2)- K(3)*sign(x(3))*abs(x(3))^alpha(3);
%     v(i) = -K*x;

     if disf<i&&i<dise
        [T,X]=ode45(@(t,x) A2*x+B2*v(i)+[0;0;dist],[0 dt],x);
            
    else
         [T,X]=ode45(@(t,x) A2*x+B2*v(i),[0 dt],x);
      
     end
     if i<length(time)
                x1(i+1)=X(end,1);
                x2(i+1)=X(end,2);
                x3(i+1)=X(end,3);
     end
end
j=1;
figure(j)
grid on
plot(time,[x1;x2;x3]);
j=j+1;

figure(j)
grid on
plot(x1,x2);
j=j+1;

figure(j)
grid on
plot(time,v);
j=j+1;
%% 4状態 FT
t=30;
dt=0.025;
time=(0:dt:t);
ZrLn=zeros(1,length(time));
ref = ZrLn;
x1 = ZrLn;
x2 = ZrLn;
x3 = ZrLn;
x4 = ZrLn;
xl1 = ZrLn;
xl2 = ZrLn;
xl3 = ZrLn;
xl4 = ZrLn;
xs1 = ZrLn;
xs2 = ZrLn;
xs3 = ZrLn;
xs4 = ZrLn;
v = ZrLn;
vl = ZrLn;
vs = ZrLn;
vss = ZrLn;
sigma = ZrLn;

%初期値
x1(1)= 1;
x2(1)= 0;
x3(1)= 0;
x4(1)= 0;
xl1(1)= x1(1);
xl2(1)= x2(1);
xl3(1)= x3(1);
xl4(1)= x4(1);
xs1(1)= x1(1);
xs2(1)= x2(1);
xs3(1)= x3(1);
xs4(1)= x4(1);
% X0=[-0.5;-6];
%ゲイン
anum = 4; %変数の数
alpha = zeros(anum + 1, 1);
alpha(anum + 1) = 1;
alp=0.8;%論文と同じ0.75
alpha(anum) = alp; %alphaの初期値
for a = anum - 1:-1:1
    alpha(a) = (alpha(a + 2) * alpha(a + 1)) / (2 * alpha(a + 2) - alpha(a + 1));
end

%状態方程式
A2 = [0 1 0 0;0 0 1 0;0 0 0 1;0 0 0 0];
B2 =[0;0;0;1];
[K,~,~] = lqr(A2,B2,diag([100,10,10, 1]),0.01);
Kf = K;
% Kf = place(A2,B2,[-4.5,-4,-3,-2.5]);
dist=0;%外乱の大きさ
disf=10/dt;%開始時間
dise=11/dt;%終了時間

%smc
    Ks = lqr(A2(1:3,1:3),A2(1:3,4),diag([100,1,1]),0.01);
    %diag([100,1,1]),1)1m/s^2定常到達でたまたま良くなったゲイン
    %diag([100,1,1]),0.01)1m/s^2比例到達では入力を小さくした方が抑えられることが分かった．
    S=[Ks 1];
    SA=S*A2;
    invSB=inv(S*B2);
    q=10; k= 10; ka = 20 ; alps = 0.7;
    %qを下げてもチャタリングする．平滑化でqを下げたときと同じくらい外乱を抑えられてチャタリングを阻止できる

a = 10;%乱数の大きさの範囲 |rand|<=a
a2 = 2*a;
for i=1:length(time)
    dist1= 0;%a2*rand - a;
    dist2= 0;%a2*rand - a;
    dist3= 0;%a2*rand - a;
    dist4= 10;%a2*rand - a;
    
    x = [x1(i);x2(i);x3(i);x4(i)];
    xl = [xl1(i);xl2(i);xl3(i);xl4(i)];
    xs = [xs1(i);xs2(i);xs3(i);xs4(i)];
    v(i) = -Kf*(sign(x).*abs(x).^alpha(1:4));
    vl(i) = -K*xl;
    sigma(i) = S*xs;
%     vs(i) = -invSB*(SA*xs+q*sign(sigma(i)));
%     vs(i) = -invSB*(SA*xs+q*sign(sigma(i))+k*sigma(i));
    vs(i) = -invSB*(SA*xs+q*tanh(5*sigma(i))+k*sigma(i));
%     vs(i) = -invSB*(SA*xs+ka*sign(sigma(i))*abs(sigma(i))^alps);
vss(i) = -Ks*xs(1:3);
     if disf<i&&i<dise
        [T,X]=ode45(@(t,x) A2*x+B2*v(i)+[dist1;dist2;dist3;dist4],[0 dt],x);
        [Tl,Xl]=ode45(@(t,x) A2*x+B2*vl(i)+[dist1;dist2;dist3;dist4],[0 dt],xl);
        [Ts,Xs]=ode45(@(t,x) A2*x+B2*vs(i)+[dist1;dist2;dist3;dist4],[0 dt],xs);
            
    else
         [T,X]=ode45(@(t,x) A2*x+B2*v(i),[0 dt],x);
         [Tl,Xl]=ode45(@(t,x) A2*x+B2*vl(i),[0 dt],xl);
         [Ts,Xs]=ode45(@(t,x) A2*x+B2*vs(i),[0 dt],xs);
      
     end
     if i<length(time)
                x1(i+1)=X(end,1);
                x2(i+1)=X(end,2);
                x3(i+1)=X(end,3);
                x4(i+1)=X(end,4);
                xl1(i+1)=Xl(end,1);
                xl2(i+1)=Xl(end,2);
                xl3(i+1)=Xl(end,3);
                xl4(i+1)=Xl(end,4);
                xs1(i+1)=Xs(end,1);
                xs2(i+1)=Xs(end,2);
                xs3(i+1)=Xs(end,3);
                xs4(i+1)=Xs(end,4);
     end
end

s = 5;
index = find(time <=5,1,"last");
RMSE_LS = rmse(ref(1, index : end),xl1(1, index : end))
RMSE_FT = rmse(ref(1, index : end),x1(1, index : end))
RMSE_SMC = rmse(ref(1, index : end),xs1(1, index : end))

fosi=18;%デフォルト9，フォントサイズ変更
LW = 1;%linewidth
j=1;

% figure(j)
% hold on
% grid on
% plot(time,[xl1;xl2;xl3;xl4],'LineWidth',LW);
% title('LS');
% set(gca,'FontSize',fosi)
% xlabel('time[s]')
% ylabel('state')
% legend('x1','x2','x3','x4')
% hold off
% j=j+1;
% 
% figure(j)
% hold on
% grid on
%  set(gca,'FontSize',fosi)
% plot(time,vl,'LineWidth',LW);
% title('LSinput');
% xlabel('time[s]')
% ylabel('state')
% hold off
% j=j+1;
% 
% figure(j)
% hold on
% grid on
%  set(gca,'FontSize',fosi)
% plot(time,[x1;x2;x3;x4],'LineWidth',LW);
% title('FT');
% xlabel('time[s]')
% ylabel('state')
% legend('x1','x2','x3','x4')
% hold off
% j=j+1;
% 
% figure(j)
% hold on
% grid on
%  set(gca,'FontSize',fosi)
% plot(time,v,'LineWidth',LW);
% title('FTinput');
% xlabel('time[s]')
% ylabel('state')
% hold off
% j=j+1;
% 
% figure(j)
% hold on
% grid on
%  set(gca,'FontSize',fosi)
% plot(time,vl,'LineWidth',LW);
% plot(time,v,'LineWidth',LW);
% title('LSFTinput');
% xlabel('time[s]')
% ylabel('input')
% legend('Linear state FB','Finite time settling');
% hold off
% j=j+1;

figure(j)
hold on
grid on
set(gca,'FontSize',fosi)
plot(time,[xl1;x1;xs1],'LineWidth',LW);
% title('LSvsFT')
xlabel('time[s]')
ylabel('x_1')
legend('Linear state FB','Finite time settling','Sliding mode');
hold off
j=j+1;

figure(j)
hold on
grid on
 set(gca,'FontSize',fosi)
plot(time,[xs1;xs2;xs3;xs4],'LineWidth',LW);
title('smc');
xlabel('time[s]')
ylabel('state')
legend('xs1','xs2','xs3','xs4')
hold off
j=j+1;

figure(j)
hold on
grid on
 set(gca,'FontSize',fosi)
plot(time,sigma,'LineWidth',LW);
title('smc');
xlabel('time[s]')
ylabel('\sigma')
% legend('xs1','xs2','xs3','xs4')
hold off
j=j+1;

figure(j)
hold on
grid on
 set(gca,'FontSize',fosi)
plot(time,vs,'LineWidth',LW);
title('smc');
xlabel('time[s]')
ylabel('input')
% legend('xs1','xs2','xs3','xs4')
hold off
j=j+1;

figure(j)
hold on
grid on
 set(gca,'FontSize',fosi)
plot(time,vss,'LineWidth',LW);
title('smc');
xlabel('time[s]')
ylabel('inputss')
% legend('xs1','xs2','xs3','xs4')
hold off
j=j+1;

function RMSE = rmse(ref,est)
        RMSE_x=sqrt(immse(ref,est));
        RMSE = ["RMSE_x" ;
                        RMSE_x];
    end
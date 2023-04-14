%tanhと線形で近似tanhをいくつか組み合わせてもいいかも
%最小のalpに対して入力の変化が耐えられるようにするこれができれば初期値のalpの値を小さくできるかも
%ddxとdddxの項は近似しなくてもいいかも
%最適化でパラメータ調整するといいかも．そうすればtanhをいくつか組み合わせる方法でもパラメータ調整簡単そう
h = get(gca,'Children'); % 軸オブジェクトの子オブジェクトを取得(複数の場合はベクトル)
% 青色ラインのハンドルを一番上に設定
for i=1:3
    nh1(i)=h(i);
end
for i=4:10
    nh2(i-3)=h(i);
end
newh = [nh2,nh1]'; % h(ind)：青色ラインのハンドル、h(~ind)：それ以外のハンドル
set(gca,'children',newh) % Childrenプロパティ値の再設定(順番の入れ替え)
%% sign,absoluteを近似
clear
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.85;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Ac2 = diag([1],1);
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
k=lqrd(Ac2,Bc2,diag([1000,1]),[0.1],dt); % xdiag([100,10,10,1])
% k=5;

x0=[50,0.01];
rng=0.01;
i=2;
fun=@(x)(integral(@(w) abs( -k(i).*abs(w).^alp(i) + k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), rng,rng+1) +integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0,rng));
% fun=@(x)(integral(@(w) abs( k(i).*abs(w).^alp(i) - k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0.1,1));
% fun=@(x)(integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0,0.5));
% fun=@(x)1 - x(1).*x(2).^(alp(i)./2);
c =@(x)0;% [k(i).*sign(rng).*abs(rng).^alp(i) - k(i).*tanh(x(1).*rng).*sqrt(rng.^2 + x(2)).^alp(i);1 - x(1).*x(2).^(alp(i)./2)];
% ceq = @(x) [1 - x(1).*x(2).^(alp(i)./2)+ 0;
%                     -k(i).*abs(rng).^alp(i) + k(i).*tanh(x(1).*rng).*sqrt(rng.^2 + x(2)).^alp(i) + 1];
% ceq = @(x) -k(i).*abs(rng).^alp(i) + k(i).*tanh(x(1).*rng).*sqrt(rng.^2 + x(2)).^alp(i) + 0.1;
ceq = @(x) 1 - x(1).*x(2).^(alp(i)./2)+ 1;
%alhpa=0.8 rang=0.05:[4.5,2.5]/rang=0.01:[6,4.8]
%alpha=0.85rng=0.01[5,3]
nonlinfcn = @(x)deal(c(x),ceq(x));

options = optimoptions("fmincon",...
    "Algorithm","interior-point",...
    "EnableFeasibilityMode",true,...
    "SubproblemAlgorithm","cg");
% [p,fval] = fmincon(fun,x0,[],[],[],[],[0,1E-4*0],[inf,1]) 
[p,fval] = fmincon(fun,x0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 
% [p,fval] = fminsearch(fun,x0) 

2*fval
1 - p(1).*p(2).^(alp(i)./2)

syms w
du = diff(k(i).*tanh(p(1).*w).*sqrt(w.^2 + p(2)).^alp(i),w,1);

e = -1:0.01:1;
% p=[20,1E-3];
usgn = -k(i).*tanh(p(1)*e).*abs(e).^alp(i);
usgnabs = -k(i).*tanh(p(1).*e).*sqrt(e.^2 + p(2)).^alp(i);
du = subs(du,w,e);
u = -k(i).*sign(e).*abs(e).^alp(i);
uk= -k(i).*e;

% plot(e,usgn);
hold on
grid on
plot(e,usgnabs, 'LineWidth', 2.5);
% plot(e,du);
plot(e,u, 'LineWidth', 2.5);
plot(e,uk, 'LineWidth', 2.5);
% legend("app","app2","du","ft","ls");
legend("Approximation","Finite time settling","Linear state FB");
fosi=20;%defolt 9
set(gca,'FontSize',fosi)
xlabel('x','FontSize',fosi);
ylabel('input','FontSize',fosi);
hold off

%%
syms k1 k w p1 p2 a 
% f=k*w - k*tanh(p1*w)*sqrt(w^2 + p2)^a==0;
% f=w - sign(p1*w)*sqrt(w^2 + p2)==0;%*sqrt(w^2 + p2)==0;
% ans_f=solve(f,w)
k=1;
f=k*w -k*tanh(18*w)*sqrt(w^2 + 0.001)^0.8;
% f=k1*w - k*tanh(p1*w)*sqrt(w^2 + p2)^a;
df =diff(f,w);
dfs=subs(df,w,0);
f=-k*abs(w) +k*tanh(18*abs(w))*sqrt(w^2 + 0.001)^0.8;
fplot(f,[-1.5,1.5],'LineWidth', 2.5)
hold on
fplot(df,[-1.5,1.5],'LineWidth', 2.5)
% fplot(0,[-1.1,1])
% fplot( -k*tanh(10*w)*sqrt(w^2 + 0.0001)^0.8,[-1.1,1])
% fplot( -k*sign(w)*abs(w)^0.8,[-1.1,1])
% fplot( -k*w,[-1.1,1])
legend("$h_i(x_i)$","$\dot{h_i}(x_i)$",'Interpreter','latex');
fosi=20;%defolt 9
set(gca,'FontSize',fosi)
xlabel("$h_i(x_i)$",'FontSize',fosi,'Interpreter','latex');
ylabel("${h_i}(x_i)$or$\dot{h_i}(x_i)$",'FontSize',fosi,'Interpreter','latex');
grid on
hold off
%%
e=-1:0.001:1;
plot(e,sqrt(e.^2 + 5e-3));
hold on
plot(e,abs(e));
% legend("app","ft","ls");
hold off
%% fminserch tanh一つ
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.8;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
dt=0.025;
k=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
%k(3:4)=[80 40];
kft=k;
kft(1)=1*kft(1);
kgain=1;
% x0=[2,2];
x0=[2,2,2];
fvals12=zeros(4,1);
gain_ser1=["","f1","a1","k"];
% gain_ser1=["","f1","a1","k1"];
er=[0 0.9]; %近似する範囲を指定
ee=er;
for i=1:4
%     if i~=5
%             er=[0.1 0.3];
%     else
%             er=ee;
%     end
fun=@(x)(integral(@(e) abs( -kft(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + kgain*k(i)*e ) ,er(1), er(2)));
% fun=@(x)(integral(@(e) abs( -kft(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*e ) ,er(1), er(2)));

[x,fval] = fminsearch(fun,x0) ;
fvals12(i) = 2*fval
gain_ser1(i+1,:)=[titlex(i),x];

e= -1:0.001:1;      
% e= -5:0.001:5;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e) - kgain*k(i)*e;%%
% utanh(i,:)= - x(1)*tanh(x(2)*e) -x(3)*e;%%
u(i,:)=-kft(i)*sign(e).*abs(e).^alp(i);
sigma(i,:)=utanh(i,:)-u(i,:);
fig=figure(i);
plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:),'LineWidth',2);
% plot(e,ufb(i,:),e,u(i,:),'LineWidth',2);

grid on
legend('FB','FT','誤差')
% legend('FB','近似','FT','誤差')
% title(titlex(i));

fosi=14;%defolt 9
set(gca,'FontSize',fosi)
xlabel('error','FontSize',fosi);
ylabel('input','FontSize',fosi);

end
%% fminserch tanh二つ
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.9;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
dt=0.025;
k=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
k2=1*k;
% x0=[5,5,5,5];
x0=[7,10,2,100];
fvals22=zeros(4,1);
gain_ser2=["","f1","a1","f2","a2"];
er=[0.1 0.4];
for i=1:4
% fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*tanh(x(4)*e) + k(i)*e ) ,0, er));
fun=@(x)(integral(@(e) abs( -k2(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*tanh(x(4)*e) + k(i)*e ) ,er(1), er(2)));
options = optimset('MaxFunEvals',1e5);%普通は200*(number of variables) (既定値) 
% options = optimset('PlotFcns','optimplotfval','TolX',1e-4);
% options = optimset('PlotFcns','optimplotfval');
[x,fval] = fminsearch(fun,x0,options) ;
% [x,fval] = fminsearch(fun,x0) ;
fvals22(i) = 2*fval
gain_ser2(i+1,:)=[titlex(i),x];

% e= -0.1:0.001:0.1;      
e= -4:0.001:2;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e)- x(3)*tanh(x(4)*e) - k(i)*e;
u(i,:)=-k2(i)*sign(e).*abs(e).^alp(i);
sigma(i,:)=utanh(i,:)-u(i,:);
uufb(i,:)=u(i,:)+ufb(i,:);

figure(i)
plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:),'LineWidth',2)
% plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:),e,uufb(i,:),'LineWidth',2);
% plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,uufb(i,:),'LineWidth',2);%誤差なし
grid on
legend('ufb','utanh','u','誤差')
% legend('ufb','utanh','u','FT+FB')%誤差なし

fosi=14;%defolt 9
set(gca,'FontSize',fosi)
xlabel('error','FontSize',fosi);
ylabel('input','FontSize',fosi);
end
%% fmincon tanh一つ
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.9;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
dt=0.025;
k=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])

% k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン

x0=[5,5];
fvalc12=zeros(4,1);
gain_con1=["","f1","a1"];
er=0.1; %近似する範囲を指定
for i=1:4
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + k(i)*e ) ,0, er));
[x,fval] = fmincon(fun,x0) ;
fvalc12(i) = 2*fval
gain_con1(i+1,:)=[titlex(i),x];

% e= -0.5:0.001:0.5;      
e= -1:0.001:1;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e) - k(i)*e;
u(i,:)=-k(i)*sign(e).*abs(e).^alp(i);
sigma(i,:)=utanh(i,:)-u(i,:);
figure(i)
plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:))
grid on
legend('ufb','utanh','u','誤差')
title(titlex(i));
end
%% tanh一つの場合のfunの関数を描いて初期値を確認
clear aa
j=1;
l=1;
i=1;
dt=0.5;
span=0:dt:22;
[xa,ya]=meshgrid(span);
er=0.3;
for s=span
    l=1;
    for v=span
        fun=@(x1,x2)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x1.*tanh(x2.*e) + k(i)*e ) ,0, er));
        aa(j,l)=fun(s,v);
        l=l+1;
    end
    j=j+1;
end
% n=0:15;
% xx=[n;n];
% [aa]=fun(n);
figure(5)
mesh(xa,ya,aa);
[min1,minI]=min(aa);
[~,minI2]=min(min1);
MIN=[(minI(minI2)-1)*dt,(minI2-1)*dt]

% plot(ss,aa)
%% fmincon tanh二つ
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.9;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
dt=0.025;
k=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])

x0=[7,10,2,100];
% x0=[10,10,10,10];
fvalc22=zeros(4,1);
gain_con2=["","f1","a1","f2","a2"];
er=0.1;
for i=1:4
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*tanh(x(4)*e) + k(i)*e ) ,0, er));
options = optimoptions(@fmincon,'OptimalityTolerance',1.0e-9);

[x,fval] = fmincon(fun,x0) ;
fvalc22(i) = 2*fval
gain_con2(i+1,:)=[titlex(i),x];

% e= -0.5:0.001:0.5;      
e= -1:0.001:1;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e)- x(3)*tanh(x(4)*e) - k(i)*e;
u(i,:)=-k(i)*sign(e).*abs(e).^alp(i);
sigma(i,:)=utanh(i,:)-u(i,:);
figure(i)
plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:))
grid on
legend('ufb','utanh','u','誤差')
end
%%
clear e utanh u ufb sigma
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.9;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac2 = [0,1;0,0];
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt); % xdiag([100,10,10,1])

syms fz1(t) fz2(t) 
    u=-k(1) *sign(fz1(t))* abs(fz1(t)).^alp(1) -k(2) *sign(fz2(t))* abs(fz2(t)).^alp(2)
    du=diff(u,t)
    ddu=diff(du,t)
    dddu=diff(ddu,t)

%% fminserch tanh一つ zサブシステムaaaa
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.8;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac2 = [0,1;0,0];
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt); % xdiag([100,10,10,1])
x0=[1,1];
% x0=[2,2];
fvals12z=zeros(2,1);
gain_ser1z=["","f","d"];
% gain_ser1z=["","f1","k1"];
er=0.2; %近似する範囲を指定
for i=1:2
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) +x(1)* e/(abs(e)+x(2)) ) ,0, er));
% fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + tanh(x(1)*e) + x(2)*e ) ,0, er));
[x,fval] = fminsearch(fun,x0) ;
% [x,fval] = fmincon(fun,x0) ;
fvals12z(i) = 2*fval
gain_ser1z(i+1,:)=[titlex(i),x];

% e= -1:0.001:1;      
e= -2:0.001:2;
ufb(i,:)= -k(i)*e;
ua(i,:)= -x(1)* e./(abs(e)+x(2));%%
% utanh(i,:)= - tanh(x(1)*e) - x(2)*e;%%
u(i,:)=-k(i)*sign(e).*abs(e).^alp(i);
% sigma(i,:)=utanh(i,:)-u(i,:);
fig=figure(i);
% plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:),'LineWidth',2);
plot(e,ua(i,:),e,u(i,:),e,ufb(i,:),'LineWidth',2);
% plot(e,ua(i,:),'LineWidth',2);
% plot(e,ufb(i,:),e,u(i,:),'LineWidth',2);
grid on
% legend('近似','FT')
% legend('FB','近似','FT','誤差')
% title(titlex(i));
% legend('Liner state feedback','Finite time settling')
legend('Approximation','Finite time settling','Linear state feedback')
% legend('Approximation','Finite time settling')


fosi=16;%defolt 9
set(gca,'FontSize',fosi)
xlabel('error','FontSize',fosi);
ylabel('input','FontSize',fosi);

end
gain_ser1z
    
%% fminserch tanh一つ zサブシステム
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.8;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac2 = [0,1;0,0];
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt)/20; % xdiag([100,10,10,1])
x0=[2,5,6];
% x0=[2,2];
fvals12z=zeros(2,1);
gain_ser1z=["","f1","a1","k1"];
% gain_ser1z=["","f1","k1"];
er=1; %近似する範囲を指定
for i=1:2
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*e ) ,0, er));
% fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + tanh(x(1)*e) + x(2)*e ) ,0, er));
[x,fval] = fminsearch(fun,x0) ;
% [x,fval] = fmincon(fun,x0) ;
fvals12z(i) = 2*fval
gain_ser1z(i+1,:)=[titlex(i),x];

% e= -1:0.001:1;      
e= -2:0.001:2;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e) - x(3)*e;%%
% utanh(i,:)= - tanh(x(1)*e) - x(2)*e;%%
u(i,:)=-k(i)*sign(e).*abs(e).^alp(i);
% sigma(i,:)=utanh(i,:)-u(i,:);
fig=figure(i);
% plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:),'LineWidth',2);
plot(e,utanh(i,:),e,u(i,:),e,ufb(i,:),'LineWidth',2);
% plot(e,utanh(i,:),e,u(i,:),'LineWidth',2);
% plot(e,ufb(i,:),e,u(i,:),'LineWidth',2);
grid on
% legend('近似','FT')
% legend('FB','近似','FT','誤差')
% title(titlex(i));
legend('Liner state feedback','Finite time settling')
% legend('Approximation','Finite time settling','Linear state feedback')
% legend('Approximation','Finite time settling')


fosi=16;%defolt 9
set(gca,'FontSize',fosi)
xlabel('error','FontSize',fosi);
ylabel('input','FontSize',fosi);

end
gain_ser1z
%% fmincon tanh二つ zサブシステム
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.8;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac2 = [0,1;0,0];
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt); % xdiag([100,10,10,1])

x0=[7,10,2,100];
% x0=[5,5,5,5];
fvalc22=zeros(2,1);
gain_con2=["","f1","a1","f2","a2"];
er=0.9;
for i=1:2
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*tanh(x(4)*e) + k(i)*e ) ,0, er));
options = optimoptions(@fmincon,'OptimalityTolerance',1.0e-9);

[x,fval] = fmincon(fun,x0) ;
fvalc22(i) = 2*fval
gain_con2(i+1,:)=[titlex(i),x];

% e= -0.5:0.001:0.5;      
e= -1:0.001:1;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e)- x(3)*tanh(x(4)*e) - k(i)*e;
u(i,:)=-k(i)*sign(e).*abs(e).^alp(i);
sigma(i,:)=utanh(i,:)-u(i,:);

fig=figure(i);
% plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:))
% grid on
% legend('ufb','utanh','u','誤差')
% 
plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),'LineWidth',2);

grid on
legend('FB','近似','FT','誤差')
% title(titlex(i));

fosi=14;%defolt 9
set(gca,'FontSize',fosi)
xlabel('error','FontSize',fosi);
ylabel('input','FontSize',fosi);

end


%%
% clear e utanh u sigma
% % e= -0.5:0.001:0.5;      
% e= -0.1:0.001:0.1;
% utanh(1,:)=-ff1*tanh(aa1*e)-ff2*tanh(aa2*e)-k(1)*e;
% u(1,:)=-k(1)*sign(e).*abs(e).^alp(1);
% sigma=utanh-u;
% plot(e,utanh,e,u,e,sigma)
% grid on
% legend('utanh','u','誤差')
% s=2*(x(ff1,aa1,ff2,aa2))

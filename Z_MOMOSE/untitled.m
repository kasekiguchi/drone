syms t real
ts=[t^3;t^2;t;1];
x = [1,7,3,5,8,2];
y = [2,4,5,1,4,7];
z = [1,2,5,1,2,1];
tt=[0,3,6,8,9,12];
dtt=[tt,0]-[0,tt];
dtt=dtt(:,1:end-1);
% px=spline(tt,x);
% cpx=csape(tt,x,'periodic');
cpx=csape(tt,[0 x 0],'complete');
cpy=csape(tt,[0 y 0],'complete');
cpz=csape(tt,[0 z 0],'complete');
% xx=px.coefs*ts;
xx=cpx.coefs*ts;
yy=cpy.coefs*ts;
zz=cpz.coefs*ts;
hold on
% figure(1)
xxx=[];
yyy=[];
zzz=[];
for i=1:length(xx)
    xx(i)=subs(xx(i),t,t-tt(i));
    yy(i)=subs(yy(i),t,t-tt(i));
    zz(i)=subs(zz(i),t,t-tt(i));

    dt=tt(i):0.2:tt(i+1);
    xxx=[xxx,subs(xx(i),t,dt)];
    yyy=[yyy,subs(yy(i),t,dt)];
    zzz=[zzz,subs(zz(i),t,dt)];
    fplot(xx(i),[tt(i),tt(i+1)])
    fplot(yy(i),[tt(i),tt(i+1)])
    fplot(zz(i),[tt(i),tt(i+1)])
end
hold off
figure(2)
hold on
% plot(double(xxx),double(yyy))
plot3(double(xxx),double(yyy),double(zzz))
plot3(x,y,z,"LineStyle","none","Marker","o")

%% これを改良diff使わなくてもできるようにする．
syms A [3 4] real
% syms t [5 1] real
% x = [1,7,3,5,8,2]';
% y = [2,4,5,1,4,7];
% z = [1,2,5,1,2,1];
% tt=[0,3,6,8,9,12]';
% dttp=[tt;0]-[0;tt];
% dtt=dttp(2:6);
% 
% % ts=[t.^4 t.^3 t.^2 t,ones(5,1)];
% % p=(a.*ts)';
% ps=sum(p)';

n=3;%多項式次数
time=[0,2,5,12];%way points
dtime=time-[time(1), time(1:end-1)];%隣の点との差 dw_i = w_i - w_i-1 (dw_1 = 0),  i=1,2,3,...
D(:,1)=ones(n+1,1);
for i = 1:n-1
    D(:,i+1)=[zeros(i,1); (1:n-i+1)'].*D(:,i);
end
D=D./factorial(0:n-1);
Ac=ones(size(D)).*D;
Sn=length(time(1:end-1));
for i=1:n+1
    power_dtime(i,:) = dtime(2:end).^(i-1);
end
% power_dw=[[ones(1,lw1);zeros(n,lw1)],power_dw];

polys = [];
polys_add = [];
% for i=1:lw1
%     for j=1:2
%         polys = [polys; A(i,:)*power_dw(:,i+(j-1)*(lw1))==power_dw(2,i+(j-1)*(lw1))];
%     end
    polys = [polys; A(:,1)==zeros(Sn,1)];
    polys = [polys; A.*power_dtime'*ones(n+1,1)==dtime(2:end)'];
% end
for i =2:n
    % for j = 1:2
    %     polys = [polys; A(i,:)*(D(:,i).*power_dw(:,i+j-1))];
    %     polys = [polys; A(i,:)*(D(:,i).*power_dw(:,i+j-1))];
    % end
    % polys =[polys; [A(1,i);A.*(D(:,i).*power_dw)'*ones(n+1,1)]==[0;A(:,i+1)];
    polys =[polys; A(1:end-1,:).*(D(:,i).*power_dtime(:,1:end-1))'*ones(n+1,1)==A(2:end,i+1)];
    if length(polys_add)<n-1
        polys_add = [polys_add; [A(1,i);A(end,:).*(D(:,i).*power_dtime(:,end))'*ones(n+1,1)]==[0;0]];
    end
end
if mod(n,2)==0
    polys_add =polys_add(1:end-1) ;
end
S_A = solve([polys;polys_add],A);
% for i=1:5
%     dp(i,1)=diff(ps(i),t(i));
%     ddp(i,1) =diff(dp(i),t(i));
%     dddp(i,1) =diff(ddp(i),t(i));
% end
dts=(t(2:end)-t(1:end-1));
fp0=subs(ps,t,zeros(5,1))==x(1:5);
fp1=subs(ps,t,dtt)==x(2:6);

dp1=subs(dp(1:end-1),t(1:4),dtt(1:end-1));
dp2=subs(dp(2:end),t(2:end),zeros(4,1));
fdp= dp2-dp1==zeros(4,1);

ddp1=subs(ddp(1:end-1),t(1:4),dtt(1:end-1));
ddp2=subs(ddp(2:end),t(2:end),zeros(4,1));
fddp= ddp2-ddp1==zeros(4,1);

dddp1=subs(dddp(1:end-1),t(1:4),dtt(1:end-1));
dddp2=subs(dddp(2:end),t(2:end),zeros(4,1));
fdddp= dddp2-dddp1==zeros(4,1);

fadd=subs([dp(1);dp(5);dddp(1)],[t(1);t(5);t(1)],[dttp(1);dtt(5);dttp(1)])==zeros(3,1);
%
sparam=solve([fp0;fp1;fdp;fddp;fdddp;fadd],a);
names=fieldnames(sparam);
%
D=zeros(5,5);
h=1;
for i=1:5
    for j= 1:5
        D(j,i)=sparam.(names{h});
        h=h+1;
    end
end
syms ttt
ts=[ttt.^4 ttt.^3 ttt.^2 ttt,1]';
xx=D*ts;
hold on
% figure(1)
xxx=[];
yyy=[];
zzz=[];
for i=1:length(xx)
    xx(i)=subs(xx(i),ttt,ttt-tt(i));
    % yy(i)=subs(yy(i),t,t-tt(i));
    % zz(i)=subs(zz(i),t,t-tt(i));

    % dt=tt(i):0.2:tt(i+1);
    % xxx=[xxx,subs(xx(i),t,dt)];
    % yyy=[yyy,subs(yy(i),t,dt)];
    % zzz=[zzz,subs(zz(i),t,dt)];
    fplot(xx(i),[tt(i),tt(i+1)])
    % fplot(yy(i),[tt(i),tt(i+1)])
    % fplot(zz(i),[tt(i),tt(i+1)])
end
%%
clear
n=3;%多項式次数
time=[0,2,5,12];%way points
dtime=time-[time(1), time(1:end-1)];%隣の点との差 dw_i = w_i - w_i-1 (dw_1 = 0),  i=1,2,3,...
% 
% D(1,:)=[0, ones(1,n)];
% power_dw(1,:)=dw;
% for i = 1:n-1
%     D(i+1,:)=[zeros(1,i+1), 2:n-i+1].*D(i,:);
%     power_dw(i+1,:) = dw.^(i+1);
% end
% D=D./factorial(0:n-1)';
% ez=[eye(n), zeros(n,1) ];
% ez2=-ez(2:end,:);
% for i = 1:length(w)-1
%     temp=D*diag([0;power_dw(:,i+1)]) +ez;
%     P{i}= [1,zeros(1,n); temp];
%     P2{i}=[zeros((n+1-2),n+1);ez2]];
% end
%%
clear
time=[0,2,5,12];%time
point = [0,4,6,2;0,2,-1,4;0,3,5,2];%way points
n=5;%多項式次数
tic
r =way_point_ref(time,point,n);
toc

%% 完成
clear
close
tic
n=5;%多項式次数
point = [0,4,6,2];%way points
time=[0,2,5,12];%time

dtime=(time-[time(1), time(1:end-1)])';%隣の点との差 dw_i = w_i - w_i-1 (dw_1 = 0),  i=1,2,3,...
Sn=length(time(1:end-1)); %求める多項式の数

D(1,:)=ones(1,n+1);
for i = 1:n-1
    D(i+1,:)=[zeros(1,i), 1:n-i+1].*D(i,:);
end
Dori=D;
D=D./factorial(0:n-1)';
Ac=ones(size(D)).*D;
for i=1:n+1
    power_dtime(:,i) = dtime(2:end).^(i-1);
end

%行列でやる
X=zeros((n+1)*Sn);
dx=dtime(2:end);
for i=1:Sn
    dr=(i-1)*2;
    dc=(i-1)*(n+1);
X(1+dr:2+dr,1+dc:(n+1)+dc) = [1,zeros(1,n);power_dtime(i,:)];
end

poweT = zeros(n-1,n+1);
for i = 1:Sn-1
    for j=1:n-1
        poweT(j,j+1:end) = power_dtime(i,1:end-j) ;
    end
    dr2=(i-1)*(n-1);
    dc2=(i-1)*(n+1);
    X(2*Sn+1+dr2 : 2*Sn+n-1+dr2, 1+dc2 : (n+1)+dc2) = D(2 : end,1:end).*poweT;
    X(2*Sn+1+dr2 : 2*Sn+n-1+dr2, n+3+dc2 : 2*n+1 +dc2) = - eye(n-1);
end
add=(n+1)*Sn - (n-1);
for j=1:n-1
        poweT(j,j+1:end) = power_dtime(end,1:end-j) ;
end

for i = 1:n-1
    X(add+1+(i-1)*2,1+i) = 1;
    X(add+2+(i-1)*2,end-n:end) = D(i+1,:).*poweT(i,:) ;
end

size=1:(n+1)*Sn;
Xp =X(size,size);

inXp = inv(Xp);

Y=[];
Y=[Y;point(1)];
y=point(2:end-1);
for i=1:Sn-1
    Y = [Y;ones(2,1)*y(i)];
end
Y = [Y;point(end);zeros((n+1)*Sn-2*Sn,1)];
% tic
% P_old1 = (inXp*Y)';
% toc
tic
P_old = Xp\Y;
toc
P=zeros(Sn,n+1);
for i = 1:Sn
    P(i,:) = P_old(1+(i-1)*(n+1):n+1+(i-1)*(n+1));
end
toc
func_t =@(dt) (dt).^(0:n)';

%確認用シミュレーション
tt=0:0.01:20;
sum_time = sum(dtime);
flag=0;
j=1;
k=1;
for i = 0:0.01:20
    dt = i - time(j);
    if  j<length(dtime)-1 && dt>= dtime(j+1) 
        j=j+1;
        dt = i - time(j);
    end
    if i>= sum_time
        if ~flag
            p_fin=p(k-1);
            v_fin=v(k-1);
            flag=1;
        end
        p(k)= p_fin;
        v(k) =v_fin;
    else
        tn = func_t(dt);
        p(k) = P(j,:)*tn;
        if n~=1
            v(k) = P(j,2:end)*(Dori(2,2:end)'.*tn(1:end-1));
        else
            v(k)=0;
        end
    end
    k=k+1;
end
plot(tt,p);
grid on
hold on
plot(time,point,'o');
plot(tt,v);
%%
%とりあえず関数化する
clear
close all
tic
n=3;%多項式次数
point = [0,4,6,2];%way points
time=[0,2,5,12];%time

% point = [0,1,4,2,2,1,5,6,5,1,0];%way points
% time=[0:2:20];%time

dtime=(time-[time(1), time(1:end-1)])';%隣の点との差 dw_i = w_i - w_i-1 (dw_1 = 0),  i=1,2,3,...
Sn=length(time(1:end-1)); %求める多項式の数
syms('A',[Sn,n+1]) ;%求める多項式の係数の配列を作成

D(1,:)=ones(1,n+1);
for i = 1:n-1
    D(i+1,:)=[zeros(1,i), 1:n-i+1].*D(i,:);
end
Dori=D;
D=D./factorial(0:n-1)';
Ac=ones(size(D)).*D;
for i=1:n+1
    power_dtime(:,i) = dtime(2:end).^(i-1);
end
polys = [];
polys_add = [];
polys = [polys; A(:,1)==point(1:end-1)'];
polys = [polys; sum(A.*power_dtime,2)==point(2:end)'];
power_dtime2=power_dtime;
for i =2:n
    power_dtime2(:,2:end) =power_dtime2(:,1:end-1) ;
    polys =[polys; sum(A(1:end-1,:).*D(i,:).*power_dtime2(1:end-1,:),2)==A(2:end,i)];
    if length(polys_add)<n-1
        polys_add = [polys_add; [A(1,i);sum(A(end,:).*D(i,:).*power_dtime2(end,:),2)]==[0;0]];
    end
end
if mod(n,2)==0
    polys_add =polys_add(1:end-1) ;
end
% polys_add =polys_add(end-1:end) ;
% aaaaa=[polys;polys_add]
S_A = solve([polys;polys_add],A);
names=fieldnames(S_A);

Ap=zeros(size(A));
i=1;
for j=1:n+1
    for k= 1:Sn
        Ap(k,j)=S_A.(names{i});
        i=i+1;
    end
end
func_t =@(dt) (dt).^(0:n)';
toc
%確認用シミュレーション
tt=0:0.01:20;
sum_time = sum(dtime);
flag=0;
j=1;
k=1;
for i = 0:0.01:20
    dt = i - time(j);
    if  j<length(dtime)-1 && dt>= dtime(j+1) 
        j=j+1;
        dt = i - time(j);
    end
    if i>= sum_time
        if ~flag
            p_fin=p(k-1);
            v_fin=v(k-1);
            flag=1;
        end
        p(k)= p_fin;
        v(k) =v_fin;
    else
        tn = func_t(dt);
        p(k) = Ap(j,:)*tn;
        v(k) = Ap(j,2:end)*(Dori(2,2:end)'.*tn(1:end-1));
    end
    k=k+1;
end
plot(tt,p);
grid on
hold on
plot(time,point,'o');
plot(tt,v);








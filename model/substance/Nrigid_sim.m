%% initialize
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
clc
clear all
%%
n = 11;% UAV間に連なるリンク数
m = 3;
N = (n+2)*m; % 冗長一般化座標次元 UAV1,2の位置:2*m，リンク位置:n*m
Np = n*m;  % リンクの向きベクトル:n*m% 相対角度ではない点に注意
% ３次元極座標による方向ベクトル t1 : 方位各(x-y平面上の角度)，t2 : 極角(z軸からの角度)
torq=@(pl,F) [pl(1)*F(2)-pl(2)*F(1)]; % torque function : F: 力ベクトル，t : 力の作用点までの角度，l : 力の作用点までの距離
syms t real
syms L [1 n] real % リンク長
syms M [1 n+2] real % 質量（UAV1,2＋リンク）
syms D [1 n+1] real % ダンパ定数（UAV含む各接点）[UAV1-link1, link1-link2, ..., link(n-1)-linkn, UAV2-linkn ]
syms Ks [1 n+1] real % ばね定数（UAV含む各接点）[UAV1-link1, link1-link2, ..., link(n-1)-linkn, UAV2-linkn ]
syms Jn [1 n] real % 慣性主軸から見た慣性モーメント
syms grav real
syms q [n+2 m]  real % 冗長一般化座標 : position of UAV1, link1, ... link n, UAV2
syms dq [n+2 m] real % 冗長一般化速度
syms ddq [n+2 m] real % 冗長一般化加速度
syms w [n 3]  real% 角速度 : 慣性空間のベクトル : link1, ..., link n
syms dw [n 3]  real% 角加速度
syms p [n 3]  real% リンクの向き direction vector of link1, ..., link n
syms dp [n 3]  real% リンクの向きの速度　dp = w x p
syms R [n+1 m] real% 各接点での内力ベクトル
syms u1 [m 1] real % UAV１,2の発生する力ベクトル
syms u2 [m 1] real % UAV１,2の発生する力ベクトル
q= q';
dq = dq';
ddq = ddq';
p = p';
dp = dp';
w = w';
dw = dw';
R = R';
u = [u1;u2];
J = [1;1;10000].*Jn;
X = [reshape(q,[N 1]);reshape(dq,[N 1]);reshape(p,[numel(p) 1]);reshape(w,[numel(w) 1])];
pParam=[L';reshape(J,[numel(J),1]);M';D'];
%% Lagrangian
energy = @(mat,cof) sum(mat.*cof'.*mat,'all')/2;
%K = energy(dq',M)+energy(w',J);% kinetic energy
K = energy(dq',M)+simplify(sum(arrayfun(@(i) simplify(w(:,i)'*rotm(p(:,i))*diag(J(:,i))*rotm(p(:,i))'*w(:,i)),[1,n])))...
+energy([p(:,1)-[0;0;-1],p(:,2:end)-p(:,1:end-1),p(:,end)-[0;0;1]]',Ks); % kinetic energy
% w が慣性座標で見た角速度なので，慣性座標で見た慣性行列 を使う：rotm(p(:,i))*diag(J(:,i))*rotm(p(:,i))'
U = grav*M*q(m,:)';% potential energy
Dis = energy([w(:,1),w(:,2:end)-w(:,1:end-1),w(:,end)]',D);% dissipative energy dp = w x p より |p| = 1なので w^2 = dp^2
Lagrange=K-U;
%% E-L equation 
dLdq=pdiff(Lagrange,[q,p]);
dLddq=pdiff(Lagrange,[dq,w]);
dLdt=LieD(dLddq,[reshape(dq,[N 1]);reshape(ddq,[N 1]);reshape(cross(w,p),[numel(w) 1]);reshape(dw,[numel(w) 1])],X);
% 一般化力　　i-th リンクの受ける力は
% (i+1)-th リンクからR(2*i+ 1,2) の力
% (i-1)-th リンクからR(2*(i-1) + 1,2) の反力を受ける（そのため符号はマイナス）
RF = [u1+R(:,1);reshape(R(:,2:end)-R(:,1:end-1),[m*n,1]);u2-R(:,end)];
%tauR=simplify(arrayfun(@(pl,F1,F2) torq(pl{1}/2,F2{1})+torq(-pl{1}/2,F1{1}),mat2cell(p.*L,m,ones(1,n)),mat2cell(-R(:,2:end),m,ones(1,n)),mat2cell(R(:,1:end-1),m,ones(1,n))));
%%
clc
dDisddq=pdiff(Dis,[dq,w]); % = 0
ELEq = RF-(-dLdq(1,1:(n+2)*m)'+dDisddq(1,1:(n+2)*m)');
Lp = L.*p;
tauR = cross(-Lp,-R(:,1:end-1))+cross(Lp,R(:,2:end));
dW =  matlabFunction(angular_acceleration(p,w,R,J,L),'Vars',{p,w,R,Jn,L});
%ELEw = matlabFunction(dW(p,w,R,Jn,L) - dDisddq(1,(n+2)*m+1:end)','Vars',{p,w,R,Jn,L,D});
%dW =  angular_acceleration(p,w,R,Jn,L);
ELEw = dW(p,w,R,Jn,L) - dDisddq(1,(n+2)*m+1:end)';
%%
% tauR = cross(-Lp,-R(:,1:end-1))+cross(Lp,R(:,2:end));
% %dp = cross(w,p); % dp = w x p
% 
% dDisddq=pdiff(Dis,[dq,w]); % = 0
% ELE=[RF;dW]-simplify(-dLdq'+dDisddq');
% Mmat = coeffMatrix(dLdt,reshape([ddq,dw],[numel([ddq,dw]), 1]),100);
% deqX=inv(Mmat)*ELE; % 並進加速度
%%
% 慣性空間から見た場合（spatial angular velocity）
% ddp0 = dw0 x p0 + w0 x (w0 x p0)
% dw0 = inv(J0)*(tau0 - w0 x (J0*w0)) = R*inv(Jb)*R'*(tau0-w0 x (R*Jb*R')*w0)
% https://en.wikipedia.org/wiki/Rotation_matrix : General rotations
 qp=[reshape(q,[numel(q),1]);reshape(p,[numel(p),1])];
dqp=[reshape(dq,[numel(dq),1]);reshape(cross(w,p),[numel(w),1])];
%% constraint : リンク間つながりからリンク重心位置を表現しtmp3とし
% 2階微分したものがddqと一致することから力-トルクの拘束条件を導出
syms dwsym [numel(w) 1]
tmp2=[kron(L.*p,ones(n+1,1)),zeros(m*(n+1),1)].*kron([1;1;1],triu(ones(n+1),1)');
COGs=q(:,1)+[zeros(m,1),[L,0].*[p,zeros(m,1)]/2+reshape(sum(tmp2,2),n+1,3)'];% UAV1 から辿った各重心位置
dCOGs=reshape(LieD(COGs,dqp,qp),[(n+2)*m,1]); % UAV1から辿った重心速度
ddCOGs=LieD(dCOGs(m+1:end),[reshape(dq,[N 1]);ELEq;reshape(cross(w,p),[numel(w),1]);dwsym],X); % UAV1から辿った重心加速度
%%
Cons1 = matlabFunction(subs(ddCOGs,dwsym,ELEw(p,w,R,Jn,L,D))-ELEq(m+1:N),'Vars',{p,w,R,Jn,L,D,M,grav,u}); % 重心加速度 拘束
%% リンクの長さ制約とその微分
Cons2 = [diag(p'*p)-1;diag(p'*dp)];
%% Controller 
F1 = lqr([zeros(2*m,m),[eye(m);zeros(m)]],[zeros(m);eye(m)/2.1],100*diag([1 1 100 1 1 1]),1*eye(m));
F2 = lqr([zeros(2*m,m),[eye(m);zeros(m)]],[zeros(m);eye(m)/2.1],100*diag([1 1 100 1 1 1]),1*eye(m));
pd1 = [3;4;4];
pd2 = [5;4;4];
U = @(t,x) [-F1*[x(1:m)-pd1;x(N+1:N+m)];-F2*[x(N-m+1:N)-pd2;x(2*N-m+1:2*N)]];

% 初期値の導出
L0 = (3/n)*ones(n,1);
Jb0=reshape(((0.5/n)*(3/n)^2/12)*[1;1;0].*ones(1,n),[numel(J),1]);
Jn0=((0.5/n)*(3/n)^2/12)*ones(1,n);
%%
M0=[0.5;0.5/n*ones(n,1);0.5];
D0 = 0.0001*ones(n+1,1);
pParamV= [L0;Jb0;M0;D0];
physicalParam = [pParam;grav];
physicalParamV =[pParamV;9.81];
UAV10 = [1;0;4];
if mod(n+1,2)
theta10 = [-arrayfun(@(i) pi/(3*i),1:n/2),arrayfun(@(i) pi/(3*i),n/2:-1:1)];
else
theta10 = [-arrayfun(@(i) pi/(3*i),1:n/2),0,arrayfun(@(i) pi/(3*i),n/2:-1:1)];
end
p0 = reshape([cos(theta10);zeros(1,n);sin(theta10)],[m*n,1]);
COGs0=reshape(double(subs(COGs,[X(1:m);reshape(p,numel(p),1);physicalParam],[UAV10;p0;physicalParamV])),[N,1]);
X0 = [COGs0; zeros(N,1);p0;zeros(numel(w),1)];
U0 = U(0,X0);
R0 = double(cell2sym(struct2cell(solve(subs(Cons1(p0,0*w,R,Jn0,L0',D0',M0',9.81,U0),[X;u;physicalParam],[X0;U0;physicalParamV])==0,R))));
%% 数値シミュレーション
dX = matlabFunction([reshape(dq,[N 1]);subs(ELEq,[M,grav],[M0',9.81]);reshape(cross(w,p),[numel(w),1]);ELEw(p,w,R,Jn0,L0',D0')],'Vars',{X,R,u}); % [dq; ddq; dw;dp]
%%
vars = [X;reshape(R,numel(R),1)];
eqns = matlabFunction(subs([dX(X,R,U(t,X));Cons1(p,w,R,Jn0,L0',D0',M0',9.81,U(t,X))],[physicalParam],[physicalParamV]),'Vars',{t,vars});
% eqns = subs([dX;Cons1;Cons2],[u;physicalParam],[U(t,X);physicalParamV]);
% eqns = [eqns(1:32);eqns(34:35);eqns(37:38);eqns(39:end-2)];
% vars = [vars(1:32);vars(34:35);vars(37:38);vars(33);vars(36);vars(39:end)];
X01 = [X0;R0];
X02= [X01(1:32);X01(34:35);X01(37:38);X01(33);X01(36);X01(39:end)];
%%
%hoge=matlabFunction(eqns,'Vars',{t,vars});
%hoge(0,[X0;R0])'
%Mass = diag([ones(1,numel(X0)-2),zeros(1,length(R0)+2)]);
Mass = diag([ones(1,numel(X0)),zeros(1,length(R0))]);
%options = odeset('Mass',Mass,'RelTol',1e+2,'AbsTol',1e+2);
options = odeset('Mass',Mass);
%[time,y]=ode15s(hoge,[0,20],X01,options);
[time,y]=ode15s(eqns,[0,20],X01,options);
%% animation
stept=ceil(length(time)/70);
%stept=1;
tips_pos=q(:,1)+reshape(sum(tmp2,2),n+1,m)';% UAV1,2 とリンク接点位置
tips=matlabFunction(subs(tips_pos,physicalParam,physicalParamV),'Vars',{vars'});
close all
%clc
make_animation(1:stept:length(time),@(k) fig3(tips(y(k,:)),[-1,10],[-5,10],[-5,10]),@(h) [],0)
%%
plot(time,y(:,19).^2+y(:,20).^2)
%% local function
function pd = pdiff(list, vars)% 偏微分できる
    list=list(:);
    vars=vars(:);
    %    pd = arrayun(@(x) di(list(1), x), vars)';
    pdi_tmp = @(list, vars) arrayfun(@(func) arrayfun(@(x) diff(func, x), vars)',list,'UniformOutput',false);
    pd = cell2sym(pdi_tmp(list,vars));
end
function dh = LieD(h,f,x)
    x = x(:);
    [row,col]=size(h);
    dh = h;
    for i = 1:row
        for j = 1:col
            dh(i,j) = pdiff(h(i,j),x)*f;
        end
    end
end
function m = mtake(mat,m,n)
    m=mat(m,n);
end
function [] = make_animation(kspan,fig,base_fig,video_flag)
    % kspan : 時間
    %fig : fig(k) ：時刻ｋの図
    % base_fig : 背景
    h =figure;
    h;
    if video_flag
            FileName = strrep(strrep(strcat('Movie(',datestr(datetime('now')),')'),':','_'),' ','_');
    v=VideoWriter(FileName,'MPEG-4');
    v.Quality=100; % Quality o graphic
    open(v);
    end
    hold on
    for k = kspan
        base_fig(h);
        
        fig(k);
      %   update screen
        drawnow %limitrate
    if video_flag
        frame=getframe(gcf);
        writeVideo(v,frame);
    end
    hold off
    end
end
function fig(y,xr,yr)
    plot(y(1,1),y(end,1),'bo','LineWidth',2,'MarkerSize',7);
    hold on;
    plot(y(1,end),y(end,end),'ro','LineWidth',2,'MarkerSize',7);
    plot(y(1,:),y(end,:),'Color','black','LineWidth',2,'MarkerSize',7);
    xl = 5;
%    xlim([0,xl]);
    xlim(xr);
    yl = 3;
   % ylim([0,yl]);
    ylim(yr);
    daspect([1 1 1]);
            legend('UAV1','UAV2','cable','Location','northoutside','NumColumns',3,'FontSize', 17);
            xlabel( '{\it x} [m]');     ylabel( '{\it z} [m]');
    grid on;
    hold off;
end
function fig3(y,xr,yr,zr)
    plot3(y(1,1),y(2,1),y(3,1),'bo','LineWidth',2,'MarkerSize',7);
    hold on;
    plot3(y(1,end),y(2,end),y(end,end),'ro','LineWidth',2,'MarkerSize',7);
    plot3(y(1,:),y(2,:),y(end,:),'Color','black','LineWidth',2,'MarkerSize',7);
    xlim(xr);
    ylim(yr);
    zlim(zr);
    daspect([1 1 1]);
            legend('UAV1','UAV2','cable','Location','northoutside','NumColumns',3,'FontSize', 17);
            xlabel( '{\it x} [m]');     ylabel( '{\it y} [m]');     zlabel( '{\it z} [m]');
    grid on;
    hold off;
end
function [A,B] = coeffMatrix(vec,var,n)
    % vec = A*var+B
    syms A [length(vec) length(var)] real
    syms B [length(vec) 1] real
    %A=zeros(length(vec),length(var));
    %B=zeros(length(vec),1);
    for i = 1:length(vec)
        for j = 1:length(var)
            tmp=coeffs(vec(i)+n*var(j)+n,var(j));
            if length(tmp)>2
                warning("ACSL : exists nonlinear terms");
            else
                A(i,j)=tmp(2)-n;
                if j == length(var)
                    B(i)=tmp(1)-n;
                else
                    vec(i)=tmp(1)-n;
                end
            end
        end
    end
end
function R = rotm(p)
    p = p(:);
sinb = sqrt(p(1,1)^2+p(2,1)^2);% beta in [0, pi]
if sinb == 0
R =  [[1;0;0],[0;1;0],[0;0;p(3)]];    % p 軸回転は無視
else
R =  [[p(1:2)*p(3)/sinb;-sinb],[-p(2);p(1);0]/sinb,p];
end
end
function dw =  angular_acceleration(p,w,R,J,L)
    n = length(L);
    %L = L(:)';
    pm = reshape(p,[3,n]);
    Rm = reshape(R,[3,n+1]);
    tau=  cross(-L.*pm,-Rm(:,1:end-1))+cross(L.*pm,Rm(:,2:end));
    dw = [];
    for i = 1:n
    Rm = rotm(p(3*(i-1)+1:3*i));
    iJ = diag([1/J(i),1/J(i),0]);
    Jm = diag([J(i),J(i),0]);
%    dw(3*(i-1)+1:3*(i-1)+3,1)=Rm*iJ*Rm'*(tau(:,i)-Skew(w(:,i))*(Rm*Jm*Rm')*w(:,i));
    dw = [dw;Rm*iJ*Rm'*(tau(3*(i-1)+1:3*i)'-Skew(w(3*(i-1)+1:3*i))*(Rm*Jm*Rm')*w(3*(i-1)+1:3*i)')];
    end
end

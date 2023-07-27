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
alp(anum)=0.86;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Ac2 = diag([1],1);
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
k=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt); % xdiag([100,10,10,1])
% k=5;

x0=[50,0.01];
rng=0.05;
i=1;
fun=@(x)(integral(@(w) abs( -k(i).*abs(w).^alp(i) + k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), rng,rng+0.5) +integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0,rng));
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
% options = optimoptions("fmincon",...
%     "Algorithm","sqp",...
%     "EnableFeasibilityMode",true,...
%     "SubproblemAlgorithm","cg");
[p,fval] = fmincon(fun,x0,[],[],[],[],[0,1E-4*0],[inf,1]) 
[p,fval] = fmincon(fun,x0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 
% [p,fval] = fminsearch(fun,x0) 

2*fval
1 - p(1).*p(2).^(alp(i)./2)

syms w
du = diff(k(i).*tanh(p(1).*w).*sqrt(w.^2 + p(2)).^alp(i),w,1);

e = -1:0.001:1;
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
% f=k*w -k*tanh(18*w)*sqrt(w^2 + 0.001)^0.8;Ua LS
% f=k*w -k*sign(w)*abs(w)^0.8;%FT LS
f1=-abs(k*w) +abs(k*sign(w)*abs(w)^0.8);%FT LS
f=k*w -k*sign(w)*abs(w)^0.8;%FT LS
% f=k1*w - k*tanh(p1*w)*sqrt(w^2 + p2)^a;
df =diff(f,w);
% dfs=subs(df,w,0);
% f=-k*abs(w) +k*tanh(18*abs(w))*sqrt(w^2 + 0.001)^0.8;
fplot(f1,[-1.5,1.5],'LineWidth', 2.5)
hold on
fplot(df,[-1.5,1.5],'LineWidth', 2.5)

% fplot(0,[-1.1,1])
% fplot( -k*tanh(10*w)*sqrt(w^2 + 0.0001)^0.8,[-1.1,1])
% fplot( -k*sign(w)*abs(w)^0.8,[-1.1,1])
% fplot( -k*w,[-1.1,1])
legend("$h_i(x_i)$","$\dot{h_i}(x_i)$",'Interpreter','latex');
fosi=20;%defolt 9
set(gca,'FontSize',fosi)
xlabel("$x_i$",'FontSize',fosi,'Interpreter','latex');
ylabel("${h_i}(x_i)$or$\dot{h_i}(x_i)$",'FontSize',fosi,'Interpreter','latex');
grid on
hold off
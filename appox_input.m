%% sign,absoluteを近似（近似区間をグラフで確認）
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
% k=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt); % xdiag([100,10,10,1])
r=[0.05,0.05];%緩和区間
a=[1,1];%近似に用いる区間
b=[1,1];%緩和区間の調整 b>=0
x0=[50,0.01];
for i=1:2
fun=@(x)(integral(@(w) abs( -k(i).*abs(w).^alp(i) + k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), r(i),r(i)+a(i)) +integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0,r(i)));
c =@(x)0;
ceq = @(x) 1 - x(1).*x(2).^(alp(i)./2)+ b(i);
nonlinfcn = @(x)deal(c(x),ceq(x));

options = optimoptions("fmincon",...
    "Algorithm","interior-point",...
    "EnableFeasibilityMode",true,...
    "SubproblemAlgorithm","cg");

[p,fval] = fmincon(fun,x0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 

2*fval
const = 1 - p(1).*p(2).^(alp(i)./2)

syms w
du = diff(k(i).*tanh(p(1).*w).*sqrt(w.^2 + p(2)).^alp(i),w,1);

e = -1:0.001:1;
usgn = -k(i).*tanh(p(1)*e).*abs(e).^alp(i);
usgnabs = -k(i).*tanh(p(1).*e).*sqrt(e.^2 + p(2)).^alp(i);
du = subs(du,w,e);
u = -k(i).*sign(e).*abs(e).^alp(i);
uk= -k(i).*e;

figure(i)
plot(e,usgnabs, 'LineWidth', 2.5);
hold on
grid on
plot(e,u, 'LineWidth', 2.5);
plot(e,uk, 'LineWidth', 2.5);
legend("Approximation","Finite time settling","Linear state FB");
fosi=20;%defolt 9
set(gca,'FontSize',fosi)
xlabel('x','FontSize',fosi);
ylabel('input','FontSize',fosi);
hold off
end
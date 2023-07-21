%% FTC入力のsign,absoluteを近似
%有限時間整定制御をz方向サブシステムに適用する際に原点で微分可能な形に近似をする必要がある
%近似に使うパラメータを求める為に入力のグラフを描いて原点付近で意図した緩和区間になっているのかを確認するプログラム
%パラメータの確認のみに使うので共通プログラムでFTCを回す上ではこのプログラムは必要ない

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
Ac2 = diag(1,1);
Bc2 = [0;1];
dt=0.025;
k=lqrd(Ac2,Bc2,diag([100,1]),0.1,dt); 
r=[0.05,0.05];%緩和区間
a=[1,1];%近似に用いる区間
b=[1,1];%緩和区間の調整 b>=0
x0=[50,0.01];%fminconの初期値
for i=1:2
fun=@(x)(integral(@(w) abs( -k(i).*abs(w).^alp(i) + k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), r(i),r(i)+a(i)) +integral(@(w) abs( k(i).*w-k(i).*tanh(x(1).*w).*sqrt(w.^2 + x(2)).^alp(i)), 0,r(i)));
c =@(x)0;
ceq = @(x) 1 - x(1).*x(2).^(alp(i)./2)+ b(i);
nonlinfcn = @(x)deal(c(x),ceq(x));%制約条件

options = optimoptions("fmincon",...
    "Algorithm","interior-point",...
    "EnableFeasibilityMode",true,...
    "SubproblemAlgorithm","cg");

[p(i,:),fval] = fmincon(fun,x0,[],[],[],[],[0,0],[inf,inf],nonlinfcn,options) 
fval2(i)=2*fval%近似したFTCとFTCとの誤差
const = 1 - p(i,1).*p(i,2).^(alp(i)./2)%算出したパラメータが制約を満たしているのか確認
end

e = -1:0.001:1;
for i=1:2
syms w
du = diff(k(i).*tanh(p(i,1).*w).*sqrt(w.^2 + p(i,2)).^alp(i),w,1);
usgn = -k(i).*tanh(p(i,1)*e).*abs(e).^alp(i);
usgnabs = -k(i).*tanh(p(i,1).*e).*sqrt(e.^2 + p(i,2)).^alp(i);
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
%%
filename="appox_FTC_param.mat";
save(filename,"r","a","b","k","p","fval2");
whos("-file",filename);
%%
 syms zF [2 4]
 syms z(t)
 syms sz1 [2 1] real
            %matlabfunctionにしてもいいかも matlabFunction([u, du, ddu, dddu], "Vars", {sz1,vF1(i),p,alpha(i)});
            u = 0; du = 0; ddu = 0; dddu = 0;
            for i=1:2
            ub(i) = -zF(i,1).*tanh(zF(i,2).*z(t)).*sqrt(z(t).^2 + zF(i,3)).^zF(i,4);
            dub(i) = diff(ub(i), t);
            ddub(i) = diff(dub(i), t);
            dddub(i) = diff(ddub(i), t);
            end

            for i = 1:2
                u = u + subs(ub(i), z, sz1(i));
            end
                       dz = Ad1*sz1 + Bd1*u;
            for i = 1:2
                du = du + subs(dub(i), [diff(z, t) z], [dz(i) sz1(i)]);
            end
                       ddz = Ad1*dz + Bd1*du;
            for i = 1:2
                ddu = ddu + subs(ddub(i), [diff(z, t, 2)  diff(z, t) z], [ddz(i)  dz(i) sz1(i)]);
            end
                       dddz = Ad1*ddz + Bd1*ddu;
            for i = 1:2
                dddu = dddu + subs(dddub(i), [diff(z, t, 3) diff(z, t, 2)  diff(z, t) z], [dddz(i) ddz(i)  dz(i) sz1(i)]);
            end
  
        matlabFunction([u, du, ddu, dddu],'file','Vzft.m', "Vars", {zF, sz1},'outputs',{'Vftc'});
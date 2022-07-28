%tanhと線形で近似tanhをいくつか組み合わせてもいいかも
%最小のalpに対して入力の変化が耐えられるようにするこれができれば初期値のalpの値を小さくできるかも
%ddxとdddxの項は近似しなくてもいいかも
%最適化でパラメータ調整するといいかも．そうすればtanhをいくつか組み合わせる方法でもパラメータ調整簡単そう
clear 
% e= -1:0.001:1;
% e = -0.35:0.001:0.35;
e= -0.1:0.001:0.1;
alp = [0.692307692307692;0.750000000000000;0.818181818181818;0.900000000000000];%初期値0.9有限整定のべき乗
k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン

g = [1 1 1 1];%元のゲインの倍率調整
a = [1 1 1 1];%曲がり具合のきつさ
%近似普通誤差0.1x
g = [0.105, 0.08, 0.055, 0.028];
a = [20, 18, 16, 15];
kg01= k.*g;
    % g(1) = 0.1;
    % a(1)=20;
    % g(2) = 0.08;
    % a(2)=18;
    % g(3) = 0.055;
    % a(3)=16;
    % g(4) = 0.028;
    % a(4)=15;
%近似Fbとの入力誤差が一番大きくなるところ[0.3, 0.3160, 0.3320, 0.3490]での近似x
g = [0.135, 0.105, 0.075, 0.035];
a = [9.5, 9, 9.5, 9.5];
kg= k.*g;
    % g(1) = 0.135;
    % a(1)=9.5;
    % g(2) = 0.105;
    % a(2)=9;
    % g(3) = 0.075;
    % a(3)=9.5;
    % g(4) = 0.035;
    % a(4)=9.5;
%近似強めより近くで近似
% g(1) = 0.1;
% a(1)=40;
titlex=["x","dx","ddx","dddx"];
for i = 1:4
    ufb(i,:)= -k(i)*e;
    u(i,:)= -k(i)*sign(e).*abs(e).^alp(i);
%     u2= -k(2)*sign(t).^alp(2).*abs(t);
%     u3= -k(3)*sign(t).^alp(3).*abs(t);
%     u4= -k(4)*sign(t).^alp(4).*abs(t);
    
    utanh(i,:)=-k(i)*g(i)*tanh(a(i)*e)-k(i)*e;
%     utanh2=-k(2)*tanh(a(2)*t)-k(2)*t;
%     utanh3=-k(3)*tanh(a(3)*t)-k(3)*t;
%     utanh4=-k(4)*tanh(a(4)*t)-k(4)*t;
% n=10;
%     up(i,:) = polyfit(e,u(i,:),n);
%     up2(i,:) = polyval(up(i,:),e2);

sigma(i,:) =abs( u(i,:)-ufb(i,:));
smax = max(sigma(i,:))
imax = find(sigma(i,:)==smax);
e(1,imax)

sigma2(i,:) = -utanh(i,:)+u(i,:);
smax2 = max(sigma2(i,:))
imax2 = find(sigma2(i,:)==smax2);
e(1,imax2)
    figure(3*i-2)  
        plot(e,u(i,:),e,utanh(i,:),e,ufb(i,:))
        legend("FT","tanh","FB")
        grid on
        title(titlex(i))
    
%     figure(3*i-1)
%         plot(e,sigma(i,:),e(1,imax),sigma(i,imax),'*')
%         grid on

    figure(3*i)
        plot(e,sigma2(i,:))%,e(1,imax2))%sigma2(i,imax2),'*')
        grid on
        title(titlex(i)+"元の入力との差")
end
%%
% %元の入力と近似の入力の差を取り二乗しそれを積分する
% alp = double([0.692307692307692;0.750000000000000;0.818181818181818;0.900000000000000]);%初期値0.9有限整定のべき乗
% k = double([82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445]);%FBゲイン
% 
% syms f1 f2 a1 a2 %alp k
% syms e positive
% utanh = -f1*tanh(a1*e)-f2*tanh(a2*e)-k(1)*e;
% u = -k(1)*sign(e)*(e)^alp(1);
% sigma(f1, f2, a1, a2, e) = (u - utanh)^2;
% % e= -0.1:0.001:0.1;
% 
% % sigma = subs(sigma,[alps,ks],[alp(1),k(1)]);
% insigma = int(sigma,e,[0 1]);
% % double(insiguma);
% finsigma = insigma == 0;
% % sol = solve(finsigma,)
%%
% alp = double([0.692307692307692;0.750000000000000;0.818181818181818;0.900000000000000]);%初期値0.9有限整定のべき乗
% k = double([82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445]);%FBゲイン
% alp = double([0.6923;0.75;0.8181;0.9]);%初期値0.9有限整定のべき乗
% k = double([82.37,132.1,64.79,13.94]);%FBゲイン
% 
% syms k real%alp k
% syms f1 f2 a1 a2 e alp positive
% sgmd1=1/(1+exp(-a1*e));%f(2x)の時のシグモイド関数
% sgmd2=1/(1+exp(-a2*e));%f(2x)の時のシグモイド関数
% tanh1 = 2*sgmd1-1;%tanhをシグモイドで表す
% tanh2 = 2*sgmd2-1;%tanhをシグモイドで表す
% 
% utanh = -f1*tanh1-f2*tanh2-k(1)*e;
% % utanh = -f1*tanh(a1*e)-f2*tanh(a2*e)-k(1)*e;
% u = -k(1)*sign(e)*(e)^alp(1);
% % sigma = (u - utanh)^2;
% sigma = abs(u - utanh);
% isigma = int(sigma,e);
% % u2=(-k(1)*sign(e)*(e)^alp(1))^2;
% % uutanh=-2*u*utanh;
% % utanh2=utanh^2;
% % intu2=double
% % sigma = subs(sigma,[],[alp(1),k(1)]);
% 
% inx1_2 = int((e*k)^2,e,0,1);
% % intuutanh =
% 
% insigma = int(sigma,e,[0 1]);
% 
% prob = optimproblem('ObjectiveSense','min');
% x = optimvar('x',4);
% % insig = subs(insigma,[f1, f2, a1, a2],x);
% % insig = int((x(5)*k(1) + x(1)*tanh(x(2)*x(5)) + x(3)*tanh(x(4)*x(5)) - x(5)^alp(1)*k(1))^2, x(5), 0, 1);
% insig = subs(isigma,e,1);
% cons1 = insig >= 0;
% cons2 = insig <= 2;
% prob.Constraints.cons1 = cons1;
% prob.Constraints.cons2 = cons2;
% show(prob)
% sol = solve(prob);
%%
% alp = [0.692307692307692;0.75;0.818181818181818;0.9];%初期値0.9有限整定のべき乗
% k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン
% % alp = [0.6923;0.75;0.8181;0.9];%初期値0.9有限整定のべき乗
% % k = [82.37,132.1,64.79,13.94];%FBゲイン
% syms f1 f2 a1 a2 e  positive
% x0=[1,1,1,1];
% utanh = -f1*tanh(a1*e)-f2*tanh(a2*e)-k(1)*e;
% u = -k(1)*sign(e)*(e)^alp(1);
% sigma = abs(u - utanh);
% isigma = int(sigma,e); 
% f=subs(isigma,e,1)-subs(isigma,e,0);
% clear f1 f2 a1 a2
% % fun=@(f1, f2, a1, a2)(f1*sign(f1*tanh(a1)) + f2*tanh(a2))*log(cosh(a1)))/a1 - (25345249*sign(f1*tanh(a1) + f2*tanh(a2)))/3384600 + (f2*sign(f1*tanh(a1) + f2*tanh(a2))*log(cosh(a2)))/a2;
% % x = fminunc(fun,x0);
%% forループ tanh一つ
% alp = [0.6923;0.75;0.8181;0.9];%初期値0.9有限整定のべき乗
% k = [82.37,132.1,64.79,13.94];%FBゲイン
alp = [0.692307692307692;0.75;0.818181818181818;0.9];%初期値0.9有限整定のべき乗
k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン

x=@(f1,a1)(integral(@(e)( abs(-k(1)*abs(e).^alp(1)+f1*tanh(a1*e)+k(1)*e)),0,0.1));

dt=0.5;
old=x(0,0);
for i=0:dt:20
    for j=0:dt:40
        new=x(i,j);
        if(old>new)
            old=new;
            ff1=i;
            aa1=j;
        end
    end
end

clear e utanh u sigma
% e= -0.5:0.001:0.5;      
e= -0.1:0.001:0.1;
utanh(1,:)=-ff1*tanh(aa1*e)-k(1)*e;
u(1,:)=-k(1)*sign(e).*abs(e).^alp(1);
sigma=utanh-u;
plot(e,utanh,e,u,e,sigma)
grid on
legend('utanh','u','誤差')
s=2*(x(ff1,aa1))
%% fminserch tanh一つ
clear e utanh u ufb sigma
titlex=["x","dx","ddx","dddx"];
anum=4;%変数の数
alp=zeros(anum+1,1);
alp(anum+1)=1;
alp(anum)=0.9;%alphaの初期値
for a=anum-1:-1:1
    alp(a)=(alp(a+2)*alp(a+1))/(2*alp(a+2)-alp(a+1));
end

% alp = [0.692307692307692;0.75;0.818181818181818;0.9];%初期値0.9有限整定のべき乗
k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン

x0=[0,0];
fval2=zeros(4,1);
gain=["","f1","a1"];
er=0.1; %近似する範囲を指定
for i=1:4
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + k(i)*e ) ,0, er));
[x,fval] = fminsearch(fun,x0) ;
fval2(i) = 2*fval
gain(i+1,:)=[titlex(i),x];

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

% alp = [0.692307692307692;0.75;0.818181818181818;0.9];%初期値0.9有限整定のべき乗
k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン
x0=[5,5,5,5];
% x0=[10,10,10,10];
fval2=zeros(4,1);
gain=["","f1","a1","f2","a2"];
er=0.3;
for i=1%:4
fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*tanh(x(4)*e) + k(i)*e ) ,0, er));
% options = optimset('MaxFunEvals',2e5);%普通は200*(number of variables) (既定値) 
% options = optimset('PlotFcns','optimplotfval','TolX',1e-4);
% options = optimset('PlotFcns','optimplotfval');
% [x,fval] = fminsearch(fun,x0,options) ;
[x,fval] = fminsearch(fun,x0) ;
fval2(i) = 2*fval
gain(i+1,:)=[titlex(i),x];

% e= -0.5:0.001:0.5;      
e= -1:0.001:1;
ufb(i,:)= -k(i)*e;
utanh(i,:)= - x(1)*tanh(x(2)*e)- x(3)*tanh(x(4)*e) - k(i)*e;
u(i,:)=-k(i)*sign(e).*abs(e).^alp(i);
sigma(i,:)=utanh(i,:)-u(i,:);
figure(i+1)
plot(e,ufb(i,:),e,utanh(i,:),e,u(i,:),e,sigma(i,:))
grid on
legend('ufb','utanh','u','誤差')
end

%%
syms a b c d e
k = [82.3694335484227,132.127723488091,64.7874537390378,13.9398476471445];%FBゲイン
alp = [0.692307692307692;0.75;0.818181818181818;0.9];%初期値0.9有限整定のべき乗

sigma = int(abs( -k(1)*abs(e).^alp(1) + a*tanh(b*e) + c*tanh(d*e) + k(1)*e ) ,e,0, 0.1);
% sigma = integral(@(e) abs( -k(i)*abs(e).^alp(i) + x(1)*tanh(x(2)*e) + x(3)*tanh(x(4)*e) + k(i)*e ) ,0, er);

%% 時間かかりすぎ
% alp = [0.6923;0.75;0.8181;0.9];%初期値0.9有限整定のべき乗
% k = [82.37,132.1,64.79,13.94];%FBゲイン
% 
% x=@(f1,a1,f2,a2)(integral(@(e) abs( -k(1)*abs(e).^alp(1) + f1*tanh(a1*e) + f2*tanh(a2*e) + k(1)*e ) ,0, 0.1));
% 
% dt=1;
% old=x(0,0,0,0);
% for i=0:dt:20%f1
%     for j=0:dt:40%a1
%         for k=0:dt:20%f2
%             for l=0:dt:40%a2
%                 new=x(i,j,k,l);
%                 if(old>new)
%                     old=new;
%                     ff1=i;
%                     aa1=j;
%                     ff2=k;
%                     aa2=l;
%                 end
%             end
%         end
%     end
% end
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

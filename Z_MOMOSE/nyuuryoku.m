t=-2:0.001:2;
k=1;
uft2=-k.*sign(t).*abs(t).^0.2;
uft4=-k.*sign(t).*abs(t).^0.9;
ta=-k*tanh(1.2.*t);
% uftt2=-k.*tanh(10*t).*abs(t).^0.4;
uftt4=-k.*tanh(10.*t).*abs(t).^0.7;
uHL=-k.*t;
udtanh2=2*abs(t).^(1/5).*(tanh(t).^2 - 1) - (2.*sign(t).*tanh(t))./(5*abs(t).^(4/5));%0.2
udtanh4=2*abs(t).^(2/5).*(tanh(t).^2 - 1) - (4.*sign(t).*tanh(t))./(5*abs(t).^(3/5));%04
%zの入力にしようとするやつ
c=1;
k=k*2;
unew=-k/2.*(tanh(c.*t)+t);%;-k/2.*(sign(2.*t)+t);
dunew=(k.*(c*(tanh(c.*t).^2 - 1) - 1))./2;
ddunew=-c^2*k.*tanh(c.*t).*(tanh(c.*t).^2 - 1);

%6/23 実験でよかった近似の入力とそのパラメータ
% k=82;
% utanh=-k*abs(t).^0.6923.*tanh(6.*t)-k.*t;
% uori=-k*abs(t).^0.6923.*sign(t)-k.*t;
% uabs=-k*tanh(1.2*t)-k.*t;

k=1;
utanh=-k*abs(t).^0.7.*tanh(6.0*t)-k.*t;
uori=-k*abs(t).^0.7.*sign(t)-k.*t;
uabs=-k*tanh(1.2*t)-k.*t;
uHL=-k.*t;

%% 0629x^atanh
syms dt
fsyms=abs(dt).^0.5.*tanh(dt);
f=double(subs(fsyms,dt,t));
df=diff(fsyms);
t1=0.001:0.1:2;
df=subs(df,dt,t1);
% i=1;
% for t=-2:0.001:2
%     uddt4(i)=(8*sign(t)*(tanh(t)^2 - 1))/(5*abs(t)^(3/5)) - 4*abs(t)^(2/5)*tanh(t)*(tanh(t)^2 - 1) - (8*dirac(t)*tanh(t))/(5*abs(t)^(3/5)) + (12*sign(t)^2*tanh(t))/(25*abs(t)^(8/5));
%     i=i+1;
% end
%%
t=-2:0.001:2;
hold on
grid on
% plot(t,uft2);
% plot(t,uft4);
% plot(t,uftt2);
% plot(t,uftt4);
% plot(t,ta);
% plot(t,udtanh2);
% plot(t,udtanh4);
% plot(t,uddt4);
% plot(t,unew);
% plot(t,dunew);
% plot(t,ddunew);
plot(t,uHL);
plot(t,uori);
plot(t,utanh);
plot(t,uabs);
% plot(t,f);
% plot(t1,df);

xlabel('error')
ylabel('u')
legend('FB','u_{FT} ','u_{sgn}','u_{abs}')
% legend('FT 02','FT 04','FTt 02','FTt 04')
hold off
%%
syms k c t real;
udtanh=diff(2*abs(t).^(2/5).*(tanh(t).^2 - 1) - (4.*sign(t).*tanh(t))./(5*abs(t).^(3/5)),t);
dunew=diff(-k/2.*(tanh(c.*t)+t),t);
ddunew=diff(dunew);
%% 7/12入力の微分方程式を解く
x0=1;
tspan=0:0.01:4;
k=1;
a=0.5;
[T,X] = ode45(@(t,x) -k*sign(x)*abs(x)^a,tspan,x0);
plot(T,X)
%%
syms ap positive
syms an negative
syms x(t) k 
odep=diff(x)== -k*sign(x)*abs(x)^ap;
odeo=diff(x)== -k*sign(x)*abs(x)^1;
oden=diff(x)== -k*sign(x)*abs(x)^an;

Sp= dsolve(odep)
So= dsolve(odeo)
Sn= dsolve(oden)

%%
syms a k t n
an=0.4;%*ones(size(tn));
kn=1;%*ones(size(tn));
tn=-2:0.01:2;
an=0.5;
nn=10;
% tanh=tanh(a*tn);%tanhの変数のゲインの大きさでどのような挙動になるかを確認
% sgn=sign(tn);

utanh=-k*tanh(n*t)*abs(t)^a;
dutanh=diff(utanh,t);
ddutanh=diff(dutanh,t);
dddutanh=diff(ddutanh,t);



%%
hold on
grid on
plot(tn,tanh);
plot(tn,sgn);
hold off
%% tanhとシグモイドのtanhの比較9/6
syms  x sz(t)
sz(t)=t;
a=-0.6;
k=-27;
xx=-1:0.05:1;
fz = 1/(1+exp(-a*2*sz));
    tanh1 = k*(2*fz-1);
    dtanh1 = k*4*a*fz*(1-fz);
    ddtanh1 = k*8*a^2*fz*(1-fz)*(1-2*fz);
    dddtanh1 = k*16*a^3*fz*(1-fz)*(1-6*fz+6*fz^2);
    
    ta = k*tanh(a*x);
    dta = diff(ta,x);
    ddta = diff(ta,x,2);
    dddta = diff(ta,x,3);
hold on 
fplot(tanh1,[-1 1])
plot(xx,subs(ta,x,xx))
fplot(dtanh1,[-1 1])
plot(xx,subs(dta,x,xx))
fplot(ddtanh1,[-1 1])
plot(xx,subs(ddta,x,xx))
fplot(dddtanh1,[-1 1])
plot(xx,subs(dddta,x,xx))

%% 入力の近似tanh1
syms k a 
x(t)=t
u = -k*tanh(a*x)-k*x;
du = diff(u,t)
ddu = diff(u,t,2)
dddu = diff(u,t,3)

a1=1;k1=1;
ts = [-2,2];
ub = subs(u,[a,k],[a1,k1]);
dub = subs(du,[a,k],[a1,k1]);
ddub = subs(ddu,[a,k],[a1,k1]);
dddub = subs(dddu,[a,k],[a1,k1]);
figure(1)
fplot(ub,ts)
figure(2)
fplot(dub,ts)
figure(3)
fplot(ddub,ts)
figure(4)
fplot(dddub,ts)
%% 入力の近似tanh2
syms f k a g b x(t)
x(t)=t;
u = -f*tanh(a*x)-k*x-g*tanh(b*x);
du = diff(u,t)
ddu = diff(u,t,2)
dddu = diff(u,t,3)

a1=1;f1=1;b1=4;g1=4;k1=6;
ts = [-2,2];
ub = subs(u,[a,k,b,g],[a1,k1,b1,g1,f1]);
dub = subs(du,[a,k,b,g],[a1,k1,b1,g1]);
ddub = subs(ddu,[a,k,b,g],[a1,k1,b1,g1]);
dddub = subs(dddu,[a,k,b,g],[a1,k1,b1,g1]);
figure(1)
fplot(ub,ts)
figure(2)
fplot(dub,ts)
figure(3)
fplot(ddub,ts)
figure(4)
fplot(dddub,ts)
%% 第一層に入れる近似入力
% syms a b f1 g1 k [1 2] real 
syms sz1 [2 1]
Ac2 = [0,1;0,0];
Bc2 = [0;1];
%alpha=0.9 e=0.1
f1=[2.8626 , 0.622153];
a=[20.7437, 19.141];
k=[28.4298558254086,8.05867722851289];
u=0;du=0;ddu=0;dddu=0;
    for i = 1%:2
        fza = 1/(1+exp(-a(i)*2*sz1(i)));
        tanha = 2*fza-1;
        dtanha = 4*a(i)*fza*(1-fza);
        ddtanha = 8*a(i)^2*fza*(1-fza)*(1-2*fza);
        dddtanha = 16*a(i)^3*fza*(1-fza)*(1-6*fza+6*fza^2);

        u = u -f1(i)*tanha -k(i)*sz1(i);
            dz = Ac2*sz1 + Bc2*u;
        du = du -f1(i)*dtanha*dz(i) -k(i)*dz(i);
            ddz = Ac2*dz + Bc2*du;
        ddu = ddu -f1(i)*ddtanha*(dz(i))^2 -f1(i)*dtanha*ddz(i) -k(i)*ddz(i);
            dddz = Ac2*ddz + Bc2*ddu;
        dddu = dddu -f1(i)*dddtanha*(dz(i))^3 -3*f1(i)*ddtanha*dz(i)*ddz(i) -f1(i)*dtanha*dddz(i) -k(i)*dddz(i);
    end
    ee=-1:0.05:1;
    hold on
    figure(2)
    plot(ee,subs(u,sz1(1),ee))
    plot(ee,subs(du,sz1(1),ee))
    plot(ee,subs(ddu,sz1(1),ee))
    plot(ee,subs(dddu,sz1(1),ee))
%% ディラックのΔ関数で無理やり微分

syms  t a k
an=0.4;%*ones(size(tn));
kn=1;%*ones(size(tn));
tn=-2:0.01:2;
% n=[1,2,3,4,5,6,7,9];
uft2=-k.*sign(t).*abs(t).^a;
duft2=diff(uft2,t);%ディラックのΔ関数
dduft2=diff(duft2,t);
ddduft2=diff(dduft2,t);


nuft2=-kn*abs(tn).^an.*sign(tn);

nduft2=- 2*kn.*abs(tn).^an.*dirac(tn) - an.*kn.*abs(tn).^(an - 1).*sign(tn).^2;

ndduft2=- 2*kn.*abs(tn).^an.*dirac(1, tn) - an.*kn.*abs(tn).^(an - 2).*sign(tn).^3*(an - 1) - 6.*an.*kn.*abs(tn).^(an - 1).*dirac(tn).*sign(tn);

nddduft2=- 2.*kn.*abs(tn).^an.*dirac(2, tn) - 12.*an.*kn.*abs(tn).^(an - 1).*dirac(tn).^2 - 8.*an.*kn.*abs(tn).^(an - 1).*sign(tn).*dirac(1, tn) - 12*an.*kn.*abs(tn).^(an - 2).*dirac(tn).*sign(tn).^2.*(an - 1) - an.*kn.*abs(tn).^(an - 3).*sign(tn).^4.*(an - 1).*(an - 2);
hold on
figure(1);
grid on
plot(tn,nuft2);
figure(2);
grid on
plot(tn,nduft2);
figure(3);
grid on
plot(tn,ndduft2);
figure(4);
grid on
plot(tn,nddduft2);
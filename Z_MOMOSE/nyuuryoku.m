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
plot(t,uft2);
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
% plot(t,uori);
% plot(t,utanh);
% plot(t,uabs);
plot(t,f);
plot(t1,df);

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
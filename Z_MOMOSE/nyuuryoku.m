t=-2:0.001:2;
k=2;
uft2=-k.*sign(t).*abs(t).^0.2;
% uft4=-k.*sign(t).*abs(t).^0.4;
uftt2=-k.*tanh(10*t).*abs(t).^0.4;
% uftt4=-k.*tanh(t).*abs(t).^0.4;
uHL=-k.*t;

hold on
grid on
plot(t,uft2);
% plot(t,uft4);
plot(t,uftt2);
% plot(t,uftt4);
plot(t,uHL);

xlabel('x')
ylabel('u')
legend('FT 02','FT 04','SF')
% legend('FT 02','FT 04','FTt 02','FTt 04')
hold off
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
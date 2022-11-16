t=20;
dt=0.01;
time=(0:dt:t);

x1 = zeros(1,length(time));
x2 = zeros(1,length(time));
sigma = zeros(1,length(time));
u = zeros(1,length(time));
%初期値
x1(1)=-0.5;
x2(1)=-6;
%ゲイン
gainq=5;
gaink=5;
gainqa=30;
alp=0.7;
kk=[10 1];
%状態方程式
%ma=-kx-cv-f
c=1;m=1;k=1;
A=[0 1;-c/m -k/m];
B=[0;1/m];

%% フィードバックかスライディングモードか
fb=10;%フィードバック：1、スライディングモード:１以外
smck=1;

dist=5;%外乱の大きさ
disf=4/dt;%開始時間
dise=6/dt;%終了時間
%% 極を求めるlqr
if fb==1
    Q=diag(10);
        R=1;
    [Kf,Sf,ef] = lqr(A,B,Q,R);%フィードバック
    Kf
    kyoku=eig(A-B*Kf)
elseif smck==1
        A11=0;
        A12=1;
        %入力が入らないシステムの最適なゲイン
        Q=diag(2);
        R=1;
    [K,S,e] = lqr(A11,A12,Q,R);%スライディングモード
    kyoku=eig(A11-A12*K);
    S=[K 1]
    sig0=S*[x1(1);x2(1)]
    Ts=abs(sig0)/gaink
    Tp=1/gaink*log(gaink*abs(sig0)/gaink+1)
    Ta=sig0^(1-alp)/((1-alp)*gainqa)
    SB=S*B;
    SA=S*A;
else
    A11=0;
        A12=1;
   %A11-A12*inv(Q22)*Q12'
   %スライディングモードに入ったあとの収束を早くするlqrの重み
        Q11 = 1;%Q11-Q12*inv(Q22)*Q12'
        Q22 = 0.5;
        Q12=0;%Q12=Q21
        [~,P,~] = lqrd(A11,A12,Q11,Q22,dt);%正準系のFBgain
        S=[A12'*P+Q12',Q22]
        sig0=S*[x1(1);x2(1)]
    Ts=abs(sig0)/gaink
    Tp=1/gaink*log(gaink*abs(sig0)/gaink+1)
    Ta=sig0^(1-alp)/((1-alp)*gainqa)
        SB=S*B;
        SA=S*A;
    
end
%% 数値シミュレーション
if fb==1%フィードバック
    for i=1:length(time)
    x=[x1(i);x2(i)];
    u(i)=-Kf*x;
%     disf=2/dt;
%     dise=3/dt;
     if disf<i&&i<dise
        [T,X]=ode45(@(t,x) A*x+B*u(i)+[0;dist],[0 dt],x);
            
    else
         [T,X]=ode45(@(t,x) A*x+B*u(i),[0 dt],x);
      
     end
     if i<length(time)
                x1(i+1)=X(end,1);
                x2(i+1)=X(end,2);
     end
    end
else %スライディングモード
    for i=1:length(time)
    x=[x1(i);x2(i)];
   
        sigma(i)=S*x;
    %入力なし
%         u(i)=0;
    %定常到達則
%           u(i)=-inv(SB)*(SA*x+gainq*sign(sigma(i)));%符号関数
%         u(i)=-inv(SB)*(SA*x+gainq*tanh(sigma(i)));%tanh(平滑化)
    %比例到達則
     u(i)=-inv(SB)*(SA*x+gainq*sign(sigma(i))+gaink*sigma(i));%-kk*x;%符号関数
%      u(i)=-inv(SB)*(SA*x+gainq*tanh(1*sigma(i))+gaink*sigma(i));%tanh(平滑化)
    %加速率  
%       u(i)=-inv(SB)*(SA*x+gainqa*abs(sigma(i))^(alp)*sign(sigma(i)));%sign 
    %     x1(i+1)=x1(i)+dt*x2(i);
    %     x2(i+1)=x2(i)+dt*((-c/m)*x1(i)+(-k/m)*x2(2)+(1/m)*u(i));
%    数値シミュレーション
% disf=2/dt;
%     dise=3/dt;
        if disf<i&&i<dise
            [T,X]=ode45(@(t,x) A*x+B*u(i)+[0;dist],[0 dt],x);
                if i<length(time)
                    x1(i+1)=X(end,1);
                    x2(i+1)=X(end,2);
                end
        else
            [T,X]=ode45(@(t,x) A*x+B*u(i),[0 dt],x);
                if i<length(time)
                    x1(i+1)=X(end,1);
                    x2(i+1)=X(end,2);
                end
        end
        
    end
end

%% 保存
logger1={time x1 x2 u sigma};

%% グラフ
if fb==1
    figure(1)
    plot(x1,x2)
    grid on
    xlabel('x1')
    ylabel('x2')
    
    figure(2)
    plot(time,x1,time,x2)
    xlabel('t [s]')
    ylabel('x')
    legend('x1','x2')
    grid on
    
    figure(3)
    plot(time,u)
    xlabel('t [s]')
    ylabel('u')
    grid on
    
else
    figure(1)
    plot(x1,x2)
    grid on
    xlabel('x1')
    ylabel('x2')
    
    figure(2)
    plot(time,x1,time,x2)
    xlabel('t [s]')
    ylabel('x')
    legend('x1','x2')
    grid on
    
    figure(3)
    plot(time,sigma)
    xlabel('t [s]')
    ylabel('{\sigma}')
    grid on
    
    figure(4)
    plot(time,u)
    xlabel('t [s]')
    ylabel('u')
    grid on
    
end
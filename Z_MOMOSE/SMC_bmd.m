t=20;
dt=0.01;
time=(0:dt:t);
c=1;
m=1;
k=1;
x1 = zeros(1,length(time));
x2 = zeros(1,length(time));
sigma = zeros(1,length(time));
u = zeros(1,length(time));
x1(1)=10;
x2(1)=0;
gainq=10;
gaink=40;
gainqa=30;
alp=0.7;
kk=[10 1];

A=[0 1;-c/m -k/m];
B=[0;1/m];
A11=[0];
A12=[1];
Q=10*eye(1);
R=1;
%% フィードバックかスライディングモードか
fb=10;%フィードバック：1、スライディングモード:１以外

%% 極を求めるlqr
if fb==1
    [Kf,Sf,ef] = lqr(A,B,Q,R);%フィードバック
    Kf
    kyoku=eig(A-B*Kf)
else
    [K,S,e] = lqr(A11,A12,Q,R);%スライディングモード
    kyoku=eig(A11-A12*K)
    S=[K 1]
    SB=S*B;
    SA=S*A
end
%% 数値シミュレーション
if fb==1%フィードバック
    for i=1:length(time)
    x=[x1(i);x2(i)];
    u(i)=-Kf*x;
     if 800<i&&i<850
        [T,X]=ode45(@(t,x) A*x+B*u(i)+[2;0],[0 dt],x);
            
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
          u(i)=-inv(SB)*(SA*x+gainq*sign(sigma(i)));%符号関数
%         u(i)=-inv(SB)*(SA*x+gainq*tanh(sigma(i)));%tanh(平滑化)
    %比例到達則
%      u(i)=-inv(SB)*(SA*x+gainq*sign(sigma(i))+gaink*sigma(i));%-kk*x;%符号関数
%     %  u(i)=-inv(SB)*(SA*x+gainq*tanh(sigma(i))+gaink*sigma(i));%tanh(平滑化)
    %加速率  
  % u(i)=-inv(SB)*(SA*x+gainqa*abs(sigma(i))^(alp)*sign(sigma(i)));%sign 
    %     x1(i+1)=x1(i)+dt*x2(i);
    %     x2(i+1)=x2(i)+dt*((-c/m)*x1(i)+(-k/m)*x2(2)+(1/m)*u(i));
%    数値シミュレーション
    if 150<i&&i<200
        [T,X]=ode45(@(t,x) A*x+B*u(i)+[0;0],[0 dt],x);
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

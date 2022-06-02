%　sinの角速度が増加する
tt=0:0.01:30;
A=1;
T=4;
w=2*pi/T;
i=1;
for t=0:0.01:30
    x(i)=A*sin(w*t);
    v(i)=A*w*cos(w*t);
    a(i)=-A*w^2*sin(w*t);
    i=i+1;
end
b=0.1;
% T2=6-b*t;
% w2=2*pi/T;
i=1;
for t=0:0.01:30
    x2(i)=A*sin((2*pi*t)/(6-0.1*t));
    v2(i)=A*(-cos((2*pi*t)/(b*t - 6))*((2*pi)/(b*t - 6) - (2*pi*b*t)/(b*t - 6)^2));
    a2(i)=A*(cos((2*pi*t)/(b*t - 6))*((4*pi*b)/(b*t - 6)^2 - (4*pi*b^2*t)/(b*t - 6)^3) + sin((2*pi*t)/(b*t - 6))*((2*pi)/(b*t - 6) - (2*pi*b*t)/(b*t - 6)^2)^2);
    i=i+1;
end

figure(1)
hold on
plot(tt,x)
plot(tt,v)
plot(tt,a)
plot(tt,x2)
plot(tt,v2)
plot(tt,a2)
legend('x','v','a','x2','v2','a2')
grid on

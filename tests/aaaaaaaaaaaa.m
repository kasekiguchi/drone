x = 0:0.025:10;
rng(0,"twister")
% A = cos(2*pi*0.05*x+2*pi*rand) + 0.5*randn(1,100);
a = 1;
A = a*cos(2*pi*x) + 0.5*randn(1,length(x));

[B,winsize] = smoothdata(A,"gaussian");
winsize

C = smoothdata(A,"gaussian",10);
plot(x,B)
hold on
plot(x,C)
plot(x,A)
% plot(a)
legend("Small Window","Large Window")
hold off

%%
windowSize = 10; 
% b = (1/windowSize)*ones(1,windowSize);
bb=windowSize:-1:1;
b = 0.1./bb;
a = 1;

x = 0:0.025:10;
rng(0,"twister")
A = cos(2*pi*x) + 0.5*randn(1,length(x));

C = filter(b,a,A);
% C = lowpass(A,4,40);

plot(x,A)
hold on
plot(x,C)
legend("Small Window","Large Window")
hold off
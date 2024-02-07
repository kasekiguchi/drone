close all
x = -3:3; 
y = [-1 -1 -1 0 1 1 1]; 
xq1 = -3:.01:3;
p = pchip(x,y,xq1);
s = spline(x,y,xq1);
m = makima(x,y,xq1);


% figure(1);
% plot(x,y,'o',xq1,p,'-',xq1,s,'-.',xq1,m,'--')
% legend('Sample Points','pchip','spline','makima','Location','SouthEast')


x = 0:0.5:4;
y = [2 2 2 1.5 1 0.5 0 0.1 0.2];
xq1 = 0:0.025:5;
m = makima(x,y,xq1);
subplot(3,1,1);
plot(x, y, 'o', xq1, m, '--');
legend("points", "makima");

vm = diff(m);
t = linspace(0, 5, length(vm));
subplot(3,1,2);
plot(t, vm)

vvm = diff(vm);
t = linspace(0, 5, length(vvm));
subplot(3,1,3);
plot(t, vvm)
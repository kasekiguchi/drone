opengl software
close all hidden;

% data.x = log.Data.agent.estimator.result{1}.state.p(1,1);
% data.a = data.x{1}.state.p;

% data.b = size(log.Data.agent.estimator.result,2);

num = 3;
subplot(2, num, 1);
p1 = plot(data.t, data.x);
xlabel('Time [s]');
ylabel('p');
hold on
grid on
p2 = plot(data.t, data.y);
p3 = plot(data.t, data.z);
p4 = plot(data.t, data.xr);
p5 = plot(data.t, data.yr);
p6 = plot(data.t, data.zr);
hold off
title('Position p of agent1');
% 姿勢角
subplot(2, num, 2);
p7 = plot(data.t, data.qx);
xlabel('Time [s]');
ylabel('q');
hold on
grid on
p8 = plot(data.t, data.qy);
p9 = plot(data.t, data.qz);
hold off
title('Attitude q of agent1');
% 速度
subplot(2, num, 3);
p10 = plot(data.t, data.vx);
xlabel('Time [s]');
ylabel('v');
hold on
grid on
p11 = plot(data.t, data.vy);
p12 = plot(data.t, data.vz);
hold off
title('Velocity v of agent1');
% 角速度
subplot(2, num, 4);
p13 = plot(data.t, data.wx);
xlabel('Time [s]');
ylabel('w');
hold on
grid on
p14 = plot(data.t, data.wy);
p15 = plot(data.t, data.wz);
hold off
title('Angular velocity w of agent1');

subplot(2,num,5);
plot(data.x,data.y);
xlabel('x');
ylabel('y');

subplot(2,num,6);
plot3(data.x,data.y,data.z);
xlabel('x');
ylabel('y');
zlabel('z');


set([p4,p5,p6],'LineStyle','--','LineWidth',1);
set([p1,p2,p3,p7,p8,p9,p10,p11,p12,p13,p14,p15],'LineWidth',1);

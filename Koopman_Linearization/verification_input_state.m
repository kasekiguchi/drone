%% input_state()から一定入力を入れたときの出力を得る
clear

% model load
tra = 'saddle';
script = [];
mode.code = '00';
mode.training_data = 'Kiyama';
% mode.training_data = 'KiyamaX20';
% mode.training_data = 'KiyamaX20fromVel';

filename = WhichLoadFile(tra, script, mode);
load(strcat(filename, '.mat'), 'est');

%
step_num = 10;
thrust = 0.5884 * 9.81; % 0.5884 * 9.81 * 1e3
torque = [-0.1; 0.1; 0];
X = input_state({est.A, est.B, est.C, step_num, thrust, torque});

% plot
Fontsize = 15;  
set(0,'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
ylimsetting = [-1e-2 1e-2];

figure(1);
sgtitle(strcat(mode.training_data, ';;thrust:', num2str(thrust), ';;torque: [', num2str(torque(1)), ', ',num2str(torque(2)), ', ', num2str(torque(3)), ']'));
% subplot(2,3,1);
% plot(0:10,X(1:3,:)); grid on;
% xlabel('Step'); ylabel('$$x, y, z$$', 'Interpreter', 'latex');

subplot(1,3,1);
plot(0:step_num,X(1,:)); grid on; ylim(ylimsetting);
xlabel('Step'); ylabel('$$x$$', 'Interpreter', 'latex');

subplot(1,3,2);
plot(0:step_num,X(2,:)); grid on; ylim(ylimsetting);
xlabel('Step'); ylabel('$$y$$', 'Interpreter', 'latex');

subplot(1,3,3);
plot(0:step_num,X(3,:)); grid on; ylim(ylimsetting);
xlabel('Step'); ylabel('$$z$$', 'Interpreter', 'latex');
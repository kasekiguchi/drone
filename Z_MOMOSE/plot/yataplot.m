%まずは現在のフォルダからパスが通っているかを確認

% newLog1 = simplifyLogger(log);
% t = newLog1.t; %t:時間
% phase = newLog1.phase;%phase:アーミングやフライトなどの状態
% k = newLog1.k;%データ数
% rpy = newLog1.sensor.q;%Attitude上からroll,pitch,yawの実測値
% xyz = newLog1.sensor.p;%Position上からz,y,zの実測値
% rpy_est = newLog1.estimator.q;%上からz,y,zの推定値
% xyz_est = newLog1.estimator.p;%上からroll,pitch,yawの推定値
% v_est = newLog1.estimator.v;%速度の推定値
% w_est = newLog1.estimator.w;%角速度の推定値
% rpy_r = newLog1.reference.q;%上からz,y,zの指令値
% xyz_r = newLog1.reference.p;%上からroll,pitch,yawの指令値
% v_r = newLog1.reference.v;%速度の指令値
% input = newLog1.controller.input;%入力
% transmitter_input = newLog1.inner_input;%プロポからの指令

newLog2 = simplifyLogger(log);
t2 = newLog2.t; %t:時間
phase2 = newLog2.phase;%phase:アーミングやフライトなどの状態
k2 = newLog2.k;%データ数
rpy2 = newLog2.sensor.q;%Attitude上からroll,pitch,yawの実測値
xyz2 = newLog2.sensor.p;%Position上からz,y,zの実測値
rpy_est2 = newLog2.estimator.q;%上からz,y,zの推定値
xyz_est2 = newLog2.estimator.p;%上からroll,pitch,yawの推定値
v_est2 = newLog2.estimator.v;%速度の推定値
w_est2 = newLog2.estimator.w;%角速度の推定値
rpy_r2 = newLog2.reference.q;%上からz,y,zの指令値(目標)
xyz_r2 = newLog2.reference.p;%上からroll,pitch,yawの指令値
v_r2 = newLog2.reference.v;%速度の指令値
input2 = newLog2.controller.input;%入力
transmitter_input2 = newLog2.inner_input;%プロポからの指令
% 
% x = xyz(1, :);
% y = xyz(2, :);
% z = xyz(3, :);
x2 = xyz2(1, :);
y2 = xyz2(2, :);
z2 = xyz2(3, :);
% xr = xyz_r(1, :);
% yr = xyz_r(2, :);
% zr = xyz_r(3, :);
xr2 = xyz_r2(1, :);
yr2 = xyz_r2(2, :);
zr2 = xyz_r2(3, :);
% xe(1,:) = xyz_r2(1, :) - xyz(1, :);
% ye(1,:) = xyz_r2(2, :) - xyz(2, :);
% ze(1,:) = xyz_r2(3, :) - xyz(3, :);
% % 
% plot(x, y, '-','LineWidth',3); % '-o'はデータ点をマークするためのオプション
% hold on
% plot(xe, ye, '--','LineWidth',3);
% 
% plot(x2, y2, '-','LineWidth',3);
% plot(xe2, ye2, ':','LineWidth',3);
% pbaspect([1 1 1])
% hold off
% % 
% plot(t, xe, '-','LineWidth',2); % '-o'はデータ点をマークするためのオプション
% hold on
% plot(t, ye, '-','LineWidth',2);
% plot(t, ze, '-','LineWidth',2);
% hold off
% plot(t, xr, '-','LineWidth',2);
% xlabel('Time [s]') 
% ylabel('Status [m]') 
% hold on
% plot(t, yr, '-','LineWidth',2);
% plot(t, zr, '-','LineWidth',2);
% plot(t, x, '--','LineWidth',2);
% plot(t, y, '--','LineWidth',2);
% plot(t, z, '--','LineWidth',2);
% legend('x','y','z','x-ref','y-ref','z-ref')
% xlim([0 inf]) 
% hold off

plot(t2, xr2, '-','LineWidth',2);
xlabel('Time [s]') 
ylabel('Status [m]') 
hold on
plot(t2, yr2, '-','LineWidth',2);
plot(t2, zr2, '-','LineWidth',2);
plot(t2, x2, '--','LineWidth',2);
plot(t2, y2, '--','LineWidth',2);
plot(t2, z2, '--','LineWidth',2);
legend('x','y','z','x-ref','y-ref','z-ref')
xlim([0 inf]) 
hold off


% plot(t2, x2, '-','LineWidth',2); % '-o'はデータ点をマークするためのオプション
% hold on
% plot(t2, y2, '-','LineWidth',2);
% plot(t2, z2, '-','LineWidth',2);
% plot(t2, xr2, '--','LineWidth',2);
% plot(t2, xr2, '--','LineWidth',2);
% plot(t2, xr2, '--','LineWidth',2);
% 
% hold off
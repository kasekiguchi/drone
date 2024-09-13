%まずは現在のフォルダからパスが通っているかを確認
%%
newLog1 = simplifyLogger(log);
t = newLog1.t; %t:時間
phase = newLog1.phase;%phase:アーミングやフライトなどの状態
k = newLog1.k;%データ数
rpy = newLog1.sensor.q;%Attitude上からroll,pitch,yawの実測値
xyz = newLog1.sensor.p;%Position上からz,y,zの実測値
rpy_est = newLog1.estimator.q;%上からz,y,zの推定値
xyz_est = newLog1.estimator.p;%上からroll,pitch,yawの推定値
v_est = newLog1.estimator.v;%速度の推定値
w_est = newLog1.estimator.w;%角速度の推定値
rpy_r = newLog1.reference.q;%上からz,y,zの指令値
xyz_r = newLog1.reference.p;%上からroll,pitch,yawの指令値
v_r = newLog1.reference.v;%速度の指令値
input = newLog1.controller.input;%入力
transmitter_input = newLog1.inner_input;%プロポからの指令
%%
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

%%
%それぞれのlogのデータの詳しい抜き出し

roll_s = rpy(1, :);
pitch_s = rpy(2, :);
yaw_s = rpy(3, :);
x_s = xyz(1, :);
y_s = xyz(2, :);
z_s = xyz(3, :);
roll_est = rpy_est(1, :);
pitch_est = rpy_est(2, :);
yaw_est = rpy_est(3, :);
x_est = xyz_est(1, :);
y_est = xyz_est(2, :);
z_est = xyz_est(3, :);
vx_est = v_est(1, :);
vy_est = v_est(2, :);
vz_est = v_est(3, :);
wx_est = w_est(1, :);
wy_est = w_est(2, :);
wz_est = w_est(3, :);
roll_ref = rpy_r(1, :);
pitch_ref = rpy_r(2, :);
yaw_ref = rpy_r(3, :);
x_ref = xyz_r(1, :);
y_ref = xyz_r(2, :);
z_ref = xyz_r(3, :);
vx_ref = v_r(1, :);
vy_ref = v_r(2, :);
vz_ref = v_r(3, :);

roll_s2 = rpy2(1, :);
pitch_s2 = rpy2(2, :);
yaw_s2 = rpy2(3, :);
x_s2 = xyz2(1, :);
y_s2 = xyz2(2, :);
z_s2 = xyz2(3, :);
roll_est2 = rpy_est2(1, :);
pitch_est2 = rpy_est2(2, :);
yaw_est2 = rpy_est2(3, :);
x_est2 = xyz_est2(1, :);
y_est2 = xyz_est2(2, :);
z_est2 = xyz_est2(3, :);
vx_est2 = v_est2(1, :);
vy_est2 = v_est2(2, :);
vz_est2 = v_est2(3, :);
wx_est2 = w_est2(1, :);
wy_est2 = w_est2(2, :);
wz_est2 = w_est2(3, :);
roll_ref2 = rpy_r2(1, :);
pitch_ref2 = rpy_r2(2, :);
yaw_ref2 = rpy_r2(3, :);
x_ref2 = xyz_r2(1, :);
y_ref2 = xyz_r2(2, :);
z_ref2 = xyz_r2(3, :);
vx_ref2 = v_r2(1, :);
vy_ref2 = v_r2(2, :);
vz_ref2 = v_r2(3, :);
%%
%xyの軌道と目標軌道の比較
figure;
plot(x_est, y_est, '-','LineWidth',2);
grid on
xlabel('X[m]') 
ylabel('Y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-1.5 1.5])
ylim([-1.5 1.5])
hold on
plot(x_ref, y_ref, '--','LineWidth',2);
legend('Estimater','Reference','fontsize',12)
hold off

figure;
plot(x_est2, y_est2, '-','LineWidth',2);
grid on
xlabel('X[m]') 
ylabel('Y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-1.5 1.5])
ylim([-1.5 1.5])
hold on
plot(x_ref2, y_ref2, '--','LineWidth',2);
legend('Estimater','Reference','fontsize',12)
hold off

%%
%xyzの時間変化による目標軌道との比較
figure;
plot(t, x_est, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
hold on
plot(t, y_est, '-','LineWidth',2);
plot(t, z_est, '-','LineWidth',2);
plot(t, x_ref, '--','LineWidth',2);
plot(t, y_ref, '--','LineWidth',2);
plot(t, z_ref, '--','LineWidth',2);
legend('X-estimator','Y-estimator','Z-estimator', ...
    'X-reference','Y-reference','Z-reference','Location', ...
    'southwest','fontsize',12)
hold off

figure;
plot(t2, x_est2, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
hold on
plot(t2, y_est2, '-','LineWidth',2);
plot(t2, z_est2, '-','LineWidth',2);
plot(t2, x_ref2, '--','LineWidth',2);
plot(t2, y_ref2, '--','LineWidth',2);
plot(t2, z_ref2, '--','LineWidth',2);
legend('X-estimator','Y-estimator','Z-estimator', ...
    'X-reference','Y-reference','Z-reference','Location', ...
    'southwest','fontsize',12)
hold off

a = 1;

while a <= k
    x_error(1,a) = x_est(1,a) - x_ref(1,a);
    y_error(1,a) = y_est(1,a) - y_ref(1,a);
    z_error(1,a) = z_est(1,a) - z_ref(1,a);
    a = a + 1;
end

b = 1;

while b <= k2
    x_error2(1,b) = x_est2(1,b) - x_ref2(1,b);
    y_error2(1,b) = y_est2(1,b) - y_ref2(1,b);
    z_error2(1,b) = z_est2(1,b) - z_ref2(1,b);
    b = b + 1;
end

figure;
plot(t, x_error, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
hold on
plot(t, y_error, '-','LineWidth',2);
plot(t, z_error, '-','LineWidth',2);
legend('X-error','Y-error','Z-error','Location', ...
    'southwest','fontsize',12)
hold off

figure;
plot(t2, x_error2, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
hold on
plot(t2, y_error2, '-','LineWidth',2);
plot(t2, z_error2, '-','LineWidth',2);
legend('X-error','Y-error','Z-error','Location', ...
    'southwest','fontsize',12)
hold off

%%
%vの時間変化による目標速度との比較
figure;
plot(t, vx_est, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
hold on
plot(t, vy_est, '-','LineWidth',2);
plot(t, vz_est, '-','LineWidth',2);
plot(t, vx_ref, '--','LineWidth',2);
plot(t, vy_ref, '--','LineWidth',2);
plot(t, vz_ref, '--','LineWidth',2);
legend('VX-estimator','VY-estimator','VZ-estimator', ...
    'VX-reference','VY-reference','VZ-reference','Location', ...
    'southwest','fontsize',12)
hold off

figure;
plot(t2, vx_est2, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
hold on
plot(t2, vy_est2, '-','LineWidth',2);
plot(t2, vz_est2, '-','LineWidth',2);
plot(t2, vx_ref2, '--','LineWidth',2);
plot(t2, vy_ref2, '--','LineWidth',2);
plot(t2, vz_ref2, '--','LineWidth',2);
legend('VX-sensor','VY-sensor','VZ-sensor', ...
    'VX-estimator','VY-estimator','VZ-estimator','Location', ...
    'southwest','fontsize',12)
hold off

a = 1;

while a <= k
    vx_error(1,a) = vx_est(1,a) - vx_ref(1,a);
    vy_error(1,a) = vy_est(1,a) - vy_ref(1,a);
    vz_error(1,a) = vz_est(1,a) - vz_ref(1,a);
    a = a + 1;
end

b = 1;

while b <= k2
    vx_error2(1,b) = vx_est2(1,b) - vx_ref2(1,b);
    vy_error2(1,b) = vy_est2(1,b) - vy_ref2(1,b);
    vz_error2(1,b) = vz_est2(1,b) - vz_ref2(1,b);
    b = b + 1;
end

figure;
plot(t, vx_error, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
ylim([-1 1])
hold on
plot(t, vy_error, '-','LineWidth',2);
plot(t, vz_error, '-','LineWidth',2);
legend('VX-error','VY-error','VZ-error','Location', ...
    'southwest','fontsize',12)
hold off

figure;
plot(t2, vx_error2, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([0 inf])
ylim([-1 1])
hold on
plot(t2, vy_error2, '-','LineWidth',2);
plot(t2, vz_error2, '-','LineWidth',2);
legend('VX-error','VY-error','VZ-error','Location', ...
    'southwest','fontsize',12)
hold off

%%
%xyの軌道と目標軌道の比較:flightのみ抜き出し
aa = 1;
ba = height(phase);
while aa <= ba
    if phase(aa,1) == 102
        x_est_sel = x_est(1:aa);
        y_est_sel = y_est(1:aa);
        x_ref_sel = x_ref(1:aa);
        y_ref_sel = y_ref(1:aa);
    end
    aa = aa + 1;
end
figure;
plot(x_est_sel, y_est_sel, '-','LineWidth',2);
grid on
xlabel('X[m]') 
ylabel('Y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-1.5 1.5])
ylim([-1.5 1.5])
hold on
plot(x_ref_sel, y_ref_sel, '--','LineWidth',2);
legend('Estimater','Reference','fontsize',12)
hold off

% figure;
% plot(x_est2, y_est2, '-','LineWidth',2);
% grid on
% xlabel('X[m]') 
% ylabel('Y[m]')
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% daspect([1 1 1])
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
% hold on
% plot(x_ref2, y_ref2, '--','LineWidth',2);
% legend('Estimater','Reference','fontsize',12)
% hold off

%%
%xyzの時間変化による目標軌道との比較
aa = 1;
ba = height(t);
x_est_sel = [];
y_est_sel = [];
z_est_sel = [];
x_ref_sel = [];
y_ref_sel = [];
z_ref_sel = [];
t_sel = [];
while aa <= ba
    if phase(aa,1) == 102
        x_est_sel = [x_est_sel,x_est(1,aa)];
        y_est_sel = [y_est_sel,y_est(1,aa)];
        z_est_sel = [z_est_sel,z_est(1,aa)];
        x_ref_sel = [x_ref_sel,x_ref(1,aa)];
        y_ref_sel = [y_ref_sel,y_ref(1,aa)];
        z_ref_sel = [z_ref_sel,z_ref(1,aa)];
        t_sel = [t_sel,t(aa,1)];
    end
    aa = aa + 1;
end

figure;
plot(t_sel, x_est_sel, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel(1,1) inf])
hold on
plot(t_sel, y_est_sel, '-','LineWidth',2);
plot(t_sel, z_est_sel, '-','LineWidth',2);
plot(t_sel, x_ref_sel, '--','LineWidth',2);
plot(t_sel, y_ref_sel, '--','LineWidth',2);
plot(t_sel, z_ref_sel, '--','LineWidth',2);
legend('X-estimator','Y-estimator','Z-estimator', ...
    'X-reference','Y-reference','Z-reference','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

% aa2 = 1;
% ba2 = height(t);
% x_est2_sel = [];
% y_est2_sel = [];
% z_est2_sel = [];
% x_ref2_sel = [];
% y_ref2_sel = [];
% z_ref2_sel = [];
% t2_sel = [];
% 
% figure;
% plot(t2_sel, x_est2_sel, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([0 inf])
% hold on
% plot(t2_sel, y_est2_sel, '-','LineWidth',2);
% plot(t2_sel, z_est2_sel, '-','LineWidth',2);
% plot(t2_sel, x_ref2_sel, '--','LineWidth',2);
% plot(t2_sel, y_ref2_sel, '--','LineWidth',2);
% plot(t2_sel, z_ref2_sel, '--','LineWidth',2);
% legend('X-estimator','Y-estimator','Z-estimator', ...
%     'X-reference','Y-reference','Z-reference','Location', ...
%     'southwest','fontsize',12)
% hold off
% 
a = 1;
x_error_sel = [];
y_error_sel = [];
z_error_sel = [];
while a <= size(t_sel)
    x_error_sel = x_est_sel(1,a) - x_ref_sel(1,a);
    y_error_sel = y_est_sel(1,a) - y_ref_sel(1,a);
    z_error_sel = z_est_sel(1,a) - z_ref_sel(1,a);
    a = a + 1;
end
% 
% b = 1;
% 
% while b <= size(t2_sel)
%     x_error2_sel(1,b) = x_est2_sel(1,b) - x_ref2_sel(1,b);
%     y_error2_sel(1,b) = y_est2_sel(1,b) - y_ref2_sel(1,b);
%     z_error2_sel(1,b) = z_est2_sel(1,b) - z_ref2_sel(1,b);
%     b = b + 1;
% end
% 
figure;
plot(t_sel, x_error_sel, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel(1,1) inf])
hold on
plot(t_sel, y_error_sel, '-','LineWidth',2);
plot(t_sel, z_error_sel, '-','LineWidth',2);
legend('X-error','Y-error','Z-error','Location', ...
    'southwest','fontsize',8)
hold off
% 
% figure;
% plot(t2_sel, x_error2_sel, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([0 inf])
% hold on
% plot(t2_sel, y_error2_sel, '-','LineWidth',2);
% plot(t2_sel, z_error2_sel, '-','LineWidth',2);
% legend('X-error','Y-error','Z-error','Location', ...
%     'southwest','fontsize',12)
% hold off
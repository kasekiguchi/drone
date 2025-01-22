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
input_roll = input(1,:);
input_pitch = input(2,:);
input_throttle = input(3,:);
input_yaw = input(4,:);
inputtran_roll = transmitter_input(1,:);
inputtran_pitch = transmitter_input(2,:);
inputtran_throttle = transmitter_input(3,:);
inputtran_yaw = transmitter_input(4,:);

%%
%計算の下準備　現在位置と速度あり
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
    if phase(aa,1) == 116
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

aa = 1;
ba = height(t);
roll_est_sel = [];
pitch_est_sel = [];
yaw_est_sel = [];
roll_ref_sel = [];
pitch_ref_sel = [];
yaw_ref_sel = [];
t_sel = [];
while aa <= ba
    if phase(aa,1) == 116
        roll_est_sel = [roll_est_sel,roll_est(1,aa)];
        pitch_est_sel = [pitch_est_sel,pitch_est(1,aa)];
        yaw_est_sel = [yaw_est_sel,yaw_est(1,aa)];
        roll_ref_sel = [roll_ref_sel,roll_ref(1,aa)];
        pitch_ref_sel = [pitch_ref_sel,pitch_ref(1,aa)];
        yaw_ref_sel = [yaw_ref_sel,yaw_ref(1,aa)];
        t_sel = [t_sel,t(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t);
input_roll_sell = [];
input_pitch_sell = [];
input_throttle_sell = [];
input_yaw_sell = [];
inputtran_roll_sell = [];
inputtran_pitch_sell = [];
inputtran_throttle_sell = [];
inputtran_yaw_sell = [];
t_sel = [];
while aa <= ba
    if phase(aa,1) == 116
        input_roll_sell = [input_roll_sell,input_roll(1,aa)];
        input_pitch_sell = [input_pitch_sell,input_pitch(1,aa)];
        input_throttle_sell = [input_throttle_sell,input_throttle(1,aa)];
        input_yaw_sell = [input_yaw_sell,input_yaw(1,aa)];
        inputtran_roll_sell = [inputtran_roll_sell,inputtran_roll(1,aa)];
        inputtran_pitch_sell = [inputtran_pitch_sell,inputtran_pitch(1,aa)];
        inputtran_throttle_sell = [inputtran_throttle_sell,inputtran_throttle(1,aa)];
        inputtran_yaw_sell = [inputtran_yaw_sell,inputtran_yaw(1,aa)];
        t_sel = [t_sel,t(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t);
vx_est_sel = [];
vy_est_sel = [];
vz_est_sel = [];
vx_ref_sel = [];
vy_ref_sel = [];
vz_ref_sel = [];
t_sel = [];
while aa <= ba
    if phase(aa,1) == 116
        vx_est_sel = [vx_est_sel,vx_est(1,aa)];
        vy_est_sel = [vy_est_sel,vy_est(1,aa)];
        vz_est_sel = [vz_est_sel,vz_est(1,aa)];
        vx_ref_sel = [vx_ref_sel,vx_ref(1,aa)];
        vy_ref_sel = [vy_ref_sel,vy_ref(1,aa)];
        vz_ref_sel = [vz_ref_sel,vz_ref(1,aa)];
        t_sel = [t_sel,t(aa,1)];
    end
    aa = aa + 1;
end

%% 収束後　位置


% 収束時間を計算するための変数
ftime = 0;      % 収束時間の初期化
shuti = 0;

for i = 1:length(vx_est_sel)
    % 現在の誤差が収束閾値を満たしているか確認
    if t_sel(i) > 14 && ftime == 0
        
            convergence_start_time = t_sel(i);  % 収束開始時刻を設定
            shuti = i;                % 収束開始行を記録
            ftime = 1;
    end
end


% 収束時刻以降のデータ
trajectory_x_1_post_convergence = x_est_sel(shuti:end);
trajectory_y_1_post_convergence = y_est_sel(shuti:end);
trajectory_z_1_post_convergence = z_est_sel(shuti:end);
t_1_post_convergence = t_sel(shuti:end);

reference_x_1_post_convergence = x_ref_sel(shuti:end);
reference_y_1_post_convergence = y_ref_sel(shuti:end);
reference_z_1_post_convergence = z_ref_sel(shuti:end);

%誤差の計算
%位置
er_x_1 = mean(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
er_y_1 = mean(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
er_z_1 = mean(trajectory_z_1_post_convergence - reference_z_1_post_convergence);
er_x_1_fig = trajectory_x_1_post_convergence - reference_x_1_post_convergence;
er_y_1_fig = trajectory_y_1_post_convergence - reference_y_1_post_convergence;
er_z_1_fig = trajectory_z_1_post_convergence - reference_z_1_post_convergence;

% MSEの計算
%位置
% mse_x_1 = mean((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2);
% mse_y_1 = mean((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2);
% mse_z_1 = mean((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2);
% mse_x_1_fig = (trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2;
% mse_y_1_fig = (trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2;
% mse_z_1_fig = (trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2;

% RMSEの計算
%位置
rmse_x_1 = sqrt(mean((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2));
rmse_y_1 = sqrt(mean((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2));
rmse_z_1 = sqrt(mean((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2));
rmse_x_1_fig = sqrt((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2);
rmse_y_1_fig = sqrt((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2);
rmse_z_1_fig = sqrt((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2);

% MAEの計算
%位置
% mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
% mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
% mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
% mae_x_1_fig = abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
% mae_y_1_fig = abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
% mae_z_1_fig = abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence);

%最大誤差
max_error_x_1 = max(abs(x_est_sel(shuti:end) - x_ref_sel(shuti:end)));
max_error_y_1 = max(abs(y_est_sel(shuti:end) - y_ref_sel(shuti:end)));
max_error_z_1 = max(abs(z_est_sel(shuti:end) - z_ref_sel(shuti:end)));

% 結果を表示
fprintf('軌道x_1の収束後の位置誤差: %f\n', er_x_1);
fprintf('軌道y_1の収束後の位置誤差: %f\n', er_y_1);
fprintf('軌道z_1の収束後の位置誤差: %f\n', er_z_1);
% fprintf('軌道x_1の収束後の位置MSE: %f\n', mse_x_1);
% fprintf('軌道y_1の収束後の位置MSE: %f\n', mse_y_1);
% fprintf('軌道z_1の収束後の位置MSE: %f\n', mse_z_1);
fprintf('軌道x_1の収束後の位置RMSE: %f\n', rmse_x_1);
fprintf('軌道y_1の収束後の位置RMSE: %f\n', rmse_y_1);
fprintf('軌道z_1の収束後の位置RMSE: %f\n', rmse_z_1);
% fprintf('軌道x_1の収束後の位置MAE: %f\n', mae_x_1);
% fprintf('軌道y_1の収束後の位置MAE: %f\n', mae_y_1);
% fprintf('軌道z_1の収束後の位置MAE: %f\n', mae_z_1);
fprintf('軌道x_1の収束後の位置最大誤差: %f\n', max_error_x_1);
fprintf('軌道y_1の収束後の位置最大誤差: %f\n', max_error_y_1);
fprintf('軌道z_1の収束後の位置最大誤差: %f\n', max_error_z_1);
itigosa = [er_x_1;er_y_1;er_z_1;rmse_x_1;rmse_y_1;rmse_z_1;max_error_x_1;max_error_y_1;max_error_z_1];
% % xy
figure;
plot(x_est_sel(shuti:end), y_est_sel(shuti:end), '-','LineWidth',2);
grid on
xlabel('X[m]') 
ylabel('Y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-1.5 1.5])
ylim([-1.5 1.5])
hold on
plot(x_ref_sel(shuti:end), y_ref_sel(shuti:end), '--','LineWidth',2);
legend('Estimater','Reference','fontsize',12)
hold off
% % % xyz
% plot3(x_est_sel(convergence_time_index:end), y_est_sel(convergence_time_index:end), z_est_sel(convergence_time_index:end),  '-','LineWidth', 2);  % 軌道の太さを指定
% grid on                         % グリッドを表示
% xlabel('X[m]','FontSize',12) 
% ylabel('Y[m]','FontSize',12)
% zlabel('Z[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% set(gca().ZAxis, 'Fontsize', 12)
% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
% zlim([0 1.5])
% pbaspect([1 1 1])
% hold on
% plot3(x_ref_sel(convergence_time_index:end), y_ref_sel(convergence_time_index:end), z_ref_sel(convergence_time_index:end), '--', 'LineWidth', 2)
% legend('Estimator','Reference','Location', ...
%     'southwest','fontsize',8)
% hold off

%推定値と目標値
figure;
plot(t_1_post_convergence,x_est_sel(shuti:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1.5 1.5])
hold on
plot(t_1_post_convergence,x_ref_sel(shuti:end), '--','LineWidth',2);
plot(t_1_post_convergence,y_est_sel(shuti:end), '-','LineWidth',2);
plot(t_1_post_convergence,y_ref_sel(shuti:end), '--','LineWidth',2);
plot(t_1_post_convergence,z_est_sel(shuti:end), '-','LineWidth',2);
plot(t_1_post_convergence,z_ref_sel(shuti:end), '--','LineWidth',2);
legend('x.est','x.ref','y.est','y.ref','z.est', ...
    'z.ref','Location', ...
    'northeast','fontsize',12,'NumColumns',3)
hold off

%誤差
figure;
plot(t_1_post_convergence,er_x_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,er_y_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,er_z_1_fig(1:end), '-','LineWidth',2);
legend('x.error','y.error','z.error','Location', ...
    'northeast','fontsize',12,'NumColumns',2)
hold off

% %MSE
% figure;
% plot(t_1_post_convergence,mse_x_1_fig(1:end), '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m^2]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_1_post_convergence(1,1) inf])
% ylim([-0.4 0.4])
% hold on
% plot(t_1_post_convergence,mse_y_1_fig(1:end), '-','LineWidth',2);
% plot(t_1_post_convergence,mse_z_1_fig(1:end), '-','LineWidth',2);
% legend('x.error','y.error','z.error','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

%RMSE
figure;
plot(t_1_post_convergence,rmse_x_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([0 0.4])
hold on
plot(t_1_post_convergence,rmse_y_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,rmse_z_1_fig(1:end), '-','LineWidth',2);
legend('x.error','y.error','z.error','Location', ...
    'northeast','fontsize',12,'NumColumns',2)
hold off

% %MAE
% figure;
% plot(t_1_post_convergence,mae_x_1_fig(1:end), '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_1_post_convergence(1,1) inf])
% ylim([-0.4 0.4])
% hold on
% plot(t_1_post_convergence,mae_y_1_fig(1:end), '-','LineWidth',2);
% plot(t_1_post_convergence,mae_z_1_fig(1:end), '-','LineWidth',2);
% legend('x.error','y.error','z.error','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

%% 収束後　速度

ftime = 0;      % 収束時間の初期化
shuti = 0;

for i = 1:length(vx_est_sel)
    % 現在の誤差が収束閾値を満たしているか確認
    if t_sel(i) > 14 && ftime == 0
        
            convergence_start_time = t_sel(i);  % 収束開始時刻を設定
            shuti = i;                % 収束開始行を記録
            ftime = 1;
    end
end

% 収束時刻以降のデータ
trajectory_vx_1_post_convergence = vx_est_sel(shuti:end);
trajectory_vy_1_post_convergence = vy_est_sel(shuti:end);
trajectory_vz_1_post_convergence = vz_est_sel(shuti:end);
t_1_post_convergence = t_sel(shuti:end);

reference_vx_1_post_convergence = vx_ref_sel(shuti:end);
reference_vy_1_post_convergence = vy_ref_sel(shuti:end);
reference_vz_1_post_convergence = vz_ref_sel(shuti:end);

%誤差の計算
%速度
er_vx_1 = mean(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence);
er_vy_1 = mean(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence);
er_vz_1 = mean(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence);
er_vx_1_fig = trajectory_vx_1_post_convergence - reference_vx_1_post_convergence;
er_vy_1_fig = trajectory_vy_1_post_convergence - reference_vy_1_post_convergence;
er_vz_1_fig = trajectory_vz_1_post_convergence - reference_vz_1_post_convergence;

% % MSEの計算
% %速度
% mse_vx_1 = mean((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2);
% mse_vy_1 = mean((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2);
% mse_vz_1 = mean((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2);
% mse_vx_1_fig = (trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2;
% mse_vy_1_fig = (trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2;
% mse_vz_1_fig = (trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2;

% RMSEの計算
%速度
rmse_vx_1 = sqrt(mean((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2));
rmse_vy_1 = sqrt(mean((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2));
rmse_vz_1 = sqrt(mean((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2));
rmse_vx_1_fig = sqrt((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2);
rmse_vy_1_fig = sqrt((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2);
rmse_vz_1_fig = sqrt((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2);

% % MAEの計算
% %速度
% mae_vx_1 = mean(abs(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence));
% mae_vy_1 = mean(abs(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence));
% mae_vz_1 = mean(abs(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence));
% mae_vx_1_fig = abs(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence);
% mae_vy_1_fig = abs(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence);
% mae_vz_1_fig = abs(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence);

%最大誤差
max_error_vx_1 = max(abs(vx_est_sel(shuti:end) - vx_ref_sel(shuti:end)));
max_error_vy_1 = max(abs(vy_est_sel(shuti:end) - vy_ref_sel(shuti:end)));
max_error_vz_1 = max(abs(vz_est_sel(shuti:end) - vz_ref_sel(shuti:end)));

% 結果を表示
fprintf('速度vx_1の収束後の速度誤差: %f\n', er_vx_1);
fprintf('速度vy_1の収束後の速度誤差: %f\n', er_vy_1);
fprintf('速度vz_1の収束後の速度誤差: %f\n', er_vz_1);
% fprintf('速度vx_1の収束後の速度MSE: %f\n', mse_vx_1);
% fprintf('速度vy_1の収束後の速度MSE: %f\n', mse_vy_1);
% fprintf('速度vz_1の収束後の速度MSE: %f\n', mse_vz_1);
fprintf('速度vx_1の収束後の速度RMSE: %f\n', rmse_vx_1);
fprintf('速度vy_1の収束後の速度RMSE: %f\n', rmse_vy_1);
fprintf('速度vz_1の収束後の速度RMSE: %f\n', rmse_vz_1);
% fprintf('速度vx_1の収束後の速度MAE: %f\n', mae_vx_1);
% fprintf('速度vy_1の収束後の速度MAE: %f\n', mae_vy_1);
% fprintf('速度vz_1の収束後の速度MAE: %f\n', mae_vz_1);
fprintf('速度vx_1の収束後の速度最大誤差: %f\n', max_error_vx_1);
fprintf('速度vy_1の収束後の速度最大誤差: %f\n', max_error_vy_1);
fprintf('速度vz_1の収束後の速度最大誤差: %f\n', max_error_vz_1);
sokudogosa = [er_vx_1;er_vy_1;er_vz_1;rmse_vx_1;rmse_vy_1;rmse_vz_1;max_error_vx_1;max_error_vy_1;max_error_vz_1];
%推定値と目標値
figure;
plot(t_1_post_convergence,vx_est_sel(shuti:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1 1])
hold on
plot(t_1_post_convergence,vx_ref_sel(shuti:end), '--','LineWidth',2);
plot(t_1_post_convergence,vy_est_sel(shuti:end), '-','LineWidth',2);
plot(t_1_post_convergence,vy_ref_sel(shuti:end), '--','LineWidth',2);
plot(t_1_post_convergence,vz_est_sel(shuti:end), '-','LineWidth',2);
plot(t_1_post_convergence,vz_ref_sel(shuti:end), '--','LineWidth',2);
legend('v_x.est','v_x.ref','v_y.est','v_y.ref','v_z.est', ...
    'v_z.ref','Location', ...
    'northeast','fontsize',12,'NumColumns',3)
hold off

%誤差
figure;
plot(t_1_post_convergence,er_vx_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.3 0.3])
hold on
plot(t_1_post_convergence,er_vy_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,er_vz_1_fig(1:end), '-','LineWidth',2);
legend('v_x.error','v_y.error','v_z.error','Location', ...
    'northeast','fontsize',12,'NumColumns',2)
hold off

% %MSE
% figure;
% plot(t_1_post_convergence,mse_vx_1_fig(1:end), '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Velocity[(m/s)^2]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_1_post_convergence(1,1) inf])
% ylim([-0.4 0.4])
% hold on
% plot(t_1_post_convergence,mse_vy_1_fig(1:end), '-','LineWidth',2);
% plot(t_1_post_convergence,mse_vz_1_fig(1:end), '-','LineWidth',2);
% legend('v_x.error','v_y.error','v_z.error','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

%RMSE
figure;
plot(t_1_post_convergence,rmse_vx_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([0 0.3])
hold on
plot(t_1_post_convergence,rmse_vy_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,rmse_vz_1_fig(1:end), '-','LineWidth',2);
legend('v_x.error','v_y.error','v_z.error','Location', ...
    'northeast','fontsize',12,'NumColumns',2)
hold off

% %MAE
% figure;
% plot(t_1_post_convergence,mae_vx_1_fig(1:end), '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Velocity[m/s]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_1_post_convergence(1,1) inf])
% ylim([-0.4 0.4])
% hold on
% plot(t_1_post_convergence,mae_vy_1_fig(1:end), '-','LineWidth',2);
% plot(t_1_post_convergence,mae_vz_1_fig(1:end), '-','LineWidth',2);
% legend('v_x.error','v_y.error','v_z.error','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

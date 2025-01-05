%まずは現在のフォルダからパスが通っているかを確認
%%
%セクションの実行
% newLog1 = LOGGER("Data/20241119_1524_kizon_double_Log(19-Nov-2024_15_24_43).mat");
% logging(newLog1, newLog1.Data.t, 102, 1:2)
% data = return_state_prop(newLog1)
newLog1 = simplifyLogger(log);
%機体1と機体2
% [newLog1,newLog2] = simplifyLogger(log);
t_1 = newLog1.t; %t:時間
phase_1 = newLog1.phase;%phase:アーミングやフライトなどの状態
k_1 = newLog1.k;%データ数
rpy_s1 = newLog1.sensor.q;%Attitude上からroll,pitch,yawの実測値
xyz_s1 = newLog1.sensor.p;%Position上からz,y,zの実測値
rpy_est1 = newLog1.estimator.q;%上からz,y,zの推定値
xyz_est1 = newLog1.estimator.p;%上からroll,pitch,yawの推定値
v_est1 = newLog1.estimator.v;%速度の推定値
w_est1 = newLog1.estimator.w;%角速度の推定値
rpy_r1 = newLog1.reference.q;%上からz,y,zの指令値
xyz_r1 = newLog1.reference.p;%上からroll,pitch,yawの指令値
v_r1 = newLog1.reference.v;%速度の指令値
input_1 = newLog1.controller.input;%入力
transmitterinput_1 = newLog1.inner_input;%プロポからの指令

%%
%セクションの実行
%機体1と機体2のlogデータの詳しい抜き出し
roll_s1 = rpy_s1(1, :);
pitch_s1 = rpy_s1(2, :);
yaw_s1 = rpy_s1(3, :);
x_s1 = xyz_s1(1, :);
y_s1 = xyz_s1(2, :);
z_s1 = xyz_s1(3, :);
roll_est1 = rpy_est1(1, :);
pitch_est1 = rpy_est1(2, :);
yaw_est1 = rpy_est1(3, :);
x_est1 = xyz_est1(1, :);
y_est1 = xyz_est1(2, :);
z_est1 = xyz_est1(3, :);
vx_est1 = v_est1(1, :);
vy_est1 = v_est1(2, :);
vz_est1 = v_est1(3, :);
wx_est1 = w_est1(1, :);
wy_est1 = w_est1(2, :);
wz_est1 = w_est1(3, :);
roll_ref1 = rpy_r1(1, :);
pitch_ref1 = rpy_r1(2, :);
yaw_ref1 = rpy_r1(3, :);
x_ref1 = xyz_r1(1, :);
y_ref1 = xyz_r1(2, :);
z_ref1 = xyz_r1(3, :);
vx_ref1 = v_r1(1, :);
vy_ref1 = v_r1(2, :);
vz_ref1 = v_r1(3, :);
inproll_1 = input_1(1,:);
inppitch_1 = input_1(2,:);
inpthrottle_1 = input_1(3,:);
inpyaw_1 = input_1(4,:);
in_inproll_1 = transmitterinput_1(1,:);
in_inppitch_1 = transmitterinput_1(2,:);
in_inpthrottle_1 = transmitterinput_1(3,:);
in_inpyaw_1 = transmitterinput_1(4,:);
in_AUX1_1 = transmitterinput_1(5,:);
in_AUX2_1 = transmitterinput_1(6,:);
in_AUX3_1 = transmitterinput_1(7,:);
in_AUX4_1 = transmitterinput_1(8,:);

%%
%機体1と機体2の計算の下準備
%1p
aa = 1;
ba = height(t_1);
x_est_sel1 = [];
y_est_sel1 = [];
z_est_sel1 = [];
x_ref_sel1 = [];
y_ref_sel1 = [];
z_ref_sel1 = [];
t_sel1 = [];
while aa <= ba
    if phase_1(aa,1) == 102
        x_est_sel1 = [x_est_sel1,x_est1(1,aa)];
        y_est_sel1 = [y_est_sel1,y_est1(1,aa)];
        z_est_sel1 = [z_est_sel1,z_est1(1,aa)];
        x_ref_sel1 = [x_ref_sel1,x_ref1(1,aa)];
        y_ref_sel1 = [y_ref_sel1,y_ref1(1,aa)];
        z_ref_sel1 = [z_ref_sel1,z_ref1(1,aa)];
        t_sel1 = [t_sel1,t_1(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_1);
roll_est_sel1 = [];
pitch_est_sel1 = [];
yaw_est_sel1 = [];
roll_ref_sel1 = [];
pitch_ref_sel1 = [];
yaw_ref_sel1 = [];
t_sel1 = [];
while aa <= ba
    if phase_1(aa,1) == 102
        roll_est_sel1 = [roll_est_sel1,roll_est1(1,aa)];
        pitch_est_sel1 = [pitch_est_sel1,pitch_est1(1,aa)];
        yaw_est_sel1 = [yaw_est_sel1,yaw_est1(1,aa)];
        roll_ref_sel1 = [roll_ref_sel1,roll_ref1(1,aa)];
        pitch_ref_sel1 = [pitch_ref_sel1,pitch_ref1(1,aa)];
        yaw_ref_sel1 = [yaw_ref_sel1,yaw_ref1(1,aa)];
        t_sel1 = [t_sel1,t_1(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_1);
input_roll_sel1 = [];
input_pitch_sel1 = [];
input_throttle_sel1 = [];
input_yaw_sel1 = [];
ininput_roll_sel1 = [];
ininput_pitch_sel1 = [];
ininput_throttle_sel1 = [];
ininput_yaw_sel1 = [];
ininput_AUX1_sel1 = [];
ininput_AUX2_sel1 = [];
ininput_AUX3_sel1 = [];
ininput_AUX4_sel1 = [];
t_sel1 = [];
while aa <= ba
    if phase_1(aa,1) == 102
        input_roll_sel1 = [input_roll_sel1,inproll_1(1,aa)];
        input_pitch_sel1 = [input_pitch_sel1,inppitch_1(1,aa)];
        input_throttle_sel1 = [input_throttle_sel1,inpthrottle_1(1,aa)];
        input_yaw_sel1 = [input_yaw_sel1,inpyaw_1(1,aa)];
        ininput_roll_sel1 = [ininput_roll_sel1,in_inproll_1(1,aa)];
        ininput_pitch_sel1 = [ininput_pitch_sel1,in_inppitch_1(1,aa)];
        ininput_throttle_sel1 = [ininput_throttle_sel1,in_inpthrottle_1(1,aa)];
        ininput_yaw_sel1 = [ininput_yaw_sel1,in_inpyaw_1(1,aa)];
        ininput_AUX1_sel1 = [ininput_AUX1_sel1,in_AUX1_1(1,aa)];
        ininput_AUX2_sel1 = [ininput_AUX2_sel1,in_AUX2_1(1,aa)];
        ininput_AUX3_sel1 = [ininput_AUX3_sel1,in_AUX3_1(1,aa)];
        ininput_AUX4_sel1 = [ininput_AUX4_sel1,in_AUX4_1(1,aa)];
        t_sel1 = [t_sel1,t_1(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_1);
vx_est_sel1 = [];
vy_est_sel1 = [];
vz_est_sel1 = [];
vx_ref_sel1 = [];
vy_ref_sel1 = [];
vz_ref_sel1 = [];
t_sel1 = [];
while aa <= ba
    if phase_1(aa,1) == 102
        vx_est_sel1 = [vx_est_sel1,vx_est1(1,aa)];
        vy_est_sel1 = [vy_est_sel1,vy_est1(1,aa)];
        vz_est_sel1 = [vz_est_sel1,vz_est1(1,aa)];
        vx_ref_sel1 = [vx_ref_sel1,vx_ref1(1,aa)];
        vy_ref_sel1 = [vy_ref_sel1,vy_ref1(1,aa)];
        vz_ref_sel1 = [vz_ref_sel1,vz_ref1(1,aa)];
        t_sel1 = [t_sel1,t_1(aa,1)];
    end
    aa = aa + 1;
end

%% 収束後　位置

% 誤差の計算
%位置
er_x_1 = mean(x_est_sel1 - x_ref_sel1);
er_y_1 = mean(y_est_sel1 - y_ref_sel1);
er_z_1 = mean(z_est_sel1 - z_ref_sel1);
er_x_1_fig = x_est_sel1 - x_ref_sel1;
er_y_1_fig = y_est_sel1 - y_ref_sel1;
er_z_1_fig = z_est_sel1 - z_ref_sel1;

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
rmse_x_1 = sqrt(mean((x_est_sel1 - x_ref_sel1).^2));
rmse_y_1 = sqrt(mean((y_est_sel1 - y_ref_sel1).^2));
rmse_z_1 = sqrt(mean((z_est_sel1 - z_ref_sel1).^2));
rmse_x_1_fig = sqrt((x_est_sel1 - x_ref_sel1).^2);
rmse_y_1_fig = sqrt((y_est_sel1 - y_ref_sel1).^2);
rmse_z_1_fig = sqrt((z_est_sel1 - z_ref_sel1).^2);

% MAEの計算
%位置
% mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
% mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
% mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
% mae_x_1_fig = abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
% mae_y_1_fig = abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
% mae_z_1_fig = abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence);

%最大誤差
max_error_x_1 = max(abs(x_est_sel1 - x_ref_sel1));
max_error_y_1 = max(abs(y_est_sel1 - y_ref_sel1));
max_error_z_1 = max(abs(z_est_sel1 - z_ref_sel1));

% 結果を表示
fprintf('軌道x_1の収束後の位置誤差: %f\n', er_x_1);
fprintf('軌道y_1の収束後の位置誤差: %f\n', er_y_1);
fprintf('軌道z_1の収束後の位置誤差: %f\n', er_z_1);

fprintf('軌道x_1の収束後の位置RMSE: %f\n', rmse_x_1);
fprintf('軌道y_1の収束後の位置RMSE: %f\n', rmse_y_1);
fprintf('軌道z_1の収束後の位置RMSE: %f\n', rmse_z_1);

fprintf('軌道x_1の収束後の位置最大誤差: %f\n', max_error_x_1);
fprintf('軌道y_1の収束後の位置最大誤差: %f\n', max_error_y_1);
fprintf('軌道z_1の収束後の位置最大誤差: %f\n', max_error_z_1);

% xy
figure;
plot(x_est_sel1, y_est_sel1, '-','LineWidth',2);
grid on
xlabel('x[m]') 
ylabel('y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-2.5 2.5])
ylim([-2.5 2.5])
hold on
plot(x_ref_sel1, y_ref_sel1, '--','LineWidth',2);
legend('D1.EST', ...
    'D1.REF','fontsize',8,'NumColumns',2)
hold off

% % % xyz
% plot3(x_est_sel1, y_est_sel1, z_est_sel1,  '-','LineWidth', 2);  % 軌道の太さを指定
% grid on                         % グリッドを表示
% xlabel('x[m]','FontSize',12) 
% ylabel('y[m]','FontSize',12)
% zlabel('z[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% set(gca().ZAxis, 'Fontsize', 12)
% xlim([-2 2])
% ylim([-2 2])
% zlim([0 1])
% pbaspect([1 1 1])
% hold on
% plot3(x_ref_sel1, y_ref_sel1, z_ref_sel1, '--', 'LineWidth', 2);
% legend('D1.EST', ...
%     'D1.REF','fontsize',12,'NumColumns',2)
% hold off

%推定値と目標値
figure;
plot(t_sel1,x_est_sel1, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,1) t_sel1(1,end)])
ylim([-2.5 2.5])
hold on
plot(t_sel1,y_est_sel1, '-','LineWidth',2);
plot(t_sel1,z_est_sel1, '-','LineWidth',2);
plot(t_sel1,x_ref_sel1, '--','LineWidth',2);
plot(t_sel1,y_ref_sel1, '--','LineWidth',2);
plot(t_sel1,z_ref_sel1, '--','LineWidth',2);
legend('x_1.EST','y_1.EST','z_1.EST', ...
    'x_1.REF','y_1.REF','z_1.REF','Location', ...
    'northeast','fontsize',8,'NumColumns',4)
hold off

%誤差
figure;
plot(t_sel1,er_x_1_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,1) t_sel1(1,end)])
ylim([-2 2])
hold on
plot(t_sel1,er_y_1_fig, '-','LineWidth',2);
plot(t_sel1,er_z_1_fig, '-','LineWidth',2);
legend('x_1.error','y_1.error','z_1.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%RMSE
figure;
plot(t_sel1,rmse_x_1_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,1) t_sel1(1,end)])
ylim([-0.5 2])
hold on
plot(t_sel1,rmse_y_1_fig, '-','LineWidth',2);
plot(t_sel1,rmse_z_1_fig, '-','LineWidth',2);
legend('x_1.RMSE','y_1.RMSE','z_1.RMSE','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%% 収束後　速度

% 誤差の計算
%速度
er_vx_1 = mean(vx_est_sel1 - vx_ref_sel1);
er_vy_1 = mean(vy_est_sel1 - vy_ref_sel1);
er_vz_1 = mean(vz_est_sel1 - vz_ref_sel1);
er_vx_1_fig = vx_est_sel1 - vx_ref_sel1;
er_vy_1_fig = vy_est_sel1 - vy_ref_sel1;
er_vz_1_fig = vz_est_sel1 - vz_ref_sel1;

% MSEの計算
%位置
% mse_x_1 = mean((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2);
% mse_y_1 = mean((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2);
% mse_z_1 = mean((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2);
% mse_x_1_fig = (trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2;
% mse_y_1_fig = (trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2;
% mse_z_1_fig = (trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2;

% RMSEの計算
%速度
rmse_vx_1 = sqrt(mean((vx_est_sel1 - vx_ref_sel1).^2));
rmse_vy_1 = sqrt(mean((vy_est_sel1 - vy_ref_sel1).^2));
rmse_vz_1 = sqrt(mean((vz_est_sel1 - vz_ref_sel1).^2));
rmse_vx_1_fig = sqrt((vx_est_sel1 - vx_ref_sel1).^2);
rmse_vy_1_fig = sqrt((vy_est_sel1 - vy_ref_sel1).^2);
rmse_vz_1_fig = sqrt((vz_est_sel1 - vz_ref_sel1).^2);

% MAEの計算
%位置
% mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
% mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
% mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
% mae_x_1_fig = abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
% mae_y_1_fig = abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
% mae_z_1_fig = abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence);

%最大誤差
max_error_vx_1 = max(abs(vx_est_sel1 - vx_ref_sel1));
max_error_vy_1 = max(abs(vy_est_sel1 - vy_ref_sel1));
max_error_vz_1 = max(abs(vz_est_sel1 - vz_ref_sel1));

% 結果を表示
fprintf('軌道x_1の収束後の速度誤差: %f\n', er_vx_1);
fprintf('軌道y_1の収束後の速度誤差: %f\n', er_vy_1);
fprintf('軌道z_1の収束後の速度誤差: %f\n', er_vz_1);

fprintf('軌道x_1の収束後の速度RMSE: %f\n', rmse_vx_1);
fprintf('軌道y_1の収束後の速度RMSE: %f\n', rmse_vy_1);
fprintf('軌道z_1の収束後の速度RMSE: %f\n', rmse_vz_1);

fprintf('軌道x_1の収束後の速度最大誤差: %f\n', max_error_vx_1);
fprintf('軌道y_1の収束後の速度最大誤差: %f\n', max_error_vy_1);
fprintf('軌道z_1の収束後の速度最大誤差: %f\n', max_error_vz_1);

%推定値と目標値
figure;
plot(t_sel1,vx_est_sel1, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,1) t_sel1(1,end)])
ylim([-1.5 1.5])
hold on
plot(t_sel1,vy_est_sel1, '-','LineWidth',2);
plot(t_sel1,vz_est_sel1, '-','LineWidth',2);
plot(t_sel1,vx_ref_sel1, '--','LineWidth',2);
plot(t_sel1,vy_ref_sel1, '--','LineWidth',2);
plot(t_sel1,vz_ref_sel1, '--','LineWidth',2);
legend('vx_1.EST','vy_1.EST','vz_1.EST', ...
    'vx_1.REF','vy_1.REF','vz_1.REF','Location', ...
    'northwest','fontsize',8,'NumColumns',4)
hold off

%誤差
figure;
plot(t_sel1,er_vx_1_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,1) t_sel1(1,end)])
ylim([-1 1])
hold on
plot(t_sel1,er_vy_1_fig, '-','LineWidth',2);
plot(t_sel1,er_vz_1_fig, '-','LineWidth',2);
legend('vx_1.error','vy_1.error','vz_1.error','Location', ...
    'northwest','fontsize',8,'NumColumns',2)
hold off

%RMSE
figure;
plot(t_sel1,rmse_vx_1_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,1) t_sel1(1,end)])
ylim([-0.5 1])
hold on
plot(t_sel1,rmse_vy_1_fig, '-','LineWidth',2);
plot(t_sel1,rmse_vz_1_fig, '-','LineWidth',2);
legend('vx_1.RMSE','vy_1.RMSE','vz_1.RMSE','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off
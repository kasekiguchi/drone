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
    if phase(aa,1) == 102
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


% bb = 1;
% ba = height(t);
% x_est2_sel = [];
% y_est2_sel = [];
% z_est2_sel = [];
% x_ref2_sel = [];
% y_ref2_sel = [];
% z_ref2_sel = [];
% t2_sel = [];
% while bb <= ba
%     if phase(bb,1) == 102
%         x_est2_sel = [x_est2_sel,x_est2(1,bb)];
%         y_est2_sel = [y_est2_sel,y_est2(1,bb)];
%         z_est2_sel = [z_est2_sel,z_est2(1,bb)];
%         x_ref2_sel = [x_ref2_sel,x_ref2(1,bb)];
%         y_ref2_sel = [y_ref2_sel,y_ref2(1,bb)];
%         z_ref2_sel = [z_ref2_sel,z_ref2(1,bb)];
%         t2_sel = [t2_sel,t(bb,1)];
%     end
%     bb = bb + 1;
% end
% 
% bb = 1;
% ba = height(t);
% vx_est2_sel = [];
% vy_est2_sel = [];
% vz_est2_sel = [];
% vx_ref2_sel = [];
% vy_ref2_sel = [];
% vz_ref2_sel = [];
% t2_sel = [];
% while bb <= ba
%     if phase(bb,1) == 102
%         vx_est2_sel = [vx_est2_sel,vx_est2(1,bb)];
%         vy_est2_sel = [vy_est2_sel,vy_est2(1,bb)];
%         vz_est2_sel = [vz_est2_sel,vz_est2(1,bb)];
%         vx_ref2_sel = [vx_ref2_sel,vx_ref2(1,bb)];
%         vy_ref2_sel = [vy_ref2_sel,vy_ref2(1,bb)];
%         vz_ref2_sel = [vz_ref2_sel,vz_ref2(1,bb)];
%         t2_sel = [t2_sel,t(bb,1)];
%     end
%     bb = bb + 1;
% end

%%
%誤差評価 目標軌道全体
% MSEの計算　平均二乗誤差
%位置
mse_x_1 = mean((x_est_sel - x_ref_sel).^2)
mse_y_1 = mean((y_est_sel - y_ref_sel).^2)
mse_z_1 = mean((z_est_sel - z_ref_sel).^2)
%速度
mse_vx_1 = mean((vx_est_sel - vx_ref_sel).^2)
mse_vy_1 = mean((vy_est_sel - vy_ref_sel).^2)
mse_vz_1 = mean((vz_est_sel - vz_ref_sel).^2)

% mse_x_2 = mean((x_est2_sel - x_ref2_sel).^2)
% mse_y_2 = mean((y_est2_sel - y_ref2_sel).^2)
% mse_z_2 = mean((z_est2_sel - z_ref2_sel).^2)
% 
% mse_vx_2 = mean((vx_est2_sel - vx_ref2_sel).^2)
% mse_vy_2 = mean((vy_est2_sel - vy_ref2_sel).^2)
% mse_vz_2 = mean((vz_est2_sel - vz_ref2_sel).^2)

% MAEの計算　平均絶対誤差
%位置
mae_x_1 = mean(abs(x_est_sel - x_ref_sel))
mae_y_1 = mean(abs(y_est_sel - y_ref_sel))
mae_z_1 = mean(abs(z_est_sel - z_ref_sel))
%速度
mae_vx_1 = mean(abs(vx_est_sel - vx_ref_sel))
mae_vy_1 = mean(abs(vy_est_sel - vy_ref_sel))
mae_vz_1 = mean(abs(vz_est_sel - vz_ref_sel))

% %位置
% mae_x_2 = mean(abs(x_est_sel - x_ref_sel))
% mae_y_2 = mean(abs(y_est_sel - y_ref_sel))
% mae_z_2 = mean(abs(z_est_sel - z_ref_sel))
% %速度
% mae_vx_2 = mean(abs(vx_est2_sel - vx_ref2_sel))
% mae_vy_2 = mean(abs(vy_est2_sel - vy_ref2_sel))
% mae_vz_2 = mean(abs(vz_est2_sel - vz_ref2_sel))

% 最大誤差の計算
%位置
max_error_x_1 = max(abs(x_est_sel - x_ref_sel))
max_error_y_1 = max(abs(y_est_sel - y_ref_sel))
max_error_z_1 = max(abs(z_est_sel - z_ref_sel))
%速度
max_error_vx_1 = max(abs(vx_est_sel - vx_ref_sel))
max_error_vy_1 = max(abs(vy_est_sel - vy_ref_sel))
max_error_vz_1 = max(abs(vz_est_sel - vz_ref_sel))

% %位置
% max_error_x_2 = max(abs(x_est2_sel - x_ref2_sel))
% max_error_y_2 = max(abs(y_est2_sel - y_ref2_sel))
% max_error_z_2 = max(abs(z_est2_sel - z_ref2_sel))
% %速度
% max_error_x_2 = max(abs(vx_est2_sel - vx_ref2_sel))
% max_error_y_2 = max(abs(vy_est2_sel - vy_ref2_sel))
% max_error_z_2 = max(abs(vz_est2_sel - vz_ref2_sel))

%% 誤差評価　収束後　位置

% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.0001;

% 各軌道が収束する最初の時刻を見つける
% convergence_time_index_x_1 = time(find(error_x_1 < threshold, 1));
% convergence_time_index_y_1 = time(find(error_y_1 < threshold, 1));
% convergence_time_index_z_1 = time(find(error_z_1 < threshold, 1));
% convergence_time_x = [convergence_time_index_x_1 convergence_time_index_y_1 convergence_time_index_z_1];

convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
convergence_time_xyz = [convergence_time_index_x_1 convergence_time_index_y_1 convergence_time_index_z_1];

% どれか遅い方の収束時刻を選ぶ
% convergence_time_index = max(convergence_time_index_x_1, convergence_time_index_y_1, ...
%     convergence_time_index_z_1);
convergence_time_index = max(convergence_time_xyz);
% convergence_time = time(convergence_time_index); % 収束時刻
convergence_time = t_sel(1:convergence_time_index); % 収束時刻

% 収束時刻以降のデータ
trajectory_x_1_post_convergence = x_est_sel(convergence_time_index:end);
trajectory_y_1_post_convergence = y_est_sel(convergence_time_index:end);
trajectory_z_1_post_convergence = z_est_sel(convergence_time_index:end);
t_1_post_convergence = t_sel(convergence_time_index:end);

reference_x_1_post_convergence = x_ref_sel(convergence_time_index:end);
reference_y_1_post_convergence = y_ref_sel(convergence_time_index:end);
reference_z_1_post_convergence = z_ref_sel(convergence_time_index:end);

% MSEの計算
%位置
mse_x_1 = mean((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2)
mse_y_1 = mean((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2)
mse_z_1 = mean((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2)

% MAEの計算
%位置
mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));

%最大誤差
max_error_x_1 = max(abs(x_est_sel(convergence_time_index:end) - x_ref_sel(convergence_time_index:end)));
max_error_y_1 = max(abs(y_est_sel(convergence_time_index:end) - y_ref_sel(convergence_time_index:end)));
max_error_z_1 = max(abs(z_est_sel(convergence_time_index:end) - z_ref_sel(convergence_time_index:end)));

% 結果を表示
fprintf('軌道x_1の収束後の位置MSE: %f\n', mse_x_1);
fprintf('軌道y_1の収束後の位置MSE: %f\n', mse_y_1);
fprintf('軌道z_1の収束後の位置MSE: %f\n', mse_z_1);
fprintf('軌道x_1の収束後の位置MAE: %f\n', mae_x_1);
fprintf('軌道y_1の収束後の位置MAE: %f\n', mae_y_1);
fprintf('軌道z_1の収束後の位置MAE: %f\n', mae_z_1);
fprintf('軌道x_1の収束後の位置最大誤差: %f\n', max_error_x_1);
fprintf('軌道y_1の収束後の位置最大誤差: %f\n', max_error_y_1);
fprintf('軌道z_1の収束後の位置最大誤差: %f\n', max_error_z_1);

figure;
plot(t_1_post_convergence,x_est_sel(convergence_time_index:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1.5 1.5])
hold on
plot(t_1_post_convergence,y_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,z_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,x_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,y_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,z_ref_sel(convergence_time_index:end), '--','LineWidth',2);
legend('X-estimator','Y-estimator','Z-estimator', ...
    'X-reference','Y-reference','Z-reference','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%% 誤差評価　収束後　位置

% % 誤差の計算
% error_x_1 = abs(x_est_sel - x_ref_sel);
% error_y_1 = abs(y_est_sel - y_ref_sel);
% error_z_1 = abs(z_est_sel - z_ref_sel);
% error_x_2 = abs(x_est2_sel - x_ref2_sel);
% error_y_2 = abs(y_est2_sel - y_ref2_sel);
% error_z_2 = abs(z_est2_sel - z_ref2_sel);
% 
% % 収束閾値を設定（例：0.01）
% threshold = 0.01;
% 
% % 各軌道が収束する最初の時刻を見つける
% convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
% convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
% convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
% convergence_time_index_x_2 = find(error_x_2 < threshold, 1);
% convergence_time_index_y_2 = find(error_y_2 < threshold, 1);
% convergence_time_index_z_2 = find(error_z_2 < threshold, 1);
% 
% % どれか遅い方の収束時刻を選ぶ
% convergence_time_index = max(convergence_time_index_x_1, convergence_time_index_y_1, ...
%     convergence_time_index_z_1,convergence_time_index_x_2,convergence_time_index_y_2,convergence_time_index_z_2);
% convergence_time = time(convergence_time_index); % 収束時刻
% 
% % 収束時刻以降のデータ
% trajectory_x_1_post_convergence = x_est_sel(convergence_time_index:end);
% trajectory_y_1_post_convergence = y_est_sel(convergence_time_index:end);
% trajectory_z_1_post_convergence = z_est_sel(convergence_time_index:end);
% trajectory_x_2_post_convergence = x_est2_sel(convergence_time_index:end);
% trajectory_y_2_post_convergence = y_est2_sel(convergence_time_index:end);
% trajectory_z_2_post_convergence = z_est2_sel(convergence_time_index:end);
% t_1_post_convergence = t(convergence_time_index:end);
% t_2_post_convergence = t2(convergence_time_index:end);
% 
% reference_x_1_post_convergence = x_ref_sel(convergence_time_index:end);
% reference_y_1_post_convergence = y_ref_sel(convergence_time_index:end);
% reference_z_1_post_convergence = z_ref_sel(convergence_time_index:end);
% reference_x_2_post_convergence = x_ref2_sel(convergence_time_index:end);
% reference_y_2_post_convergence = y_ref2_sel(convergence_time_index:end);
% reference_z_2_post_convergence = z_ref2_sel(convergence_time_index:end);
% 
% % MSEの計算
% %位置
% mse_x_1 = mean((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2)
% mse_y_1 = mean((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2)
% mse_z_1 = mean((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2)
% mse_x_2 = mean((trajectory_x_2_post_convergence - reference_x_2_post_convergence).^2)
% mse_y_2 = mean((trajectory_y_2_post_convergence - reference_y_2_post_convergence).^2)
% mse_z_2 = mean((trajectory_z_2_post_convergence - reference_z_2_post_convergence).^2)
% 
% % MAEの計算
% %位置
% mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
% mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
% mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
% mae_x_2 = mean(abs(trajectory_x_2_post_convergence - reference_x_2_post_convergence));
% mae_y_2 = mean(abs(trajectory_y_2_post_convergence - reference_y_2_post_convergence));
% mae_z_2 = mean(abs(trajectory_z_2_post_convergence - reference_z_2_post_convergence));
% 
% % 結果を表示
% fprintf('軌道x_1の収束後の位置MSE: %f\n', mse_x_1);
% fprintf('軌道y_1の収束後の位置MSE: %f\n', mse_y_1);
% fprintf('軌道z_1の収束後の位置MSE: %f\n', mse_z_1);
% fprintf('軌道x_2の収束後の位置MSE: %f\n', mse_x_2);
% fprintf('軌道y_2の収束後の位置MSE: %f\n', mse_y_2);
% fprintf('軌道z_2の収束後の位置MSE: %f\n', mse_z_2);
% fprintf('軌道x_1の収束後の位置MAE: %f\n', mae_x_1);
% fprintf('軌道y_1の収束後の位置MAE: %f\n', mae_y_1);
% fprintf('軌道z_1の収束後の位置MAE: %f\n', mae_z_1);
% fprintf('軌道x_2の収束後の位置MAE: %f\n', mae_x_2);
% fprintf('軌道y_2の収束後の位置MAE: %f\n', mae_y_2);
% fprintf('軌道z_2の収束後の位置MAE: %f\n', mae_z_2);
% 
% figure;
% plot(t_1_post_convergence, trajectory_x_1_post_convergence, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_1_post_convergence(1,1) inf])
% ylim([-1.5 1.5])
% hold on
% plot(t_1_post_convergence, trajectory_y_1_post_convergence, '-','LineWidth',2);
% plot(t_1_post_convergence, trajectory_z_1_post_convergence, '-','LineWidth',2);
% plot(t_1_post_convergence, reference_x_1_post_convergence, '--','LineWidth',2);
% plot(t_1_post_convergence, reference_y_1_post_convergence, '--','LineWidth',2);
% plot(t_1_post_convergence, reference_z_1_post_convergence, '--','LineWidth',2);
% legend('X-estimator','Y-estimator','Z-estimator', ...
%     'X-reference','Y-reference','Z-reference','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off
% 
% figure;
% plot(t_2_post_convergence, trajectory_x_2_post_convergence, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_2_post_convergence(1,1) inf])
% ylim([-1.5 1.5])
% hold on
% plot(t_2_post_convergence, trajectory_y_2_post_convergence, '-','LineWidth',2);
% plot(t_2_post_convergence, trajectory_z_2_post_convergence, '-','LineWidth',2);
% plot(t_2_post_convergence, reference_x_2_post_convergence, '--','LineWidth',2);
% plot(t_2_post_convergence, reference_y_2_post_convergence, '--','LineWidth',2);
% plot(t_2_post_convergence, reference_z_2_post_convergence, '--','LineWidth',2);
% legend('X-estimator','Y-estimator','Z-estimator', ...
%     'X-reference','Y-reference','Z-reference','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

%% 誤差評価　収束後　速度

% 誤差の計算
error_vx_1 = abs(vx_est_sel - vx_ref_sel);
error_vy_1 = abs(vy_est_sel - vy_ref_sel);
error_vz_1 = abs(vz_est_sel - vz_ref_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.0001;

% 各軌道が収束する最初の時刻を見つける
convergence_time_index_vx_1 = find(error_vx_1 < threshold, 1);
convergence_time_index_vy_1 = find(error_vy_1 < threshold, 1);
convergence_time_index_vz_1 = find(error_vz_1 < threshold, 1);
convergence_time_vxyz = [convergence_time_index_vx_1 convergence_time_index_vy_1 convergence_time_index_vz_1];

% どれか遅い方の収束時刻を選ぶ
convergence_time_index = max(convergence_time_vxyz);
convergence_time = t_sel(1:convergence_time_index); % 収束時刻

% 収束時刻以降のデータ
trajectory_vx_1_post_convergence = vx_est_sel(convergence_time_index:end);
trajectory_vy_1_post_convergence = vy_est_sel(convergence_time_index:end);
trajectory_vz_1_post_convergence = vz_est_sel(convergence_time_index:end);
t_1_post_convergence = t_sel(convergence_time_index:end);

reference_vx_1_post_convergence = vx_ref_sel(convergence_time_index:end);
reference_vy_1_post_convergence = vy_ref_sel(convergence_time_index:end);
reference_vz_1_post_convergence = vz_ref_sel(convergence_time_index:end);

% MSEの計算
%速度
mse_vx_1 = mean((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2)
mse_vy_1 = mean((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2)
mse_vz_1 = mean((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2)

% MAEの計算
%速度
mae_vx_1 = mean(abs(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence));
mae_vy_1 = mean(abs(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence));
mae_vz_1 = mean(abs(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence));

%最大誤差
max_error_vx_1 = max(abs(vx_est_sel(convergence_time_index:end) - vx_ref_sel(convergence_time_index:end)));
max_error_vy_1 = max(abs(vy_est_sel(convergence_time_index:end) - vy_ref_sel(convergence_time_index:end)));
max_error_vz_1 = max(abs(vz_est_sel(convergence_time_index:end) - vz_ref_sel(convergence_time_index:end)));

% 結果を表示
fprintf('軌道x_1の収束後の速度MSE: %f\n', mse_vx_1);
fprintf('軌道y_1の収束後の速度MSE: %f\n', mse_vy_1);
fprintf('軌道z_1の収束後の速度MSE: %f\n', mse_vz_1);
fprintf('軌道x_1の収束後の速度MAE: %f\n', mae_vx_1);
fprintf('軌道y_1の収束後の速度MAE: %f\n', mae_vy_1);
fprintf('軌道z_1の収束後の速度MAE: %f\n', mae_vz_1);
fprintf('軌道x_1の収束後の速度最大誤差: %f\n', max_error_vx_1);
fprintf('軌道y_1の収束後の速度最大誤差: %f\n', max_error_vy_1);
fprintf('軌道z_1の収束後の速度最大誤差: %f\n', max_error_vz_1);

figure;
plot(t_1_post_convergence, vx_est_sel(convergence_time_index:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1.5 1.5])
hold on
plot(t_1_post_convergence, vy_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence, vz_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence, vx_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence, vy_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence, vz_ref_sel(convergence_time_index:end), '--','LineWidth',2);
legend('X-estimator','Y-estimator','Z-estimator', ...
    'X-reference','Y-reference','Z-reference','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off


%% 誤差評価　収束後　速度

% % 誤差の計算
% error_vx_1 = abs(vx_est_sel - vx_ref_sel);
% error_vy_1 = abs(vy_est_sel - vy_ref_sel);
% error_vz_1 = abs(vz_est_sel - vz_ref_sel);
% error_vx_2 = abs(vx_est2_sel - vx_ref2_sel);
% error_vy_2 = abs(vy_est2_sel - vy_ref2_sel);
% error_vz_2 = abs(vz_est2_sel - vz_ref2_sel);
% 
% % 収束閾値を設定（例：0.01）
% threshold = 0.01;
% 
% % 各軌道が収束する最初の時刻を見つける
% convergence_time_index_vx_1 = find(error_vx_1 < threshold, 1);
% convergence_time_index_vy_1 = find(error_vy_1 < threshold, 1);
% convergence_time_index_vz_1 = find(error_vz_1 < threshold, 1);
% convergence_time_index_vx_2 = find(error_vx_2 < threshold, 1);
% convergence_time_index_vy_2 = find(error_vy_2 < threshold, 1);
% convergence_time_index_vz_2 = find(error_vz_2 < threshold, 1);
% 
% % どれか遅い方の収束時刻を選ぶ
% convergence_time_index = max(convergence_time_index_vx_1, convergence_time_index_vy_1, ...
%     convergence_time_index_vz_1,convergence_time_index_vx_2,convergence_time_index_vy_2,convergence_time_index_vz_2);
% convergence_time = time(convergence_time_index); % 収束時刻
% 
% % 収束時刻以降のデータ
% trajectory_vx_1_post_convergence = vx_est_sel(convergence_time_index:end);
% trajectory_vy_1_post_convergence = vy_est_sel(convergence_time_index:end);
% trajectory_vz_1_post_convergence = vz_est_sel(convergence_time_index:end);
% trajectory_vx_2_post_convergence = vx_est2_sel(convergence_time_index:end);
% trajectory_vy_2_post_convergence = vy_est2_sel(convergence_time_index:end);
% trajectory_vz_2_post_convergence = vz_est2_sel(convergence_time_index:end);
% t_1_post_convergence = t_sel(convergence_time_index:end);
% t_2_post_convergence = t2_sel(convergence_time_index:end);
% 
% reference_vx_1_post_convergence = vx_ref_sel(convergence_time_index:end);
% reference_vy_1_post_convergence = vy_ref_sel(convergence_time_index:end);
% reference_vz_1_post_convergence = vz_ref_sel(convergence_time_index:end);
% reference_vx_2_post_convergence = vx_ref2_sel(convergence_time_index:end);
% reference_vy_2_post_convergence = vy_ref2_sel(convergence_time_index:end);
% reference_vz_2_post_convergence = vz_ref2_sel(convergence_time_index:end);
% 
% % MSEの計算
% %速度
% mse_vx_1 = mean((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2)
% mse_vy_1 = mean((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2)
% mse_vz_1 = mean((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2)
% mse_vx_2 = mean((trajectory_vx_2_post_convergence - reference_vx_2_post_convergence).^2)
% mse_vy_2 = mean((trajectory_vy_2_post_convergence - reference_vy_2_post_convergence).^2)
% mse_vz_2 = mean((trajectory_vz_2_post_convergence - reference_vz_2_post_convergence).^2)
% 
% % MAEの計算
% %速度
% mae_vx_1 = mean(abs(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence));
% mae_vy_1 = mean(abs(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence));
% mae_vz_1 = mean(abs(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence));
% mae_vx_2 = mean(abs(trajectory_vx_2_post_convergence - reference_vx_2_post_convergence));
% mae_vy_2 = mean(abs(trajectory_vy_2_post_convergence - reference_vy_2_post_convergence));
% mae_vz_2 = mean(abs(trajectory_vz_2_post_convergence - reference_vz_2_post_convergence));
% 
% % 結果を表示
% fprintf('軌道x_1の収束後の速度MSE: %f\n', mse_vx_1);
% fprintf('軌道y_1の収束後の速度MSE: %f\n', mse_vy_1);
% fprintf('軌道z_1の収束後の速度MSE: %f\n', mse_vz_1);
% fprintf('軌道x_2の収束後の速度MSE: %f\n', mse_vx_2);
% fprintf('軌道y_2の収束後の速度MSE: %f\n', mse_vy_2);
% fprintf('軌道z_2の収束後の速度MSE: %f\n', mse_vz_2);
% fprintf('軌道x_1の収束後の速度MAE: %f\n', mae_vx_1);
% fprintf('軌道y_1の収束後の速度MAE: %f\n', mae_vy_1);
% fprintf('軌道z_1の収束後の速度MAE: %f\n', mae_vz_1);
% fprintf('軌道x_2の収束後の速度MAE: %f\n', mae_vx_2);
% fprintf('軌道y_2の収束後の速度MAE: %f\n', mae_vy_2);
% fprintf('軌道z_2の収束後の速度MAE: %f\n', mae_vz_2);
% 
% figure;
% plot(t_1_post_convergence, trajectory_vx_1_post_convergence, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_1_post_convergence(1,1) inf])
% ylim([-1.5 1.5])
% hold on
% plot(t_1_post_convergence, trajectory_vy_1_post_convergence, '-','LineWidth',2);
% plot(t_1_post_convergence, trajectory_vz_1_post_convergence, '-','LineWidth',2);
% plot(t_1_post_convergence, reference_vx_1_post_convergence, '--','LineWidth',2);
% plot(t_1_post_convergence, reference_vy_1_post_convergence, '--','LineWidth',2);
% plot(t_1_post_convergence, reference_vz_1_post_convergence, '--','LineWidth',2);
% legend('X-estimator','Y-estimator','Z-estimator', ...
%     'X-reference','Y-reference','Z-reference','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off
% 
% figure;
% plot(t_2_post_convergence, trajectory_vx_2_post_convergence, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_2_post_convergence(1,1) inf])
% ylim([-1.5 1.5])
% hold on
% plot(t_2_post_convergence, trajectory_vy_2_post_convergence, '-','LineWidth',2);
% plot(t_2_post_convergence, trajectory_vz_2_post_convergence, '-','LineWidth',2);
% plot(t_2_post_convergence, reference_vx_2_post_convergence, '--','LineWidth',2);
% plot(t_2_post_convergence, reference_vy_2_post_convergence, '--','LineWidth',2);
% plot(t_2_post_convergence, reference_vz_2_post_convergence, '--','LineWidth',2);
% legend('X-estimator','Y-estimator','Z-estimator', ...
%     'X-reference','Y-reference','Z-reference','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

%% 収束性
%位置
% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.01;

% 各軌道が収束する最初の時刻を見つける
convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
convergence_time_x_1 = time(convergence_time_index_x_1 - t_sel(1,1)); % time は時間軸
convergence_time_y_1 = time(convergence_time_index_y_1 - t_sel(1,1));
convergence_time_z_1 = time(convergence_time_index_z_1 - t_sel(1,1));

%速度
% 誤差の計算
error_vx_1 = abs(vx_est_sel - vx_ref_sel);
error_vy_1 = abs(vy_est_sel - vy_ref_sel);
error_vz_1 = abs(vz_est_sel - vz_ref_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.01;

% 各軌道が収束する最初の時刻を見つける
convergence_time_index_vx_1 = find(error_vx_1 < threshold, 1);
convergence_time_index_vy_1 = find(error_vy_1 < threshold, 1);
convergence_time_index_vz_1 = find(error_vz_1 < threshold, 1);
convergence_time_vx_1 = time(convergence_time_index_vx_1 - t_sel(1,1)); % time は時間軸
convergence_time_vy_1 = time(convergence_time_index_vy_1 - t_sel(1,1));
convergence_time_vz_1 = time(convergence_time_index_vz_1 - t_sel(1,1));


%% 収束性
%位置
% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);
error_x_2 = abs(x_est2_sel - x_ref2_sel);
error_y_2 = abs(y_est2_sel - y_ref2_sel);
error_z_2 = abs(z_est2_sel - z_ref2_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.01;

% 各軌道が収束する最初の時刻を見つける
convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
convergence_time_index_x_2 = find(error_x_2 < threshold, 1);
convergence_time_index_y_2 = find(error_y_2 < threshold, 1);
convergence_time_index_z_2 = find(error_z_2 < threshold, 1);
convergence_time_x_1 = time(convergence_time_index_x_1 - t_sel(1,1)); % time は時間軸
convergence_time_y_1 = time(convergence_time_index_y_1 - t_sel(1,1));
convergence_time_z_1 = time(convergence_time_index_z_1 - t_sel(1,1));
convergence_time_x_2 = time(convergence_time_index_x_2 - t2_sel(1,1)); % time は時間軸
convergence_time_y_2 = time(convergence_time_index_y_2 - t2_sel(1,1));
convergence_time_z_2 = time(convergence_time_index_z_2 - t2_sel(1,1));

%速度
% 誤差の計算
error_vx_1 = abs(vx_est_sel - vx_ref_sel);
error_vy_1 = abs(vy_est_sel - vy_ref_sel);
error_vz_1 = abs(vz_est_sel - vz_ref_sel);
error_vx_2 = abs(vx_est2_sel - vx_ref2_sel);
error_vy_2 = abs(vy_est2_sel - vy_ref2_sel);
error_vz_2 = abs(vz_est2_sel - vz_ref2_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.01;

% 各軌道が収束する最初の時刻を見つける
convergence_time_index_vx_1 = find(error_vx_1 < threshold, 1);
convergence_time_index_vy_1 = find(error_vy_1 < threshold, 1);
convergence_time_index_vz_1 = find(error_vz_1 < threshold, 1);
convergence_time_index_vx_2 = find(error_vx_2 < threshold, 1);
convergence_time_index_vy_2 = find(error_vy_2 < threshold, 1);
convergence_time_index_vz_2 = find(error_vz_2 < threshold, 1);
convergence_time_vx_1 = time(convergence_time_index_vx_1 - t_sel(1,1)); % time は時間軸
convergence_time_vy_1 = time(convergence_time_index_vy_1 - t_sel(1,1));
convergence_time_vz_1 = time(convergence_time_index_vz_1 - t_sel(1,1));
convergence_time_vx_2 = time(convergence_time_index_vx_2 - t2_sel(1,1)); % time は時間軸
convergence_time_vy_2 = time(convergence_time_index_vy_2 - t2_sel(1,1));
convergence_time_vz_2 = time(convergence_time_index_vz_2 - t2_sel(1,1));
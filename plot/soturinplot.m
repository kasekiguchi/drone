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
roll_est_sel = [];
pitch_est_sel = [];
yaw_est_sel = [];
roll_ref_sel = [];
pitch_ref_sel = [];
yaw_ref_sel = [];
t_sel = [];
while aa <= ba
    if phase(aa,1) == 102
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
    if phase(aa,1) == 102
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

%% 収束後　位置

% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);

% 収束閾値を設定（例：0.01）
% min_duration = 0.5; %最低収束時間
% threshold = 0.05;

% 各軌道が収束する最初の時刻を見つける
% convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
% convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
% convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
% convergence_time_xyz = [convergence_time_index_x_1 convergence_time_index_y_1 convergence_time_index_z_1];

% convergence_time_index = find(error_x_1 < threshold & error_y_1 < threshold & error_z_1 < threshold, 1);

% total_error = sqrt(error_x_1.^2 + error_y_1.^2 + error_z_1.^2);


% どれか遅い方の収束時刻を選ぶ
% convergence_time_index = max(convergence_time_xyz);
% convergence_time_index = find(total_error < threshold, 1);
% convergence_time = t_sel(1:convergence_time_index); % 収束時刻

% threshold = 0.1;  % 収束閾値を0.1に設定 (実際のデータに基づく)
% T_continuous = 5; % 連続して収束が確認される必要がある時間 (5秒)
% 
% % 各エラーが閾値以下かどうかを確認
% within_threshold_x = error_x_1 < threshold;
% within_threshold_y = error_y_1 < threshold;
% within_threshold_z = error_z_1 < threshold;
% 
% % 全軸で閾値以下である部分
% all_within_threshold = within_threshold_x & within_threshold_y & within_threshold_z;
% 
% % 各時点での誤差と収束条件を表示
% for i = 1:length(t_sel)
%     fprintf('時刻: %.5f秒, 誤差: (%.5f, %.5f, %.5f), 収束条件: %d\n', ...
%             t_sel(i), error_x_1(i), error_y_1(i), error_z_1(i), all_within_threshold(i));
% end
% 
% % 収束の開始を見つける
% convergence_time = NaN;  % 初期化
% indices = find(all_within_threshold);  % 収束している全てのインデックス
% 
% if ~isempty(indices)
%     % 収束が始まるインデックスを取得
%     start_index = indices(1);
%     start_time = t_sel(start_index);
% 
%     % 連続して収束しているか確認
%     j = 1;  % インデックスのリセット
%     while (j <= length(indices)) && (t_sel(indices(j)) - start_time) < T_continuous
%         j = j + 1;  % 次のインデックスへ
%     end
% 
%     % 一定期間収束が続いたかどうか確認
%     if (j <= length(indices)) && (t_sel(indices(j)) - start_time) >= T_continuous
%         convergence_time = start_time;
%         fprintf('連続収束が確認された時刻: %.5f秒\n', convergence_time);
%         fprintf('収束点のインデックス (行番号): %d\n', indices(1));  % 収束ポイントのインデックスを表示
%     end
% end
% 
% % 収束が見つからなかった場合
% if isnan(convergence_time)
%     fprintf('連続収束は確認されませんでした\n');
% end
% 
% convergence_time_index = start_index;

threshold = 0.15;  % 収束閾値
T_continuous = 3;  % 連続収束の閾値（秒）

% 収束時間を計算するための変数
convergence_start_time = NaN;  % 収束開始時刻
convergence_duration = 0;      % 収束時間の初期化
convergence_row = NaN;         % 収束開始行の初期化
found_convergence = false;     % 収束が確認されたかどうかのフラグ

for i = 1:length(error_z_1)
    % 現在の誤差が収束閾値を満たしているか確認
    if abs(error_x_1(i)) < threshold && abs(error_y_1(i)) < threshold && abs(error_z_1(i)) < threshold
        if isnan(convergence_start_time)  % 収束開始時刻が未設定の場合
            convergence_start_time = t_sel(i);  % 収束開始時刻を設定
            convergence_row = i;                % 収束開始行を記録
        end
    else
        % 収束条件が満たされない場合
        if ~isnan(convergence_start_time)  % 収束開始時刻が設定されている場合
            end_time = t_sel(i - 1);  % 収束終了時刻（直前の時刻）
            duration = end_time - convergence_start_time;  % 収束が続いた時間を計算

            % T_continuous（連続収束の閾値）を満たしているか確認
            if duration >= T_continuous
                fprintf('連続収束が確認されました。収束開始時刻: %.5f秒, 収束時間: %.5f秒, 収束開始行: %d\n', convergence_start_time, duration, convergence_row);
                found_convergence = true;
                break;  % 最初の収束が確認されたらループを終了
            else
                % 時間が足りなかった場合、再度リセットして次の期間を確認
                convergence_start_time = NaN;
                convergence_row = NaN;
            end
        end
    end
end

% 最後のデータ点で収束しているか確認
if ~found_convergence && ~isnan(convergence_start_time)
    end_time = t_sel(end);  % 最後の時刻を取得
    duration = end_time - convergence_start_time;

    if duration >= T_continuous
        fprintf('連続収束が確認されました。収束開始時刻: %.5f秒, 収束時間: %.5f秒, 収束開始行: %d\n', convergence_start_time, duration, convergence_row);
    else
        fprintf('収束は確認されたが、時間が%.5f秒でT_continuousを満たしていません。\n', duration);
    end
end

% 収束開始行を結果として返す
convergence_time_index = convergence_row;

% 収束時刻以降のデータ
trajectory_x_1_post_convergence = x_est_sel(convergence_time_index:end);
trajectory_y_1_post_convergence = y_est_sel(convergence_time_index:end);
trajectory_z_1_post_convergence = z_est_sel(convergence_time_index:end);
t_1_post_convergence = t_sel(convergence_time_index:end);

reference_x_1_post_convergence = x_ref_sel(convergence_time_index:end);
reference_y_1_post_convergence = y_ref_sel(convergence_time_index:end);
reference_z_1_post_convergence = z_ref_sel(convergence_time_index:end);

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
mse_x_1 = mean((trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2);
mse_y_1 = mean((trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2);
mse_z_1 = mean((trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2);
mse_x_1_fig = (trajectory_x_1_post_convergence - reference_x_1_post_convergence).^2;
mse_y_1_fig = (trajectory_y_1_post_convergence - reference_y_1_post_convergence).^2;
mse_z_1_fig = (trajectory_z_1_post_convergence - reference_z_1_post_convergence).^2;

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
mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
mae_x_1_fig = abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
mae_y_1_fig = abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
mae_z_1_fig = abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence);

%最大誤差
max_error_x_1 = max(abs(x_est_sel(convergence_time_index:end) - x_ref_sel(convergence_time_index:end)));
max_error_y_1 = max(abs(y_est_sel(convergence_time_index:end) - y_ref_sel(convergence_time_index:end)));
max_error_z_1 = max(abs(z_est_sel(convergence_time_index:end) - z_ref_sel(convergence_time_index:end)));

% 結果を表示
fprintf('軌道x_1の収束後の位置誤差: %f\n', er_x_1);
fprintf('軌道y_1の収束後の位置誤差: %f\n', er_y_1);
fprintf('軌道z_1の収束後の位置誤差: %f\n', er_z_1);
fprintf('軌道x_1の収束後の位置MSE: %f\n', mse_x_1);
fprintf('軌道y_1の収束後の位置MSE: %f\n', mse_y_1);
fprintf('軌道z_1の収束後の位置MSE: %f\n', mse_z_1);
fprintf('軌道x_1の収束後の位置RMSE: %f\n', rmse_x_1);
fprintf('軌道y_1の収束後の位置RMSE: %f\n', rmse_y_1);
fprintf('軌道z_1の収束後の位置RMSE: %f\n', rmse_z_1);
fprintf('軌道x_1の収束後の位置MAE: %f\n', mae_x_1);
fprintf('軌道y_1の収束後の位置MAE: %f\n', mae_y_1);
fprintf('軌道z_1の収束後の位置MAE: %f\n', mae_z_1);
fprintf('軌道x_1の収束後の位置最大誤差: %f\n', max_error_x_1);
fprintf('軌道y_1の収束後の位置最大誤差: %f\n', max_error_y_1);
fprintf('軌道z_1の収束後の位置最大誤差: %f\n', max_error_z_1);

% xy
figure;
plot(x_est_sel(convergence_time_index:end), y_est_sel(convergence_time_index:end), '-','LineWidth',2);
grid on
xlabel('X[m]') 
ylabel('Y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-1.5 1.5])
ylim([-1.5 1.5])
hold on
plot(x_ref_sel(convergence_time_index:end), y_ref_sel(convergence_time_index:end), '--','LineWidth',2);
legend('Estimater','Reference','fontsize',12)
hold off

% % xyz
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
% zlim([0 1])
% hold on
% plot3(x_ref_sel(convergence_time_index:end), y_ref_sel(convergence_time_index:end), z_ref_sel(convergence_time_index:end), '--', 'LineWidth', 2)
% legend('Estimator','Reference','Location', ...
%     'southwest','fontsize',8)
% hold off

%推定値と目標値
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
legend('x.est','y.est','z.est', ...
    'x.ref','y.ref','z.ref','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
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
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MSE
figure;
plot(t_1_post_convergence,mse_x_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,mse_y_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mse_z_1_fig(1:end), '-','LineWidth',2);
legend('x.error','y.error','z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%RMSE
figure;
plot(t_1_post_convergence,rmse_x_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,rmse_y_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,rmse_z_1_fig(1:end), '-','LineWidth',2);
legend('x.error','y.error','z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MAE
figure;
plot(t_1_post_convergence,mae_x_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,mae_y_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mae_z_1_fig(1:end), '-','LineWidth',2);
legend('x.error','y.error','z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%% 収束後　速度

% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);

% % 収束閾値を設定（例：0.01）
% threshold = 0.1;
% 
% % 各軌道が収束する最初の時刻を見つける
% convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
% convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
% convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
% convergence_time_xyz = [convergence_time_index_x_1 convergence_time_index_y_1 convergence_time_index_z_1];
% 
% % どれか遅い方の収束時刻を選ぶ
% convergence_time_index = max(convergence_time_xyz);
% convergence_time = t_sel(1:convergence_time_index); % 収束時刻

threshold = 0.15;  % 収束閾値
T_continuous = 3;  % 連続収束の閾値（秒）

% 収束時間を計算するための変数
convergence_start_time = NaN;  % 収束開始時刻
convergence_duration = 0;      % 収束時間の初期化
convergence_row = NaN;         % 収束開始行の初期化
found_convergence = false;     % 収束が確認されたかどうかのフラグ

for i = 1:length(error_z_1)
    % 現在の誤差が収束閾値を満たしているか確認
    if abs(error_x_1(i)) < threshold && abs(error_y_1(i)) < threshold && abs(error_z_1(i)) < threshold
        if isnan(convergence_start_time)  % 収束開始時刻が未設定の場合
            convergence_start_time = t_sel(i);  % 収束開始時刻を設定
            convergence_row = i;                % 収束開始行を記録
        end
    else
        % 収束条件が満たされない場合
        if ~isnan(convergence_start_time)  % 収束開始時刻が設定されている場合
            end_time = t_sel(i - 1);  % 収束終了時刻（直前の時刻）
            duration = end_time - convergence_start_time;  % 収束が続いた時間を計算

            % T_continuous（連続収束の閾値）を満たしているか確認
            if duration >= T_continuous
                fprintf('連続収束が確認されました。収束開始時刻: %.5f秒, 収束時間: %.5f秒, 収束開始行: %d\n', convergence_start_time, duration, convergence_row);
                found_convergence = true;
                break;  % 最初の収束が確認されたらループを終了
            else
                % 時間が足りなかった場合、再度リセットして次の期間を確認
                convergence_start_time = NaN;
                convergence_row = NaN;
            end
        end
    end
end

% 最後のデータ点で収束しているか確認
if ~found_convergence && ~isnan(convergence_start_time)
    end_time = t_sel(end);  % 最後の時刻を取得
    duration = end_time - convergence_start_time;

    if duration >= T_continuous
        fprintf('連続収束が確認されました。収束開始時刻: %.5f秒, 収束時間: %.5f秒, 収束開始行: %d\n', convergence_start_time, duration, convergence_row);
    else
        fprintf('収束は確認されたが、時間が%.5f秒でT_continuousを満たしていません。\n', duration);
    end
end

% 収束開始行を結果として返す
convergence_time_index = convergence_row;

% 収束時刻以降のデータ
trajectory_vx_1_post_convergence = vx_est_sel(convergence_time_index:end);
trajectory_vy_1_post_convergence = vy_est_sel(convergence_time_index:end);
trajectory_vz_1_post_convergence = vz_est_sel(convergence_time_index:end);
t_1_post_convergence = t_sel(convergence_time_index:end);

reference_vx_1_post_convergence = vx_ref_sel(convergence_time_index:end);
reference_vy_1_post_convergence = vy_ref_sel(convergence_time_index:end);
reference_vz_1_post_convergence = vz_ref_sel(convergence_time_index:end);

%誤差の計算
%速度
er_vx_1 = mean(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence);
er_vy_1 = mean(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence);
er_vz_1 = mean(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence);
er_vx_1_fig = trajectory_vx_1_post_convergence - reference_vx_1_post_convergence;
er_vy_1_fig = trajectory_vy_1_post_convergence - reference_vy_1_post_convergence;
er_vz_1_fig = trajectory_vz_1_post_convergence - reference_vz_1_post_convergence;

% MSEの計算
%速度
mse_vx_1 = mean((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2);
mse_vy_1 = mean((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2);
mse_vz_1 = mean((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2);
mse_vx_1_fig = (trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2;
mse_vy_1_fig = (trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2;
mse_vz_1_fig = (trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2;

% RMSEの計算
%速度
rmse_vx_1 = sqrt(mean((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2));
rmse_vy_1 = sqrt(mean((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2));
rmse_vz_1 = sqrt(mean((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2));
rmse_vx_1_fig = sqrt((trajectory_vx_1_post_convergence - reference_vx_1_post_convergence).^2);
rmse_vy_1_fig = sqrt((trajectory_vy_1_post_convergence - reference_vy_1_post_convergence).^2);
rmse_vz_1_fig = sqrt((trajectory_vz_1_post_convergence - reference_vz_1_post_convergence).^2);

% MAEの計算
%速度
mae_vx_1 = mean(abs(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence));
mae_vy_1 = mean(abs(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence));
mae_vz_1 = mean(abs(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence));
mae_vx_1_fig = abs(trajectory_vx_1_post_convergence - reference_vx_1_post_convergence);
mae_vy_1_fig = abs(trajectory_vy_1_post_convergence - reference_vy_1_post_convergence);
mae_vz_1_fig = abs(trajectory_vz_1_post_convergence - reference_vz_1_post_convergence);

%最大誤差
max_error_vx_1 = max(abs(vx_est_sel(convergence_time_index:end) - vx_ref_sel(convergence_time_index:end)));
max_error_vy_1 = max(abs(vy_est_sel(convergence_time_index:end) - vy_ref_sel(convergence_time_index:end)));
max_error_vz_1 = max(abs(vz_est_sel(convergence_time_index:end) - vz_ref_sel(convergence_time_index:end)));

% 結果を表示
fprintf('速度vx_1の収束後の速度誤差: %f\n', er_vx_1);
fprintf('速度vy_1の収束後の速度誤差: %f\n', er_vy_1);
fprintf('速度vz_1の収束後の速度誤差: %f\n', er_vz_1);
fprintf('速度vx_1の収束後の速度MSE: %f\n', mse_vx_1);
fprintf('速度vy_1の収束後の速度MSE: %f\n', mse_vy_1);
fprintf('速度vz_1の収束後の速度MSE: %f\n', mse_vz_1);
fprintf('速度vx_1の収束後の速度RMSE: %f\n', rmse_vx_1);
fprintf('速度vy_1の収束後の速度RMSE: %f\n', rmse_vy_1);
fprintf('速度vz_1の収束後の速度RMSE: %f\n', rmse_vz_1);
fprintf('速度vx_1の収束後の速度MAE: %f\n', mae_vx_1);
fprintf('速度vy_1の収束後の速度MAE: %f\n', mae_vy_1);
fprintf('速度vz_1の収束後の速度MAE: %f\n', mae_vz_1);
fprintf('速度vx_1の収束後の速度最大誤差: %f\n', max_error_vx_1);
fprintf('速度vy_1の収束後の速度最大誤差: %f\n', max_error_vy_1);
fprintf('速度vz_1の収束後の速度最大誤差: %f\n', max_error_vz_1);

%推定値と目標値
figure;
plot(t_1_post_convergence,vx_est_sel(convergence_time_index:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1.5 1.5])
hold on
plot(t_1_post_convergence,vy_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,vz_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,vx_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,vy_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,vz_ref_sel(convergence_time_index:end), '--','LineWidth',2);
legend('v_x.est','v_y.est','v_z.est', ...
    'v_x.ref','v_y.ref','v_z.ref','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
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
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,er_vy_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,er_vz_1_fig(1:end), '-','LineWidth',2);
legend('v_x.error','v_y.error','v_z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MSE
figure;
plot(t_1_post_convergence,mse_vx_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[(m/s)^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,mse_vy_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mse_vz_1_fig(1:end), '-','LineWidth',2);
legend('v_x.error','v_y.error','v_z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%RMSE
figure;
plot(t_1_post_convergence,rmse_vx_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,rmse_vy_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,rmse_vz_1_fig(1:end), '-','LineWidth',2);
legend('v_x.error','v_y.error','v_z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MAE
figure;
plot(t_1_post_convergence,mae_vx_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-0.4 0.4])
hold on
plot(t_1_post_convergence,mae_vy_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mae_vz_1_fig(1:end), '-','LineWidth',2);
legend('v_x.error','v_y.error','v_z.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%% 収束後　姿勢

% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);

% % 収束閾値を設定（例：0.01）
% threshold = 0.1;
% 
% % 各軌道が収束する最初の時刻を見つける
% convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
% convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
% convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
% convergence_time_xyz = [convergence_time_index_x_1 convergence_time_index_y_1 convergence_time_index_z_1];
% 
% % どれか遅い方の収束時刻を選ぶ
% convergence_time_index = max(convergence_time_xyz);
% convergence_time = t_sel(1:convergence_time_index); % 収束時刻

threshold = 0.15;  % 収束閾値
T_continuous = 3;  % 連続収束の閾値（秒）

% 収束時間を計算するための変数
convergence_start_time = NaN;  % 収束開始時刻
convergence_duration = 0;      % 収束時間の初期化
convergence_row = NaN;         % 収束開始行の初期化
found_convergence = false;     % 収束が確認されたかどうかのフラグ

for i = 1:length(error_z_1)
    % 現在の誤差が収束閾値を満たしているか確認
    if abs(error_x_1(i)) < threshold && abs(error_y_1(i)) < threshold && abs(error_z_1(i)) < threshold
        if isnan(convergence_start_time)  % 収束開始時刻が未設定の場合
            convergence_start_time = t_sel(i);  % 収束開始時刻を設定
            convergence_row = i;                % 収束開始行を記録
        end
    else
        % 収束条件が満たされない場合
        if ~isnan(convergence_start_time)  % 収束開始時刻が設定されている場合
            end_time = t_sel(i - 1);  % 収束終了時刻（直前の時刻）
            duration = end_time - convergence_start_time;  % 収束が続いた時間を計算

            % T_continuous（連続収束の閾値）を満たしているか確認
            if duration >= T_continuous
                fprintf('連続収束が確認されました。収束開始時刻: %.5f秒, 収束時間: %.5f秒, 収束開始行: %d\n', convergence_start_time, duration, convergence_row);
                found_convergence = true;
                break;  % 最初の収束が確認されたらループを終了
            else
                % 時間が足りなかった場合、再度リセットして次の期間を確認
                convergence_start_time = NaN;
                convergence_row = NaN;
            end
        end
    end
end

% 最後のデータ点で収束しているか確認
if ~found_convergence && ~isnan(convergence_start_time)
    end_time = t_sel(end);  % 最後の時刻を取得
    duration = end_time - convergence_start_time;

    if duration >= T_continuous
        fprintf('連続収束が確認されました。収束開始時刻: %.5f秒, 収束時間: %.5f秒, 収束開始行: %d\n', convergence_start_time, duration, convergence_row);
    else
        fprintf('収束は確認されたが、時間が%.5f秒でT_continuousを満たしていません。\n', duration);
    end
end

% 収束開始行を結果として返す
convergence_time_index = convergence_row;

% 収束時刻以降のデータ
trajectory_roll_1_post_convergence = roll_est_sel(convergence_time_index:end);
trajectory_pitch_1_post_convergence = pitch_est_sel(convergence_time_index:end);
trajectory_yaw_1_post_convergence = yaw_est_sel(convergence_time_index:end);
t_1_post_convergence = t_sel(convergence_time_index:end);

reference_roll_1_post_convergence = roll_ref_sel(convergence_time_index:end);
reference_pitch_1_post_convergence = pitch_ref_sel(convergence_time_index:end);
reference_yaw_1_post_convergence = yaw_ref_sel(convergence_time_index:end);

%誤差の計算
%姿勢
er_roll_1 = mean(trajectory_roll_1_post_convergence - reference_roll_1_post_convergence);
er_pitch_1 = mean(trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence);
er_yaw_1 = mean(trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence);
er_roll_1_fig = trajectory_roll_1_post_convergence - reference_roll_1_post_convergence;
er_pitch_1_fig = trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence;
er_yaw_1_fig = trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence;

% MSEの計算
%姿勢
mse_roll_1 = mean((trajectory_roll_1_post_convergence - reference_roll_1_post_convergence).^2);
mse_pitch_1 = mean((trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence).^2);
mse_yaw_1 = mean((trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence).^2);
mse_roll_1_fig = (trajectory_vx_1_post_convergence - reference_roll_1_post_convergence).^2;
mse_pitch_1_fig = (trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence).^2;
mse_yaw_1_fig = (trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence).^2;

% RMSEの計算
%姿勢
rmse_roll_1 = sqrt(mean((trajectory_roll_1_post_convergence - reference_roll_1_post_convergence).^2));
rmse_pitch_1 = sqrt(mean((trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence).^2));
rmse_yaw_1 = sqrt(mean((trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence).^2));
rmse_roll_1_fig = sqrt((trajectory_roll_1_post_convergence - reference_roll_1_post_convergence).^2);
rmse_pitch_1_fig = sqrt((trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence).^2);
rmse_yaw_1_fig = sqrt((trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence).^2);

% MAEの計算
%姿勢
mae_roll_1 = mean(abs(trajectory_roll_1_post_convergence - reference_roll_1_post_convergence));
mae_pitch_1 = mean(abs(trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence));
mae_yaw_1 = mean(abs(trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence));
mae_roll_1_fig = abs(trajectory_roll_1_post_convergence - reference_roll_1_post_convergence);
mae_pitch_1_fig = abs(trajectory_pitch_1_post_convergence - reference_pitch_1_post_convergence);
mae_yaw_1_fig = abs(trajectory_yaw_1_post_convergence - reference_yaw_1_post_convergence);

%最大誤差
max_error_roll_1 = max(abs(roll_est_sel(convergence_time_index:end) - roll_ref_sel(convergence_time_index:end)));
max_error_pitch_1 = max(abs(pitch_est_sel(convergence_time_index:end) - pitch_ref_sel(convergence_time_index:end)));
max_error_yaw_1 = max(abs(yaw_est_sel(convergence_time_index:end) - yaw_ref_sel(convergence_time_index:end)));

% 結果を表示
fprintf('姿勢roll_1の収束後の姿勢誤差: %f\n', er_roll_1);
fprintf('姿勢pitch_1の収束後の姿勢誤差: %f\n', er_pitch_1);
fprintf('姿勢yaw_1の収束後の姿勢誤差: %f\n', er_yaw_1);
fprintf('姿勢roll_1の収束後の姿勢MSE: %f\n', mse_roll_1);
fprintf('姿勢pitch_1の収束後の姿勢MSE: %f\n', mse_pitch_1);
fprintf('姿勢yaw_1の収束後の姿勢MSE: %f\n', mse_yaw_1);
fprintf('姿勢roll_1の収束後の姿勢RMSE: %f\n', rmse_roll_1);
fprintf('姿勢pitch_1の収束後の姿勢RMSE: %f\n', rmse_pitch_1);
fprintf('姿勢yaw_1の収束後の姿勢RMSE: %f\n', rmse_yaw_1);
fprintf('姿勢rollの収束後の姿勢MAE: %f\n', mae_roll_1);
fprintf('姿勢pitch_1の収束後の姿勢MAE: %f\n', mae_pitch_1);
fprintf('姿勢yaw_1の収束後の姿勢MAE: %f\n', mae_yaw_1);
fprintf('姿勢rollの収束後の姿勢最大誤差: %f\n', max_error_roll_1);
fprintf('姿勢pitch_1の収束後の姿勢最大誤差: %f\n', max_error_pitch_1);
fprintf('姿勢yaw_1の収束後の姿勢最大誤差: %f\n', max_error_yaw_1);

%推定値と目標値
figure;
plot(t_1_post_convergence,roll_est_sel(convergence_time_index:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[rad]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-5 5])
hold on
plot(t_1_post_convergence,pitch_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,yaw_est_sel(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,roll_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,pitch_ref_sel(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,yaw_ref_sel(convergence_time_index:end), '--','LineWidth',2);
legend('\Phi.est','\theta.est','\Psi.estr', ...
    '\Phi.ref','\theta.ref','\Psi.ref','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%誤差
figure;
plot(t_1_post_convergence,er_roll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[rad]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-5 5])
hold on
plot(t_1_post_convergence,er_pitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,er_yaw_1_fig(1:end), '-','LineWidth',2);
legend('\Phi.error','\theta.error','\Psi.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MSE
figure;
plot(t_1_post_convergence,mse_roll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[rad^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-5 5])
hold on
plot(t_1_post_convergence,mse_pitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mse_yaw_1_fig(1:end), '-','LineWidth',2);
legend('\Phi.error','\theta.error','\Psi.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%RMSE
figure;
plot(t_1_post_convergence,rmse_roll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[rad]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-5 5])
hold on
plot(t_1_post_convergence,rmse_pitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,rmse_yaw_1_fig(1:end), '-','LineWidth',2);
legend('\Phi.error','\theta.error','\Psi.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MAE
figure;
plot(t_1_post_convergence,mae_roll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[rad]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-5 5])
hold on
plot(t_1_post_convergence,mae_pitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mae_yaw_1_fig(1:end), '-','LineWidth',2);
legend('\Phi.error','\theta.error','\Psi.error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%% 収束後　入力

% 誤差の計算
error_x_1 = abs(x_est_sel - x_ref_sel);
error_y_1 = abs(y_est_sel - y_ref_sel);
error_z_1 = abs(z_est_sel - z_ref_sel);

% 収束閾値を設定（例：0.01）
threshold = 0.1;

% 各軌道が収束する最初の時刻を見つける
convergence_time_index_x_1 = find(error_x_1 < threshold, 1);
convergence_time_index_y_1 = find(error_y_1 < threshold, 1);
convergence_time_index_z_1 = find(error_z_1 < threshold, 1);
convergence_time_xyz = [convergence_time_index_x_1 convergence_time_index_y_1 convergence_time_index_z_1];

% どれか遅い方の収束時刻を選ぶ
convergence_time_index = max(convergence_time_xyz);
convergence_time = t_sel(1:convergence_time_index); % 収束時刻

% 収束時刻以降のデータ
reference_inturoll_1_post_convergence = input_roll_sell(convergence_time_index:end);
reference_intupitch_1_post_convergence = input_pitch_sell(convergence_time_index:end);
reference_intuyaw_1_post_convergence = input_yaw_sell(convergence_time_index:end);
reference_intuthrottle_1_post_convergence = input_throttle_sell(convergence_time_index:end);
t_1_post_convergence = t_sel(convergence_time_index:end);

trajectory_inroll_1_post_convergence = inputtran_roll_sell(convergence_time_index:end);
trajectory_inpitch_1_post_convergence = inputtran_pitch_sell(convergence_time_index:end);
trajectory_inyaw_1_post_convergence = inputtran_yaw_sell(convergence_time_index:end);
trajectory_inthrottle_1_post_convergence = inputtran_throttle_sell(convergence_time_index:end);

%誤差の計算
%入力
er_inroll_1 = mean(trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence);
er_inpitch_1 = mean(trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence);
er_inyaw_1 = mean(trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence);
er_inthrottle_1 = mean(trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence);
er_inroll_1_fig = trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence;
er_inpitch_1_fig = trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence;
er_inyaw_1_fig = trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence;
er_inthrottle_1_fig = trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence;

% MSEの計算
%入力
mse_inroll_1 = mean((trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence).^2);
mse_inpitch_1 = mean((trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence).^2);
mse_inyaw_1 = mean((trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence).^2);
mse_inthrottle_1 = mean((trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence).^2);
mse_inroll_1_fig = (trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence).^2;
mse_inpitch_1_fig = (trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence).^2;
mse_inyaw_1_fig = (trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence).^2;
mse_inthrottle_1_fig = (trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence).^2;

% RMSEの計算
%入力
rmse_inroll_1 = sqrt(mean((trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence).^2));
rmse_inpitch_1 = sqrt(mean((trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence).^2));
rmse_inyaw_1 = sqrt(mean((trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence).^2));
rmse_inthrottle_1 = sqrt(mean((trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence).^2));
rmse_inroll_1_fig = sqrt((trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence).^2);
rmse_inpitch_1_fig = sqrt((trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence).^2);
rmse_inyaw_1_fig = sqrt((trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence).^2);
rmse_inthrottle_1_fig = sqrt((trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence).^2);

% MAEの計算
%入力
mae_inroll_1 = mean(abs(trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence));
mae_inpitch_1 = mean(abs(trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence));
mae_inyaw_1 = mean(abs(trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence));
mae_inthrottle_1 = mean(abs(trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence));
mae_inroll_1_fig = abs(trajectory_inroll_1_post_convergence - reference_inturoll_1_post_convergence);
mae_inpitch_1_fig = abs(trajectory_inpitch_1_post_convergence - reference_intupitch_1_post_convergence);
mae_inyaw_1_fig = abs(trajectory_inyaw_1_post_convergence - reference_intuyaw_1_post_convergence);
mae_inthrottle_1_fig = abs(trajectory_inthrottle_1_post_convergence - reference_intuthrottle_1_post_convergence);

%最大誤差
max_inerror_roll_1 = max(abs(input_roll_sell(convergence_time_index:end) - inputtran_roll_sell(convergence_time_index:end)));
max_inerror_pitch_1 = max(abs(input_pitch_sell(convergence_time_index:end) - inputtran_pitch_sell(convergence_time_index:end)));
max_inerror_yaw_1 = max(abs(input_yaw_sell(convergence_time_index:end) - inputtran_yaw_sell(convergence_time_index:end)));
max_inerror_throttle_1 = max(abs(input_throttle_sell(convergence_time_index:end) - inputtran_throttle_sell(convergence_time_index:end)));

% 結果を表示
fprintf('入力roll_1の収束後の入力誤差: %f\n', er_inroll_1);
fprintf('入力pitch_1の収束後の入力誤差: %f\n', er_inpitch_1);
fprintf('入力yaw_1の収束後の入力誤差: %f\n', er_inyaw_1);
fprintf('入力throttle_1の収束後の入力誤差: %f\n', er_inthrottle_1);
fprintf('入力roll_1の収束後の入力MSE: %f\n', mse_inroll_1);
fprintf('入力pitch_1の収束後の入力MSE: %f\n', mse_inpitch_1);
fprintf('入力yaw_1の収束後の入力MSE: %f\n', mse_inyaw_1);
fprintf('入力throttle_1の収束後の入力MSE: %f\n', mse_inthrottle_1);
fprintf('入力roll_1の収束後の入力RMSE: %f\n', rmse_inroll_1);
fprintf('入力pitch_1の収束後の入力RMSE: %f\n', rmse_inpitch_1);
fprintf('入力yaw_1の収束後の入力RMSE: %f\n', rmse_inyaw_1);
fprintf('入力throttle_1の収束後の入力RMSE: %f\n', rmse_inthrottle_1);
fprintf('入力rollの収束後の入力MAE: %f\n', mae_inroll_1);
fprintf('入力pitch_1の収束後の入力MAE: %f\n', mae_inpitch_1);
fprintf('入力yaw_1の収束後の入力MAE: %f\n', mae_inyaw_1);
fprintf('入力throttle_1の収束後の入力MAE: %f\n', mae_inthrottle_1);
fprintf('入力rollの収束後の入力最大誤差: %f\n', max_inerror_roll_1);
fprintf('入力pitch_1の収束後の入力最大誤差: %f\n', max_inerror_pitch_1);
fprintf('入力yaw_1の収束後の入力最大誤差: %f\n', max_inerror_yaw_1);
fprintf('入力yaw_1の収束後の入力最大誤差: %f\n', max_inerror_throttle_1);

%推定値と目標値
figure;
plot(t_1_post_convergence,input_roll_sell(convergence_time_index:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Input[N]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([1100 2100])
hold on
plot(t_1_post_convergence,input_pitch_sell(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,input_yaw_sell(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,input_throttle_sell(convergence_time_index:end), '-','LineWidth',2);
plot(t_1_post_convergence,inputtran_roll_sell(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,inputtran_pitch_sell(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,inputtran_yaw_sell(convergence_time_index:end), '--','LineWidth',2);
plot(t_1_post_convergence,inputtran_throttle_sell(convergence_time_index:end), '--','LineWidth',2);
legend('Roll-estimator','Pitch-estimator','Yaw-estimator', ...
    'Roll-reference','Pitch-reference','Yaw-reference','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%誤差
figure;
plot(t_1_post_convergence,er_inroll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[m/s^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1 1])
hold on
plot(t_1_post_convergence,er_inpitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,er_inyaw_1_fig(1:end), '-','LineWidth',2);
legend('Roll-error','Pitch-error','Yaw-error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MSE
figure;
plot(t_1_post_convergence,mse_inroll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[(m/s^2)^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1 1])
hold on
plot(t_1_post_convergence,mse_inpitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mse_inyaw_1_fig(1:end), '-','LineWidth',2);
legend('Roll-error','Pitch-error','Yaw-error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%RMSE
figure;
plot(t_1_post_convergence,rmse_inroll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[m/s^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1 1])
hold on
plot(t_1_post_convergence,rmse_inpitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,rmse_inyaw_1_fig(1:end), '-','LineWidth',2);
legend('Roll-error','Pitch-error','Yaw-error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%MAE
figure;
plot(t_1_post_convergence,mae_inroll_1_fig(1:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Attitude[m/s^2]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_1_post_convergence(1,1) inf])
ylim([-1 1])
hold on
plot(t_1_post_convergence,mae_inpitch_1_fig(1:end), '-','LineWidth',2);
plot(t_1_post_convergence,mae_inyaw_1_fig(1:end), '-','LineWidth',2);
legend('Roll-error','Pitch-error','Yaw-error','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

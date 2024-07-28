%まずは現在のフォルダからパスが通っているかを確認

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
rpy_com = newLog1.reference.q;%上からz,y,zの指令値
xyz_com = newLog1.reference.p;%上からroll,pitch,yawの指令値
v_com = newLog1.reference.v;%速度の指令値
input = newLog1.controller.input;%入力
transmitter_input = newLog1.inner_input;%プロポからの指令

x = rpy(1, :);
y = rpy(2, :);

figure;
plot(x, y, '-'); % '-o'はデータ点をマークするためのオプション
xlabel('X軸 (1行目)');
ylabel('Y軸 (2行目)');
title('1行目をX軸、2行目をY軸としたプロット');
grid on; % グリッドを表示
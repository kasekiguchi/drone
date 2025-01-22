%まずは現在のフォルダからパスが通っているかを確認
%%
%セクションの実行
% newLog1 = LOGGER("Data/20241119_1524_kizon_double_Log(19-Nov-2024_15_24_43).mat");
% logging(newLog1, newLog1.Data.t, 102, 1:2)
% data = return_state_prop(newLog1)
% newLog1 = simplifyLogger(log);
%機体1と機体2
[newLog1,newLog2] = simplifyLogger(log1);
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

t_2 = newLog2.t; %t:時間
phase_2 = newLog2.phase;%phase:アーミングやフライトなどの状態
k_2 = newLog2.k;%データ数
rpy_s2 = newLog2.sensor.q;%Attitude上からroll,pitch,yawの実測値
xyz_s2 = newLog2.sensor.p;%Position上からz,y,zの実測値
rpy_est2 = newLog2.estimator.q;%上からz,y,zの推定値
xyz_est2 = newLog2.estimator.p;%上からroll,pitch,yawの推定値
v_est2 = newLog2.estimator.v;%速度の推定値
w_est2 = newLog2.estimator.w;%角速度の推定値
rpy_r2 = newLog2.reference.q;%上からz,y,zの指令値
xyz_r2 = newLog2.reference.p;%上からroll,pitch,yawの指令値
v_r2 = newLog2.reference.v;%速度の指令値
input_2 = newLog2.controller.input;%入力
transmitterinput_2 = newLog2.inner_input;%プロポからの指令

%%
%セクションの実行
%機体3と機体4
[newLog3,newLog4] = simplifyLogger(log2);
t_3 = newLog3.t; %t:時間
phase_3 = newLog3.phase;%phase:アーミングやフライトなどの状態
k_3 = newLog3.k;%データ数
rpy_s3 = newLog3.sensor.q;%Attitude上からroll,pitch,yawの実測値
xyz_s3 = newLog3.sensor.p;%Position上からz,y,zの実測値
rpy_est3 = newLog3.estimator.q;%上からz,y,zの推定値
xyz_est3 = newLog3.estimator.p;%上からroll,pitch,yawの推定値
v_est3 = newLog3.estimator.v;%速度の推定値
w_est3 = newLog3.estimator.w;%角速度の推定値
rpy_r3 = newLog3.reference.q;%上からz,y,zの指令値
xyz_r3 = newLog3.reference.p;%上からroll,pitch,yawの指令値
v_r3 = newLog3.reference.v;%速度の指令値
input_3 = newLog3.controller.input;%入力
transmitterinput_3 = newLog3.inner_input;%プロポからの指令

t_4 = newLog4.t; %t:時間
phase_4 = newLog4.phase;%phase:アーミングやフライトなどの状態
k_4 = newLog4.k;%データ数
rpy_s4 = newLog4.sensor.q;%Attitude上からroll,pitch,yawの実測値
xyz_s4 = newLog4.sensor.p;%Position上からz,y,zの実測値
rpy_est4 = newLog4.estimator.q;%上からz,y,zの推定値
xyz_est4 = newLog4.estimator.p;%上からroll,pitch,yawの推定値
v_est4 = newLog4.estimator.v;%速度の推定値
w_est4 = newLog4.estimator.w;%角速度の推定値
rpy_r4 = newLog4.reference.q;%上からz,y,zの指令値
xyz_r4 = newLog4.reference.p;%上からroll,pitch,yawの指令値
v_r4 = newLog4.reference.v;%速度の指令値
input_4 = newLog4.controller.input;%入力
transmitterinput_4 = newLog4.inner_input;%プロポからの指令

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

roll_s2 = rpy_s2(1, :);
pitch_s2 = rpy_s2(2, :);
yaw_s2 = rpy_s2(3, :);
x_s2 = xyz_s2(1, :);
y_s2 = xyz_s2(2, :);
z_s2 = xyz_s2(3, :);
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
inproll_2 = input_2(1,:);
inppitch_2 = input_2(2,:);
inpthrottle_2 = input_2(3,:);
inpyaw_2 = input_2(4,:);
in_inproll_2 = transmitterinput_2(1,:);
in_inppitch_2 = transmitterinput_2(2,:);
in_inpthrottle_2 = transmitterinput_2(3,:);
in_inpyaw_2 = transmitterinput_2(4,:);
in_AUX1_2 = transmitterinput_2(5,:);
in_AUX2_2 = transmitterinput_2(6,:);
in_AUX3_2 = transmitterinput_2(7,:);
in_AUX4_2 = transmitterinput_2(8,:);

%%
%セクションの実行
%機体3と機体4のlogデータの詳しい抜き出し
roll_s3 = rpy_s3(1, :);
pitch_s3 = rpy_s3(2, :);
yaw_s3 = rpy_s3(3, :);
x_s3 = xyz_s3(1, :);
y_s3 = xyz_s3(2, :);
z_s3 = xyz_s3(3, :);
roll_est3 = rpy_est3(1, :);
pitch_est3 = rpy_est3(2, :);
yaw_est3 = rpy_est3(3, :);
x_est3 = xyz_est3(1, :);
y_est3 = xyz_est3(2, :);
z_est3 = xyz_est3(3, :);
vx_est3 = v_est3(1, :);
vy_est3 = v_est3(2, :);
vz_est3 = v_est3(3, :);
wx_est3 = w_est3(1, :);
wy_est3 = w_est3(2, :);
wz_est3 = w_est3(3, :);
roll_ref3 = rpy_r3(1, :);
pitch_ref3 = rpy_r3(2, :);
yaw_ref3 = rpy_r3(3, :);
x_ref3 = xyz_r3(1, :);
y_ref3 = xyz_r3(2, :);
z_ref3 = xyz_r3(3, :);
vx_ref3 = v_r3(1, :);
vy_ref3 = v_r3(2, :);
vz_ref3 = v_r3(3, :);
inproll_3 = input_3(1,:);
inppitch_3 = input_3(2,:);
inpthrottle_3 = input_3(3,:);
inpyaw_3 = input_3(4,:);
in_inproll_3 = transmitterinput_3(1,:);
in_inppitch_3 = transmitterinput_3(2,:);
in_inpthrottle_3 = transmitterinput_3(3,:);
in_inpyaw_3 = transmitterinput_3(4,:);
in_AUX1_3 = transmitterinput_3(5,:);
in_AUX2_3 = transmitterinput_3(6,:);
in_AUX3_3 = transmitterinput_3(7,:);
in_AUX4_3 = transmitterinput_3(8,:);

roll_s4 = rpy_s4(1, :);
pitch_s4 = rpy_s4(2, :);
yaw_s4 = rpy_s4(3, :);
x_s4 = xyz_s4(1, :);
y_s4 = xyz_s4(2, :);
z_s4 = xyz_s4(3, :);
roll_est4 = rpy_est4(1, :);
pitch_est4 = rpy_est4(2, :);
yaw_est4 = rpy_est4(3, :);
x_est4 = xyz_est4(1, :);
y_est4 = xyz_est4(2, :);
z_est4 = xyz_est4(3, :);
vx_est4 = v_est4(1, :);
vy_est4 = v_est4(2, :);
vz_est4 = v_est4(3, :);
wx_est4 = w_est4(1, :);
wy_est4 = w_est4(2, :);
wz_est4 = w_est4(3, :);
roll_ref4 = rpy_r4(1, :);
pitch_ref4 = rpy_r4(2, :);
yaw_ref4 = rpy_r4(3, :);
x_ref4 = xyz_r4(1, :);
y_ref4 = xyz_r4(2, :);
z_ref4 = xyz_r4(3, :);
vx_ref4 = v_r4(1, :);
vy_ref4 = v_r4(2, :);
vz_ref4 = v_r4(3, :);
inproll_4 = input_4(1,:);
inppitch_4 = input_4(2,:);
inpthrottle_4 = input_4(3,:);
inpyaw_4 = input_4(4,:);
in_inproll_4 = transmitterinput_4(1,:);
in_inppitch_4 = transmitterinput_4(2,:);
in_inpthrottle_4 = transmitterinput_4(3,:);
in_inpyaw_4 = transmitterinput_4(4,:);
in_AUX1_4 = transmitterinput_4(5,:);
in_AUX2_4 = transmitterinput_4(6,:);
in_AUX3_4 = transmitterinput_4(7,:);
in_AUX4_4 = transmitterinput_4(8,:);

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
    if phase_1(aa,1) == 116
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
    if phase_1(aa,1) == 116
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
    if phase_1(aa,1) == 116
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
    if phase_1(aa,1) == 116
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

%2p
aa = 1;
ba = height(t_2);
x_est_sel2 = [];
y_est_sel2 = [];
z_est_sel2 = [];
x_ref_sel2 = [];
y_ref_sel2 = [];
z_ref_sel2 = [];
t_sel2 = [];
while aa <= ba
    if phase_2(aa,1) == 116
        x_est_sel2 = [x_est_sel2,x_est2(1,aa)];
        y_est_sel2 = [y_est_sel2,y_est2(1,aa)];
        z_est_sel2 = [z_est_sel2,z_est2(1,aa)];
        x_ref_sel2 = [x_ref_sel2,x_ref2(1,aa)];
        y_ref_sel2 = [y_ref_sel2,y_ref2(1,aa)];
        z_ref_sel2 = [z_ref_sel2,z_ref2(1,aa)];
        t_sel2 = [t_sel2,t_2(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_2);
roll_est_sel2 = [];
pitch_est_sel2 = [];
yaw_est_sel2 = [];
roll_ref_sel2 = [];
pitch_ref_sel2 = [];
yaw_ref_sel2 = [];
t_sel2 = [];
while aa <= ba
    if phase_2(aa,1) == 116
        roll_est_sel2 = [roll_est_sel2,roll_est2(1,aa)];
        pitch_est_sel2 = [pitch_est_sel2,pitch_est2(1,aa)];
        yaw_est_sel2 = [yaw_est_sel2,yaw_est2(1,aa)];
        roll_ref_sel2 = [roll_ref_sel2,roll_ref2(1,aa)];
        pitch_ref_sel2 = [pitch_ref_sel2,pitch_ref2(1,aa)];
        yaw_ref_sel2 = [yaw_ref_sel2,yaw_ref2(1,aa)];
        t_sel2 = [t_sel2,t_2(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_2);
input_roll_sel2 = [];
input_pitch_sel2 = [];
input_throttle_sel2 = [];
input_yaw_sel2 = [];
ininput_roll_sel2 = [];
ininput_pitch_sel2 = [];
ininput_throttle_sel2 = [];
ininput_yaw_sel2 = [];
ininput_AUX1_sel2 = [];
ininput_AUX2_sel2 = [];
ininput_AUX3_sel2 = [];
ininput_AUX4_sel2 = [];
t_sel2 = [];
while aa <= ba
    if phase_2(aa,1) == 116
        input_roll_sel2 = [input_roll_sel2,inproll_2(1,aa)];
        input_pitch_sel2 = [input_pitch_sel2,inppitch_2(1,aa)];
        input_throttle_sel2 = [input_throttle_sel2,inpthrottle_2(1,aa)];
        input_yaw_sel2 = [input_yaw_sel2,inpyaw_2(1,aa)];
        ininput_roll_sel2 = [ininput_roll_sel2,in_inproll_2(1,aa)];
        ininput_pitch_sel2 = [ininput_pitch_sel2,in_inppitch_2(1,aa)];
        ininput_throttle_sel2 = [ininput_throttle_sel2,in_inpthrottle_2(1,aa)];
        ininput_yaw_sel2 = [ininput_yaw_sel2,in_inpyaw_2(1,aa)];
        ininput_AUX1_sel2 = [ininput_AUX1_sel2,in_AUX1_2(1,aa)];
        ininput_AUX2_sel2 = [ininput_AUX2_sel2,in_AUX2_2(1,aa)];
        ininput_AUX3_sel2 = [ininput_AUX3_sel2,in_AUX3_2(1,aa)];
        ininput_AUX4_sel2 = [ininput_AUX4_sel2,in_AUX4_2(1,aa)];
        t_sel2 = [t_sel2,t_2(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_2);
vx_est_sel2 = [];
vy_est_sel2 = [];
vz_est_sel2 = [];
vx_ref_sel2 = [];
vy_ref_sel2 = [];
vz_ref_sel2 = [];
t_sel2 = [];
while aa <= ba
    if phase_2(aa,1) == 116
        vx_est_sel2 = [vx_est_sel2,vx_est2(1,aa)];
        vy_est_sel2 = [vy_est_sel2,vy_est2(1,aa)];
        vz_est_sel2 = [vz_est_sel2,vz_est2(1,aa)];
        vx_ref_sel2 = [vx_ref_sel2,vx_ref2(1,aa)];
        vy_ref_sel2 = [vy_ref_sel2,vy_ref2(1,aa)];
        vz_ref_sel2 = [vz_ref_sel2,vz_ref2(1,aa)];
        t_sel2 = [t_sel2,t_2(aa,1)];
    end
    aa = aa + 1;
end

%%
%機体3と機体4の計算の下準備
%3p
aa = 1;
ba = height(t_3);
x_est_sel3 = [];
y_est_sel3 = [];
z_est_sel3 = [];
x_ref_sel3 = [];
y_ref_sel3 = [];
z_ref_sel3 = [];
t_sel3 = [];
while aa <= ba
    if phase_3(aa,1) == 116
        x_est_sel3 = [x_est_sel3,x_est3(1,aa)];
        y_est_sel3 = [y_est_sel3,y_est3(1,aa)];
        z_est_sel3 = [z_est_sel3,z_est3(1,aa)];
        x_ref_sel3 = [x_ref_sel3,x_ref3(1,aa)];
        y_ref_sel3 = [y_ref_sel3,y_ref3(1,aa)];
        z_ref_sel3 = [z_ref_sel3,z_ref3(1,aa)];
        t_sel3 = [t_sel3,t_3(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_3);
roll_est_sel3 = [];
pitch_est_sel3 = [];
yaw_est_sel3 = [];
roll_ref_sel3 = [];
pitch_ref_sel3 = [];
yaw_ref_sel3 = [];
t_sel3 = [];
while aa <= ba
    if phase_3(aa,1) == 116
        roll_est_sel3 = [roll_est_sel3,roll_est3(1,aa)];
        pitch_est_sel3 = [pitch_est_sel3,pitch_est3(1,aa)];
        yaw_est_sel3 = [yaw_est_sel3,yaw_est3(1,aa)];
        roll_ref_sel3 = [roll_ref_sel3,roll_ref3(1,aa)];
        pitch_ref_sel3 = [pitch_ref_sel3,pitch_ref3(1,aa)];
        yaw_ref_sel3 = [yaw_ref_sel3,yaw_ref3(1,aa)];
        t_sel3 = [t_sel3,t_3(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_3);
input_roll_sel3 = [];
input_pitch_sel3 = [];
input_throttle_sel3 = [];
input_yaw_sel3 = [];
ininput_roll_sel3 = [];
ininput_pitch_sel3 = [];
ininput_throttle_sel3 = [];
ininput_yaw_sel3 = [];
ininput_AUX1_sel3 = [];
ininput_AUX2_sel3 = [];
ininput_AUX3_sel3 = [];
ininput_AUX4_sel3 = [];
t_sel3 = [];
while aa <= ba
    if phase_3(aa,1) == 116
        input_roll_sel3 = [input_roll_sel3,inproll_3(1,aa)];
        input_pitch_sel3 = [input_pitch_sel3,inppitch_3(1,aa)];
        input_throttle_sel3 = [input_throttle_sel3,inpthrottle_3(1,aa)];
        input_yaw_sel3 = [input_yaw_sel3,inpyaw_3(1,aa)];
        ininput_roll_sel3 = [ininput_roll_sel3,in_inproll_3(1,aa)];
        ininput_pitch_sel3 = [ininput_pitch_sel3,in_inppitch_3(1,aa)];
        ininput_throttle_sel3 = [ininput_throttle_sel3,in_inpthrottle_3(1,aa)];
        ininput_yaw_sel3 = [ininput_yaw_sel3,in_inpyaw_3(1,aa)];
        ininput_AUX1_sel3 = [ininput_AUX1_sel3,in_AUX1_3(1,aa)];
        ininput_AUX2_sel3 = [ininput_AUX2_sel3,in_AUX2_3(1,aa)];
        ininput_AUX3_sel3 = [ininput_AUX3_sel3,in_AUX3_3(1,aa)];
        ininput_AUX4_sel3 = [ininput_AUX4_sel3,in_AUX4_3(1,aa)];
        t_sel3 = [t_sel3,t_3(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_3);
vx_est_sel3 = [];
vy_est_sel3 = [];
vz_est_sel3 = [];
vx_ref_sel3 = [];
vy_ref_sel3 = [];
vz_ref_sel3 = [];
t_sel3 = [];
while aa <= ba
    if phase_3(aa,1) == 116
        vx_est_sel3 = [vx_est_sel3,vx_est3(1,aa)];
        vy_est_sel3 = [vy_est_sel3,vy_est3(1,aa)];
        vz_est_sel3 = [vz_est_sel3,vz_est3(1,aa)];
        vx_ref_sel3 = [vx_ref_sel3,vx_ref3(1,aa)];
        vy_ref_sel3 = [vy_ref_sel3,vy_ref3(1,aa)];
        vz_ref_sel3 = [vz_ref_sel3,vz_ref3(1,aa)];
        t_sel3 = [t_sel3,t_3(aa,1)];
    end
    aa = aa + 1;
end

%4p
aa = 1;
ba = height(t_4);
x_est_sel4 = [];
y_est_sel4 = [];
z_est_sel4 = [];
x_ref_sel4 = [];
y_ref_sel4 = [];
z_ref_sel4 = [];
t_sel4 = [];
while aa <= ba
    if phase_4(aa,1) == 116
        x_est_sel4 = [x_est_sel4,x_est4(1,aa)];
        y_est_sel4 = [y_est_sel4,y_est4(1,aa)];
        z_est_sel4 = [z_est_sel4,z_est4(1,aa)];
        x_ref_sel4 = [x_ref_sel4,x_ref4(1,aa)];
        y_ref_sel4 = [y_ref_sel4,y_ref4(1,aa)];
        z_ref_sel4 = [z_ref_sel4,z_ref4(1,aa)];
        t_sel4 = [t_sel4,t_4(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_4);
roll_est_sel4 = [];
pitch_est_sel4 = [];
yaw_est_sel4 = [];
roll_ref_sel4 = [];
pitch_ref_sel4 = [];
yaw_ref_sel4 = [];
t_sel4 = [];
while aa <= ba
    if phase_4(aa,1) == 116
        roll_est_sel4 = [roll_est_sel4,roll_est4(1,aa)];
        pitch_est_sel4 = [pitch_est_sel4,pitch_est4(1,aa)];
        yaw_est_sel4 = [yaw_est_sel4,yaw_est4(1,aa)];
        roll_ref_sel4 = [roll_ref_sel4,roll_ref4(1,aa)];
        pitch_ref_sel4 = [pitch_ref_sel4,pitch_ref4(1,aa)];
        yaw_ref_sel4 = [yaw_ref_sel4,yaw_ref4(1,aa)];
        t_sel4 = [t_sel4,t_4(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_4);
input_roll_sel4 = [];
input_pitch_sel4 = [];
input_throttle_sel4 = [];
input_yaw_sel4 = [];
ininput_roll_sel4 = [];
ininput_pitch_sel4 = [];
ininput_throttle_sel4 = [];
ininput_yaw_sel4 = [];
ininput_AUX1_sel4 = [];
ininput_AUX2_sel4 = [];
ininput_AUX3_sel4 = [];
ininput_AUX4_sel4 = [];
t_sel4 = [];
while aa <= ba
    if phase_4(aa,1) == 116
        input_roll_sel4 = [input_roll_sel4,inproll_4(1,aa)];
        input_pitch_sel4 = [input_pitch_sel4,inppitch_4(1,aa)];
        input_throttle_sel4 = [input_throttle_sel4,inpthrottle_4(1,aa)];
        input_yaw_sel4 = [input_yaw_sel4,inpyaw_4(1,aa)];
        ininput_roll_sel4 = [ininput_roll_sel4,in_inproll_4(1,aa)];
        ininput_pitch_sel4 = [ininput_pitch_sel4,in_inppitch_4(1,aa)];
        ininput_throttle_sel4 = [ininput_throttle_sel4,in_inpthrottle_4(1,aa)];
        ininput_yaw_sel4 = [ininput_yaw_sel4,in_inpyaw_4(1,aa)];
        ininput_AUX1_sel4 = [ininput_AUX1_sel4,in_AUX1_4(1,aa)];
        ininput_AUX2_sel4 = [ininput_AUX2_sel4,in_AUX2_4(1,aa)];
        ininput_AUX3_sel4 = [ininput_AUX3_sel4,in_AUX3_4(1,aa)];
        ininput_AUX4_sel4 = [ininput_AUX4_sel4,in_AUX4_4(1,aa)];
        t_sel4 = [t_sel4,t_4(aa,1)];
    end
    aa = aa + 1;
end

aa = 1;
ba = height(t_4);
vx_est_sel4 = [];
vy_est_sel4 = [];
vz_est_sel4 = [];
vx_ref_sel4 = [];
vy_ref_sel4 = [];
vz_ref_sel4 = [];
t_sel4 = [];
while aa <= ba
    if phase_4(aa,1) == 116
        vx_est_sel4 = [vx_est_sel4,vx_est4(1,aa)];
        vy_est_sel4 = [vy_est_sel4,vy_est4(1,aa)];
        vz_est_sel4 = [vz_est_sel4,vz_est4(1,aa)];
        vx_ref_sel4 = [vx_ref_sel4,vx_ref4(1,aa)];
        vy_ref_sel4 = [vy_ref_sel4,vy_ref4(1,aa)];
        vz_ref_sel4 = [vz_ref_sel4,vz_ref4(1,aa)];
        t_sel4 = [t_sel4,t_4(aa,1)];
    end
    aa = aa + 1;
end

%% 収束後　位置

ftime = 0;      % 収束時間の初期化
shuti = 0;
ftime2 = 0;
shuti2 = 0;

for i = 1:length(vx_est_sel1)
    % 現在の誤差が収束閾値を満たしているか確認
    if t_sel1(i) > 14 && ftime == 0

            convergence_start_time = t_sel1(i);  % 収束開始時刻を設定
            shuti = i;                % 収束開始行を記録
            ftime = 1;
    end
end
for i = 1:length(vx_est_sel4)
    % 現在の誤差が収束閾値を満たしているか確認
    if t_sel4(i) > 14 && ftime2 == 0

            convergence_start_time2 = t_sel3(i);  % 収束開始時刻を設定
            shuti2 = i;                % 収束開始行を記録
            ftime2 = 1;
    end
end

% 誤差の計算
%位置
er_x_1 = mean(x_est_sel1(shuti:end) - x_ref_sel1(shuti:end));
er_y_1 = mean(y_est_sel1(shuti:end) - y_ref_sel1(shuti:end));
er_z_1 = mean(z_est_sel1(shuti:end) - z_ref_sel1(shuti:end));
er_x_1_fig = x_est_sel1(shuti:end) - x_ref_sel1(shuti:end);
er_y_1_fig = y_est_sel1(shuti:end) - y_ref_sel1(shuti:end);
er_z_1_fig = z_est_sel1(shuti:end) - z_ref_sel1(shuti:end);

er_x_2 = mean(x_est_sel2(shuti:end) - x_ref_sel2(shuti:end));
er_y_2 = mean(y_est_sel2(shuti:end) - y_ref_sel2(shuti:end));
er_z_2 = mean(z_est_sel2(shuti:end) - z_ref_sel2(shuti:end));
er_x_2_fig = x_est_sel2(shuti:end) - x_ref_sel2(shuti:end);
er_y_2_fig = y_est_sel2(shuti:end) - y_ref_sel2(shuti:end);
er_z_2_fig = z_est_sel2(shuti:end) - z_ref_sel2(shuti:end);

er_x_3 = mean(x_est_sel3(shuti2:end) - x_ref_sel3(shuti2:end));
er_y_3 = mean(y_est_sel3(shuti2:end) - y_ref_sel3(shuti2:end));
er_z_3 = mean(z_est_sel3(shuti2:end) - z_ref_sel3(shuti2:end));
er_x_3_fig = x_est_sel3(shuti2:end) - x_ref_sel3(shuti2:end);
er_y_3_fig = y_est_sel3(shuti2:end) - y_ref_sel3(shuti2:end);
er_z_3_fig = z_est_sel3(shuti2:end) - z_ref_sel3(shuti2:end);

er_x_4 = mean(x_est_sel4(shuti2:end) - x_ref_sel4(shuti2:end));
er_y_4 = mean(y_est_sel4(shuti2:end) - y_ref_sel4(shuti2:end));
er_z_4 = mean(z_est_sel4(shuti2:end) - z_ref_sel4(shuti2:end));
er_x_4_fig = x_est_sel4(shuti2:end) - x_ref_sel4(shuti2:end);
er_y_4_fig = y_est_sel4(shuti2:end) - y_ref_sel4(shuti2:end);
er_z_4_fig = z_est_sel4(shuti2:end) - z_ref_sel4(shuti2:end);

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
rmse_x_1 = sqrt(mean((x_est_sel1(shuti:end) - x_ref_sel1(shuti:end)).^2));
rmse_y_1 = sqrt(mean((y_est_sel1(shuti:end) - y_ref_sel1(shuti:end)).^2));
rmse_z_1 = sqrt(mean((z_est_sel1(shuti:end) - z_ref_sel1(shuti:end)).^2));
rmse_x_1_fig = sqrt((x_est_sel1(shuti:end) - x_ref_sel1(shuti:end)).^2);
rmse_y_1_fig = sqrt((y_est_sel1(shuti:end) - y_ref_sel1(shuti:end)).^2);
rmse_z_1_fig = sqrt((z_est_sel1(shuti:end) - z_ref_sel1(shuti:end)).^2);

rmse_x_2 = sqrt(mean((x_est_sel2(shuti:end) - x_ref_sel2(shuti:end)).^2));
rmse_y_2 = sqrt(mean((y_est_sel2(shuti:end) - y_ref_sel2(shuti:end)).^2));
rmse_z_2 = sqrt(mean((z_est_sel2(shuti:end) - z_ref_sel2(shuti:end)).^2));
rmse_x_2_fig = sqrt((x_est_sel2(shuti:end) - x_ref_sel2(shuti:end)).^2);
rmse_y_2_fig = sqrt((y_est_sel2(shuti:end) - y_ref_sel2(shuti:end)).^2);
rmse_z_2_fig = sqrt((z_est_sel2(shuti:end) - z_ref_sel2(shuti:end)).^2);

rmse_x_3 = sqrt(mean((x_est_sel3(shuti2:end) - x_ref_sel3(shuti2:end)).^2));
rmse_y_3 = sqrt(mean((y_est_sel3(shuti2:end) - y_ref_sel3(shuti2:end)).^2));
rmse_z_3 = sqrt(mean((z_est_sel3(shuti2:end) - z_ref_sel3(shuti2:end)).^2));
rmse_x_3_fig = sqrt((x_est_sel3(shuti2:end) - x_ref_sel3(shuti2:end)).^2);
rmse_y_3_fig = sqrt((y_est_sel3(shuti2:end) - y_ref_sel3(shuti2:end)).^2);
rmse_z_3_fig = sqrt((z_est_sel3(shuti2:end) - z_ref_sel3(shuti2:end)).^2);

rmse_x_4 = sqrt(mean((x_est_sel4(shuti2:end) - x_ref_sel4(shuti2:end)).^2));
rmse_y_4 = sqrt(mean((y_est_sel4(shuti2:end) - y_ref_sel4(shuti2:end)).^2));
rmse_z_4 = sqrt(mean((z_est_sel4(shuti2:end) - z_ref_sel4(shuti2:end)).^2));
rmse_x_4_fig = sqrt((x_est_sel4(shuti2:end) - x_ref_sel4(shuti2:end)).^2);
rmse_y_4_fig = sqrt((y_est_sel4(shuti2:end) - y_ref_sel4(shuti2:end)).^2);
rmse_z_4_fig = sqrt((z_est_sel4(shuti2:end) - z_ref_sel4(shuti2:end)).^2);

% MAEの計算
%位置
% mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
% mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
% mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
% mae_x_1_fig = abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
% mae_y_1_fig = abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
% mae_z_1_fig = abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence);

%最大誤差
max_error_x_1 = max(abs(x_est_sel1(shuti:end) - x_ref_sel1(shuti:end)));
max_error_y_1 = max(abs(y_est_sel1(shuti:end) - y_ref_sel1(shuti:end)));
max_error_z_1 = max(abs(z_est_sel1(shuti:end) - z_ref_sel1(shuti:end)));
max_error_x_2 = max(abs(x_est_sel2(shuti:end) - x_ref_sel2(shuti:end)));
max_error_y_2 = max(abs(y_est_sel2(shuti:end) - y_ref_sel2(shuti:end)));
max_error_z_2 = max(abs(z_est_sel2(shuti:end) - z_ref_sel2(shuti:end)));
max_error_x_3 = max(abs(x_est_sel3(shuti2:end) - x_ref_sel3(shuti2:end)));
max_error_y_3 = max(abs(y_est_sel3(shuti2:end) - y_ref_sel3(shuti2:end)));
max_error_z_3 = max(abs(z_est_sel3(shuti2:end) - z_ref_sel3(shuti2:end)));
max_error_x_4 = max(abs(x_est_sel4(shuti2:end) - x_ref_sel4(shuti2:end)));
max_error_y_4 = max(abs(y_est_sel4(shuti2:end) - y_ref_sel4(shuti2:end)));
max_error_z_4 = max(abs(z_est_sel4(shuti2:end) - z_ref_sel4(shuti2:end)));

% 結果を表示
% fprintf('軌道x_1の収束後の位置誤差: %f\n', er_x_1);
% fprintf('軌道y_1の収束後の位置誤差: %f\n', er_y_1);
% fprintf('軌道z_1の収束後の位置誤差: %f\n', er_z_1);
% fprintf('軌道x_2の収束後の位置誤差: %f\n', er_x_2);
% fprintf('軌道y_2の収束後の位置誤差: %f\n', er_y_2);
% fprintf('軌道z_2の収束後の位置誤差: %f\n', er_z_2);
% fprintf('軌道x_3の収束後の位置誤差: %f\n', er_x_3);
% fprintf('軌道y_3の収束後の位置誤差: %f\n', er_y_3);
% fprintf('軌道z_3の収束後の位置誤差: %f\n', er_z_3);
% fprintf('軌道x_4の収束後の位置誤差: %f\n', er_x_4);
% fprintf('軌道y_4の収束後の位置誤差: %f\n', er_y_4);
% fprintf('軌道z_4の収束後の位置誤差: %f\n', er_z_4);

fprintf('軌道x_1の収束後の位置RMSE: %f\n', rmse_x_1);
fprintf('軌道y_1の収束後の位置RMSE: %f\n', rmse_y_1);
fprintf('軌道z_1の収束後の位置RMSE: %f\n', rmse_z_1);
fprintf('軌道x_2の収束後の位置RMSE: %f\n', rmse_x_2);
fprintf('軌道y_2の収束後の位置RMSE: %f\n', rmse_y_2);
fprintf('軌道z_2の収束後の位置RMSE: %f\n', rmse_z_2);
fprintf('軌道x_3の収束後の位置RMSE: %f\n', rmse_x_3);
fprintf('軌道y_3の収束後の位置RMSE: %f\n', rmse_y_3);
fprintf('軌道z_3の収束後の位置RMSE: %f\n', rmse_z_3);
fprintf('軌道x_4の収束後の位置RMSE: %f\n', rmse_x_4);
fprintf('軌道y_4の収束後の位置RMSE: %f\n', rmse_y_4);
fprintf('軌道z_4の収束後の位置RMSE: %f\n', rmse_z_4);

% fprintf('軌道x_1の収束後の位置最大誤差: %f\n', max_error_x_1);
% fprintf('軌道y_1の収束後の位置最大誤差: %f\n', max_error_y_1);
% fprintf('軌道z_1の収束後の位置最大誤差: %f\n', max_error_z_1);
% fprintf('軌道x_2の収束後の位置最大誤差: %f\n', max_error_x_2);
% fprintf('軌道y_2の収束後の位置最大誤差: %f\n', max_error_y_2);
% fprintf('軌道z_2の収束後の位置最大誤差: %f\n', max_error_z_2);
% fprintf('軌道x_3の収束後の位置最大誤差: %f\n', max_error_x_3);
% fprintf('軌道y_3の収束後の位置最大誤差: %f\n', max_error_y_3);
% fprintf('軌道z_3の収束後の位置最大誤差: %f\n', max_error_z_3);
% fprintf('軌道x_4の収束後の位置最大誤差: %f\n', max_error_x_4);
% fprintf('軌道y_4の収束後の位置最大誤差: %f\n', max_error_y_4);
% fprintf('軌道z_4の収束後の位置最大誤差: %f\n', max_error_z_4);

% % xy目標軌道
% figure;
% plot(x_ref_sel1, y_ref_sel1, '--','LineWidth',2);
% grid on
% xlabel('x[m]') 
% ylabel('y[m]')
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% daspect([1 1 1])
% xlim([-2.5 2.5])
% ylim([-2.5 2.5])
% hold on
% plot(x_ref_sel2, y_ref_sel2, '--','LineWidth',2);
% plot(x_ref_sel3, y_ref_sel3, '--','LineWidth',2);
% plot(x_ref_sel4, y_ref_sel4, '--','LineWidth',2);
% legend('D1.REF','D2.REF','D3.REF','D4.REF','fontsize',8,'NumColumns',2)
% hold off

% xy
figure;
plot(x_est_sel1(shuti:end), y_est_sel1(shuti:end), '-','LineWidth',2);
grid on
xlabel('x[m]') 
ylabel('y[m]')
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
daspect([1 1 1])
xlim([-2.5 2.5])
ylim([-2.5 2.5])
hold on
plot(x_est_sel2(shuti:end), y_est_sel2(shuti:end), '-','LineWidth',2);
plot(x_est_sel3(shuti2:end), y_est_sel3(shuti2:end), '-','LineWidth',2);
plot(x_est_sel4(shuti2:end), y_est_sel4(shuti2:end), '-','LineWidth',2);
plot(x_ref_sel1(shuti:end), y_ref_sel1(shuti:end), '--','LineWidth',2);
plot(x_ref_sel2(shuti:end), y_ref_sel2(shuti:end), '--','LineWidth',2);
plot(x_ref_sel3(shuti2:end), y_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(x_ref_sel4(shuti2:end), y_ref_sel4(shuti2:end), '--','LineWidth',2);
legend('D1.EST','D2.EST','D3.EST','D4.EST', ...
    'D1.REF','D2.REF','D3.REF','D4.REF','fontsize',8,'NumColumns',2)
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
% plot3(x_est_sel2, y_est_sel2, z_est_sel2,  '-','LineWidth', 2);
% plot3(x_est_sel3, y_est_sel3, z_est_sel3,  '-','LineWidth', 2);
% plot3(x_est_sel4, y_est_sel4, z_est_sel4,  '-','LineWidth', 2);
% plot3(x_ref_sel2, y_ref_sel2, z_ref_sel2, '--', 'LineWidth', 2);
% plot3(x_ref_sel1, y_ref_sel1, z_ref_sel1, '--', 'LineWidth', 2);
% plot3(x_ref_sel2, y_ref_sel2, z_ref_sel2, '--', 'LineWidth', 2);
% legend('D1.EST','D2.EST','D3.EST','D4.EST', ...
%     'D1.REF','D2.REF','D3.REF','D4.REF','fontsize',12,'NumColumns',2)
% hold off

%推定値と目標値
figure;
plot(t_sel1(shuti:end),x_est_sel1(shuti:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,shuti) t_sel1(1,end)])
ylim([-2.5 2.5])
hold on
plot(t_sel1(shuti:end),y_est_sel1(shuti:end), '-','LineWidth',2);
plot(t_sel1(shuti:end),z_est_sel1(shuti:end), '-','LineWidth',2);
plot(t_sel2(shuti:end),x_est_sel2(shuti:end), '-','LineWidth',2);
plot(t_sel2(shuti:end),y_est_sel2(shuti:end), '-','LineWidth',2);
plot(t_sel2(shuti:end),z_est_sel2(shuti:end), '-','LineWidth',2);
plot(t_sel1(shuti:end),x_ref_sel1(shuti:end), '--','LineWidth',2);
plot(t_sel1(shuti:end),y_ref_sel1(shuti:end), '--','LineWidth',2);
plot(t_sel1(shuti:end),z_ref_sel1(shuti:end), '--','LineWidth',2);
plot(t_sel2(shuti:end),x_ref_sel2(shuti:end), '--','LineWidth',2);
plot(t_sel2(shuti:end),y_ref_sel2(shuti:end), '--','LineWidth',2);
plot(t_sel2(shuti:end),z_ref_sel2(shuti:end), '--','LineWidth',2);
legend('x_1.EST','y_1.EST','z_1.EST','x_2.EST','y_2.EST','z_2.EST', ...
    'x_1.REF','y_1.REF','z_1.REF','x_2.REF','y_2.REF','z_2.REF','Location', ...
    'northeast','fontsize',8,'NumColumns',4)
hold off
figure;
plot(t_sel3(shuti2:end),x_est_sel3(shuti2:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Trajectory[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel3(1,shuti2) t_sel3(1,end)])
ylim([-2.5 2.5])
hold on
plot(t_sel3(shuti2:end),y_est_sel3(shuti2:end), '-','LineWidth',2);
plot(t_sel3(shuti2:end),z_est_sel3(shuti2:end), '-','LineWidth',2);
plot(t_sel4(shuti2:end),x_est_sel4(shuti2:end), '-','LineWidth',2);
plot(t_sel4(shuti2:end),y_est_sel4(shuti2:end), '-','LineWidth',2);
plot(t_sel4(shuti2:end),z_est_sel4(shuti2:end), '-','LineWidth',2);
plot(t_sel3(shuti2:end),x_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(t_sel3(shuti2:end),y_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(t_sel3(shuti2:end),z_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(t_sel4(shuti2:end),x_ref_sel4(shuti2:end), '--','LineWidth',2);
plot(t_sel4(shuti2:end),y_ref_sel4(shuti2:end), '--','LineWidth',2);
plot(t_sel4(shuti2:end),z_ref_sel4(shuti2:end), '--','LineWidth',2);
legend('x_3.EST','y_3.EST','z_3.EST','x_4.EST','y_4.EST','z_4.EST', ...
    'x_3.REF','y_3.REF','z_3.REF','x_4.REF','y_4.REF','z_4.REF','Location', ...
    'northeast','fontsize',8,'NumColumns',4)
hold off

% %誤差
% figure;
% plot(t_sel1,er_x_1_fig, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_sel1(1,1) t_sel1(1,end)])
% ylim([-2 2])
% hold on
% plot(t_sel1,er_y_1_fig, '-','LineWidth',2);
% plot(t_sel1,er_z_1_fig, '-','LineWidth',2);
% plot(t_sel2,er_x_2_fig, '-','LineWidth',2);
% plot(t_sel2,er_y_2_fig, '-','LineWidth',2);
% plot(t_sel2,er_z_2_fig, '-','LineWidth',2);
% legend('x_1.error','y_1.error','z_1.error','x_2.error','y_2.error','z_2.error','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off
% figure;
% plot(t_sel3,er_x_3_fig, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Trajectory[m]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_sel1(1,1) t_sel1(1,end)])
% ylim([-2 2])
% hold on
% plot(t_sel3,er_y_3_fig, '-','LineWidth',2);
% plot(t_sel3,er_z_3_fig, '-','LineWidth',2);
% plot(t_sel4,er_x_4_fig, '-','LineWidth',2);
% plot(t_sel4,er_y_4_fig, '-','LineWidth',2);
% plot(t_sel4,er_z_4_fig, '-','LineWidth',2);
% legend('x_3.error','y_3.error','z_3.error','x_4.error','y_4.error','z_4.error','Location', ...
%     'northwest','fontsize',8,'NumColumns',2)
% hold off

%RMSE
figure;
plot(t_sel1(shuti:end),rmse_x_1_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('RMSE[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,shuti) t_sel1(1,end)])
ylim([-0.5 2])
hold on
plot(t_sel1(shuti:end),rmse_y_1_fig, '-','LineWidth',2);
plot(t_sel1(shuti:end),rmse_z_1_fig, '-','LineWidth',2);
plot(t_sel2(shuti:end),rmse_x_2_fig, '-','LineWidth',2);
plot(t_sel2(shuti:end),rmse_y_2_fig, '-','LineWidth',2);
plot(t_sel2(shuti:end),rmse_z_2_fig, '-','LineWidth',2);
legend('x_1.RMSE','y_1.RMSE','z_1.RMSE','x_2.RMSE','y_2.RMSE','z_2.RMSE','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off
figure;
plot(t_sel3(shuti2:end),rmse_x_3_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('RMSE[m]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel3(1,shuti2) t_sel3(1,end)])
ylim([-0.5 2])
hold on
plot(t_sel3(shuti2:end),rmse_y_3_fig, '-','LineWidth',2);
plot(t_sel3(shuti2:end),rmse_z_3_fig, '-','LineWidth',2);
plot(t_sel4(shuti2:end),rmse_x_4_fig, '-','LineWidth',2);
plot(t_sel4(shuti2:end),rmse_y_4_fig, '-','LineWidth',2);
plot(t_sel4(shuti2:end),rmse_z_4_fig, '-','LineWidth',2);
legend('x_3.RMSE','y_3.RMSE','z_3.RMSE','x_4.RMSE','y_4.RMSE','z_4.RMSE','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off

%% 収束後　速度

ftime = 0;      % 収束時間の初期化
shuti = 0;
ftime2 = 0;
shuti2 = 0;

for i = 1:length(vx_est_sel1)
    % 現在の誤差が収束閾値を満たしているか確認
    if t_sel1(i) > 14 && ftime == 0

            convergence_start_time = t_sel1(i);  % 収束開始時刻を設定
            shuti = i;                % 収束開始行を記録
            ftime = 1;
    end
end
for i = 1:length(vx_est_sel4)
    % 現在の誤差が収束閾値を満たしているか確認
    if t_sel4(i) > 14 && ftime2 == 0

            convergence_start_time2 = t_sel3(i);  % 収束開始時刻を設定
            shuti2 = i;                % 収束開始行を記録
            ftime2 = 1;
    end
end

% 誤差の計算
%速度
er_vx_1 = mean(vx_est_sel1(shuti:end) - vx_ref_sel1(shuti:end));
er_vy_1 = mean(vy_est_sel1(shuti:end) - vy_ref_sel1(shuti:end));
er_vz_1 = mean(vz_est_sel1(shuti:end) - vz_ref_sel1(shuti:end));
er_vx_1_fig = vx_est_sel1(shuti:end) - vx_ref_sel1(shuti:end);
er_vy_1_fig = vy_est_sel1(shuti:end) - vy_ref_sel1(shuti:end);
er_vz_1_fig = vz_est_sel1(shuti:end) - vz_ref_sel1(shuti:end);

er_vx_2 = mean(vx_est_sel2(shuti:end) - vx_ref_sel2(shuti:end));
er_vy_2 = mean(vy_est_sel2(shuti:end) - vy_ref_sel2(shuti:end));
er_vz_2 = mean(vz_est_sel2(shuti:end) - vz_ref_sel2(shuti:end));
er_vx_2_fig = vx_est_sel2(shuti:end) - vx_ref_sel2(shuti:end);
er_vy_2_fig = vy_est_sel2(shuti:end) - vy_ref_sel2(shuti:end);
er_vz_2_fig = vz_est_sel2(shuti:end) - vz_ref_sel2(shuti:end);

er_vx_3 = mean(vx_est_sel3(shuti2:end) - vx_ref_sel3(shuti2:end));
er_vy_3 = mean(vy_est_sel3(shuti2:end) - vy_ref_sel3(shuti2:end));
er_vz_3 = mean(vz_est_sel3(shuti2:end) - vz_ref_sel3(shuti2:end));
er_vx_3_fig = vx_est_sel3(shuti2:end) - vx_ref_sel3(shuti2:end);
er_vy_3_fig = vy_est_sel3(shuti2:end) - vy_ref_sel3(shuti2:end);
er_vz_3_fig = vz_est_sel3(shuti2:end) - vz_ref_sel3(shuti2:end);

er_vx_4 = mean(vx_est_sel4(shuti2:end) - vx_ref_sel4(shuti2:end));
er_vy_4 = mean(vy_est_sel4(shuti2:end) - vy_ref_sel4(shuti2:end));
er_vz_4 = mean(vz_est_sel4(shuti2:end) - vz_ref_sel4(shuti2:end));
er_vx_4_fig = vx_est_sel4(shuti2:end) - vx_ref_sel4(shuti2:end);
er_vy_4_fig = vy_est_sel4(shuti2:end) - vy_ref_sel4(shuti2:end);
er_vz_4_fig = vz_est_sel4(shuti2:end) - vz_ref_sel4(shuti2:end);

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
rmse_vx_1 = sqrt(mean((vx_est_sel1(shuti:end) - vx_ref_sel1(shuti:end)).^2));
rmse_vy_1 = sqrt(mean((vy_est_sel1(shuti:end) - vy_ref_sel1(shuti:end)).^2));
rmse_vz_1 = sqrt(mean((vz_est_sel1(shuti:end) - vz_ref_sel1(shuti:end)).^2));
rmse_vx_1_fig = sqrt((vx_est_sel1(shuti:end) - vx_ref_sel1(shuti:end)).^2);
rmse_vy_1_fig = sqrt((vy_est_sel1(shuti:end) - vy_ref_sel1(shuti:end)).^2);
rmse_vz_1_fig = sqrt((vz_est_sel1(shuti:end) - vz_ref_sel1(shuti:end)).^2);

rmse_vx_2 = sqrt(mean((vx_est_sel2(shuti:end) - vx_ref_sel2(shuti:end)).^2));
rmse_vy_2 = sqrt(mean((vy_est_sel2(shuti:end) - vy_ref_sel2(shuti:end)).^2));
rmse_vz_2 = sqrt(mean((vz_est_sel2(shuti:end) - vz_ref_sel2(shuti:end)).^2));
rmse_vx_2_fig = sqrt((vx_est_sel2(shuti:end) - vx_ref_sel2(shuti:end)).^2);
rmse_vy_2_fig = sqrt((vy_est_sel2(shuti:end) - vy_ref_sel2(shuti:end)).^2);
rmse_vz_2_fig = sqrt((vz_est_sel2(shuti:end) - vz_ref_sel2(shuti:end)).^2);

rmse_vx_3 = sqrt(mean((vx_est_sel3(shuti2:end) - vx_ref_sel3(shuti2:end)).^2));
rmse_vy_3 = sqrt(mean((vy_est_sel3(shuti2:end) - vy_ref_sel3(shuti2:end)).^2));
rmse_vz_3 = sqrt(mean((vz_est_sel3(shuti2:end) - vz_ref_sel3(shuti2:end)).^2));
rmse_vx_3_fig = sqrt((vx_est_sel3(shuti2:end) - vx_ref_sel3(shuti2:end)).^2);
rmse_vy_3_fig = sqrt((vy_est_sel3(shuti2:end) - vy_ref_sel3(shuti2:end)).^2);
rmse_vz_3_fig = sqrt((vz_est_sel3(shuti2:end) - vz_ref_sel3(shuti2:end)).^2);

rmse_vx_4 = sqrt(mean((vx_est_sel4(shuti2:end) - vx_ref_sel4(shuti2:end)).^2));
rmse_vy_4 = sqrt(mean((vy_est_sel4(shuti2:end) - vy_ref_sel4(shuti2:end)).^2));
rmse_vz_4 = sqrt(mean((vz_est_sel4(shuti2:end) - vz_ref_sel4(shuti2:end)).^2));
rmse_vx_4_fig = sqrt((vx_est_sel4(shuti2:end) - vx_ref_sel4(shuti2:end)).^2);
rmse_vy_4_fig = sqrt((vy_est_sel4(shuti2:end) - vy_ref_sel4(shuti2:end)).^2);
rmse_vz_4_fig = sqrt((vz_est_sel4(shuti2:end) - vz_ref_sel4(shuti2:end)).^2);

% MAEの計算
%位置
% mae_x_1 = mean(abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence));
% mae_y_1 = mean(abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence));
% mae_z_1 = mean(abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence));
% mae_x_1_fig = abs(trajectory_x_1_post_convergence - reference_x_1_post_convergence);
% mae_y_1_fig = abs(trajectory_y_1_post_convergence - reference_y_1_post_convergence);
% mae_z_1_fig = abs(trajectory_z_1_post_convergence - reference_z_1_post_convergence);

%最大誤差
max_error_vx_1 = max(abs(vx_est_sel1(shuti:end) - vx_ref_sel1(shuti:end)));
max_error_vy_1 = max(abs(vy_est_sel1(shuti:end) - vy_ref_sel1(shuti:end)));
max_error_vz_1 = max(abs(vz_est_sel1(shuti:end) - vz_ref_sel1(shuti:end)));
max_error_vx_2 = max(abs(vx_est_sel2(shuti:end) - vx_ref_sel2(shuti:end)));
max_error_vy_2 = max(abs(vy_est_sel2(shuti:end) - vy_ref_sel2(shuti:end)));
max_error_vz_2 = max(abs(vz_est_sel2(shuti:end) - vz_ref_sel2(shuti:end)));
max_error_vx_3 = max(abs(vx_est_sel3(shuti2:end) - vx_ref_sel3(shuti2:end)));
max_error_vy_3 = max(abs(vy_est_sel3(shuti2:end) - vy_ref_sel3(shuti2:end)));
max_error_vz_3 = max(abs(vz_est_sel3(shuti2:end) - vz_ref_sel3(shuti2:end)));
max_error_vx_4 = max(abs(vx_est_sel4(shuti2:end) - vx_ref_sel4(shuti2:end)));
max_error_vy_4 = max(abs(vy_est_sel4(shuti2:end) - vy_ref_sel4(shuti2:end)));
max_error_vz_4 = max(abs(vz_est_sel4(shuti2:end) - vz_ref_sel4(shuti2:end)));

% 結果を表示
% fprintf('軌道x_1の収束後の速度誤差: %f\n', er_vx_1);
% fprintf('軌道y_1の収束後の速度誤差: %f\n', er_vy_1);
% fprintf('軌道z_1の収束後の速度誤差: %f\n', er_vz_1);
% fprintf('軌道x_2の収束後の速度誤差: %f\n', er_vx_2);
% fprintf('軌道y_2の収束後の速度誤差: %f\n', er_vy_2);
% fprintf('軌道z_2の収束後の速度誤差: %f\n', er_vz_2);
% fprintf('軌道x_3の収束後の速度誤差: %f\n', er_vx_3);
% fprintf('軌道y_3の収束後の速度誤差: %f\n', er_vy_3);
% fprintf('軌道z_3の収束後の速度誤差: %f\n', er_vz_3);
% fprintf('軌道x_4の収束後の速度誤差: %f\n', er_vx_4);
% fprintf('軌道y_4の収束後の速度誤差: %f\n', er_vy_4);
% fprintf('軌道z_4の収束後の速度誤差: %f\n', er_vz_4);

fprintf('軌道x_1の収束後の速度RMSE: %f\n', rmse_vx_1);
fprintf('軌道y_1の収束後の速度RMSE: %f\n', rmse_vy_1);
fprintf('軌道z_1の収束後の速度RMSE: %f\n', rmse_vz_1);
fprintf('軌道x_2の収束後の速度RMSE: %f\n', rmse_vx_2);
fprintf('軌道y_2の収束後の速度RMSE: %f\n', rmse_vy_2);
fprintf('軌道z_2の収束後の速度RMSE: %f\n', rmse_vz_2);
fprintf('軌道x_3の収束後の速度RMSE: %f\n', rmse_vx_3);
fprintf('軌道y_3の収束後の速度RMSE: %f\n', rmse_vy_3);
fprintf('軌道z_3の収束後の速度RMSE: %f\n', rmse_vz_3);
fprintf('軌道x_4の収束後の速度RMSE: %f\n', rmse_vx_4);
fprintf('軌道y_4の収束後の速度RMSE: %f\n', rmse_vy_4);
fprintf('軌道z_4の収束後の速度RMSE: %f\n', rmse_vz_4);

% fprintf('軌道x_1の収束後の速度最大誤差: %f\n', max_error_vx_1);
% fprintf('軌道y_1の収束後の速度最大誤差: %f\n', max_error_vy_1);
% fprintf('軌道z_1の収束後の速度最大誤差: %f\n', max_error_vz_1);
% fprintf('軌道x_2の収束後の速度最大誤差: %f\n', max_error_vx_2);
% fprintf('軌道y_2の収束後の速度最大誤差: %f\n', max_error_vy_2);
% fprintf('軌道z_2の収束後の速度最大誤差: %f\n', max_error_vz_2);
% fprintf('軌道x_3の収束後の速度最大誤差: %f\n', max_error_vx_3);
% fprintf('軌道y_3の収束後の速度最大誤差: %f\n', max_error_vy_3);
% fprintf('軌道z_3の収束後の速度最大誤差: %f\n', max_error_vz_3);
% fprintf('軌道x_4の収束後の速度最大誤差: %f\n', max_error_vx_4);
% fprintf('軌道y_4の収束後の速度最大誤差: %f\n', max_error_vy_4);
% fprintf('軌道z_4の収束後の速度最大誤差: %f\n', max_error_vz_4);

%推定値と目標値
figure;
plot(t_sel1(shuti:end),vx_est_sel1(shuti:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,shuti) t_sel1(1,end)])
ylim([-1.5 1.5])
hold on
plot(t_sel1(shuti:end),vy_est_sel1(shuti:end), '-','LineWidth',2);
plot(t_sel1(shuti:end),vz_est_sel1(shuti:end), '-','LineWidth',2);
plot(t_sel2(shuti:end),vx_est_sel2(shuti:end), '-','LineWidth',2);
plot(t_sel2(shuti:end),vy_est_sel2(shuti:end), '-','LineWidth',2);
plot(t_sel2(shuti:end),vz_est_sel2(shuti:end), '-','LineWidth',2);
plot(t_sel1(shuti:end),vx_ref_sel1(shuti:end), '--','LineWidth',2);
plot(t_sel1(shuti:end),vy_ref_sel1(shuti:end), '--','LineWidth',2);
plot(t_sel1(shuti:end),vz_ref_sel1(shuti:end), '--','LineWidth',2);
plot(t_sel2(shuti:end),vx_ref_sel2(shuti:end), '--','LineWidth',2);
plot(t_sel2(shuti:end),vy_ref_sel2(shuti:end), '--','LineWidth',2);
plot(t_sel2(shuti:end),vz_ref_sel2(shuti:end), '--','LineWidth',2);
legend('vx_1.EST','vy_1.EST','vz_1.EST','vx_2.EST','vy_2.EST','vz_2.EST', ...
    'vx_1.REF','vy_1.REF','vz_1.REF','vx_2.REF','vy_2.REF','vz_2.REF','Location', ...
    'northwest','fontsize',8,'NumColumns',4)
hold off
figure;
plot(t_sel3(shuti2:end),vx_est_sel3(shuti2:end), '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('Velocity[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel3(1,shuti2) t_sel3(1,end)])
ylim([-1.5 1.5])
hold on
plot(t_sel3(shuti2:end),vy_est_sel3(shuti2:end), '-','LineWidth',2);
plot(t_sel3(shuti2:end),vz_est_sel3(shuti2:end), '-','LineWidth',2);
plot(t_sel4(shuti2:end),vx_est_sel4(shuti2:end), '-','LineWidth',2);
plot(t_sel4(shuti2:end),vy_est_sel4(shuti2:end), '-','LineWidth',2);
plot(t_sel4(shuti2:end),vz_est_sel4(shuti2:end), '-','LineWidth',2);
plot(t_sel3(shuti2:end),vx_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(t_sel3(shuti2:end),vy_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(t_sel3(shuti2:end),vz_ref_sel3(shuti2:end), '--','LineWidth',2);
plot(t_sel4(shuti2:end),vx_ref_sel4(shuti2:end), '--','LineWidth',2);
plot(t_sel4(shuti2:end),vy_ref_sel4(shuti2:end), '--','LineWidth',2);
plot(t_sel4(shuti2:end),vz_ref_sel4(shuti2:end), '--','LineWidth',2);
legend('vx_3.EST','vy_3.EST','vz_3.EST','vx_4.EST','vy_4.EST','vz_4.EST', ...
    'vx_3.REF','vy_3.REF','vz_3.REF','vx_4.REF','vy_4.REF','vz_4.REF','Location', ...
    'southwest','fontsize',8,'NumColumns',4)
hold off

% %誤差
% figure;
% plot(t_sel1,er_vx_1_fig, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Velocity[m/s]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_sel1(1,1) t_sel1(1,end)])
% ylim([-1 1])
% hold on
% plot(t_sel1,er_vy_1_fig, '-','LineWidth',2);
% plot(t_sel1,er_vz_1_fig, '-','LineWidth',2);
% plot(t_sel2,er_vx_2_fig, '-','LineWidth',2);
% plot(t_sel2,er_vy_2_fig, '-','LineWidth',2);
% plot(t_sel2,er_vz_2_fig, '-','LineWidth',2);
% legend('vx_1.error','vy_1.error','vz_1.error','vx_2.error','vy_2.error','vz_2.error','Location', ...
%     'northwest','fontsize',8,'NumColumns',2)
% hold off
% figure;
% plot(t_sel3,er_vx_3_fig, '-','LineWidth',2);
% grid on
% xlabel('Time[s]','FontSize',12) 
% ylabel('Velocity[m/s]','FontSize',12)
% set(gca().XAxis, 'Fontsize', 12)
% set(gca().YAxis, 'Fontsize', 12)
% xlim([t_sel1(1,1) t_sel1(1,end)])
% ylim([-1 1])
% hold on
% plot(t_sel3,er_vy_3_fig, '-','LineWidth',2);
% plot(t_sel3,er_vz_3_fig, '-','LineWidth',2);
% plot(t_sel4,er_vx_4_fig, '-','LineWidth',2);
% plot(t_sel4,er_vy_4_fig, '-','LineWidth',2);
% plot(t_sel4,er_vz_4_fig, '-','LineWidth',2);
% legend('vx_3.error','vy_3.error','vz_3.error','vx_4.error','vy_4.error','vz_4.error','Location', ...
%     'southwest','fontsize',8,'NumColumns',2)
% hold off

%RMSE
figure;
plot(t_sel1(shuti:end),rmse_vx_1_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('RMSE[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel1(1,shuti) t_sel1(1,end)])
ylim([-0.5 1])
hold on
plot(t_sel1(shuti:end),rmse_vy_1_fig, '-','LineWidth',2);
plot(t_sel1(shuti:end),rmse_vz_1_fig, '-','LineWidth',2);
plot(t_sel2(shuti:end),rmse_vx_2_fig, '-','LineWidth',2);
plot(t_sel2(shuti:end),rmse_vy_2_fig, '-','LineWidth',2);
plot(t_sel2(shuti:end),rmse_vz_2_fig, '-','LineWidth',2);
legend('vx_1.RMSE','vy_1.RMSE','vz_1.RMSE','vx_2.RMSE','vy_2.RMSE','vz_2.RMSE','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off
figure;
plot(t_sel3(shuti2:end),rmse_vx_3_fig, '-','LineWidth',2);
grid on
xlabel('Time[s]','FontSize',12) 
ylabel('RMSE[m/s]','FontSize',12)
set(gca().XAxis, 'Fontsize', 12)
set(gca().YAxis, 'Fontsize', 12)
xlim([t_sel3(1,shuti2) t_sel3(1,end)])
ylim([-0.5 1])
hold on
plot(t_sel3(shuti2:end),rmse_vy_3_fig, '-','LineWidth',2);
plot(t_sel3(shuti2:end),rmse_vz_3_fig, '-','LineWidth',2);
plot(t_sel4(shuti2:end),rmse_vx_4_fig, '-','LineWidth',2);
plot(t_sel4(shuti2:end),rmse_vy_4_fig, '-','LineWidth',2);
plot(t_sel4(shuti2:end),rmse_vz_4_fig, '-','LineWidth',2);
legend('vx_3.RMSE','vy_3.RMSE','vz_3.RMSE','vx_4.RMSE','vy_4.RMSE','vz_4.RMSE','Location', ...
    'southwest','fontsize',8,'NumColumns',2)
hold off
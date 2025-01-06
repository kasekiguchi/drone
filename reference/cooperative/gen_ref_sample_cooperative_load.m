function ref = gen_ref_sample_cooperative_load(param)
arguments
    param.freq = 1% 周期
    param.orig = [0 0 1]% サドルの中心
    param.size = [1 1 0] % 各軸の振幅    
end

%必要パラメーター
% [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;r0d],[3,3,3,3,3,3,4]
% x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% r0d : 牽引物の姿勢を表すクォータニオン
% o0d, do0d ：牽引物の角速度・角加速度
syms t real 

T = param.freq;
origin = param.orig;
scale = param.size;
% 原点
lx_offset = origin(1);
ly_offset = origin(2);
lz_offset = origin(3);
%振幅
lx = scale(1);
ly = scale(2);
lz = scale(3);
% 角速度
w = 2*pi/T;%T秒で一周
%saddle
x = lx*cos(w*t)+lx_offset; % x
y = ly*sin(w*t)+ly_offset; % y
z = lz*sin(2*w*t - pi/2)+lz_offset; % z

%circle
% x = lx*cos(w*t)+lx_offset; % x
% y = ly*sin(w*t)+ly_offset; % y
% z = lz_offset; % z

%line
% x = 0.1*t^4; % x
% y = 0.2*t^4; % y
% z = lz_offset; % z

%point
% x = lx_offset;  % x
% y = ly_offset;  % y
% z = lz_offset; % z

roll = 15*pi/180;
pitch = 20*pi/180;
yaw = 10*pi/180;
% Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
% Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
% Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
% rotm = Rx*Ry*Rz;

ref.pYaw    = [x;y;z;yaw];%x,y,z,roll,pitch,yaw
% rotm = eul2rotm([roll,pitch,yaw]);
ref.q       =  [roll,pitch,yaw];%x,y,z,roll,pitch,yaw
% ref.pYaw    = @(t)[x;y;z;yaw];%x,y,z,roll,pitch,yaw
% rotm = eul2rotm([roll,pitch,yaw]);
% ref.rotm       = @(t) rotm;%x,y,z,roll,pitch,yaw
% fprintf("max ref acceleration = %f\n",subs(ddx(3),t,T/4));
end
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

x = lx_offset;  % x
y = ly_offset;  % y
z = lz*sin(2*w*t - pi/2)+lz_offset; % z

%point
% x = lx_offset;  % x
% y = ly_offset;  % y
% z = lz_offset; % z

ref = @(t)[x;y;z];
% fprintf("max ref acceleration = %f\n",subs(ddx(3),t,T/4));
end
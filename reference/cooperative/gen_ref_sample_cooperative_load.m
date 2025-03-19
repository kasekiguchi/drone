function ref = gen_ref_sample_cooperative_load(param)
arguments
    param.freq = 1% 周期
    param.orig = [0 0 1]% サドルの中心
    param.size = [1 1 0] % 各軸の振幅    
end

syms t real 

T           = param.freq;
origin      = param.orig;
scale       = param.size;
% 原点
lx_offset   = origin(1);
ly_offset   = origin(2);
lz_offset   = origin(3);
%振幅
lx          = scale(1);
ly          = scale(2);
lz          = scale(3);
% 角速度
w           = -2*pi/T;%T秒で一周

%saddle
x = 1*lx*cos(w*t)+lx_offset; % x
y = 1*ly*sin(w*t)+ly_offset; % y
z = 1*lz*sin(2*w*t - pi/2)+lz_offset; % z

%circle
% x = lx*cos(w*t)+lx_offset; % x
% y = ly*sin(w*t)+ly_offset; % y
% z = lz_offset; % z

%line
% x = 0.1*t^4; % x
% y = 0.2*t^4; % y
% z = lz_offset; % z
% x = 0.1*t^1; % x
% y = 0.1*t^1; % y
% z = 0.1*t^1; % z

%point
% x = lx_offset;  % x
% y = ly_offset;  % y
% z = lz_offset; % z

% ANGLE
% exp
    % roll = -3*pi/180;
    % pitch = 4*sin(2*pi*t/T/2)*pi/180;
    % % pitch = 3*pi/180;
    % yaw = 3*pi/180;
    roll    = 0;
    pitch   = 0;
    yaw     = 0;

% sim
    % roll = 2*pi/180;
    % pitch = 3*sin(2*pi*t/T)*pi/180;
    % % pitch = 3*pi/180;
    % yaw = -5*pi/180;
    % 
    % roll = 2*sin(2*pi*t/T)*pi/180;
    % pitch = 3*sin(2*pi*t/T)*pi/180;
    % yaw = -5*sin(2*pi*t/T)*pi/180;
    % yaw = 0*2*pi*t/T/2;
    % yaw = acos(cos(2*pi*t/T));


ref.pYaw    = [x;y;z;yaw];%x,y,z,roll,pitch,yaw
ref.q       = [roll;pitch;yaw];%x,y,z,roll,pitch,yaw
% fprintf("max ref acceleration = %f\n",subs(ddx(3),t,T/4));
end
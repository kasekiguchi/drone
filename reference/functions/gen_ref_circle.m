function ref = gen_ref_circle(param)
arguments
    param.freq = 10% 周期
    param.init = [0 0 0]% サドルの中心
    param.radius = 1.0 % 各軸の振幅
    param.phase = 0.0 % 位相    
end
x_0 = param.init(1);
y_0 = param.init(2);
T = param.freq;
% origin = param.orig;
r = param.radius;
phase = param.phase;
syms t real
% syms lx ly real
% lx = scale(1); % 4
% lx_offset = origin(1); %4;
% ly = scale(2); %3.5;
% ly_offset = origin(2);% 3.5;
% lz = scale(3);% 1;
% lz_offset=origin(3);% 1;
% w = 2*pi/T; % T秒で一周

ref=@(t) [x_0 + r*sin(2*pi*t/T); % x
y_0 + r*cos(2*pi*t/T); % y
1; % z
0];%


% ref=@(t) [0;0;2;0];%

end
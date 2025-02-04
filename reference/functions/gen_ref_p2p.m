function ref = gen_ref_p2p(param)
arguments
    param.freq = 10% 周期
    param.init = [0 0 0]% サドルの中心
    param.radius = 1.0 % 各軸の振幅
    param.phase = 0.0 % 位相
    param.i 
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

ref=@(t) [2;-2;2;0];

% ref=@(t) [one_or_minaone(sin(2*pi*t/T)); % x
% one_or_minaone(cos(2*pi*t/T)); % y
% 2; % z
% 0];%
% ref=@(t) [0;0;0;0];%

end

function x = one_or_minaone(x)
    if x >= 0
        x = 1;
    else
        x = -1;
    end
end

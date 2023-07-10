function ref = gen_ref_sample_cooperative_load(param)
arguments
    param.freq = 10% 周期
    param.orig = [0 0 1]% サドルの中心
    param.size = [1 1 0] % 各軸の振幅
    param.phase = -pi % 位相    
end

%必要パラメーター
% [x0d;dx0d;ddx0d;dddx0d;o0d;do0d;r0d],[3,3,3,3,3,3,4]
% x0d;dx0d;ddx0d;dddx0d 牽引物の位置とその微分
% r0d : 牽引物の姿勢を表すクォータニオン
% o0d, do0d ：牽引物の角速度・角加速度

% 円軌道

T = param.freq;
origin = param.orig;
scale = param.size;
phase = param.phase;
syms t real
syms lx ly real
lx = scale(1); % 4
lx_offset = origin(1); %4;
ly = scale(2); %3.5;
ly_offset = origin(2);% 3.5;
lz = scale(3);% 1;
lz_offset=origin(3);% 1;
w = 0.2%*pi/T; % T秒で一周

% ref=@(t) [lx*cos(w*t + phase)+lx_offset; % x
% ly*sin(w*t + phase)+ly_offset; % y
% lz*sin(2*w*t + phase/2)+lz_offset; % z
% 0];%

% ref=@(t) [lx*cos(w*t + phase)+lx_offset; % x
% ly*sin(w*t + phase)+ly_offset; % y
% lz_offset]; % z
% dx = diff(ref,t,1);

ref=@(t)[1.2*sin(2*w*pi*t);4.2*cos(w*pi*t);2];

% fprintf("max ref acceleration = %f\n",subs(ddx(3),t,T/4));

% r0x = [(4*2^(1/2)*w*cos(2*pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2)) -(7*2^(1/2)*w*sin(pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2)) 0]';
% r0z = [0;0;1];
% r0y = [   (7*2^(1/2)*w*sin(pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2));(4*2^(1/2)*w*cos(2*pi*t*w))/(abs(w)*(16*cos(4*t*w*pi) - 49*cos(2*t*w*pi) + 65)^(1/2));               0];
% R0d = [r0x r0y r0z];
% o0d = [ 0;    0;-(28*w*pi*(3*cos(pi*t*w) - 2*cos(pi*t*w)^3))/(64*cos(pi*t*w)^4 - 113*cos(pi*t*w)^2 + 65)];
% do0d = [   0;   0;-(28*w^2*pi^2*sin(pi*t*w)*(51*cos(pi*t*w)^2 + 350*cos(pi*t*w)^4 - 128*cos(pi*t*w)^6 - 195))/(64*cos(t*w*pi)^4 - 113*cos(t*w*pi)^2 + 65)^2];
% %R0d = obj.toR([1;0;0;0]);
% x0d = [1.2*sin(2*w*pi*t);4.2*cos(w*pi*t);2];
% dx0d = [ (12*w*pi*cos(2*pi*t*w))/5; -(21*w*pi*sin(pi*t*w))/5;    0];
% ddx0d = [-(24*w^2*pi^2*sin(2*pi*t*w))/5;  -(21*w^2*pi^2*cos(pi*t*w))/5;       0];
% dddx0d = [ -(48*w^3*pi^3*cos(2*pi*t*w))/5;   (21*w^3*pi^3*sin(pi*t*w))/5;     0];

% 圧倒的に遅いので以下のような書き方はしないこと
% xdf =@(t) [xd1(t),xd2(t),xd3(t),xd4(t)];
% dxdf =@(tt) subs(diff(xdf(t),t),t,tt);
% ddxdf =@(tt) subs( diff(dxdf(t),t),t,tt);
% dddxdf =@(tt)  subs(diff(ddxdf(t),t),t,tt);
% ddddxdf =@(tt)  subs(diff(dddxdf(t),t),t,tt);
% tXd=@(t) double([xdf(t),dxdf(t),ddxdf(t),dddxdf(t),ddddxdf(t)]);
end
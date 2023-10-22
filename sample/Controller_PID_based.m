function Controller = Controller_PID_based(dt)
% PIDコントローラ設計用
Controller_param.dt = dt;
F2 = lqrd([zeros(1,1),eye(1);zeros(1,2)], [0;1], diag([100, 1]), 0.1,dt);
F22 = 0*lqrd([zeros(1,1),eye(1);zeros(1,2)], [0;1], diag([100, 1]), 0.01,dt); % 姿勢角
F23 = 1*lqrd([zeros(1,1),eye(1);zeros(1,2)], [0;1], diag([100, 1]), 1,dt);% 位置
F4 = 0.1*lqrd([zeros(3,1),eye(3);zeros(1,4)], [0;0;0;1], diag([1,1,100,100]), 10000,dt);
Controller_param.Kp = diag([F2(1),F23(1),F23(1),F23(1)]);
Controller_param.Kd = diag([F2(2),F23(2),F23(2),F23(2)]);
Controller_param.Ki = zeros(4);
Controller_param.etrans = str2func("etrans_44");
Controller_param.utrans = str2func("utrans_throttle2thrust");
Controller.type = "PID_BASED_CONTROLLER";
Controller.name = "pid";
Controller.param = Controller_param;
end


function [e,ed] = etrans_44(s,sr)
% s : estimator state
% rs : reference state
% e = [距離，姿勢角]
% ed = de/dt

% 目標速度ベクトル V 
p = s.p(1:3);
rp = sr.p(1:3);
v0 = p - rp; % 目標方向
v0l = vecnorm(v0);
if v0l == 0
    e1 = 0;
    V = v0;
else
    e1 = min(3,v0l); % max でも3 m/s
    V = e1*v0/v0l; % 目標速度
end
% 目標姿勢角（オイラー角）
if V(3) == 0
    rollr = 0;
    pitchr = 0;
else
    rollr = -atan(V(2)/V(3));
    pitchr = atan(V(1)/V(3));
end
yawr = 0;

v = s.v(1:3);

rv = sr.v;
if isempty(rv)
    rv = [0;0;0];
else
    rv = rv(1:3);
end
a0 = v - V; % 目標加速度
a0 = a0 - ([0,0,1]*a0)*[0;0;1]; % 回転軸
a0l = vecnorm(a0);
if a0l == 0
    E1 = 0;
    V = a0;
else
    E1 = min(3,a0l); % max でも3 m/s^2
    V = E1*a0/a0l; % 目標
end
% 目標角速度（オイラー角）
wrr = -a0(1)/a0l;
wpr = -a0(2)/a0l;
wyr = 0;

q = s.getq('3');
w = s.w;
k = tanh((v0l)/10);
e = [p(3)-rp(3);q - ((1-k)*q + k*[rollr;pitchr;yawr])];
ed = [v(3)-rv(3);w - [wrr;wpr;wyr]];
end

function u = utrans_throttle2thrust(v)
% v = [total thrust; roll ; pitch ; yaw torques]
% u = thrust of propeller 1,2,3,4
%v = min(v,2*[1;0.5;0.5;0.5]);
u = [v(1) / 4 - v(2) / 4 + v(3) / 4 + v(4) / 4;
    v(1) / 4 - v(2) / 4 - v(3) / 4 - v(4) / 4;
    v(1) / 4 + v(2) / 4 + v(3) / 4 - v(4) / 4;
    v(1) / 4 + v(2) / 4 - v(3) / 4 + v(4) / 4];
end

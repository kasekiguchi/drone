function Controller = Controller_PID(dt)
% PIDコントローラ設計用
Controller_param.dt = dt;
% Controller_param.Kp = [0,0,0;1,1,1];
% Controller_param.Ki = [0 0 0;0 0 0];
% Controller_param.Kd = [1;1];
% Controller_param.strans = str2func("strans_2110");
% Controller_param.rtrans = str2func("strans_2110");
F2 = lqrd([zeros(1, 1), eye(1); zeros(1, 2)], [0; 1], diag([100, 1]), 0.1, dt);
F22 = 0 * lqrd([zeros(1, 1), eye(1); zeros(1, 2)], [0; 1], diag([100, 1]), 0.01, dt); % 姿勢角
F23 = 1 * lqrd([zeros(1, 1), eye(1); zeros(1, 2)], [0; 1], diag([1, 100]), 10000, dt); % 位置
F4 = 0.1 * lqrd([zeros(3, 1), eye(3); zeros(1, 4)], [0; 0; 0; 1], diag([1, 1, 100, 100]), 10000, dt);
% Controller_param.Kp = [0,0,F2(1),0,0,0;...
%                         0,F4(1),0,F4(3),0,0;...
%                         F4(1),0,0,0,F4(3),0;...
%                         0,0,0,0,0,F2(1)];
% Controller_param.Kd = [0,0,F2(2),0,0,0;...
%                         0,F4(2),0,F4(4),0,0;...
%                         F4(2),0,0,0,F4(4),0;...
%                         0,0,0,0,0,F2(2)];
Controller_param.Kp = [0, 0, F2(1), 0, 0, 0; ...
                           0, -F4(1), 0, F22(1), 0, 0; ...
                           F4(1), 0, 0, 0, F22(1), 0; ...
                           0, 0, 0, 0, 0, 0 * F22(1)];
Controller_param.Kd = [0, 0, F2(2), 0, 0, 0; ...
                           0, -F4(2), 0, F22(2), 0, 0; ...
                           F4(2), 0, 0, 0, F22(2), 0; ...
                           0, 0, 0, 0, 0, 0 * F22(2)];
Controller_param.Ki = zeros(4, 6);
Controller_param.strans = str2func("strans_3333");
Controller_param.rtrans = str2func("strans_3333");
Controller_param.utrans = str2func("utrans_throttle2thrust");
Controller.type = "PID_CONTROLLER";
Controller.name = "pid";
Controller.param = Controller_param;
end

function [p, q, v, w] = strans_2110(state)
% STATEクラス変数を以下に変換する関数
% p : 2dim（平面位置）
% q : 1dim（平面上の姿勢）
% v : 1dim
% w : 1dim
p = state.p(1:2, end);
% switch length(p)
%     case 3
%         p = p(1:2);
% end
if isprop(state, "q")
    q = state.q(:, end);

    switch length(q)
        case 3
            q = q(3);
        case {4, 9}
            q = state.getq('3');
            q = q(3);
    end

else
    q = [];
end

if isprop(state, "v")
    v = state.v(:, end);

    switch length(v)
        case 3
            v = v(3);
    end

else
    v = [];
end

if isprop(state, "w")
    w = state.w(:, end);

    switch length(w)
        case 3
            w = w(3);
    end

else
    w = [];
end

end

function [p, q, v, w] = strans_3333(state)
% STATEクラス変数を以下に変換する関数
% p : 3 dim
% q : 3 dim（オイラー角）
% v : 3 dim
% w : 3 dim
p = state.p(1:3);

if isfield(state, 'q')
    q = state.getq('3');
else
    q = [0; 0; 0];
end

v = state.v;

if isempty(v)
    v = [0; 0; 0];
else
    v = v(1:3);
end

if isfield(state, 'w')
    w = state.w(1:3);
else
    w = [0; 0; 0];
end

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

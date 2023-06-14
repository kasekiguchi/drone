function Controller = Controller_PID(dt)
% PIDコントローラ設計用
Controller.dt = dt;
% Controller.Kp = [0,0,0;1,1,1];
% Controller.Ki = [0 0 0;0 0 0];
% Controller.Kd = [1;1];
% Controller.strans = str2func("strans_2110");
% Controller.rtrans = str2func("strans_2110");
F = lqr([0, 1; 0 0], [0; 1], diag([10, 1]), 0.01);
% Controller.Kp = F(1) * eye(4);
Controller.Ki = zeros(4);
% Controller.Kd = F(2) * eye(4);
% Controller.strans = str2func("strans_4");
% Controller.rtrans = str2func("strans_4");
% Controller.utrans = str2func("utrans_throttle2thrust");
Controller.Kp = F(1) * eye(3);
Controller.Kd = F(2) * eye(3);
Controller.strans = @(x) x;%str2func("strans_4");
Controller.rtrans = @(x) x;%str2func("strans_4");
Controller.utrans = @(x) x;%str2func("utrans_throttle2thrust");
Controller.ptarget = ["p"];
Controller.vtarget = ["v"];
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
% p : 3dim
% q : 3dim（オイラー角）
% v : 3dim
% w : 3dim
p = state.p;
q = state.getq('3');
v = state.v;
w = state.w(:, end);
end

function [p, q, v, w] = strans_4(state)
% STATEクラス変数を以下に変換する関数
% p : 1 dim
% q : 3 dim（オイラー角）
% v : 1 dim
% w : 3 dim
p = sum(state.p);
q = state.getq('3');
v = vecnorm(state.v);
w = state.w(:, end);
end

function u = utrans_throttle2thrust(v)
% v = [total thrust; roll ; pitch ; yaw torques]
% u = thrust of propeller 1,2,3,4
u = [v(1) / 4 - v(2) / 4 + v(3) / 4 + v(4) / 4;
    v(1) / 4 - v(2) / 4 - v(3) / 4 - v(4) / 4;
    v(1) / 4 + v(2) / 4 + v(3) / 4 - v(4) / 4;
    v(1) / 4 + v(2) / 4 - v(3) / 4 + v(4) / 4];
end

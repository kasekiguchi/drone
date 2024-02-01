function Controller = Controller_APID(dt)
% Adaptive PIDコントローラ設計用
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Controller.Kp = [2.5, 2, 0; 0,0,2] * 0.1;
Controller.Ki = [0 0 0; 0 0 0];
Controller.Kd = [2; 0.1] * 1;
Controller.K = [1, 1] * 0.1;
Controller.dt = dt;
% Controller.strans = str2func("strans_2111");
% Controller.rtrans = str2func("strans_2111");
Controller.trans = str2func("strans_2110");
Controller.adaptive = str2func("adaptive_gain");
Controller.gen_error = str2func("gen_e_2110");
Controller.type = "APID_CONTROLLER";
Controller.name = "pid";
end

function [Kp, Ki, Kd] = adaptive_gain(Kp, Ki, Kd, x, xr)
% Kp = Kp .* [-sin(x(3)), cos(x(3)), 1];
end

function [p, q, v, w] = strans_2111(state)
% STATEクラス変数を以下に変換する関数
% p : 2dim（平面位置）
% q : 1dim（平面上の姿勢）
% v : 1dim
% w : 1dim
% p = state.p(1:state.num_list(1));
p = state.p(1:2);
% p = state.p(1:2, end);
% p = state.p;
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

    if isempty(state.v)
        v = [];
    else
        v = state.v(:, end);

        switch length(v)
            case 3
                v = v(3);
        end

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

function [p, q, v, w] = strans_2110(state)
% STATEクラス変数を以下に変換する関数
% p : 2dim（平面位置）
% q : 1dim（平面上の姿勢）
% v : 1dim
% w : 1dim
% p = state.p(1:2, end);
p = state.p(1:2);
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

function [e,ed] = gen_e_2110(model,ref)
% 慣性座標目標値を相対座標目標値に変換し相対座標形状でのerror を算出する。
[p,q,v,w] = strans_2110(model);
[rp,rq,rv,rw]= strans_2110(ref);
R = [cos(q),-sin(q);sin(q),cos(q)];
e = [-R'*(rp - p);q-rq];
ed = [v-rv;w-rw];
end

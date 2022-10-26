function Controller= Controller_APID(dt)
% Adaptive PIDコントローラ設計用
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Controller_param.Kp = [0,0,0;2,2,3]*0.1;
Controller_param.Ki = [0 0 0;0 0 0];
Controller_param.Kd = [2;0.1];
Controller_param.dt = dt;
Controller_param.strans = str2func("strans_2110");
Controller_param.rtrans = str2func("strans_2110");
Controller_param.adaptive = str2func("adaptive_gain");
Controller.type="APID_CONTROLLER";
Controller.name="pid";


Controller.param=Controller_param;
end

function [Kp,Ki,Kd] = adaptive_gain(Kp,Ki,Kd,x,xr)
 Kp = Kp.*[-sin(x(3)),cos(x(3)),1];
end
function [p,q,v,w] = strans_2110(state)
% STATEクラス変数を以下に変換する関数
% p : 2dim（平面位置）
% q : 1dim（平面上の姿勢）
% v : 1dim
% w : 1dim
p = state.p(1:2,end);
% switch length(p)
%     case 3
%         p = p(1:2);
% end
if isprop(state,"q")
    q = state.q(:,end);
    switch length(q)
        case 3
            q = q(3);
        case {4 , 9}
            q = state.getq('3');
            q = q(3);
    end
else
    q = [];
end

if isprop(state,"v")
    v = state.v(:,end);
    switch length(v)
        case 3
            v = v(3);
    end
else
    v = [];
end

if isprop(state,"w")
    w = state.w(:,end);
    switch length(w)
        case 3
            w = w(3);
    end
else
    w = [];
end
end

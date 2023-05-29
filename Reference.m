% referenceを生成する関数

%% Timevarying　着陸含む
% param : agentの中身いじるパラメータ
% t : reference生成時の現在時刻
% T : time.t そのステップの現在時刻

% function xr = Reference(params, T, Agent)
%     % timevaryingをホライズンごとのreferenceに変換する
%     % params.dt = 0.1;
%     xr = zeros(params.total_size, params.H);    % initialize
% 
%     % 時間関数の取得→時間を代入してリファレンス生成
%     RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
%     for h = 0:params.H-1
%         t = T + params.dt * h; % reference生成時の時刻をずらす
%         Ref = RefTime(t);
%         if T <= 10
%             % 追従項
%             xr(1:3, h+1) = Ref(1:3);
%             xr(7:9, h+1) = Ref(5:7);
%         else
%             % 追従項
%             xr(1:3, h+1) = [0;0;0.001];
%             xr(7:9, h+1) = [0;0;0];
%         end
%         % 抑制項
%         xr(4:6, h+1) =   [0; 0; 0];
%         xr(10:12, h+1) = [0; 0; 0];
% 
%         xr(13:16, h+1) = params.ur;
%     end
% end

%% Timevarying
% param : agentの中身いじるパラメータ
% t : reference生成時の現在時刻
% T : time.t そのステップの現在時刻

function [xr] = Reference(params, T, Agent, Gq, Gp, phase)
    % パラメータ取得
    
    % timevaryingをホライズンごとのreferenceに変換する
    % params.dt = 0.1;
    xr = zeros(params.total_size, params.H);    % initialize
    
    % 時間関数の取得→時間を代入してリファレンス生成
    % RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
    for h = 0:params.H-1
        t = T.t + params.dt * h; % reference生成時の時刻をずらす
        % Ref = RefTime(t); % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
        % それぞれの関数 % z方向目標値
        if t<=phase
            tz = 2;
            tx = -1;
            tvz = 0;
            tvx = 0;
        elseif phase<t && t<phase+0.3
            tz = -5 * (t-phase).^2 + 2; tvz = 20-10*t;
            tx = 5 * (t-phase).^2 - 1;  tvx = 10*t-20;
        elseif phase+0.3 <= t
            tz = 2 * exp(-(t-phase-0.14)/0.5)+0.1; tvz = -4*exp((107/25)-2*t);
            tx = -exp(-(t-phase)/0.5);             tvx = 2*exp(4-2*t);
        end

        xr(1:3, h+1) = [tx;  0; tz];
        xr(7:9, h+1) = [tvx; 0; tvz];
        xr(4:6, h+1) =   [0;0;0]; % 姿勢角
        xr(10:12, h+1) = [0;0;0];

        xr(13:16, h+1) = params.ur; % MC -> 0.6597,   HL -> 0
        % xr(13:16, h+1) = params.ur_array(:, round(T.ind)+1); % HLの入力を目標入力

        %% 斜面
        if T.t < 2
            xr(1:3, h+1) = Gp;  % 座標
            xr(7:9, h+1) = [0;0;0]; % 速度
        end
% 
%         if h == params.H-1
%             xr(4:6, h) = Gq;% 終端ホライズンのみ姿勢角目標値
%         end
    end
end

% function funcRef = Reft(t)
%     % 加速度が重力加速度を超えないようなリファレンスの作成
%     phase = 2;
%     % それぞれの関数
%     if t<=phase
%         funcRef = 2;
%     elseif phase<t && t<phase+0.3
%         funcRef = -5 * (t-phase).^2 + 2;
%     elseif phase+0.3 <= t
%         funcRef = 2 * exp(-(t-phase-0.14)/0.5)+0.1;
%     end
% end

%% P2P すべてのホライズンに目標値を割り当て
% function xr = Reference(params, ~, ~, Gp)
%     xr = zeros(16, params.H);
%     for h = 0:params.H-1
%         % 追従項
%         xr(1:3, h+1) = Gp;
%         xr(7:9, h+1) = [0;0;0];
%         % 抑制項
%         xr(4:6, h+1) =   [0; 0; 0]; % 姿勢角
%         xr(10:12, h+1) = [0; 0; 0];
%         % 入力
%         xr(13:16, h+1) = params.ur;
%     end
% end

%% p2p 速度制御つき
% function xr = Reference(params, ~, ~, Gp, Gq, Cp, ~, ~)
%     xr = zeros(16, params.H);
%     Dp = Gp - Cp;
%     RefV = Dp /2;
%     for h = 0:params.H-1
%         % 追従項
%         xr(1:3, h+1) = Gp;
%         xr(7:9, h+1) = RefV;
%         % 抑制項
%         xr(4:6, h+1) =   Gq; % 姿勢角
%         xr(10:12, h+1) = [0; 0; 0];
%         % 入力
%         xr(13:16, h+1) = params.ur;
%     end
% end

%% P2P 関数
% function xr = Reference(params, T, ~, Gp, Gq, initP, RT, StartT)
%     xr = zeros(16, params.H);
% %     StartT = 0;
%     r0 = initP;
%     r = Gp;
%     xa = -2/RT^3 * (r(1)-r0(1));
%     xb = 3/RT^2 * (r(1)-r0(1));
%     ya = -2/RT^3 * (r(2)-r0(2));
%     yb = 3/RT^2 * (r(2)-r0(2));
%     za = -2/RT^3 * (r(3)-r0(3));
%     zb = 3/RT^2 * (r(3)-r0(3));
% 
%     syms rt
%     eq = [xa*(rt-StartT)^3+xb*(rt-StartT)^2+r0(1);
%           ya*(rt-StartT)^3+yb*(rt-StartT)^2+r0(2);
%           za*(rt-StartT)^3+zb*(rt-StartT)^2+r0(3)]; % 位置の式
%     veq = diff(eq, rt);             % 速度
%     for h = 0:params.H-1
%         t = T + params.dt * h; % reference生成時の時刻をずらす
%         x = xa*(t-StartT)^3+xb*(t-StartT)^2+r0(1);
%         y = ya*(t-StartT)^3+yb*(t-StartT)^2+r0(2);
%         z = za*(t-StartT)^3+zb*(t-StartT)^2+r0(3);
%         v = subs(veq, rt, t);
%         % 追従項
%         xr(1:3, h+1) = [x;y;z];
%         xr(7:9, h+1) = v;
%         % 抑制項
%         xr(4:6, h+1) =   Gq; % 姿勢角
%         xr(10:12, h+1) = [0; 0; 0];
%         % 入力
%         xr(13:16, h+1) = params.ur;
%     end
% end

%% 現在位置からのリファレンスを生成する
% zの関数を現在位置から目標値に設定する
% function [xr, fGp] = Reference(params, T, Agent, Gp, fGp)
%     % timevaryingをホライズンごとのreferenceに変換する
%     % params.dt = 0.1;
%     xr = zeros(params.total_size, params.H);    % initialize
%     Cp = Agent.estimator.result.state.p;
% %     Diffp = Gp - Cp;
% 
%     RT = 10 - T;  % Time
%     
%     r0 = Cp;
%     r = Gp;
%     xa = -2/RT^3 * (r(1)-r0(1));
%     xb = 3/RT^2 * (r(1)-r0(1));
% 
%     ya = -2/RT^3 * (r(2)-r0(2));
%     yb = 3/RT^2 * (r(2)-r0(2));
% 
%     za = -2/RT^3 * (r(3)-r0(3));
%     zb = 3/RT^2 * (r(3)-r0(3));
% 
%     syms rt
% 
%     eq = [xa*(rt)^3+xb*(rt)^2+r0(1);
%         ya*(rt)^3+yb*(rt)^2+r0(2);
%         za*(rt)^3+zb*(rt)^2+r0(3)];
% 
% %     eq{1} = xa*(rt)^3+xb*(rt)^2+r0(1);
% %     eq{2} = ya*(rt)^3+yb*(rt)^2+r0(2);
% %     eq{3} = za*(rt)^3+zb*(rt)^2+r0(3);
%     veq = diff(eq, rt);
% 
%     for h = 0:params.H-1
%         t = T + params.dt * h; % reference生成時の時刻をずらす
% 
%         z = za*(t)^3+zb*(t)^2+r0(3);
%         x = xa*(t)^3+xb*(t)^2+r0(1);
%         y = ya*(t)^3+yb*(t)^2+r0(2);
%         
%         v = subs(veq, rt, t);
%         % 目標値に到達したら目標値固定＋速度0
% 
%         if     Gp(1)*0.99 < Cp(1) && Gp(1)*1.01 > Cp(1); fGp(1) = 1;
%         elseif Gp(2)*0.99 < Cp(2) && Gp(2)*1.01 > Cp(2); fGp(2) = 1;
%         elseif Gp(3)*0.99 < Cp(3) && Gp(3)*1.01 > Cp(3); fGp(3) = 1;
%         end
% 
%         if     fGp(1) == 1; x = Gp(1); v(1) = 0;
%         elseif fGp(2) == 1; y = Gp(2); v(2) = 0;
%         elseif fGp(3) == 1; z = Gp(3); v(3) = 0;
%         end
% 
%         % 追従項
%         xr(1:3, h+1) = [x;y;z];
%         xr(7:9, h+1) = v;
%         % 抑制項
%         xr(4:6, h+1) =   [0; 0; 0]; % 姿勢角
%         xr(10:12, h+1) = [0; 0; 0];
% 
%         xr(13:16, h+1) = params.ur;
%     end
% end
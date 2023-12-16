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
%         if Agent.estimator.result.state.p(3) < 1
%             % 追従項
%             xr(1:3, h+1) = Ref(1:3);
%             xr(7:9, h+1) = Ref(5:7);
%         else
%             % 追従項
%             xr(1:3, h+1) = [0;0;1];
%             xr(7:9, h+1) = [0;0;0];
%         end
%         % 抑制項
%         xr(4:6, h+1) =   [0; 0; 0];
%         xr(10:12, h+1) = [0; 0; 0];
% 
%         xr(13:16, h+1) = params.ur;
%     end
% end

% Timevarying
% param : agentの中身いじるパラメータ
% t : reference生成時の現在時刻
% T : time.t そのステップの現在時刻

%元のやつ
function xr = Reference(params, T, Agent)
    % timevaryingをホライズンごとのreferenceに変換する
    % params.dt = 0.1;
    xr = zeros(params.total_size, params.H);    % initialize
    % 時間関数の取得→時間を代入してリファレンス生成
    RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
    for h = 0:params.H-1
        t = T + params.dt * h; % reference生成時の時刻をずらす
        Ref = RefTime(t);
        % 追従項
        xr(1:3, h+1) = Ref(1:3);
        xr(7:9, h+1) = Ref(5:7);
        % 抑制項
        xr(4:6, h+1) =   [0; 0; 0];
        xr(10:12, h+1) = [0; 0; 0];

        xr(13:16, h+1) = params.ur;

        %観測量の追加項を評価関数に入れる場合
%         Xr = xr(1:12,1);
%         zr = quaternions(Xr);
%         xr(17:30, h+1) = zr(13:end);
%         xr(17:26, h+1) = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
    end
        
end

% %姿勢角にリファレンス導入
% function xr = Reference(params, T, Agent, idx)
%     % timevaryingをホライズンごとのreferenceに変換する
%     % params.dt = 0.1;
%     xr = zeros(params.total_size, params.H);    % initialize
%     % 時間関数の取得→時間を代入してリファレンス生成
%     RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
%     Ref_attitude = params.attitude(1:2,idx:idx+9);
%     
%     for h = 0:params.H-1
%         t = T + params.dt * h; % reference生成時の時刻をずらす
%         Ref = RefTime(t);
%         % 追従項
%         xr(1:3, h+1) = Ref(1:3);
%         xr(7:9, h+1) = Ref(5:7);
%         % 抑制項
%         xr(4:5, h+1) = Ref_attitude(1:2, h+1);
%         xr(6, h+1) = 0;
%         xr(10:12, h+1) = [0; 0; 0];
%     
%         xr(13:16, h+1) = params.ur;
%     end
% end
%% takeoff -> circle -> landing
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
%         % 追従項
%         xr(1:3, h+1) = Ref(1:3);
%         xr(7:9, h+1) = Ref(5:7);
%         % 抑制項
%         xr(4:6, h+1) =   [0; 0; 0];
%         xr(10:12, h+1) = [0; 0; 0];
% 
%         xr(13:16, h+1) = params.ur;
%     end
% end

% function xr = Reference(params, T, Agent)
%     % timevaryingをホライズンごとのreferenceに変換する
% %     params.dt = 0.1;
%     xr = zeros(params.total_size, params.H);    % initialize
% 
%     % take off
%     rz = 0.05; % 目標
%     rz0 = 1;% スタート
%     Tz = 10; % かける時間
%     a = -2/Tz^3 * (rz-rz0);
%     b = 3/Tz^2 * (rz-rz0);
% 
%     % 時間関数の取得→時間を代入してリファレンス生成
%     RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
%     for h = 0:params.H-1
%         t = T + params.dt * h; % reference生成時の時刻をずらす
%         if T < 10
%             x = t;
%             y = 0;
%             z = 1;
%        else
%             Ref = RefTime(t);
% %             x = Agent.estimator.result.state.p(1);
% %             y = Agent.estimator.result.state.p(2);
% %             z = Ref(3);
% %               x = (t - 15) - sin((t - 15));
% %               y = (1 - cos((t - 15)));
% %               z = 1;
%               x = 10;
%               y = 0;
%               z = a*(t)^3+b*(t)^2+rz0;
%         end
% 
%         % 追従項
%         xr(1:3, h+1) = [x; y; z];
%         xr(7:9, h+1) = [0; 0; 0];
%         % 抑制項
%         xr(4:6, h+1) =   [0; 0; 0];
%         xr(10:12, h+1) = [0; 0; 0];
% 
%         xr(13:16, h+1) = params.ur;
%     end
%         
% end

%% Reference from HL
% function xr = Reference(params, T, x)
%     xr = zeros(params.total_size, params.H);    % initialize
%     if T ~= 0
%         start = round(T/params.dT);
%         fin = start + params.H-1;
%         xr(1:3, 1:params.H) = x(1:3,start:fin);
%         xr(4:6, 1:params.H) = x(4:6,start:fin);
%         xr(7:9, 1:params.H) = x(7:9,start:fin);
%         xr(10:12, 1:params.H) = x(10:12,start:fin);
%         xr(13:16, 1:params.H) = repmat(params.ur, 1, params.H);
%     end
% end

%% 着陸
% function xr = Reference(params, time)
%     xr = zeros(params.total_size, params.H);
%     rz = 0.001; % 目標
%     rz0 = 1;% スタート
%     T = 10; % かける時間
%     StartT = 0;
%     a = -2/T^3 * (rz-rz0);
%     b = 3/T^2 * (rz-rz0);
% %     z = a*(t-StartT)^3+b*(t-StartT)^2+rz0;
% %     X = subs(z, t, Tv);
%     %-- ホライゾンごとのreference
%     %-- velocity#########################################################
%         syms t H real
%         zf = a*((t-StartT)+params.dt*H)^3+b*((t-StartT)+params.dt*H)^2+rz0;
%         zfdt = diff(zf, t); % 微分
%     %####################################################################
%     if time.t <= T
%         for h = 1:params.H
%             xr(1:3, h) = [0;0;subs(zf, [t, H], [time.t, h])];
%             xr(4:12,h) = [0;0;0;0;0;0;0;0;0];
%             xr(7:9, h) = [0;0;subs(zfdt, [t, H], [time.t, h])]; % 速度
%             xr(13:16,h)= params.ur;
%         end
%     else
%         for h = 1:params.H
%             xr(1:3, h) = [0;0;rz];   % 位置
%             xr(4:12,h) = [0;0;0;0;0;0;0;0;0];   % 位置以外 
%             xr(7:9, h) = [0;0;0]; % 速度
%             xr(13:16,h)= params.ur;
%         end
%     end
% end

%% 離陸 
% function xr = Reference(params, time)
%     xr = zeros(params.total_size, params.H);
%     rz = 1; % 目標
%     rz0 = 0;% スタート
%     T = 10; % かける時間
%     StartT = 0;
%     a = -2/T^3 * (rz-rz0);
%     b = 3/T^2 * (rz-rz0);
% %     z = a*(t-StartT)^3+b*(t-StartT)^2+rz0;
% %     X = subs(z, t, Tv);
%     %-- ホライゾンごとのreference
%     %-- velocity#########################################################
%         syms t H real
%         zf = a*((t-StartT)+params.dt*H)^3+b*((t-StartT)+params.dt*H)^2+rz0;
%         zfdt = diff(zf, t); % 微分
%     %####################################################################
%     if time.t <= T
%         for h = 1:params.H
%             xr(1:3, h) = [0;0;subs(zf, [t, H], [time.t, h])];
%             xr(4:12,h) = [0;0;0;0;0;0;0;0;0];
%             xr(7:9, h) = [0;0;subs(zfdt, [t, H], [time.t, h])]; % 速度
%             xr(13:16,h)= params.ur;
%         end
%     else
%         for h = 1:params.H
%             xr(1:3, h) = [0;0;subs(zf, [t, H], [T, 1])];   % 位置
%             xr(4:12,h) = [0;0;0;0;0;0;0;0;0];   % 位置以外 
%             xr(7:9, h) = [0;0;0]; % 速度
%             xr(13:16,h)= params.ur;
%         end
%     end
% end

%% 離陸 + 円旋回
% function xr = Reference(params, time, xr)
% % 離陸
%     rz = 1; % 目標
%     rz0 = 0;% スタート
%     T = 5; % かける時間
%     StartT = 0;
%     a = -2/T^3 * (rz-rz0);
%     b = 3/T^2 * (rz-rz0);
%     %-- takeoff velocity#########################################################
%         syms t H real
%         zf = a*((t-StartT)+params.dt*H)^3+b*((t-StartT)+params.dt*H)^2+rz0;
%         zfdt = diff(zf, t); % 微分
%     %####################################################################
% 
%     %-- flight
%         xf = cos(t * H / 5);
%         yf = sin(t * H / 5);
%         xfdt = diff(xf, t);
%         yfdt = diff(yf, t);
%     %-------------------------
%     if time.t < T
%         for h = 1:params.H
%             xr(1:3, h) = [0;0;a*((time.t-StartT)+params.dt*h)^3+b*((time.t-StartT)+params.dt*h)^2+rz0];
%             xr(4:12,h) = [0;0;0;0;0;0;0;0;0];
%             xr(7:9, h) = [0;0;subs(zfdt, [t, H], [time.t, h])]; % 速度
%             xr(13:16,h)= params.ur;
%         end
%     else
%         for h = 1:params.H
%             xr(1:3, h) = [subs(xf, [t, H], [time.t, h]);subs(yf, [t, H], [time.t, h]);1.0];   % 位置
%             xr(4:12,h) = [0;0;0;0;0;0;0;0;0];   % 位置以外 
%             xr(7:9, h) = [subs(xfdt, [t, H], [time.t, h]);subs(yfdt, [t, H], [time.t, h]);0]; % 速度
%             xr(13:16,h)= params.ur;
%         end
%     end
% end

%% 円旋回
% function xr = Reference(params, time)
%     syms t H real
%     xr = zeros(params.total_size, params.H);
% %-- flight
%     xf = cos(t + params.dt * H);
%     yf = sin(t + params.dt * H);
%     xfdt = diff(xf, t);
%     yfdt = diff(yf, t);
%     for h = 1:params.H
%         xr(1:3, h) = [subs(xf, [t, H], [time.t, h]);subs(yf, [t, H], [time.t, h]);1.0];
%         xr(4:12,h) = [0;0;0;0;0;0;0;0;0];
%         xr(7:9, h) = [subs(xfdt, [t, H], [time.t, h]);subs(yfdt, [t, H], [time.t, h]);0]; % 速度
%         xr(13:16,h)= params.ur;
%     end
% end
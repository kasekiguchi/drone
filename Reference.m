% referenceを生成する関数
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
function xr = Reference(params, time)
    syms t H real
    xr = zeros(params.total_size, params.H);
%-- flight
    xf = cos(t * H / 5)-1;
    yf = sin(t * H / 5);
    xfdt = diff(xf, t);
    yfdt = diff(yf, t);
    for h = 1:params.H
        xr(1:3, h) = [subs(xf, [t, H], [time.t, h]);subs(yf, [t, H], [time.t, h]);1.0];
        xr(4:12,h) = [0;0;0;0;0;0;0;0;0];
        xr(7:9, h) = [subs(xfdt, [t, H], [time.t, h]);subs(yfdt, [t, H], [time.t, h]);0]; % 速度
        xr(13:16,h)= params.ur;
    end
end
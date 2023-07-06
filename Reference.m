% referenceを生成する関数

%% Timevarying
% param : agentの中身いじるパラメータ
% t : reference生成時の現在時刻
% T : time.t そのステップの現在時刻

% function [xr] = Reference(params, T, Agent, Gq, Gp, phase, refFlag)
%     % パラメータ取得
%     % timevaryingをホライズンごとのreferenceに変換する
%     % params.dt = 0.1;
% 
%     xr = zeros(params.total_size, params.H);    % initialize
%     % 時間関数の取得→時間を代入してリファレンス生成
%     RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
%     for h = 0:params.H-1
%         t = T.t + params.dt * h; % reference生成の時刻をずらす
%         % それぞれの関数 % z方向目標値時
%         if refFlag == 1
%             if t<=phase
%                 tz = 2;
%                 tx = -1;
%                 tvz = 0;
%                 tvx = 0;
%             elseif phase<t && t<phase+0.3
%                 tz = -5 * (t-phase).^2 + 2; tvz = 20-10*t;
%                 tx = 5 * (t-phasex).^2 - 1;  tvx = 10*t-20;
%             elseif phase+0.3 <= t
%                 tz = 2 * exp(-(t-phase-0.14)/0.55)+0.2; tvz = -4*exp((107/25)-2*t); % zeta=0.5, offset=0.1
%                 tx = -exp(-(t-phasex)/0.28);             tvx = 2*exp(4-2*t);  % 0.2 : good
%             end
%             xr(1:3, h+1) = [tx;  0; tz];
%             xr(7:9, h+1) = [tvx; 0; tvz];
%             xr(4:6, h+1) =   [0;0;0]; % 姿勢角
%             xr(10:12, h+1) = [0;0;0];
%             xr(13:16, h+1) = params.ur; % MC -> 0.6597,   HL -> 0
%             %% 斜面
%             if T.t < 2
%                 xr(1:3, h+1) = Gp;  % 座標
%                 xr(7:9, h+1) = [0;0;0]; % 速度
%             elseif h > 5
%                 xr(4:6, h+1) = Gq;
% %             elseif h == params.H-1
% %                 xr(4:6, h) = Gq;% 終端ホライズンのみ姿勢角目標値
%             end
%         elseif refFlag == 2  % 逆時間
%             % t = abs(t-T.te);
%             t = abs(t-3);
%             Ref = RefTime(t);
%             xr(1:3, h+1) = Ref(1:3);
%             xr(7:9, h+1) = -1 * Ref(5:7);
%             xr(4:6, h+1) =   [0;0;0]; % 姿勢角
%             xr(10:12, h+1) = [0;0;0];
%             xr(13:16, h+1) = params.ur;
%         else   % TimeVarying
%             Ref = RefTime(t); % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
%             xr(1:3, h+1) = Ref(1:3);
%             xr(7:9, h+1) = Ref(5:7);
%             xr(4:6, h+1) =   [0;0;0]; % 姿勢角
%             xr(10:12, h+1) = [0;0;0];
%             xr(13:16, h+1) = params.ur;
%         end
%     end
% end

%% xとzで時間ずらす
function [xr] = Reference(params, T, Agent, Gq, Gp, phase, refFlag)
    % パラメータ取得
    % timevaryingをホライズンごとのreferenceに変換する
    % params.dt = 0.1;
    phasex = phase + 0.5;
    xr = zeros(params.total_size, params.H);    % initialize
    % 時間関数の取得→時間を代入してリファレンス生成
    RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
    for h = 0:params.H-1
        t = T.t + params.dt * h; % reference生成の時刻をずらす
        % それぞれの関数 % z方向目標値時
        if refFlag == 1
            if t<=phase
                tz = 2;
                tvz = 0;
            elseif phase<t && t<phase+0.3
                tz = -5 * (t-phase).^2 + 2;             tvz = 20-10*t;
            elseif phase+0.3 <= t
                tz = 2 * exp(-(t-phase-0.09)/0.55)+0.2; tvz = -(40*exp(19/5 - (20*t)/11))/11;%tvz = -4*exp((107/25)-2*t); % zeta=0.5, offset=0.1
            end

            if t<=phasex
                tx = -1;
                tvx = 0;
            elseif phasex<t && t<phasex+0.3
                tx = 5 * (t-phasex).^2 - 1;  tvx = 10*t-25;
            elseif phasex+0.3 <= t
                tx = -exp(-(t-phasex)/0.5); tvx = 2*exp(5 - 2*t); %tvx = 2*exp(4-2*t);  % 0.2 : good
            end
            xr(1:3, h+1) = [tx;  0; tz];
            xr(7:9, h+1) = [tvx; 0; tvz];
            xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            xr(10:12, h+1) = [0;0;0];
            xr(13:16, h+1) = params.ur; % MC -> 0.6597,   HL -> 0
            %% 斜面
            if T.t < 2
                xr(1:3, h+1) = Gp;  % 座標
                xr(7:9, h+1) = [0;0;0]; % 速度
            elseif h > 5
                xr(4:6, h+1) = Gq;
%             elseif h == params.H-1
%                 xr(4:6, h) = Gq;% 終端ホライズンのみ姿勢角目標値
            end
        elseif refFlag == 2  % 逆時間
            % t = abs(t-T.te);
            t = abs(t-3);
            Ref = RefTime(t);
            xr(1:3, h+1) = Ref(1:3);
            xr(7:9, h+1) = -1 * Ref(5:7);
            xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            xr(10:12, h+1) = [0;0;0];
            xr(13:16, h+1) = params.ur;
        else   % TimeVarying
            Ref = RefTime(t); % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
            xr(1:3, h+1) = Ref(1:3);
            xr(7:9, h+1) = Ref(5:7);
            xr(4:6, h+1) =   [0;0;0]; % 姿勢角
            xr(10:12, h+1) = [0;0;0];
            xr(13:16, h+1) = params.ur;
        end
    end
end
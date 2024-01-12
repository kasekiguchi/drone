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
% function [xr] = Reference(params, T, Agent, Gq, Gp, phase, refFlag, Zdis)
%     % パラメータ取得
%     % timevaryingをホライズンごとのreferenceに変換する
%     % params.dt = 0.1;
%     % phasex = phase + 0.5;
%     xr = zeros(params.total_size, params.H);    % initialize
%     % 時間関数の取得→時間を代入してリファレンス生成
%     RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
%     for h = 0:params.H-1
%         t = T.t + params.dt * h; % reference生成の時刻をずらす
%         % それぞれの関数 % z方向目標値時
%         if refFlag == 1
%             ind = round((t-phase)/0.025) + 1; 
%             if t < phase % zとxの開始時間を変える
%                 tz = 2; tvz = 0;
%             elseif t > 4
%                 tz = params.refZ(end,1); tvz = params.refZ(end,2);
%             else % 斜面開始
%                 tz = params.refZ(ind,1); % 9次補完のリファレンスから値だけ持ってくる
%                 tvz = params.refZ(ind,2);
%             end
% 
%             if t < phase
%                 tx = -1; tvx = 0; 
%             elseif t > 4
%                 tx = params.refX(end,1); tvx = params.refX(end,2);
%             else
%                 tx = params.refX(ind,1); tvx = params.refX(ind,2); 
%             end
% 
%             % if t < params.soft_time
%             if T.ind == 0 || T.ind == 1
%                 pitch = 0;
%             elseif  Zdis(round(T.ind-1)) > params.soft_z
%                 pitch = 0;
%             else    
%                 pitch = 0;
%                 if h == 10
%                     tz = 0.3; tvz = 0;
%                     pitch = -0.2915;
%                 end
%             end
%             xr(1:3, h+1) = [tx;  0.0; tz];
%             xr(7:9, h+1) = [tvx; 0.0; tvz];
%             xr(4:6, h+1) =   [0;pitch;0]; % 姿勢角
%             xr(10:12, h+1) = [0;0;0];
%             xr(13:16, h+1) = params.ur; % MC -> 0.6597,   HL -> 0
%             %% 斜面
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

% %% SICE 斜面 
% function [xr] = Reference(Data, T, Agent, ~, ~, ~, ~, phase)
%     % パラメータ取得
%     % timevaryingをホライズンごとのreferenceに変換する
%     % params.dt = 0.1;
%     % phasex = phase + 0.5;
%     xr = zeros(16, Data.param.H);    % initialize
%     for h = 0:Data.param.H-1
%         t = T.t + Data.param.dt * h; % reference生成の時刻をずらす
%         % それぞれの関数 % z方向目標値時
%         ind = round((t-phase)/0.025) + 1; 
%         if t < phase % zとxの開始時間を変える
%             tz = 2; tvz = 0;
%         elseif t > 4
%             tz = Data.ref.refZ(end,1); tvz = Data.ref.refZ(end,2);
%         else % 斜面開始
%             tz = Data.ref.refZ(ind,1); % 9次補完のリファレンスから値だけ持ってくる
%             tvz = Data.ref.refZ(ind,2);
%         end
% 
%         if t < phase
%             tx = -1; tvx = 0; 
%         elseif t > 4
%             tx = Data.ref.refX(end,1); tvx = Data.ref.refX(end,2);
%         else
%             tx = Data.ref.refX(ind,1); tvx = Data.ref.refX(ind,2); 
%         end
% 
%         %% 重み可変
%         % pitch = 0;
%         % if h == 10
%         %     tz = 0.3; tvz = 0;
%         %     pitch = -0.2915;
%         % end
% 
%         %% 重み変えない
%         if T.ind == 0 || T.ind == 1
%             pitch = 0;
%         % elseif  Zdis(round(T.ind-1)) > params.soft_z
%         %     pitch = 0;
%         else    
%             pitch = 0;
%             if h == 10
%                 pitch = -0.2915;
%                 % 斜面に対する高度の目標値
%                 tz = (3/10 * Agent.estimator.result.state.p(1) + 0.1) + 0.15; % 斜面に対して0.1m上を目標値
%                 tvz = 0.05;
%             end
%         end
%         xr(1:3, h+1) = [tx;  0.0; tz];
%         xr(7:9, h+1) = [tvx; 0.0; tvz];
%         xr(4:6, h+1) =   [0;pitch;0]; % 姿勢角
%         xr(10:12, h+1) = [0;0;0];
%         xr(13:16, h+1) = Data.param.ref_input; % MC -> 0.6597,   HL -> 0
%     end
% end


%% normal 9th polynomial trajectory
% function [xr] = Reference(params, T, ~, ~, ~, ~, ~, ~)
%     xr = zeros(16, params.H);    % initialize
%     for h = 0:params.H-1
%         t = T.t + params.dt * h; % reference生成の時刻をずらす
%         % それぞれの関数 % z方向目標値時
%         ind = round(t/0.025) + 1; 
%         if ind > 401; ind = 401; end
%         xr(1:3, h+1) = [params.refX(ind,1); params.refY(ind,1); params.refZ(ind,1)];
%         xr(7:9, h+1) = [params.refX(ind,2); params.refY(ind,2); params.refZ(ind,2)];
%         xr(4:6, h+1) =   [0;0;0]; % 姿勢角
%         xr(10:12, h+1) = [0;0;0];
%         xr(13:16, h+1) = params.ur; % MC -> 0.6597*4 (総推力，0,0,0),   HL -> 0  
%     end
% end

%% TimeVarying
function [xr] = Reference(Data, T, Agent, ~, ~, ~, ~, ~)
    xr = zeros(16, Data.param.H);
    RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
    % TimeVarying
    % T.t = T.t + 0.025;
    % if T.ind == 1; T.t = 0; end
    for h = 0:Data.param.H-1
        t = T.t + Data.param.dt * h;
        Ref = RefTime(t); % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
        xr(1:3, h+1) = Ref(1:3);
        xr(7:9, h+1) = Ref(5:7);
        xr(4:6, h+1) =   [0;0;Ref(4)]; % 姿勢角
        xr(10:12, h+1) = [0;0;0];
        xr(13:16, h+1) = Data.param.ref_input;

        %% 加速度
        xr(17:19,h+1) = Ref(9:11);

        %% 加速度から姿勢角目標値の算出 
        % acc = Ref(9:11);
        % roll = atan(-acc(2)/-9.81);
        % pitch = atan(-acc(1)/-9.81);
        % xr(4:6, h+1) =   [roll;pitch;Ref(4)]; % 姿勢角
    end
end
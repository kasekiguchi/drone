% referenceを生成する関数

%% caseによる改造
function [xr] = Reference(params, T, Agent, Gq, ini, phase, refFlag, te)
    switch refFlag 
        case 1
            [xr] = Reference_timevarying(params, T, Agent, Gq, ini, phase, refFlag, te);
        case 2
            [xr] = Reference_SICE(params, T, Agent, Gq, ini, phase, refFlag, te);
        case 3
            [xr] = Reference_polynomial(params, T, Agent, Gq, ini, phase, refFlag, te);
        case 4
            [xr] = Reference_SICE_HL(params, T, Agent, Gq, ini, phase, refFlag, te);
        case 5
            [xr] = Reference_spline(params, T, Agent, Gq, ini, phase, refFlag, te);
        otherwise
            error("Not generate reference");
    end
end

% %% SICE 斜面 
function [xr] = Reference_SICE(Data, T, Agent, ~, ~, ~, ~, ~)
    % パラメータ取得
    % timevaryingをホライズンごとのreferenceに変換する
    % params.dt = 0.1;
    % phasex = phase + 0.5;
    xr = zeros(16, Data.param.H);    % initialize
    for h = 0:Data.param.H-1
        t = T.t + Data.param.dt * h; % reference生成の時刻をずらす
        % それぞれの関数 % z方向目標値時
        ind = round((t-phase)/0.025) + 1; 
        if t < phase % zとxの開始時間を変える
            tz = 2; tvz = 0;
        elseif t > 4
            tz = Data.ref.refZ(end,1); tvz = Data.ref.refZ(end,2);
        else % 斜面開始
            tz = Data.ref.refZ(ind,1); % 9次補完のリファレンスから値だけ持ってくる
            tvz = Data.ref.refZ(ind,2);
        end

        if t < phase
            tx = -1; tvx = 0; 
        elseif t > 4
            tx = Data.ref.refX(end,1); tvx = Data.ref.refX(end,2);
        else
            tx = Data.ref.refX(ind,1); tvx = Data.ref.refX(ind,2); 
        end

        %% 重み可変
        % pitch = 0;
        % if h == 10
        %     tz = 0.3; tvz = 0;
        %     pitch = -0.2915;
        % end

        %% 重み変えない
        if T.ind == 0 || T.ind == 1
            pitch = 0;
        % elseif  Zdis(round(T.ind-1)) > params.soft_z
        %     pitch = 0;
        else    
            pitch = 0;
            if h == 10
                pitch = -0.2915;
                % 斜面に対する高度の目標値
                tz = (3/10 * Agent.estimator.result.state.p(1) + 0.1) + 0.15; % 斜面に対して0.1m上を目標値
                tvz = 0.05;
            end
        end
        xr(1:3, h+1) = [tx;  0.0; tz];
        xr(7:9, h+1) = [tvx; 0.0; tvz];
        xr(4:6, h+1) =   [0;pitch;0]; % 姿勢角
        xr(10:12, h+1) = [0;0;0];
        xr(13:16, h+1) = Data.param.ref_input; % MC -> 0.6597,   HL -> 0
    end
end

%% Polynomial
function [xr] = Reference_polynomial(Data, T, ~, ~, ~, ~, ~, te)
    xr = zeros(16, Data.param.H);    % initialize
    for h = 0:Data.param.H-1
        t = T.t + Data.param.dt * h; % reference生成の時刻をずらす
        ind = round(t/0.025) + 1; 
        if ind > (te/0.025 + 1); ind = te/0.025 + 1; end
        xr(1:3, h+1) = [Data.ref.X(ind,1); Data.ref.Y(ind,1); Data.ref.Z(ind,1)];
        xr(7:9, h+1) = [Data.ref.X(ind,2); Data.ref.Y(ind,2); Data.ref.Z(ind,2)];
        xr(17:19, h+1) = [Data.ref.X(ind,3); Data.ref.Y(ind,3); Data.ref.Z(ind,3)];
        xr(4:6, h+1) =   [0;0;0]; % 姿勢角
        xr(10:12, h+1) = [0;0;0];
        xr(13:16, h+1) = Data.param.ref_input;
    end
end

%% normal 9th polynomial trajectory ほぼSICE  ホバリング(timevarying) + poylnomial(landing)
function [xr] = Reference_SICE_HL(Data, T, ~, ~, ini, ~, ~, te)
    xr = zeros(16, Data.param.H);    % initialize
    for h = 0:Data.param.H-1
        t = T.t + Data.param.dt * h; % reference生成の時刻をずらす
        % それぞれの関数 % z方向目標値時
        del = 0.5; % ホバリングの時間 [s]
        delay = round(del/0.025); % 落下開始時間：t=2s
        ind = round(t/0.025) + 1; 
        ind = ind - delay;
        if ind > (te/0.025 + 1); ind = te/0.025 + 1; end
        if t <= del
            xr(1:3, h+1) = ini.p;
            xr(7:9, h+1) = ini.v;
            xr(17:19, h+1) = [0;0;0];
        else
            xr(1:3, h+1) = [Data.ref.X(ind,1); Data.ref.Y(ind,1); Data.ref.Z(ind,1)];
            xr(7:9, h+1) = [Data.ref.X(ind,2); Data.ref.Y(ind,2); Data.ref.Z(ind,2)];
            xr(17:19, h+1) = [Data.ref.X(ind,3); Data.ref.Y(ind,3); Data.ref.Z(ind,3)];
        end
        xr(4:6, h+1) =   [0;0;0]; % 姿勢角
        xr(10:12, h+1) = [0;0;0];
        xr(13:16, h+1) = Data.param.ref_input; % MC -> 0.6597*4 (総推力，0,0,0),   HL -> 0  
    end
end

%% TimeVarying
function [xr] = Reference_timevarying(Data, T, Agent, ~, ~, ~, ~, ~)
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

%% MCHLMPC + landing + polynomial(xy) + spline(z)
function [xr] = Reference_spline(Data, T, Agent, ~, ~, ~, ~, te)
    xr = zeros(16, Data.param.H);
    RefTime = Agent.reference.timeVarying.func;    % 時間関数の取得
    spline = Data.ref.spline;
    for h = 0:Data.param.H-1
        t = T.t + Data.param.dt * h;
        ind = round(t/0.025) + 1; 
        if ind > (te/0.025 + 1); ind = te/0.025 + 1; end
        Ref = RefTime(t);
        %-- TimeVarying
        xr(1:2, h+1) = Ref(1:2);
        xr(7:8, h+1) = Ref(5:6);
        xr(17:18,h+1) = Ref(9:10);
        %-- spline 
        xr(3, h+1) = spline.p(ind);
        xr(9, h+1) = spline.v(ind);
        xr(19,h+1) = spline.a(ind);
        %-- general
        xr(4:6, h+1) = [0;0;0];
        xr(10:12, h+1) = [0;0;0];
        xr(13:16, h+1) = Data.param.ref_input;
    end
end

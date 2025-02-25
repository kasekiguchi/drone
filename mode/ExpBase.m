% 複数機牽引でないmodeファイルのための設定
if isscalar(agent)
    N                   = 1;
    firstId             = 1;
end
% 複数の単機機体のmodeファイルなどのための設定
if ~exist("firstId","var")
    firstId             = 1;
end

% 単機機体, 単機牽引モデルのとき
if firstId == 1
    for i = firstId:N
        takeoff_ref{i}  = TAKEOFF_REFERENCE(agent(i),[]);    % take off reference
        landing_ref{i}  = LANDING_REFERENCE(agent(i),dt,0);  % landing reference
    end
% 複数機牽引モデルのとき
else
    for i = 1:N
        takeoff_ref{i}  = agent(i).reference;                % take off reference
        landing_ref{i}  = agent(i).reference;                % landing reference
    end
end

function ref = generate_spline_curve_ref(te,filename,order,isManualSetting)
%% この関数でやりたい処理
% isManualSetting = 1のときにここでwaypointを設定する
% 保存したmatファイルからway_point_refを呼び出す

% te: 実行時間
% filename: 読み込む目標軌道
% order: 何次までのスプラインか(default:5)
% isManualSetting: 手動で設定するか、読み込むか

%% ここから処理開始
    if ~isManualSetting 
        disp('Loading reference data from mat');
        % load(strcat('../Data/reference/', filename));
        load(strcat('Data/reference/', filename)); % for exp
        fshowfig = 0; % 読み込んだ時はグラフは描画しない
    else
        pointN = 5; %waypointの数 default:5, y方向のみの時は7
        dt = 5;%waypoint間の時間
        time =  (0:dt:dt*(pointN-1))';

        %% ランダムな軌道の生成
        % only x-directional
        % wp_xy = max(-1.2, min(1.2, [zeros(pointN-2,1), round(1*randn(pointN-2,1),3)]));
        % wp_z  = ones(pointN-2,1);

        % only z-directional
        % wp_xy = max(-1.2, min(1.2, [zeros(pointN-2,1), zeros(pointN-2,1)]));
        % wp_z  = max(0.5, min(1.5, round(1*randn(pointN-2,1),3)));

        % xyz-directional
        wp_xy = max(-1.2, min(1.2, [round(1*randn(pointN-2,1),3), round(1*randn(pointN-2,1),3)]));
        wp_z  = max(0.5, min(1.5, round(1*randn(pointN-2,1),3)));
        wp = [0, 0, 1;wp_xy, wp_z; 0, 0, 1];
        waypoints = [time, wp];

        fshowfig = 1;      
    end
    ref=MY_WAY_POINT_REFERENCE.way_point_ref(waypoints,order,fshowfig);

    if isManualSetting
        isSaved = input("Save spline curve : '1'\nNo save : '0'\nFill in : ");
        % isSaved = 0; % fixed
        if isSaved==0||isempty(isSaved)
            disp("No save")
        elseif isSaved==1
            % save('../Data/reference/exp_ref.mat', 'waypoints');
            save('Data\reference\exp_ref.mat', 'waypoints');
        end
    end
end
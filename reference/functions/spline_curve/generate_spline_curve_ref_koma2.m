function ref = generate_spline_curve_ref_koma2(te,filename,order,isManualSetting,fshowfig,num)
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
        % fshowfig = 1; % 読み込んだ時はグラフは描画しない
    else
        isSaved = 1; % fixed
        pointN = 7; %waypointの数 default:5, y方向のみの時は7
        dt = 5;%waypoint間の時間
        time =  (0:dt:dt*(pointN-1))';

        %% 特定方向のみ
        % 生成する点を-1.5<point<1.5にする
        %% only x-directional
        % wp_xy = max(-1.2, min(1.2, [round(1*randn(pointN-2,1),3), zeros(pointN-2,1)]));
        % wp_z  = ones(pointN-2,1);
        %% only y-directional
        % wp_xy = max(-1.2, min(1.2, [zeros(pointN-2,1), round(1*randn(pointN-2,1),3)]));
        % wp_z  = ones(pointN-2,1);
        %% only z-directional
        % wp_xy = max(-1.2, min(1.2, [zeros(pointN-2,1), zeros(pointN-2,1)]));
        % wp_z  = max(0.5, min(1.5, round(1*randn(pointN-2,1),3)));
        %% xyz-directional
        wp_xy = max(-1.2, min(1.2, [round(1*randn(pointN-2,1),3), round(1*randn(pointN-2,1),3)]));
        wp_z  = max( 0.5, min(1.5, round(0.3*randn(pointN-2,1)+1.0,3)));
        wp = [0, 0, 1;wp_xy, wp_z; 0, 0, 1];
        waypoints = [time, wp];
        
        %% 円旋回を原点から開始する
        % dt = 1;
        % tt = 0:0.1:te;
        % pointN = length(tt);
        % time =  (0:dt:dt*(pointN-1))';
        % T = 20;
        % tra = [cos(2*pi*(tt-0.5)'/T), sin(2*pi*(tt-0.5)'/T), 0 * tt' + 1];
        
        %% マウスによる入力
        % figure
        % figt = 0:0.1:50;
        % x = cos(2*pi*figt/T); % 書きたいreference のプロット
        % y = sin(2*pi*figt/T);  
        % scatter(x,y); hold on;
        % scatter(tra(1,1), tra(1,2), '*');
        % daspect([1 1 1]);
        % [x1,y1] = ginput;
        % middle_wp = [x1, y1, ones(size(x1,1),1)];
        % disp('The midpoint is inserted by mouse click.')
        % 
        % if isempty(x1); close all; error('Error creating point'); end

        %% 直接入力
        % middle_wp = [0, -0.05, 1;
        %     0.05, -0.25, 1;
        %     0.1, -0.4, 1;
        %     0.2, -0.45, 1;
        %     0.3, -0.5, 1;
        %     0.5, -0.6, 1;
        %     0.75, -0.5, 1;
        %     ];
        % middle_wp = [0, -0.05, 1;
        %             0.2, -0.3, 1;
        %             0.5, -0.6, 1;
        %             0.75, -0.5, 1;];
        % disp('Direct midpoint inserted.')

        %% 円旋回へのスプライン補間のつもり
        % wp = [0, 0, 1; 
        %       middle_wp;
        %       tra(1:end-size(middle_wp,1)-1,:)];
        % waypoints = [time, wp];

        % fshowfig = 1;
        % ref = MY_WAY_POINT_REFERENCE.way_point_ref(waypoints,order,1); %手動で設定したときはここで軌道が生成される         
    end
    ref=MY_WAY_POINT_REFERENCE.way_point_ref(waypoints,order,fshowfig);

    if isManualSetting
        % isSaved = input("Save spline curve : '1'\nNo save : '0'\nFill in : ");
        
        if isSaved==0||isempty(isSaved)
            disp("No save")
        elseif isSaved==1
            % save('../Data/reference/exp_ref.mat', 'waypoints');
            % save(strcat('Data\reference\exp_ref', string(datetime('now'), 'yyyy-MM-dd_hh-mm-ss'), '.mat'), 'waypoints'); % 日付をファイル名に入れて区別する
            save(strcat('Data\reference\exp_ref', '_', num2str(num), '.mat'), 'waypoints');
            % writematrix(M2,'M.xls','WriteMode','append')
        end
    end
end
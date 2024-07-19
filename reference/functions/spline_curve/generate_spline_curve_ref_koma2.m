function ref = generate_spline_curve_ref_koma2(te,filename,order,isManualSetting)
%% この関数でやりたい処理
% isManualSetting = 1のときにここでwaypointを設定する
% 保存したmatファイルからway_point_refを呼び出す

%% ここから処理開始
    if ~isManualSetting 
        disp('Loading reference data from mat');
        load(strcat('../Data/reference/', filename));
        fshowfig = 0;
    else
        % pointN = 8; %waypointの数 default:5
        % dt = 3;%waypoint間の時間
        % time =  (0:dt:dt*(pointN-1))';

        %% x方向のみ
        % 生成する点を-1.5<point<1.5にする
        % wp_xy = max(-1.5, min(1.5, [round(1*randn(pointN-1,1),3), zeros(pointN-1,1)]));
        % wp_z  = ones(pointN-1,1);
        % wp = [0, 0, 1;wp_xy, wp_z];
        % waypoints = [time, wp];
        
        %% 円旋回を原点から開始する
        tt = 0:0.1:te;
        pointN = length(tt);
        dt = 0.1;
        time =  (0:dt:dt*(pointN-1))';
        T = 20;
        tra = [cos(2*pi*(tt-0.5)'/T), sin(2*pi*(tt-0.5)'/T), 0 * tt' + 1];
        
        %% マウスによる入力
        figure
        figt = 0:0.1:50;
        x = cos(2*pi*figt/T); % 書きたいreference のプロット
        y = sin(2*pi*figt/T);  
        scatter(x,y); hold on;
        scatter(tra(1,1), tra(1,2), '*');
        daspect([1 1 1]);
        [x1,y1] = ginput;
        middle_wp = [x1, y1, ones(size(x1,1),1)];
        disp('The midpoint is inserted by mouse click.')

        if isempty(x1); close all; error('Error creating point'); end

        %% 直接入力
        % middle_wp = [0, -0.5, 1;
        %     0.2, -0.75, 1;
        %     0.75, -0.5, 1;
        %     ];
        % disp('Direct midpoint inserted.')

        %% 円旋回へのスプライン補間のつもり
        wp = [0, 0, 1; 
              middle_wp;
              tra(1:end-size(middle_wp,1)-1,:)];
        waypoints = [time, wp];

        fshowfig = 1;
        % ref = MY_WAY_POINT_REFERENCE.way_point_ref(waypoints,order,1); %手動で設定したときはここで軌道が生成される         
    end
    ref=MY_WAY_POINT_REFERENCE.way_point_ref(waypoints,order,fshowfig);

    if isManualSetting
        isSaved = input("Save spline curve : '1'\nNo save : '0'\nFill in : ");
        % isSaved = 1;
        if isSaved==0||isempty(isSaved)
            disp("No save")
        elseif isSaved==1
            save('../Data/reference/exp_ref.mat', 'waypoints');
        end
    end
end
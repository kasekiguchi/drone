function plot_and_close(rigid_num,agent)
% 初期設定
check_rigid = rigid_num; % とりあえずそのまま持ってくる.剛体中心基点をやめたときはいじる必要あり．
%agent(1).sensor.motive.result.rigid = struct('p', cell(1, check_rigid));%↓4行はテスト用
%for i = 1:check_rigid
%    agent(1).sensor.motive.result.rigid(i).p = [randi([0, 10]), randi([0, 10])]; % 例としてランダムな座標を設定
%end
    check_position = struct('p', cell(1, check_rigid));
    for check_i = 1:check_rigid %将来的に幾何中心をmotiveではなく計算や任意の値にするとき用.剛体中心基点をやめたときはいじる必要あり．
        check_position(check_i).p = agent(1).sensor.motive.result.rigid(check_i).p;
    end

    % グラフの初期化
    motive_fig = figure('Name', 'motive_fig');
    hold on;

    % プロットのループ
    for check_i = 1:check_rigid
        x = check_position(check_i).p(1);
        y = check_position(check_i).p(2);

        if check_i == 1
            % 最初の点を星で表示(牽引物幾何中心のはず)
            plot(x, y, 'p', 'MarkerSize', 10, 'DisplayName', ['Point ' num2str(check_i)]);
            text(x + 0.2, y, num2str(check_i), 'FontSize', 12, 'Color', 'black'); % 番号を表示
        elseif mod(check_i, 2) == 0
            % check_iが偶数のときDroneとして表示
            plot(x, y, 's', 'MarkerSize', 10, 'DisplayName', ['Quadcopter ' num2str(check_i)]);
            text(x + 0.2, y, ['Drone ' num2str(check_i)], 'FontSize', 12, 'Color', 'black'); % 番号を表示

            if check_i + 1 <= check_rigid
                % 次の奇数の座標へ矢印を表示(単機牽引のロープの方向)
                next_x = check_position(check_i + 1).p(1);
                next_y = check_position(check_i + 1).p(2);
                quiver(x, y, next_x - x, next_y - y, 0, 'MaxHeadSize', 0.5, 'Color', 'k');
            end
        elseif check_i >= 3 && mod(check_i, 2) == 1
            % check_iが3以上で奇数のとき丸で表示(牽引物接続点のはず)
            plot(x, y, 'o', 'MarkerSize', 10, 'DisplayName', ['Point ' num2str(check_i)]);
            text(x + 0.2, y, num2str(check_i), 'FontSize', 12, 'Color', 'black'); % 番号を表示
        end
    end

    % グラフの設定
    xlabel('X座標');
    ylabel('Y座標');
    title('Motiveのセンサー結果 Enterで閉じる');
    legend('Location', 'northeastoutside'); % 凡例を外側に表示
    legend show;
    grid on
    hold off;

    % キー押下時のコールバック関数を設定
    set(motive_fig, 'KeyPressFcn', @(src, event) key_press_callback(src, event, motive_fig));

    function key_press_callback(~, event, fig)
        % Enterキーが押された場合に特定のFigureを閉じる
        if strcmp(event.Key, 'return')
            close(fig);
        end
    end
end

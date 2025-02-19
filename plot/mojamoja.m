function mojamoja(gui, P, style)
    agent = gui.logger.Data.agent;
    idx = 1:find(gui.logger.Data.phase == 102, 1, 'last'); %インデックスの取得
    ref = cell2mat(arrayfun(@(N) agent.reference.result{N}.state.get(), idx, 'UniformOutput', false)); %reference
    path = zeros(idx(end), 3, P.H+1, P.particle_num); %MCの軌道（もじゃもじゃ）
    
    result.cost = cell2mat(arrayfun(@(N) agent.controller.result{N}.Evaluationtra(:,1), idx, 'UniformOutput', false)); %MCの全コスト
    result.bestcost = cell2mat(arrayfun(@(N) agent.controller.result{N}.bestcost(1), idx, 'UniformOutput', false)); %MCの最も良いコスト
    result.idx = cell2mat(arrayfun(@(N) agent.controller.result{N}.bestcostID(1), idx, 'UniformOutput', false)); %MCの最も良いコストのインデックス
    result.sigma = cell2mat(arrayfun(@(N) agent.controller.result{N}.sigma, idx, 'UniformOutput', false)); %サンプルのσ（値の表示用）
    result.u = cell2mat(arrayfun(@(N) agent.controller.result{N}.input, idx, 'UniformOutput', false));

    parfor i = idx
        path(i,:,:,:) = agent.controller.result{i}.path(1:3,:,:); % 時刻x状態xホライズンxサンプル数
    end
    result.data = path;
    % result.cost = reshape(result.cost, [], idx(end)); %1x? -> Nx? に変換
    
    N = P.particle_num; %サンプル数

    % result = cpu2gpu(result); % cpu -> gpu
    result.P = P;
    result.style = style;
    
    %%
    mov(result, ref, N, idx, 1);
    
    %%
    function mov(result, Ref, N, Ti, mp4)
        switch result.style
            case 'xy'; d1 = 1; d2 = 2; label1 = 'x [m]'; label2 = 'y [m]';
            case 'xz'; d1 = 1; d2 = 3; label1 = 'x [m]'; label2 = 'z [m]';
            case 'yz'; d1 = 2; d2 = 3; label1 = 'y [m]'; label2 = 'z [m]';
            otherwise; error('NO TYPE. xy or xz or yz');
        end
        
        % 初期化
        filename = strrep(strrep(strcat('./plot/Mov/Movie(',datestr(datetime('now')),').mp4'),':','_'),' ','_');
        f=figure(3);
        daspect([1 1 1]); % 現在位置からのサイズ
        
        framev(1:length(Ti)-1) = struct('cdata', [], 'colormap', []);
        parfor j = 1:length(Ti)-1 % parforによりかなり早く描画できる
            data = reshape(result.data(j,:,:,:), 3, result.P.H+1, []);
            data1 = reshape(data(d1,:,:), [], N);
            data2 = reshape(data(d2,:,:), [], N);

            % サンプルの並び替え 大きい順(悪い順)
            [~, ind] = sort(result.cost(:,j), 'ascend');
            cm = flipud(jet(N));

            % 上位10％を色付け
            cm10 = [repmat([0.5 0.5 0.5], N-round(N/10),1); cm(N-round(N/10)+1:end,:)];

            for n = 1:N % 悪い順に描画
                % plot(data1(:,ind(n)), data2(:,ind(n)), 'Color', cm(n,:)); hold on;
                plot(data1(:,ind(n)), data2(:,ind(n)), 'Color', cm10(n,:)); hold on;
                % plot(data1(:,n), data2(:,n), 'Color', '#696969'); hold on;
            end

            % best 
            plot(data1(:,result.idx(j)), data2(:,result.idx(j)), '--', 'Color', '#FFA500', 'LineWidth', 2); hold on;
            plot(data1(1,result.idx(j)), data2(1,result.idx(j)), '*'); % 初期値に点
            % ref
            plot(Ref(1,:), Ref(2,:), '-', 'LineWidth', 0.1);
            % info param
            text(0.85, 0.9, strcat('t: ', num2str(j*0.025)), 'Units', 'normalized');
            text(0.85, 0.85, strcat('sigma: ', num2str(result.sigma(1,j))), 'Units', 'normalized');
            text(0.85, 0.8, strcat('cost: ', num2str(result.bestcost(1,j))), 'Units', 'normalized');
            % info pos
            text(0.85, 0.7, strcat(label1, num2str(data1(1,result.idx(j)))), 'Units', 'normalized');
            text(0.85, 0.65, strcat(label2, num2str(data2(1,result.idx(j)))), 'Units', 'normalized');
            text(0.85, 0.55, strcat('input ', num2str(result.u(:,j))), 'Units', 'normalized');

            hold off;
            ylim([min(data2(1,result.idx(j)))-5e-4 max(data2(1,result.idx(j)))+5e-4]); 
            xlim([min(data1(1,result.idx(j)))-5e-4 max(data1(1,result.idx(j)))+5e-4]); 
            xlabel(label1, 'FontSize', 15); ylabel(label2, 'FontSize', 15);
            drawnow;
            framev(j) = getframe(f);
        end

        if mp4
            v = VideoWriter(filename,"MPEG-4");
            % v = VideoWriter(filename);
            v.FrameRate = round(1/0.025);
            open(v); 
            writeVideo(v, framev);
            close(v);
        end
        close(3);
    end
end

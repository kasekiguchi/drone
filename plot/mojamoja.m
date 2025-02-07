function mojamoja(gui, P, style)
    agent = gui.logger.Data.agent;
    idx = 1:find(gui.logger.Data.phase == 102, 1, 'last'); %インデックスの取得
    ref = cell2mat(arrayfun(@(N) agent.reference.result{N}.state.get(), idx, 'UniformOutput', false)); %reference
    path = zeros(idx(end), 3, P.H+1, P.particle_num); %MCの軌道（もじゃもじゃ）
    
    result.cost = cell2mat(arrayfun(@(N) agent.controller.result{N}.Evaluationtra(1), idx, 'UniformOutput', false)); %MCの全コスト
    result.bestcost = cell2mat(arrayfun(@(N) agent.controller.result{N}.bestcost(1), idx, 'UniformOutput', false)); %MCの最も良いコスト
    result.idx = cell2mat(arrayfun(@(N) agent.controller.result{N}.bestcostID(1), idx, 'UniformOutput', false)); %MCの最も良いコストのインデックス
    result.sigma = cell2mat(arrayfun(@(N) agent.controller.result{N}.sigma, idx, 'UniformOutput', false)); %サンプルのσ（値の表示用）
    result.u = cell2mat(arrayfun(@(N) agent.controller.result{N}.input, idx, 'UniformOutput', false));

    for i = idx
        path(i,:,:,:) = agent.controller.result{i}.path(1:3,:,:); % 時刻x状態xホライズンxサンプル数
    end
    result.data = path;
    result.cost = reshape(result.cost, [], idx(end)); %1x? -> Nx? に変換
    result.P = P;
    result.style = style;
    N = P.particle_num; %サンプル数
    
    %%
    mov(result, ref, N, idx, 1);
    
    %%
    function mov(result, Ref, N, Ti, mp4)
        switch result.style
            case 'xy'; d1 = 1; d2 = 2; label1 = 'x [m]'; label2 = 'y [m]';
            case 'xz'; d1 = 1; d2 = 3; label1 = 'x [m]'; label2 = 'z [m]';
            case 'yz'; d1 = 2; d2 = 3; label1 = 'y [m]'; label2 = 'z [m]';
            otherwise; error('NO TYPE');
        end
        
        % 初期化
        filename = strrep(strrep(strcat('./plot/Mov/Movie(',datestr(datetime('now')),').mp4'),':','_'),' ','_');
        f=figure(3);
        xlabel(label1, 'FontSize', 15); ylabel(label2, 'FontSize', 15);
        daspect([1 1 1]); % 現在位置からのサイズ
        
        framev(1:length(Ti)-1) = struct('cdata', [], 'colormap', []);
        for j = 1:length(Ti)-1
            data = reshape(result.data(j,:,:,:), 3, result.P.H+1, []);
            data1 = reshape(data(d1,:,:), [], N);
            data2 = reshape(data(d2,:,:), [], N);
            for n = 1:N % サンプル数分の軌道を描画
                plot(data1(:,n), data2(:,n), 'Color', '#696969'); hold on;
            end
            % best 
            plot(data1(:,result.idx(j)), data2(:,result.idx(j)), '--', 'Color', 'red', 'LineWidth', 1.5); hold on;
            plot(data1(1,result.idx(j)), data2(1,result.idx(j)), '*'); % 初期値に点
            % ref
            plot(Ref(1,:), Ref(2,:), '-', 'LineWidth', 0.1);
            % info param
            text(0.7, 0.9, strcat('t: ', num2str(j*0.025)), 'Units', 'normalized');
            text(0.7, 0.85, strcat('sigma: ', num2str(result.sigma(1,j))), 'Units', 'normalized');
            text(0.7, 0.8, strcat('cost: ', num2str(result.bestcost(1,j))), 'Units', 'normalized');
            % info pos
            text(0.7, 0.7, strcat(label1, num2str(data1(1,result.idx(j)))), 'Units', 'normalized');
            text(0.7, 0.65, strcat(label2, num2str(data2(1,result.idx(j)))), 'Units', 'normalized');
            text(0.7, 0.55, strcat('input ', num2str(result.u(:,j))), 'Units', 'normalized');

            hold off;
            ylim([data2(1,result.idx(j))-0.05 data2(1,result.idx(j))+0.05]); 
            xlim([data1(1,result.idx(j))-0.05 data1(1,result.idx(j))+0.05]); 
            drawnow;
            framev(j) = getframe(f);
        end

        if mp4
            v = VideoWriter(filename,"MPEG-4");
            v.FrameRate = round(1/0.1);
            open(v); 
            writeVideo(v, framev);
            close(v);
        end
    end
end

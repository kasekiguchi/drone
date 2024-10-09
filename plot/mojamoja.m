% logt = gui.logger.Data.t;
% xmax = gui.time.t-gui.time.dt;
% for i = 1:length(gui.logger.Data.t) -1
%     Data(:,i) = gui.logger.Data.agent.estimator.result{i}.state.get();
%     RData(:,i) = gui.logger.Data.agent.controller.result{i}.xr(:,1);
%     Idata(:,i) = gui.logger.Data.agent.input{i};
%     InputV(:,i) = gui.logger.Data.agent.controller.result{i}.input_v;
% end
idx = 1:find(gui.logger.Data.phase == 102, 1, 'last');
est = cell2mat(arrayfun(@(N) gui.logger.Data.agent.estimator.result{N}.state.get(), idx, 'UniformOutput', false));
Ref = cell2mat(arrayfun(@(N) gui.logger.Data.agent.reference.result{N}.state.get(), idx, 'UniformOutput', false));
u = cell2mat(arrayfun(@(N) gui.logger.Data.agent.controller.result{N}.input, idx, 'UniformOutput', false));
path = zeros(idx(end), 12, 11, gui.logger.Data.agent.controller.result{1}.variable_N);
result.cost = cell2mat(arrayfun(@(N) gui.logger.Data.agent.controller.result{N}.Evaluationtra, idx, 'UniformOutput', false));
result.bestcost = cell2mat(arrayfun(@(N) gui.logger.Data.agent.controller.result{N}.bestcost, idx, 'UniformOutput', false));

result.state(:, sim) = X;
result.input(:, sim) = input;
result.data{sim} = state;
result.idx(sim) = BestcostID;
result.sigma(sim,:) = sigma;
result.mu(sim,:) = mu';
result.bestcost(sim) = Bestcost;
result.cost(sim,:) = eval;



for i = idx
    path(i,:,:,:) = gui.logger.Data.agent.controller.result{i}.path;
end

N = idx(end);
filename = strrep(strrep(strcat('Mov/Movie(',datestr(datetime('now')),').mp4'),':','_'),' ','_');
% plot range
yrange = [-0.2 0.2];
xrange = [-0.1 0.5];
% colormap
c = jet(N); c(20:end,:) = repmat(0.533*ones(1,3), N-19, 1);
% sort
[~, sort_idx] = sort(result.cost, 2);

figure(3);
v = VideoWriter(filename,"MPEG-4");
v.FrameRate = round(1/0.1);
if mp4; open(v); writeAnimation(v); end
% t = 0:0.1:10; % reference描画用．あまり必要ない
for j = 1:length(Ti)-1
    data = reshape(path(j,:,:,:), 12, 11, 5000);
    x = reshape(data(1,:,:), [], N);
    y = reshape(data(2,:,:), [], N);
    for n = 1:N % サンプル数分の軌道を描画
        plot(x(:,n), y(:,n), '-', 'Color', colormap(c(sort_idx(n),:))); hold on;
    end
    % best 
    plot(x(:,result.idx(j)), y(:,result.idx(j)), '--', 'Color', 'red'); hold on;
    plot(x(1,result.idx(j)), y(1,result.idx(j)), '*');
    % ref
    plot(Ref(1,:), Ref(2,:), '-', 'LineWidth', 0.1);
    % info
    text(0.85, 0.9, strcat('t: ', num2str(j*0.1)), 'Units', 'normalized');
    text(0.85, 0.85, strcat('sigma: ', num2str(result.sigma(j,1))), 'Units', 'normalized');
    text(0.85, 0.75, strcat('cost: ', num2str(result.bestcost(j))), 'Units', 'normalized');
    text(0.85, 0.8, strcat('mu: ', num2str(result.mu(j,1))), 'Units', 'normalized');
    hold off;
    % xlim([x(1,result.idx(j))+xrange(1) x(1,result.idx(j))+xrange(2)]); ylim([x(2,result.idx(j))+yrange(1) x(2,result.idx(j))+yrange(2)]);
    ylim([min(Ref(2,:))-1 max(Ref(2,:)+1)]); xlim([min(Ref(1,:))-0.1 max(Ref(1,:)+0.1)]); daspect([1 1 1]); % グラフの体裁
    drawnow;
    if mp4; framev = getframe(gca); writeVideo(v,framev); end
end
if mp4; close(v); end

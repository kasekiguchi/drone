%%
clear
load('Koopman_Linearization\Integration_Dataset\Kiyama_Exp_Dataset.mat');
%%
clear data
for j = 1:Data.HowmanyDataset
    % data.X = Data.X{j};
    for k = 1:12  
        est = Data.X(k,:)';
        pd = fitdist(est, 'Normal');
        data.pd(:,k) = [pd.mu; pd.sigma];
    end
end
%% plot
close all
% set(0,'DefaultAxesFontSize',18);
set(0,'DefaultTextFontSize', 18);
variable = {'x', 'y', 'z', 'q_r', 'q_p', 'q_y', 'v_x', 'v_y', 'v_z', 'omega_r', 'omega_p', 'omega_y'};
variable_state = {'Position', 'Angle', 'Velocity', 'Angular velocity'};
flg.savefig = 0;

idx = 0;
for s = 1:1
    figure(s);
    for m = 1:3
        idx = idx + 1;
        subplot(1,3,m);
        sgtitle(strcat('approximate standard normal distribution:  ', variable_state{s}));
        histfit(Data.X(idx,:)); title(strcat('$$', variable{idx}, '$$'), 'Interpreter','latex', 'FontSize', 20);
        text(0.1, 0.8, strcat('$$', '\mu :', '$$', num2str(data.pd(1,idx))), 'Interpreter','latex', 'FontSize', 20, 'Units', 'normalized');
        text(0.1, 0.75, strcat('$$', '\sigma :', '$$', num2str(data.pd(2,idx))), 'Interpreter','latex', 'FontSize', 20, 'Units', 'normalized');
        set(gca,"FontSize",15);
    
        % save
        % if flg.savefig; saveas(m, strcat('./Koopman_Linearization/Data_analysis/Xdirection_', variable{m}), 'png'); end
    end
end


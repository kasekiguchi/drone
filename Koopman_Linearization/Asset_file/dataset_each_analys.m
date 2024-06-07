%% 各データのちらばりを見る
% Data.HowmanyDataset = 170;
% loading_filename = 'Exp_0604_15data_add';
% Data.X = {};
% for i = 1:Data.HowmanyDataset
%     if contains(loading_filename,'.mat')
%         Dataset = ImportFromExpData_tutorial(loading_filename); %ImportFromExpData_tutorial:データセットをくっつけるための関数
%     else
%         if i == 1 %66 ~ 78はコマンドウィンドウから入力するのに必要(クープマン線形化には関係ない)
%             setting = 1;
%             Dataset = ImportFromExpData_tutorial(append(loading_filename,'_',num2str(i),'.mat'),setting);
%             datarange = Dataset.datarange;
%             range = Dataset.range;
%             IDX = Dataset.IDX;
%             phase2 = Dataset.phase2;
%             vz_z = Dataset.vz_z;
%             fprintf('\n')
%         else
%             setting = 0;
%             Dataset = ImportFromExpData_tutorial(append(loading_filename,'_',num2str(i),'.mat'),setting,datarange,range,IDX,phase2,vz_z);
%         end
%     end
%     % if i==1
%     %     Data.X = [Dataset.X];
%         % Data.U = [Dataset.U];
%         % Data.Y = [Dataset.Y];        
%     % else
%         % Data.X = [Data.X; Dataset.X];
%         Data.X{1,i} = Dataset.X;
%         % Data.U = [Data.U, Dataset.U];
%         % Data.Y = [Data.Y, Dataset.Y];
%     % end
%     disp(append('loading data number: ',num2str(i),', now data:',num2str(Dataset.N),', all data: ',num2str(size(Data.X,2))))
% end
% save("Koopman_Linearization\Data_cell_Xdirection_add", "Data", "-mat");

%%
clear
load('Koopman_Linearization\Data_cell_Xdirection_add.mat');
%%
clear data
for j = 1:Data.HowmanyDataset
    data.X = Data.X{j};
    for k = 1:12  
        est = data.X(k,:)';
        pd = fitdist(est, 'Normal');
        data.pd(:,j,k) = [pd.mu; pd.sigma];
    end
end
%% plot
close all
% set(0,'DefaultAxesFontSize',18);
set(0,'DefaultTextFontSize', 18);
variable = {'x', 'y', 'z', 'q_r', 'q_p', 'q_y', 'v_x', 'v_y', 'v_z', 'omega_r', 'omega_p', 'omega_y'};
flg.savefig = 1;

% all x
% figure(1); sgtitle(strcat('$$', variable(1), '$$'), 'Interpreter','latex', 'FontSize', 20);
% subplot(1,2,1);
% histfit(data.pd(1,:,1)); title('\mu')
% subplot(1,2,2);
% histogram(data.pd(2,:,1),10); title('\sigma')

% cd('Koopman_Linearization\Data_analysis\')
for m = 1:3
    figure(m); sgtitle(strcat('$$', variable{m}, '$$'), 'Interpreter','latex', 'FontSize', 20);
    subplot(1,2,1);
    histfit(data.pd(1,:,m)); title('\mu');
    set(gca,"FontSize",15);
    subplot(1,2,2);
    histogram(data.pd(2,:,m),20); title('\sigma');
    set(gca,"FontSize",15);

    % save
    if flg.savefig; saveas(m, strcat('./Koopman_Linearization/Data_analysis/Xdirection_', variable{m}), 'png'); end
end


% all y
% figure(2);
% subplot(1,2,1);
% histfit(data.pd(1,:,2)); title('mu')
% subplot(1,2,2);
% histogram(data.pd(2,:,2),10); title('sigma')

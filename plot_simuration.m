%%　実機実験プロット
%pos = cell2mat(logger.Data.agent.sigma(1,:)'); %cell2matでcell配列を行列に変換，:,1が列全選択
%tn = find(logger.Data.t,1,'last');
%posn=length(pos);
% time=size(1,posn);
% time = logger.Data.t';
clear 
%% import
fsingle=1;%figureの数が一つの時１
% 単体
if fsingle==1
    time = logger.Data.t';
    tn = length(time);
    ref=zeros(3,tn);
    est=zeros(3,tn);
    err=zeros(3,tn);
    inp=zeros(4,tn);
    att=zeros(3,tn);
    vel=zeros(3,tn);
    w=zeros(3,tn);
    for i=1:tn
        ref(:,i)=logger.Data.agent.reference.result{1,i}.state.p;
        est(:,i)=logger.Data.agent.estimator.result{1,i}.state.p;
        err(:,i)=est(:,i)-ref(:,i);%誤差
        inp(:,i)=logger.Data.agent.input{1,i};
        att(:,i)=logger.Data.agent.estimator.result{1,i}.state.q;
        vel(:,i)=logger.Data.agent.estimator.result{1,i}.state.v;
        w(:,i)=logger.Data.agent.estimator.result{1,i}.state.w;
    end
else
% 比較
    name1=remasui1_0509_HL_G75;%HL
    name2=remasui1_0509_FT_G75;%FT
    time = name1.Data.t';
    tn = length(time);
    ref=zeros(3,tn);
    est1=zeros(3,tn);
    est2=zeros(3,tn);
    err1=zeros(3,tn);
    err2=zeros(3,tn);
    inp1=zeros(4,tn);
    inp2=zeros(4,tn);
    att1=zeros(3,tn);
    att2=zeros(3,tn);
    vel1=zeros(3,tn);
    vel2=zeros(3,tn);
    w1=zeros(3,tn);
    w2=zeros(3,tn);

    for i=1:tn
        ref(:,i)=name1.Data.agent.reference.result{1,i}.state.p;
        est1(:,i)=name1.Data.agent.estimator.result{1,i}.state.p;
        est2(:,i)=name2.Data.agent.estimator.result{1,i}.state.p;
        err1(:,i)=est1(:,i)-ref(:,i);%誤差
        err2(:,i)=est2(:,i)-ref(:,i);
        inp1(:,i)=name1.Data.agent.input{1,i};
        inp2(:,i)=name2.Data.agent.input{1,i};
        att1(:,i)=name1.Data.agent.estimator.result{1,i}.state.q;
        att2(:,i)=name2.Data.agent.estimator.result{1,i}.state.q;
        vel1(:,i)=name1.Data.agent.estimator.result{1,i}.state.v;
        vel2(:,i)=name2.Data.agent.estimator.result{1,i}.state.v;
        w1(:,i)=name1.Data.agent.estimator.result{1,i}.state.w;
        w2(:,i)=name2.Data.agent.estimator.result{1,i}.state.w;
    end
end

% figure
FigName=["x-y" "t-x" "t-y" "error" "input" "attitude" "velocity" "angular_velocity" "3D"];
if fsingle==1
    f(1)=figure('Name',FigName(1));
    hold on
    plot(ref(1,:),ref(2,:));
    plot(est(1,:),est(2,:));
    grid on
    xlabel('x[m]')
    ylabel('y[m]')
    legend('reference','estimater')
    hold off

    f(2)=figure('Name',FigName(2));
    hold on
    plot(time,ref(1,:));
    plot(time,est(1,:));
    grid on
    xlabel('time[s]')
    ylabel('x[m]')
    legend('reference','estimater')
    hold off

    f(3)=figure('Name',FigName(3));
    hold on
    plot(time,ref(2,:));
    plot(time,est(2,:));
    grid on
    xlabel('time[s]')
    ylabel('y[m]')
    legend('reference','estimater')
    hold off
    
    f(4)=figure('Name',FigName(4));
    hold on
    plot(time,err);
    grid on
    xlabel('time[s]')
    ylabel('error[m]')
    legend('x','y','z')
    hold off
    
    f(5)=figure('Name',FigName(5));
    hold on
    plot(time,inp);
    grid on
    xlabel('time[s]')
    ylabel('input')%単位はN？
    legend('1','2','3','4')
    hold off

    f(6)=figure('Name',FigName(6));
    hold on
    plot(time,att);
    grid on
    xlabel('time[s]')
    ylabel('attitude[rad?]')
    legend('x','y','z')
    hold off

    f(7)=figure('Name',FigName(7));
    hold on
    plot(time,vel);
    grid on
    xlabel('time[s]')
    ylabel('velocity[m/s]')
    legend('x','y','z')
    hold off

    f(8)=figure('Name',FigName(8));
    hold on
    plot(time,w);
    grid on
    xlabel('time[s]')
    ylabel('angular velocity[rad/s]')
    legend('x','y','z')
    hold off

    f(9)=figure('Name',FigName(9));
    hold on
    plot3(ref(1,:),ref(2,:),ref(3,:));
    plot3(est(1,:),est(2,:),est(3,:));
    grid on
    xlabel('x[m]')
    ylabel('y[m]')
    zlabel('z[m]')
    legend('reference','estimater')
    hold off
else
% 比較
    f(1)=figure('Name',FigName(1));
    hold on
    plot(ref(1,:),ref(2,:));
    plot(est1(1,:),est1(2,:));
    plot(est2(1,:),est2(2,:));
    grid on
    xlabel('x[m]')
    ylabel('y[m]')
    legend('ref','HL','FT')
    hold off

    f(2)=figure('Name',FigName(2));
    hold on
    plot(time,ref(1,:));
    plot(time,est1(1,:));
    plot(time,est2(1,:));
    grid on
    xlabel('time[s]')
    ylabel('x[m]')
    legend('ref','HL','FT')
    hold off
    
    f(3)=figure('Name',FigName(3));
    hold on
    plot(time,ref(2,:));
    plot(time,est1(2,:));
    plot(time,est2(2,:));
    grid on
    xlabel('time[s]')
    ylabel('y[m]')
    legend('ref','HL','FT')
    hold off
    
    f(4)=figure('Name',FigName(4));
    hold on
    plot(time,err1);
    plot(time,err2);
    grid on
    xlabel('time[s]')
    ylabel('error[m]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(5)=figure('Name',FigName(5));
    hold on
    plot(time,inp1);
    plot(time,inp2);
    grid on
    xlabel('time[s]')
    ylabel('input')%[?]
    legend('1HL','2HL','3HL','4HL','1FT','2FT','3FT','4FT')
    hold off

    f(6)=figure('Name',FigName(6));
    hold on
    plot(time,att1);
    plot(time,att2);
    grid on
    xlabel('time[s]')
    ylabel('attitude[rad?]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(7)=figure('Name',FigName(7));
    hold on
    plot(time,vel1);
    plot(time,vel2);
    grid on
    xlabel('time[s]')
    ylabel('velocity[m/s]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(8)=figure('Name',FigName(8));
    hold on
    plot(time,w1);
    plot(time,w2);
    grid on
    xlabel('time[s]')
    ylabel('angular velocity[rad/s]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(9)=figure('Name',FigName(9));
    hold on
    plot3(ref(1,:),ref(2,:),ref(3,:));
    plot3(est1(1,:),est1(2,:),est1(3,:));
    plot3(est2(1,:),est2(2,:),est2(3,:));
    grid on
    xlabel('x[m]')
    ylabel('y[m]')
    zlabel('z[m]')
    legend('ref','HL','FT')
    hold off
end

%% make folder
%変更しない
ExportFolder='C:\Users\81809\OneDrive\デスクトップ\ACSL\卒業研究\results';
DataFig='figure';%データか図か

%変更
subfolder='sim';%sim or exp
ExpSimName="remasui1";%実験,シミュレーション名
date='0509';%日付
contents="HL_hovering";%実験,シミュレーション内容
FolderName=fullfile(ExportFolder,subfolder,ExpSimName,DataFig);%保存先のpath

%フォルダができてないとき
mkdir(FolderName);
addpath(genpath(folder));
%% save 
n=length(f);
SaveTitle=strings(1,n);
for i=1:5%n %保存する図を選ぶ場合["x-y" "t-x" "t-y" "error" "input" "attitude" "velocity" "angular_velocity" "3D"]
    SaveTitle(i)=strcat(ExpSimName,'_',date,'_',contents,'_',FigName(i));
%     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'jpg');
    saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'fig');
%     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');
end
%% single save
i=0;%figiureの番号
SaveTitle=strings(1,1);
    SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',FigName(i));
%     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'png');
    saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'fig');
%     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');
%%
% FigHandles =  findobj('type','figure');
%%
% n=length(FigHandles);
% for i=1:n
%     h = FigHandles(i);
%     FigName  = get(h, 'Name');%これでないとだめ
%     savefig(h, fullfile(FolderName,( FigName(i) + '.fig')))
% end
% openfig("fig8.fig");
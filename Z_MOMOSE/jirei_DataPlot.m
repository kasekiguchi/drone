%%　DataPlot
%pos = cell2mat(logger.Data.agent.sigma(1,:)'); %cell2matでcell配列を行列に変換，:,1が列全選択

%%
%=======================================================================
%ふぃぐは１つ
%pvqwuの五つのグラフx-y,error?
%figの保存の仕方（保存形式，コピーなど）
%flightのみ？
%グラフの見方を教える必要：プロペラの位置，referenceとエステいめーたなど
%動画を取らせる
%referenceのファイルを渡しておく
%どんな考察をすればいいのかやヒント
%=======================================================================
%import
%選択

ff=10;%flightのみは１
fHLorFT=10;%単体の時,HLは1
HLorFT='';
% 単体
    %loggerの名前が変わっているとき
    name=logger;
%     name=logger_FB_lqr_dst1;
%     name=remasui2_0518_FT_hovering_15;
        
    t0 = name.Data.t';
    k0=name.k;
    ti0=t0(1:k0);
    if ff==1
        k0f=find(name.Data.phase == 102,1,'first');
        k0e=find(name.Data.phase == 102,1,'last');
        tt0=ti0(k0f);
    else
        k0f=1;
        k0e=name.k;
        tt0=0;
    end
    
    lt0=k0e-k0f+1;
    n0 = lt0;
    time=zeros(1,n0);
    tn = length(time);
    ref=zeros(3,tn);
    est=zeros(3,tn);
    err=zeros(3,tn);
    inp=zeros(4,tn);%外乱なしは4
    att=zeros(3,tn);
    vel=zeros(3,tn);
    w=zeros(3,tn);
    uHL=zeros(4,tn);
    z1=zeros(2,tn);
    z2=zeros(4,tn);
    z3=zeros(4,tn);
    z4=zeros(2,tn);
    ininp=zeros(8,tn);
    vf=zeros(4,tn);
    j=1;
    for i=k0f:1:k0e
        time(j)=ti0(i)-tt0;
        ref(:,j)=name.Data.agent.reference.result{1,i}.state.p(1:3);
        est(:,j)=name.Data.agent.estimator.result{1,i}.state.p(1:3);
        err(:,j)=est(:,j)-ref(:,j);%誤差
        inp(:,j)=name.Data.agent.input{1,i};
        att(:,j)=name.Data.agent.estimator.result{1,i}.state.q(1:3);
        vel(:,j)=name.Data.agent.estimator.result{1,i}.state.v(1:3);
        w(:,j)=name.Data.agent.estimator.result{1,i}.state.w(1:3);
%         uHL(:,j)=name.Data.agent.controller.result{1, i}.uHL;
%         z1(:,j)=name.Data.agent.controller.result{1, i}.z1;
%         z2(:,j)=name.Data.agent.controller.result{1, i}.z2;
%         z3(:,j)=name.Data.agent.controller.result{1, i}.z3;
%         z4(:,j)=name.Data.agent.controller.result{1, i}.z4;
        %ininp(:,j)=name.Data.agent.inner_input{1, i};
%         vf(:,j)=name.Data.agent.controller.result{1, i}.vf';
        j=j+1;
    end

% figure
FigName= ["t-p" "t-x" "t-y" "t-z" "velocity" "attitude" "angular_velocity" "input" "error" "x-y" "3D" "uHL" "z1" "z2" "z3" "z4" "inner_input" "vf"];
    
    fosi=14;%defolt 9
    
    f(10)=figure('Name',FigName(10));
    hold on
    plot(ref(1,:),ref(2,:),'LineWidth',2);
    plot(est(1,:),est(2,:),'LineWidth',2);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('x [m]','FontSize',fosi)
    ylabel('y [m]','FontSize',fosi)
    legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimator'))
    daspect([1 1 1])
    hold off
    

%     f(2)=figure('Name',FigName(2));
%     hold on
%     plot(time,ref(1,:));
%     plot(time,est(1,:));
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('x[m]')
%     legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
%     hold off
% 
%     f(3)=figure('Name',FigName(3));
%     hold on
%     plot(time,ref(2,:));
%     plot(time,est(2,:));
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('y[m]')
%     legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
%     hold off
%     
%     f(4)=figure('Name',FigName(4));
%     hold on
%     plot(time,ref(3,:));
%     plot(time,est(3,:));
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('z[m]')
%     legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
%     hold off
    
    f(9)=figure('Name',FigName(9));
    hold on
    plot(time,err,'LineWidth',2);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time [s]','FontSize',fosi)
    ylabel('error [m]','FontSize',fosi)
    legend('x','y','z')
    hold off
    
    f(8)=figure('Name',FigName(8));
    hold on
    plot(time,inp,'LineWidth',2);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time [s]','FontSize',fosi)
    ylabel('input [N]','FontSize',fosi)%単位はN？
    legend('プロペラ1','プロペラ2','プロペラ3','プロペラ4')
    hold off

    f(6)=figure('Name',FigName(6));
    hold on
    plot(time,att,'LineWidth',2);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time [s]','FontSize',fosi)
    ylabel('attitude [rad]','FontSize',fosi)
    legend('roll','pitch','yaw')
    hold off

    f(5)=figure('Name',FigName(5));
    hold on
    plot(time,vel,'LineWidth',2);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time [s]','FontSize',fosi)
    ylabel('velocity [m/s]','FontSize',fosi)
    legend('x','y','z')
    hold off

    f(7)=figure('Name',FigName(7));
    hold on
    plot(time,w,'LineWidth',2);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time [s]','FontSize',fosi)
    ylabel('angular velocity [rad/s]','FontSize',fosi)
    legend('roll','pitch','yaw')
    hold off

%     f(11)=figure('Name',FigName(11));
%     hold on
%     plot3(ref(1,:),ref(2,:),ref(3,:));
%     plot3(est(1,:),est(2,:),est(3,:));
%     grid on
%     title(HLorFT)
%     xlabel('x[m]')
%     ylabel('y[m]')
%     zlabel('z[m]')
%     legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
%     hold off
%     
%     f(12)=figure('Name',FigName(12));
%     hold on
%     plot(time,uHL);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('inputHL')
%     legend('z','x','y','yaw')
%     hold off
%     
%     f(13)=figure('Name',FigName(13));
%     hold on
%     plot(time,z1);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('z1')
%     legend('z','dz')
%     hold off
%     
%     f(14)=figure('Name',FigName(14));
%     hold on
%     plot(time,z2);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('z2')
%     legend('x','dx','ddx','dddx')
%     hold off
%     
%     f(15)=figure('Name',FigName(15));
%     hold on
%     plot(time,z3);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('z3')
%     legend('y','dy','ddy','dddy')
%     hold off
%     
%     f(16)=figure('Name',FigName(16));
%     hold on
%     plot(time,z4);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('z4')
%     legend('psi','dpsi')
%     hold off
%     
    f(1)=figure('Name',FigName(1));
    hold on
    plot(time,ref,time,est,'LineWidth',2);
    grid on
    title(HLorFT)
    xlabel('time [s]','FontSize',fosi)
    ylabel('position [m]','FontSize',fosi)
    legend('x ref','y ref','z ref','x est','y est','z est')
    hold off
%     
%     f(17)=figure('Name',FigName(17));
%     hold on
%     plot(time,ininp);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('inner input')
% %     legend('')
%     hold off
%     
%     f(18)=figure('Name',FigName(18));
%     hold on
%     plot(time,vf);
%     grid on
%     title(HLorFT)
%     xlabel('time[s]')
%     ylabel('vf')
%     legend('zu','dzu','ddzu','dddzu')
%     hold off

%% make folder
%変更しない
    ExportFolder='C:\Users\Students\Documents\momose';%実験用pcのパス
%         ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    DataFig='figure';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
    
    %名前\日付_名前_
%変更
% subfolder='sim';%sim or exp
% subfolder='exp';%sim or exp
%===================================================
subfolder='result_sakura';
%===================================================
ExpSimName='sakura';%実験名,シミュレーション名
% contents='FT_apx_max';%実験,シミュレーション内容
%===================================================
contents='No8';%your name
%===================================================
%     FolderName=fullfile(ExportFolder,subfolder,strcat(date,'_',ExpSimName),'data');%保存先のpath
%     FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
%     FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath
    FolderNamef=fullfile(ExportFolder,subfolder,contents);%保存先のpath
%フォルダができてないとき

%     mkdir(FolderNamed);
    mkdir(FolderNamef);
    addpath(genpath(ExportFolder));
%フォルダをrmる
%     rmpath(genpath(ExportFolder))

% save 
n=length(f);
SaveTitle=strings(1,n);
%保存する図を選ぶ場合[1:"x-y" 2:"t-x" 3:"t-y" 4:"t-z" 5:"error" 6:"input" 7:"attitude" 8:"velocity" 9:"angular_velocity" 10:"3D" 11:"uHL" 12:"z1" 13:"z2" 14:"z3" 15:"z4" 16:"t-p" 17:"inner_input" 18:"vf"]
indent = [1,5,6,7,8,9,10];%保存したいものを書く
for i=1:length(indent) 
    j=indent(i);
    SaveTitle(j)=strcat(date,'_',ExpSimName,'_',contents,'_',FigName(j));
    saveas(f(j), fullfile(FolderNamef, SaveTitle(j) ),'pdf');%拡張子変えられる、saveas関数
end


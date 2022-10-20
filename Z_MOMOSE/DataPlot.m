%%　DataPlot
%pos = cell2mat(logger.Data.agent.sigma(1,:)'); %cell2matでcell配列を行列に変換，:,1が列全選択
clear 
%%
%import
%選択
fsingle=1;%figureの数が一つの時１
ff=1;%flightのみは１
fHLorFT=10;%単体の時,HLは1

% 単体
if fsingle==1
    %loggerの名前が変わっているとき
    name=logger;
%     name=logger_FB_lqr_dst1;
%     name=remasui2_0518_FT_hovering_15;
    %
    if fHLorFT==1
        HLorFT='FB';
    else
        HLorFT='FT';
    end
    
    
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
    inp=zeros(5,tn);
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
    sigmax=zeros(1,tn);
    sigmay=zeros(1,tn);
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
        uHL(:,j)=name.Data.agent.controller.result{1, i}.uHL;
        z1(:,j)=name.Data.agent.controller.result{1, i}.z1;
        z2(:,j)=name.Data.agent.controller.result{1, i}.z2;
        z3(:,j)=name.Data.agent.controller.result{1, i}.z3;
        z4(:,j)=name.Data.agent.controller.result{1, i}.z4;
        %ininp(:,j)=name.Data.agent.inner_input{1, i};
        vf(:,j)=name.Data.agent.controller.result{1, i}.vf';
%         sigmax(:,j)=name.Data.agent.controller.result{1, i}.sigmax;
%         sigmay(:,j)=name.Data.agent.controller.result{1, i}.sigmay;
        j=j+1;
    end
else
% 比較
    name1=tanh_al09a6_kx;%HL
    name2=FT_kx;%_2nd;%FT
    
    t1 = name1.Data.t';
    t2 = name2.Data.t';
    k1=name1.k;
    k2=name2.k;
    ti1=t1(1:k1);
    ti2=t2(1:k2);
    if ff==1
        k1f=find(name1.Data.phase == 102,1,'first');
        k1e=find(name1.Data.phase == 102,1,'last');
        k2f=find(name2.Data.phase == 102,1,'first');
        k2e=find(name2.Data.phase == 102,1,'last');
        tt1=ti1(k1f);
        tt2=ti2(k2f);
        %表示する時間を最小のものに合わせる
        m=min([k1e k2e]);
        k1e=m;
        k2e=m;
    else
        k1f=1;
        k1e=name1.k;
        k2f=1;
        k2e=name2.k;
        tt1=0;
        tt2=0;
    end
    
    
    lt1=k1e-k1f+1;
    lt2=k2e-k2f+1;
   
    n1 = lt1;
    n2 = lt2;
    time1=zeros(1,n1);
    time2=zeros(1,n2);
    ref1=zeros(3,n1);
    ref2=zeros(3,n2);
    est1=zeros(3,n1);
    est2=zeros(3,n2);
    err1=zeros(3,n1);
    err2=zeros(3,n2);
    inp1=zeros(4,n1);
    inp2=zeros(4,n2);
    att1=zeros(3,n1);
    att2=zeros(3,n2);
    vel1=zeros(3,n1);
    vel2=zeros(3,n2);
    w1=zeros(3,n1);
    w2=zeros(3,n2);
    j=1;
    for i=k1f:1:k1e
        time1(j)=ti1(i)-tt1;
        ref1(:,j)=name1.Data.agent.reference.result{1,i}.state.p;
        est1(:,j)=name1.Data.agent.estimator.result{1,i}.state.p;
        err1(:,j)=est1(:,j)-ref1(:,j);%誤差        
        inp1(:,j)=name1.Data.agent.input{1,i};
        att1(:,j)=name1.Data.agent.estimator.result{1,i}.state.q;
        vel1(:,j)=name1.Data.agent.estimator.result{1,i}.state.v;
        w1(:,j)=name1.Data.agent.estimator.result{1,i}.state.w;
        j=j+1;
    end
    j=1;
    for i=k2f:k2e
        time2(j)=ti2(i)-tt2;
        ref2(:,j)=name2.Data.agent.reference.result{1,i}.state.p;
        est2(:,j)=name2.Data.agent.estimator.result{1,i}.state.p;
        err2(:,j)=est2(:,j)-ref2(:,j);%誤差
        inp2(:,j)=name2.Data.agent.input{1,i};
        att2(:,j)=name2.Data.agent.estimator.result{1,i}.state.q;
        vel2(:,j)=name2.Data.agent.estimator.result{1,i}.state.v;
        w2(:,j)=name2.Data.agent.estimator.result{1,i}.state.w;
        j=j+1;
    end
end

% figure
FigName=["x-y" "t-x" "t-y" "t-z" "error" "input" "attitude" "velocity" "angular_velocity" "3D" "uHL" "z1" "z2" "z3" "z4" "t-p" "inner_input" "vf" "sigma"];
fosi=14;%デフォルト9，フォントサイズ変更
LW = 2;%linewidth
if fsingle==1
    i=1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(ref(1,:),ref(2,:),'LineWidth',LW);
    plot(est(1,:),est(2,:),'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('x[m]')
    ylabel('y[m]')
    daspect([1,1,1])
    legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimator'))
    hold off
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,ref(1,:),'LineWidth',LW);
    plot(time,est(1,:),'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('x[m]')
    legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
    hold off
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,ref(2,:),'LineWidth',LW);
    plot(time,est(2,:),'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('y[m]')
    legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
    hold off
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,ref(3,:),'LineWidth',LW);
    plot(time,est(3,:),'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('z[m]')
    legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
    hold off    
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,err,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('error[m]')
    legend('x','y','z')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,inp,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('input')%単位はN？
    legend('1','2','3','4')
    hold off    
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,att,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('attitude [rad]')
    legend('x','y','z')
    hold off    
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,vel,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('velocity[m/s]')
    legend('x','y','z')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,w,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('angular velocity[rad/s]')
    legend('x','y','z')
    hold off     

    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot3(ref(1,:),ref(2,:),ref(3,:),'LineWidth',LW);
    plot3(est(1,:),est(2,:),est(3,:),'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('x[m]')
    ylabel('y[m]')
    zlabel('z[m]')
    daspect([1,1,1])
    legend(strcat(HLorFT,'reference'),strcat(HLorFT,'estimater'))
    daspect([1,1,1]);
    campos([-45,-45,60]);
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,uHL,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('inputHL')
    legend('z','x','y','yaw')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,z1,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('z1')
    legend('z','dz')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,z2,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('z2')
    legend('x','dx','ddx','dddx')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,z3,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('z3')
    legend('y','dy','ddy','dddy')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,z4,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('z4')
    legend('psi','dpsi')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,ref,time,est,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('p [m]')
    legend('x ref','y ref','z ref','x est','y est','z est')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,ininp,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('inner input')
%     legend('')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,vf,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('vf')
    legend('zu','dzu','ddzu','dddzu')
    hold off     
    
    i=i+1;
    f(i)=figure('Name',FigName(i));
    hold on
    plot(time,sigmax,time,sigmay,'LineWidth',LW);
    grid on
    title(HLorFT)
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('sigma')
    legend('sigmax','sigmay')
    hold off     
    
    %二乗誤差平均
    MSE_x=immse(ref(1,:),est(1,:))
    MSE_y=immse(ref(2,:),est(2,:))
    MSE_z=immse(ref(3,:),est(3,:))
    MSE = ["MSE_x"  "MSE_y" "MSE_z" ;
                    MSE_x  MSE_y MSE_z]
else
% 比較
    f(1)=figure('Name',FigName(1));
    hold on
    plot(ref1(1,:),ref1(2,:),'LineWidth',LW);
    plot(ref2(1,:),ref2(2,:),'LineWidth',LW);
    plot(est1(1,:),est1(2,:),'LineWidth',LW);
    plot(est2(1,:),est2(2,:),'LineWidth',LW);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('x[m]')
    ylabel('y[m]')
    legend('refHL','refFT','HL','FT')
    hold off

    f(2)=figure('Name',FigName(2));
    hold on
    plot(time1,ref1(1,:),'LineWidth',LW);
    plot(time2,ref2(1,:),'LineWidth',LW);
    plot(time1,est1(1,:),'LineWidth',LW);
    plot(time2,est2(1,:),'LineWidth',LW);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('x[m]')
    legend('refHL','refFT','HL','FT')
    hold off
    
    f(3)=figure('Name',FigName(3));
    hold on
    plot(time1,ref1(2,:),'LineWidth',LW);
    plot(time2,ref2(2,:),'LineWidth',LW);
    plot(time1,est1(2,:),'LineWidth',LW);
    plot(time2,est2(2,:),'LineWidth',LW);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('y[m]')
    legend('refHL','refFT','HL','FT')
    hold off
    
    f(4)=figure('Name',FigName(4));
    hold on
    plot(time1,ref1(3,:),'LineWidth',LW);
    plot(time2,ref2(3,:),'LineWidth',LW);
    plot(time1,est1(3,:),'LineWidth',LW);
    plot(time2,est2(3,:),'LineWidth',LW);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('z[m]')
    legend('refHL','refFT','HL','FT')
    hold off
    
    f(5)=figure('Name',FigName(5));
    hold on
    plot(time1,err1,'LineWidth',LW);
    plot(time2,err2,'LineWidth',LW);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('error[m]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(6)=figure('Name',FigName(6));
    hold on
    plot(time1,inp1);
    plot(time2,inp2);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('input')%[?]
    legend('1HL','2HL','3HL','4HL','1FT','2FT','3FT','4FT')
    hold off

    f(7)=figure('Name',FigName(7));
    hold on
    plot(time1,att1);
    plot(time2,att2);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('attitude')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(8)=figure('Name',FigName(8));
    hold on
    plot(time1,vel1);
    plot(time2,vel2);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('velocity[m/s]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(9)=figure('Name',FigName(9));
    hold on
    plot(time1,w1);
    plot(time2,w2);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('time[s]')
    ylabel('angular velocity[rad/s]')
    legend('xHL','yHL','zHL','xFT','yFT','zFT')
    hold off

    f(10)=figure('Name',FigName(10));
    hold on
    plot3(ref1(1,:),ref1(2,:),ref1(3,:),'LineWidth',LW);
    plot3(ref2(1,:),ref2(2,:),ref2(3,:),'LineWidth',LW);
    plot3(est1(1,:),est1(2,:),est1(3,:),'LineWidth',LW);
    plot3(est2(1,:),est2(2,:),est2(3,:),'LineWidth',LW);
    grid on
    set(gca,'FontSize',fosi)
    xlabel('x[m]')
    ylabel('y[m]')
    zlabel('z[m]')
    legend('refHL','refFT','HL','FT')
    hold off
end

%% make folder
%変更しない
%     ExportFolder='C:\Users\Students\Documents\momose';%実験用pcのパス
        ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    DataFig='figure';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
    
%変更
% subfolder='sim';%sim or exp
subfolder='sim';%sim or exp
ExpSimName='FT_xyz_model_error';%実験名,シミュレーション名
% contents='FT_apx_max';%実験,シミュレーション内容
contents='FB';%実験,シミュレーション内容

FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath

%フォルダができてないとき

    mkdir(FolderNamed);
    mkdir(FolderNamef);
    addpath(genpath(ExportFolder));
%フォルダをrmる
%     rmpath(genpath(ExportFolder))
%% save 
n=length(f);
SaveTitle=strings(1,n);
na=[1 2 3 4 5 6 7 8 9 10]; %保存する図を選ぶ場合[1:"x-y" 2:"t-x" 3:"t-y" 4:"t-z" 5:"error" 6:"input" 7:"attitude" 8:"velocity" 9:"angular_velocity" 10:"3D"]
for i=1:length(na)
    SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',FigName(na(i)));
%     saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'jpg');
    saveas(f(na(i)), fullfile(FolderNamef, SaveTitle(i) ),'fig');
%     saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'eps');
end
%% single save
i=6;%figiureの番号
% n=length(f);
SaveTitle=strings(1,1);
    SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',FigName(i));
%     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'jng');
    saveas(f(i), fullfile(FolderNamef, SaveTitle(i) ),'fig');
%     saveas(f(i), fullfile(FolderName, SaveTitle(i) ),'eps');

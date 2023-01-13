%%　DataPlot
%pos = cell2mat(logger.Data.agent.sigma(1,:)'); %cell2matでcell配列を行列に変換，:,1が列全選択
close all
%% --------------ここのセクションだけを実行
%import
%選択
fExp=10;%実験のデータかどうか
fSingle=1;%loggerの数が一つの時１
fLSorFT=2;%HL:1,FT:2,No:>=3
fMul =1;%複数まとめるか
fF=10;%flightのみは１

%どの時間の範囲を描画するか指定
startTime = 5;
endTime = 20;
% startTime = 0;
% endTime = 1E2;
%========================================================================
%図を選ぶ[1:"t_p" 2:"x_y" 3:"t_x" 4:"t_y" 5:"t_z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 
%              11:"three_D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
%========================================================================
if fSingle == 1
    name = logger;
%     name =logger_FT_c_09;
%     name =logger_HL_c;
    n = 1:19;
    n = [1,9,8,10,7];
else
%     name1 = logger1;%LS
%     name2 = logger2;%FT
    name1 = logger_FT_c_09;%LS
    name2 = logger_HL_c;%FT

    n = 2:12;%比較
    c1="Linear state FB";
    c2="Finit time settling";
    comp=[c1,c2];%     comp = struct('c1',' Linear state FB','c2',' Finit time settling');
end

option.lineWidth = 1;%linewidth
option.fontSize = 18;%デフォルト9，フォントサイズ変更
option.legendColumns = 1;
option.aspect = [];
option.camposition = [];
option.fExp = fExp;

%タイトルの名前を付ける
if fLSorFT==1
        option.titleName="LS";
elseif fLSorFT==2 && fSingle ==1
        option.titleName="FT";
elseif fSingle~=1 || fLSorFT>2
        option.titleName=[];
end
LSorFT = option.titleName;
%figごとに追加する場合のもの
addingContents.aspect = [1,1,1];
addingContents.camposition = [-45,-45,60];

% multiFigure
% nM = {[1,9,8,10,7],[13,14,15,16,12]};%複数まとめる
nM = {[3:5 6 2 11],[9,8,10,7,12],13:16};%複数まとめる
multiFigure.num =3;%figの数
multiFigure.title = [" state1", " state2 and input", " subsystem"];%[" state", " subsystem"];%title name
multiFigure.layout = {[2,3],[2,3],[2,2]};%{[2,3],[2,3]}%figureの配置場所
multiFigure.fontSize = 14;
multiFigure.pba = [1,0.78084714548803,0.78084714548803];%各図の縦横比
multiFigure.padding = 'tight';
multiFigure.tileSpacing = 'tight';
multiFigure.f = fMul;

%==================================================================================

% 単体
if fSingle==1
    %loggerの名前が変わっているとき
%     name=logger;
%     name = logger_FTzdst10;
%     name=logger_FTnaname3;
%     name=logger_FTxyz_mass_saddle;
%     name=logger_FB2_mass_saddle;
%         name=logger_FB_saddle;
%         name=logger_FB_xyz2_saddle;
%         name=logger_FT_xy_saddle;
%     name=logger_FT_c_09;
%     name=logger_HL_c;
%     name=remasui2_0518_FT_hovering_15;
    
    t = name.Data.t';
    k=name.k;
    ti=t(1:k);
    if fF==1
        kf=find(name.Data.phase == 102,1,'first') + 1;%0.025sは40Hz
        ke=find(name.Data.phase == 102,1,'last');
        startTime = ti(kf) + startTime;
        endTime = ti(kf) + endTime;
        ti = ti(1:ke);
        spanIndex = find(ti <= endTime & ti >= startTime );
        kf = min(spanIndex);
        ke = max(spanIndex);
%         k0f=961;
%         k0e=1527;
%         k0f=1090;
%         k0e=1655;
        %連合の時に使ったrmse
        
%         k0f=find(name.Data.phase == 102,1,'first')+240;%0.025sは40Hz
%         k0e=find(name.Data.phase == 102,1,'last');
%         k0f=find(name.Data.phase == 102,1,'first')+230;%0.025sは40Hz
%         k0e=find(name.Data.phase == 102,1,'last')-470;
        tt=ti(kf);
    else
        spanIndex = find(ti <= endTime & ti >=startTime );
        kf = min(spanIndex);
        ke = max(spanIndex);
        tt = 0;
    end
    
    lt=ke-kf+1;
    time=zeros(1,lt);
    tn = length(time);
    ref=zeros(3,tn);
    est=zeros(3,tn);
    err=zeros(3,tn);
    if fExp==1
        inp=zeros(4,tn);
    else
        inp=zeros(5,tn);
    end
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
    for i=kf:1:ke
        time(j)=ti(i)-tt;
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

        if fExp==1
            ininp(:,j)=name.Data.agent.inner_input{1, i};
        end
%         vf(:,j)=name.Data.agent.controller.result{1, i}.vf';
%         sigmax(:,j)=name.Data.agent.controller.result{1, i}.sigmax;
%         sigmay(:,j)=name.Data.agent.controller.result{1, i}.sigmay;
        j=j+1;
    end
else
    
% =============================================================
%比較 : 二つのデータを同じグラフに表示する
%==============================================================
%     name1=logger_HL_c;%HLを書く
%     name2=logger_FT_c_09;%FTを書く

%     name1=logger_LSprodstpit;%LSを書く
%     name2=logger_FTprodstpit;%FTを書く
%     name1=logger_LSprodstx;%LSを書く
%     name2=logger_FTprodstx;%FTを書く
    
% name1=logger_LSnaname3;%LSを書く
%     name2=logger_FTnaname3;%FTを書く

    t1 = name1.Data.t';
    t2 = name2.Data.t';
    k1=name1.k;
    k2=name2.k;
    ti1=t1(1:k1);
    ti2=t2(1:k2);
    if fF==1
        k1f=find(name1.Data.phase == 102,1,'first')+1;
        k1e=find(name1.Data.phase == 102,1,'last');
        k2f=find(name2.Data.phase == 102,1,'first')+1;
        k2e=find(name2.Data.phase == 102,1,'last');

        startTime1 = ti1(k1f) + startTime;
        endTime1 = ti1(k1f) + endTime;
        ti1 = ti1(1:k1e);
        spanIndex1 = find(ti1 <= endTime1 & ti1 >= startTime1 );
        k1f = min(spanIndex1);
        k1e = max(spanIndex1);

        startTime2 = ti2(k2f) + startTime;
        endTime2 = ti2(k2f) + endTime;
        ti2 = ti2(1:k2e);
        spanIndex2 = find(ti2 <= endTime2 & ti2 >= startTime2 );
        k2f = min(spanIndex2);
        k2e = max(spanIndex2);

        tt1=ti1(k1f);
        tt2=ti2(k2f);
        fspan1=k1e-k1f;
        fspan2=k2e-k2f;
        if  fspan1>=fspan2
            k1e=k1f+fspan2;
        else
            k2e=k2f+fspan1;
        end
    else
        k1f=find(name1.Data.phase == 102,1,'first')+0;
        k2f=find(name2.Data.phase == 102,1,'first')+0;
        
%         startTime = t(k1f) + startTime;
%         endTime = t(k1f) + endTime;
%         t1 = t(k1f:k1);
%         spanIndex = find(t1 <= endTime & t1 >= startTime );
%         k1f = min(spanIndex);
%         k1e = max(spanIndex);

        tt1 = 0;
        tt2 = ti2(k2f) - ti1(k1f) ;
        k1f=1;
        k1e=name1.k;
        k2f=1;
        k2e=name2.k;
        %手動で指定
%         k1f=961-360;%name1の開始するindex
%         k1e=1527+200;
%         k2f=1090-360;%name2の開始するindex
%         k2e=1655+200;%name2のするindex
%         tt1 = ti1(k1f) - ti1(1) ;
%         tt2 = ti2(k2f) - ti2(1) ;
    end
        %表示する時間を最小のものに合わせる
%         m=min([k1e k2e]);
%         k1e=m;
%         k2e=m;
%     else
%         k1f=1;
%         k1e=name1.k;
%         k2f=1;
%         k2e=name2.k;
%         fspan1=0;
%         fspan2=0;
%         tt1=0;
%         tt2=0;
%     end
    
    
    lt1=k1e-k1f+0-0;
    lt2=k2e-k2f+0-0;
   
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
    if fExp
        inp1=zeros(4,n1);
        inp2=zeros(4,n2);
    else
        inp1=zeros(5,n1);
        inp2=zeros(5,n2);
    end
    att1=zeros(3,n1);
    att2=zeros(3,n2);
    vel1=zeros(3,n1);
    vel2=zeros(3,n2);
    w1=zeros(3,n1);
    w2=zeros(3,n2);
    j=1;
    for i=k1f:1:k1e
        time1(j)=ti1(i)-tt1;
        ref1(:,j)=name1.Data.agent.reference.result{1,i}.state.p(1:3);
        est1(:,j)=name1.Data.agent.estimator.result{1,i}.state.p(1:3);
        err1(:,j)=est1(:,j)-ref1(:,j);%誤差        
        inp1(:,j)=name1.Data.agent.input{1,i};
        att1(:,j)=name1.Data.agent.estimator.result{1,i}.state.q(1:3);
        vel1(:,j)=name1.Data.agent.estimator.result{1,i}.state.v(1:3);
        w1(:,j)=name1.Data.agent.estimator.result{1,i}.state.w(1:3);
%         uHL1(:,j)=name1.Data.agent.controller.result{1, i}.uHL;
        j=j+1;
    end
    j=1;
    for i=k2f:k2e
        time2(j)=ti2(i)-tt2;
        ref2(:,j)=name2.Data.agent.reference.result{1,i}.state.p(1:3);
        est2(:,j)=name2.Data.agent.estimator.result{1,i}.state.p(1:3);
        err2(:,j)=est2(:,j)-ref2(:,j);%誤差
        inp2(:,j)=name2.Data.agent.input{1,i};
        att2(:,j)=name2.Data.agent.estimator.result{1,i}.state.q(1:3);
        vel2(:,j)=name2.Data.agent.estimator.result{1,i}.state.v(1:3);
        w2(:,j)=name2.Data.agent.estimator.result{1,i}.state.w(1:3);
%         uHL2(:,j)=name2.Data.agent.controller.result{1, i}.uHL;
        j=j+1;
    end
end

%二乗誤差平均
if fSingle ==1
     RMSE = rmse(ref,est)
else
    RMSE_LS = rmse(ref1,est1)
    RMSE_FT = rmse(ref2,est2)
end

% figure
%図を選ぶ場合[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
figName=["t_p" "x_y" "t_x" "t_y" "t_z" "error" "input" "attitude" "velocity" "angular_velocity" "three_D" "uHL" "z1" "z2" "z3" "z4" "inner_input" "vf" "sigma"];
if fSingle==1
       % allData.i : (data, label, legendLabels, option)   
       %option : titleName, lineWidth, fontSize, legend, aspect, campositon
            allData.t_p = {struct('x',{{time}},'y',{{ref,est}}), struct('x','time [s]','y','p [m]'), {'x ref','y ref','z ref','x est','y est','z est'},add_option([],option,addingContents)};
            allData.x_y = {struct('x',{{ref(1,:),est(1,:)}},'y',{{ref(2,:),est(2,:)}}), struct('x','x [m]','y','y [m]'), {'Reference','Estimator'},add_option(["aspect"],option,addingContents)};
            allData.t_x = {struct('x',{{time}},'y',{{ref(1,:),est(1,:)}}), struct('x','time [s]','y','x [m]'), {'Reference','Estimator'},add_option([],option,addingContents)};
            allData.t_y = {struct('x',{{time}},'y',{{ref(2,:),est(2,:)}}), struct('x','time [s]','y','y [m]'), {'Reference','Estimator'},add_option([],option,addingContents)};
            allData.t_z = { struct('x',{{time}},'y',{{ref(3,:),est(3,:)}}), struct('x','time [s]','y','z [m]'), {'Reference','Estimator'},add_option([],option,addingContents)};
            allData.error = { struct('x',{{time}},'y',{{err}}), struct('x','time [s]','y','error [m]'), {'x','y','z'},add_option([],option,addingContents)};
            allData.input = { struct('x',{{time}},'y',{{inp}}), struct('x','time [s]','y','input [N]'), {'1','2','3','4','dst'},add_option([],option,addingContents)};
            allData.attitude = {struct('x',{{time}},'y',{{att}}), struct('x','time [s]','y','attitude [rad]'), {'roll','pitch','yaw'},add_option([],option,addingContents)};
            allData.velocity = {struct('x',{{time}},'y',{{vel}}), struct('x','time [s]','y','velocity[m/s]'), {'x','y','z'},add_option([],option,addingContents)};
            allData.angular_velocity = { struct('x',{{time}},'y',{{w}}), struct('x','time [s]','y','angular velocity[rad/s]'), {'roll','pitch','yaw'},add_option([],option,addingContents)};
            allData.three_D = {struct('x',{{ref(1,:),est(1,:)}},'y',{{ref(2,:),est(2,:)}},'z',{{ref(3,:),est(3,:)}}), struct('x','x [m]','y','y [m]','z','z [m]'), {'Reference','Estimator'},add_option(["aspect","camposition"],option,addingContents)};
            allData.uHL = { struct('x',{{time}},'y',{{uHL}}), struct('x','time [s]','y','inputHL'), {'z','x','y','yaw'},add_option([],option,addingContents)};
            allData.z1 = {struct('x',{{time}},'y',{{z1}}), struct('x','time [s]','y','z1'), {'z','dz'},add_option([],option,addingContents)};
            allData.z2 = {struct('x',{{time}},'y',{{z2}}), struct('x','time [s]','y','z2'), {'x','dx','ddx','dddx'},add_option([],option,addingContents)};
            allData.z3 = {struct('x',{{time}},'y',{{z3}}), struct('x','time [s]','y','z3'), {'y','dy','ddy','dddy'},add_option([],option,addingContents)};
            allData.z4 = {struct('x',{{time}},'y',{{z4}}), struct('x','time [s]','y','z4'), {'\psi','d\psi'},add_option([],option,addingContents)};
            allData.inner_input = {struct('x',{{time}},'y',{{ininp}}), struct('x','time [s]','y','inner input'), {},add_option([],option,addingContents)};
            allData.vf = {struct('x',{{time}},'y',{{vf}}), struct('x','time [s]','y','vf'), {'zu','dzu','ddzu','dddzu'},add_option([],option,addingContents)};
            allData.sigma = {struct('x',{{time}},'y',{{sigmax,sigmay}}), struct('x','time [s]','y','\sigma'), {'\sigma_x','\sigma_y'},add_option([],option,addingContents)};
else
%             allData.t_p = {struct('x',{{time}},'y',{{ref,est}}), struct('x','time [s]','y','p [m]'), {'x ref','y ref','z ref','x est','y est','z est'},add_option([],option,addingContents)};
            allData.x_y = {struct('x',{{ref1(1,:),est1(1,:),est2(1,:)}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}}), struct('x','x [m]','y','y [m]'), {'Reference',c1,c2},add_option(["aspect"],option,addingContents)};
            allData.t_x = {struct('x',{{time1,time1,time2}},'y',{{ref1(1,:),est1(1,:),est2(1,:)}}), struct('x','time [s]','y','x [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.t_y = {struct('x',{{time1,time1,time2}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}}), struct('x','time [s]','y','y [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.t_z = {struct('x',{{time1,time1,time2}},'y',{{ref1(3,:),est1(3,:),est2(3,:)}}), struct('x','time [s]','y','z [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.error = { struct('x',{{time1,time2}},'y',{{err1,err2}}), struct('x','time [s]','y','error [m]'), {'x '+c1,'y '+c1,'z '+c1,'x '+c2,'y '+c2,'z '+c2},add_option([],option,addingContents)};
            if fExp
                allData.input = { struct('x',{{time1,time2}},'y',{{inp1,inp2}}), struct('x','time [s]','y','input [N]'), {'1 '+c1,'2 '+c1,'3 '+c1,'4 '+c1,'1 '+c2,'2 '+c2,'3 '+c2,'4 '+c2},add_option([],option,addingContents)};
            else
                allData.input = { struct('x',{{time1,time2}},'y',{{inp1,inp2}}), struct('x','time [s]','y','input [N]'), {'1 '+c1,'2 '+c1,'3 '+c1,'4 '+c1,'dst '+c1,'1 '+c2,'2 '+c2,'3 '+c2,'4 '+c2,'dst '+c2},add_option([],option,addingContents)};
            end
            allData.attitude = {struct('x',{{time1,time2}},'y',{{att1,att2}}), struct('x','time [s]','y','attitude [rad]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
            allData.velocity = {struct('x',{{time1,time2}},'y',{{vel1,vel2}}), struct('x','time [s]','y','velocity[m/s]'), {'x '+c1,'y '+c1,'z '+c1,'x '+c2,'y '+c2,'z '+c2},add_option([],option,addingContents)};
            allData.angular_velocity = { struct('x',{{time1,time2}},'y',{{w1,w2}}), struct('x','time [s]','y','angular velocity[rad/s]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
            allData.three_D = {struct('x',{{ref1(1,:),est1(1,:),est2(1,:)}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}},'z',{{ref1(3,:),est1(3,:),est2(3,:)}}), struct('x','x [m]','y','y [m]','z','z [m]'), {'ref', 'est'},add_option(["aspect","camposition"],option,addingContents)};
%             allData.uHL = { struct('x',{{time1,time2}},'y',{{uHL1(2,:),uHL2(2,:)}}), struct('x','time [s]','y','inputHL'), {c1,c2},add_option([],option,addingContents)};
%             allData.z1 = {struct('x',{{time}},'y',{{z1}}), struct('x','time [s]','y','z1'), {'z','dz'},add_option([],option,addingContents)};
%             allData.z2 = {struct('x',{{time}},'y',{{z2}}), struct('x','time [s]','y','z2'), {'x','dx','ddx','dddx'},add_option([],option,addingContents)};
%             allData.z3 = {struct('x',{{time}},'y',{{z3}}), struct('x','time [s]','y','z3'), {'y','dy','ddy','dddy'},add_option([],option,addingContents)};
%             allData.z4 = {struct('x',{{time}},'y',{{z4}}), struct('x','time [s]','y','z4'), {'\psi','d\psi'},add_option([],option,addingContents)};
%             allData.inner_input = {struct('x',{{time}},'y',{{ininp}}), struct('x','time [s]','y','inner input'), {},add_option([],option,addingContents)};
%             allData.vf = {struct('x',{{time}},'y',{{vf}}), struct('x','time [s]','y','vf'), {'zu','dzu','ddzu','dddzu'},add_option([],option,addingContents)};
%             allData.sigma = {struct('x',{{time}},'y',{{sigmax,sigmay}}), struct('x','time [s]','y','\sigma'), {'\sigma_x','\sigma_y'},add_option([],option,addingContents)};
end

%plot
if multiFigure.f == 1 %multiFigure
    for mfn = 1: multiFigure.num
        f(mfn)=figure(mfn);
        tpolt = tiledlayout(multiFigure.layout{1,mfn}(1), multiFigure.layout{1,mfn}(2));
        tpolt.Padding = multiFigure.padding;%'tight'; %'compact';
        tpolt.TileSpacing = multiFigure.tileSpacing;%tight';%  'compact';
            
        for fN = 1:length(nM{mfn}) 
                nexttile
                plot_data_multi(allData.(figName(nM{mfn}(fN))), multiFigure);
        end
        if ~isempty(LSorFT)
            title(tpolt,option.titleName+ multiFigure.title(1,mfn));
            option.titleName = LSorFT;
        end
    end
else %singleFigure
     for fN = 1:length(n) 
          plot_data_single(fN, figName(n(fN)), allData.(figName(n(fN))));
     end
end


%% make folder
%変更しない
%     ExportFolder='C:\Users\Students\Documents\momose';%実験用pcのパス
        ExportFolder='C:\Users\81809\OneDrive\デスクトップ\results';%自分のパス
    DataFig='figure';%データか図か
    date=string(datetime('now','Format','yyyy_MMdd_HHmm'));%日付
    date2=string(datetime('now','Format','yyyy_MMdd'));%日付
    
%変更========================================================
% subfolder='sim';%sim or exp
subfolder='sim';%sim or exp
ExpSimName='FTxyz3';%実験名,シミュレーション名
% contents='FT_apx_max';%実験,シミュレーション内容
contents='FB_90_c';%実験,シミュレーション内容
%==========================================================
FolderNamed=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'data');%保存先のpath
FolderNamef=fullfile(ExportFolder,subfolder,strcat(date2,'_',ExpSimName),'figure');%保存先のpath

%フォルダができてないとき

    mkdir(FolderNamed);
    mkdir(FolderNamef);
    addpath(genpath(ExportFolder));
%フォルダをrmる
%     rmpath(genpath(ExportFolder))
%% save 
nf=length(f);
SaveTitle=strings(1,n);
%保存する図を選ぶ場合[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]

for i=1:length(nf)
    SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',FigName(n(i)));
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
%% functions

    function option = add_option(add,option,contents)
        if ~isempty(add)
            for i = 1:length(add)
                if add(i) == "aspect"
                    option.aspect = contents.aspect;
                elseif add(i) == "camposition"
                    option.camposition = contents.camposition;
                end
            end
        end
    end

    function RMSE = rmse(ref,est)
        RMSE_x=sqrt(immse(ref(1,:),est(1,:)));
        RMSE_y=sqrt(immse(ref(2,:),est(2,:)));
        RMSE_z=sqrt(immse(ref(3,:),est(3,:)));
        RMSE = ["RMSE_x" "RMSE_y" "RMSE_z" ;
                        RMSE_x RMSE_y RMSE_z];
    end

    function plot_data_single(figureNumber, figName, branchData)
        data = branchData{1,1};
        label = branchData{1,2};
        legendLabels = branchData{1,3};
        option = branchData{1,4};
        plotNum = length(data.y);
        if ~isfield(data, 'z')
                f(figureNumber) = figure('Name',figName);
                hold on
                if length(data.x) ~= length(data.y)
                    for i = 1:plotNum 
                        plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                else
                    for i = 1:plotNum 
                        plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                end
                xlabel(label.x)
                ylabel(label.y)
                legend(legendLabels,'NumColumns',option.legendColumns)
                if ~isempty(option.aspect)
                    daspect(option.aspect)
                end
                title(option.titleName)
                set(gca,'FontSize',option.fontSize)
                grid on
                hold off

        else
                f(figureNumber) = figure('Name',figName);
                hold on
                for i = 1:plotNum 
                    plot3(data.x{1,i}, data.y{1,i}, data.z{1,i}, 'LineWidth', option.lineWidth)
                end
                xlabel(label.x)
                ylabel(label.y)
                zlabel(label.z)
                legend(legendLabels,'NumColumns',option.legendColumns)
                daspect(option.aspect)
                campos(option.camposition)
                title(option.titleName)
                set(gca,'FontSize',option.fontSize)
                grid on
                hold off
        end
    end

    function plot_data_multi(branchData, multi)
        data = branchData{1,1};
        label = branchData{1,2};
        legendLabels = branchData{1,3};
        option = branchData{1,4};
        plotNum = length(data.y);
        if ~isfield(data, 'z')
                hold on
                if length(data.x) ~= length(data.y)
                    for i = 1:plotNum 
                        plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                else
                    for i = 1:plotNum 
                        plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth)
                    end
                end
                xlabel(label.x)
                ylabel(label.y)
                legend(legendLabels,'NumColumns',option.legendColumns)
                if ~isempty(option.aspect)
                    daspect(option.aspect)
                end
                set(gca,'FontSize',multi.fontSize)
                pbaspect(multi.pba)  
                grid on
                hold off
        else
                hold on
                for i = 1:plotNum 
                    plot3(data.x{1,i}, data.y{1,i}, data.z{1,i}, 'LineWidth', option.lineWidth)
                end
                xlabel(label.x)
                ylabel(label.y)
                zlabel(label.z)
                legend(legendLabels,'NumColumns',option.legendColumns)
                daspect(option.aspect)
                campos(option.camposition)
                set(gca,'FontSize',multi.fontSize)
                pbaspect(multi.pba)  
                grid on
                hold off
        end
    end

%     function plot_data(figureNumber, figName, branchData, multi)
%         data = branchData{1,1};
%         label = branchData{1,2};
%         legendLabels = branchData{1,3};
%         option = branchData{1,4};
%         plotNum = length(data.y);
%         if ~isfield(data, 'z')
%             if multi.f ~=1
%                 f(figureNumber) = figure('Name',figName);
%             end
%                 hold on
%                 if length(data.x) ~= length(data.y)
%                     for i = 1:plotNum 
%                         plot(data.x{1}, data.y{1,i}, 'LineWidth', option.lineWidth)
%                     end
%                 else
%                     for i = 1:plotNum 
%                         plot(data.x{1,i}, data.y{1,i}, 'LineWidth', option.lineWidth)
%                     end
%                 end
%                 xlabel(label.x)
%                 ylabel(label.y)
%                 legend(legendLabels,'NumColumns',option.legendColumns)
%                 if ~isempty(option.aspect)
%                     daspect(option.aspect)
%                 end
%                 if multi.f ==1
%                     set(gca,'FontSize',multi.fontSize)
%                     pbaspect(multi.pba)  
%                 else
%                     title(option.titleName)
%                     set(gca,'FontSize',option.fontSize)
%                 end
%                 grid on
%                 hold off
% 
%         else
%                 if multi.f  ~=1
%                     f(figureNumber) = figure('Name',figName);
%                 end
%                 hold on
%                 for i = 1:plotNum 
%                     plot3(data.x{1,i}, data.y{1,i}, data.z{1,i}, 'LineWidth', option.lineWidth)
%                 end
%                 xlabel(label.x)
%                 ylabel(label.y)
%                 zlabel(label.z)
%                 legend(legendLabels,'NumColumns',option.legendColumns)
%                 daspect(option.aspect)
%                 campos(option.camposition)
%                 if multi.f ==1
%                     set(gca,'FontSize',multi.fontSize)
%                     pbaspect(multi.pba)  
%                 else
%                     title(option.titleName)
%                     set(gca,'FontSize',option.fontSize)
%                 end
%                 grid on
%                 hold off
%         end
%     end
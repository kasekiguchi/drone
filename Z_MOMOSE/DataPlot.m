%%　DataPlot
%pos = cell2mat(logger.Data.agent.sigma(1,:)'); %cell2matでcell配列を行列に変換，:,1が列全選択
close all
%% --------------ここのセクションだけを実行
%import
%選択
fExp=10;%実験のデータかどうか
fLogN=2;%loggerの数が一つの時１ 2つの時:2, other:3
fLSorFT=3;%LS:1,FT:2,No:>=3
fMul =10;%複数まとめるかレーダーチャートの時は無視される
fspider=10;%レーダーチャート1
fF=1;%flightのみは１

%どの時間の範囲を描画するか指定
% startTime = 5;
% endTime = 20;
startTime = 5;
endTime = 1E2;
%========================================================================
%図を選ぶ[1:"t_p" 2:"x_y" 3:"t_x" 4:"t_y" 5:"t_z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 
%              11:"three_D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma" 20:"plant"]
%========================================================================
if fLogN == 1
    name = logger;
%     name = logger_FT_lxy10;
% name = logger_FB2_mass_saddle;
%     name = logger_FTxyz2_mass_saddle;

%     name = logger_FB_codin0;
%     name =logger_FT_c_09;
%     name =logger_HL_c;
% name = logger_ls_mss_n01_dir;%LS
% name = logger_ls_mss_n01;%LS
% name = logger_ls_lx_001;%LS 
% name = logger_ls_lx_001_dire;%LS 
% name = logger_ls_km1xyz_n0025;%LS direcotでやってみる
% name = logger_ls_km1xyz_1;%LS direcotでやってみる
% name = logger_ls_km2z_1;
% name = logger_ls_km2z_n0025;
% name = logger_ls_km1z_0025;
% name = logger_ls_km1z_1;

% name = logger_ls_km2_1;
% name = logger_ls_km2_n0025;
% name = logger_ls_km1_n0025;
% name = logger_ls_km1_1;
% name = logger_ls_jz_n003;

%chuse figure
%     n = 11;
    n = [1,5,8,10,7, 12:16,20:23];
%     n=20:23;
elseif fLogN==2

    name1 = logger_proba_LS;%LS
    name2 = logger_proba_FT;%FT
%     name1 = logger_saddle2_LS;%LS
%     name2 = logger_saddle2_FT;%FT

%     name1 = logger_LS_jxy50;
% name2=logger_FT_jxy50;
% name1=logger_LS_massn40;
% name2=logger_LS_mass40;

%simration of approximation
% name1 = logger_app_circl_1_alp09;
%     name2 = logger_FT_circl_1_alp09;
%     name1 = logger_AFT_model_alp09;
%     name2 = logger_FT_model_alp09;
%     name1 = logger_AFT_dst_alp09;
%     name2 = logger_FT_dst_alp09;
%     name1 = logger_AFT_prob_alp09;
%     name2 = logger_FT_prob_alp09;
%----------------------------------------
%     name1 = logger_LS;
%     name2 = logger_FT2;
%-----------------------------------------
% name1 = logger_lsjx002;%LS
%     name2 = logger_ftjx002;%FT
%     name1 = logger_ls_jx_n001;%LS
%     name2 = logger_ft_jx_n001;%FT
%     name1 = logger_ls_jy_n001;%LS
%     name2 = logger_ft_jy_n001;%FT
%     name1 = logger_ls_jy_002;%LS
%     name2 = logger_ft_jy_002;%FT
%     name1 = logger_ls_jy_003;%LS
%     name2 = logger_ft_jy_003;%FT
%     name1 = logger_ls_lx_001_dire;%LS    
%     name2 = logger_ft_lx_001_dire;%FT
%     name1 = logger_ls_lx_001;%LS    
%     name2 = logger_ft_lx_001;%FT
%     name1 = logger_ls_ly_001;%LS
%     name2 = logger_ft_ly_001;%FT
%     name1 = logger_ls_mss_01;%LS
%     name2 = logger_ft_mss_01;%FT
%     name1 = logger_ls_mss_n01;%LS
%     name2 = logger_ft_mss_n01;%FT
%     name1 = logger_ls_mss_n01_dir;%LS
%     name2 = logger_ft_mss_n01_dir;%FT

%chuse figure
    n = 2:12;%比較
%     n = 2:10;
%     n = [2:5 19];
    c1="Linear state FB";
c2="Finit time settling";
    c1="LS";
    c2="FT";
    comp=[c1,c2];%     comp = struct('c1',' Linear state FB','c2',' Finit time settling');
else
    loggers = {
%         logger,...
%         logger_ft_lx_001,...
%         logger_ls_lx_001,...
%         logger_ft_ly_001,...
%         logger_ls_ly_001,...
%         logger_ls_saddle
%         logger_ft_saddle
%         logger_LS_lxy10,...
%         logger_FT_lxy10,...
%         logger_LS_lxy30,...
%         logger_FT_lxy30,...
%         logger_LS_lxy50,...
%         logger_FT_lxy50,...
%         logger_LS_lxy100,...
%         logger_FT_lxy100,...
% logger_LS_massn10,...
% logger_FT_massn10,...
% logger_LS_massn30,...
% logger_FT_massn30,...
% logger_LS_massn40,...
% logger_FT_massn40,...
% logger_LS_mass40,...
% logger_FT_mass40,...
% logger_LS_massn50,...
% logger_FT_massn50,...
%Jxyz
% logger_LS_jxyn70,...
% logger_FT_jxyn70,...
% logger_LS_jxy50,...
% logger_FT_jxy50,...
% logger_LS_jxy150,...
% logger_FT_jxy150,...
% logger_LS_jzn85,...
% logger_LS_jz50,...
% logger_LS_jz150,...
% logger_LS_jz300,...
logger_LS_km1_n50,...
logger_LS_km1_500,...
logger_LS_km1_1000,...
logger_LS_km1_1500,...
        };
    c=[
%         "lxFinit time settling",...
%         "lxLinear state FB",...
%         "lyFinit time settling",...
%         "lyLinear state FB"
%         "Linear state FB001",...
%         "Finit time settling001",...
% COG
%         "LS 10\%",...
%         "FT 10\%",...
%         "LS 30\%",...
%         "FT 30\%",...
%         "LS 50\%",...
%         "FT 50\%",...
%         "LS 100\%",...
%         "FT 100\%",...
%mass
%         "FS 90\%",...
%         "FT 90\%",...
%         "FS 70\%",...
%         "FT 70\%",...
%         "FS 60\%",...
%         "FT 60\%",...
%jxyz
%         "FS 30\%",...
%         "FT 30\%",...
%         "FS 150\%",...
%         "FT 150\%",...
%         "FS 250\%",...
%         "FT 250\%",...
        "FS 50\%",...
        "FS 600\%",...
        "FS 1100\%",...
        "FS 1600\%",...
%         "Linear state FBm40",...
%         "Finit time settlingm40",...
%         "Linear state FBmn50",...
%         "Finit time settlingmn540",...
%         "Linear state FBmn10",...
%         "Finit time settling mn10",...
%         "Linear state FBmn30",...
%         "Finit time settlingmn30",...
%         "Linear state FBj50",...
%         "Finit time settlingj50",...
%         "Linear state FBj100",...
%         "Finit time settlingj100",...
%         "Linear state FBj150",...
%         "Finit time settlingj150",...
        ];

%     c ={c1,c2,c3,c4};
     n = [2:11];

     %今だけ
     c1="Linear state FB";
    c2="Finit time settling";
end

% multiFigure
% nM = {[1,9,8,10,7],[13,14,15,16,12]};%複数まとめる
nM = {[3:5 6 2 11],[9,8,10,7,12,18],13:16,[1,8,9,10]};%複数まとめる
multiFigure.num = length(nM);%figの数
multiFigure.title = [" state1", " state2 and input", " subsystem",""];%[" state", " subsystem"];%title name
multiFigure.layout = {[2,3],[2,3],[2,2],[2,2]};%{[2,3],[2,3]}%figureの配置場所
multiFigure.fontSize = 14;
multiFigure.pba = [1,0.78084714548803,0.78084714548803];%各図の縦横比
multiFigure.padding = 'tight';
multiFigure.tileSpacing = 'tight';
multiFigure.f = fMul;

option.lineWidth = 2;%linewidth
option.fontSize = 18;%デフォルト9，フォントサイズ変更
option.legendColumns = 2;
option.aspect = [];
option.camposition = [];
option.fExp = fExp;

%タイトルの名前を付ける
if fLSorFT==1 && fLogN ==1
        option.titleName="LS";
elseif fLSorFT==2 && fLogN ==1
        option.titleName="FT";
elseif fLogN~=1 || fLSorFT>2
        option.titleName=[];
end
LSorFT = option.titleName;
%figごとに追加する場合のもの
addingContents.aspect = [1,1,1];
addingContents.camposition = [-45,-45,60];

%==================================================================================
clear t ti k spanIndex tt flightSpan time ref est err inp att vel w uHL z1 z2 z3 z4
% 単体
if fLogN==1
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
%         pltp(:,j) = name.Data.agent.plant.result{1,i}.state.p(1:3);
%         pltv(:,j) = name.Data.agent.plant.result{1,i}.state.v(1:3);
%         pltq(:,j) = name.Data.agent.plant.result{1,i}.state.q(1:3);
%         pltw(:,j) = name.Data.agent.plant.result{1,i}.state.w(1:3);
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

%         if fExp==1
%             ininp(:,j)=name.Data.agent.inner_input{1, i};
%         end
%         vf(:,j)=name.Data.agent.controller.result{1, i}.vf';
%         if ismember(19,n)
%             sigmax(:,j)=name.Data.agent.controller.result{1, i}.sigmax;
%             sigmay(:,j)=name.Data.agent.controller.result{1, i}.sigmay;
%         end
        j=j+1;
    end
elseif fLogN == 2
    
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
    % if fExp ==1
        inp1=zeros(4,n1);
        inp2=zeros(4,n2);
    % else
    %     inp1=zeros(4,n1);
    %     inp2=zeros(4,n2);
    % end
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
        inp1(:,j)=name1.Data.agent.input{1,i}(1:4);
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
        inp2(:,j)=name2.Data.agent.input{1,i}(1:4);
        att2(:,j)=name2.Data.agent.estimator.result{1,i}.state.q(1:3);
        vel2(:,j)=name2.Data.agent.estimator.result{1,i}.state.v(1:3);
        w2(:,j)=name2.Data.agent.estimator.result{1,i}.state.w(1:3);
%         uHL2(:,j)=name2.Data.agent.controller.result{1, i}.uHL;
        j=j+1;
    end
    %figureは何個でもいい========================================================
else
%%%%%%%%%%%%%%%%%%%%これに行こう===============================
    if fF==1
        logNum = length(loggers);
        for i = 1:logNum
            t{i} = loggers{i}.Data.t';
            k(i)=loggers{i}.k;
            ti{i}=t{i}(1:k(i));
            kf(i)=find(loggers{i}.Data.phase == 102,1,'first')+1;
            ke(i)=find(loggers{i}.Data.phase == 102,1,'last');
    
            sTime(i) = ti{i}(kf(i)) + startTime;
            eTime(i) = ti{i}(kf(i)) + endTime;
            ti{i} = ti{i}(1:ke(i));
            spanIndex{i} = find(ti{i} <= eTime(i) & ti{i} >= sTime(i) );
            kf(i) = min(spanIndex{i});
            ke(i) = max(spanIndex{i});
    
            tt(i)=ti{i}(kf(i));
            flightSpan(i)=ke(i)-kf(i);
        end
        %表示する時間を最小のものに合わせる
        minSpan = min(flightSpan);
        for i = 1:logNum
            ke(i) = kf(i) + minSpan;
        end
    else 
        logNum = length(loggers);
       for i = 1:logNum
            t{i} = loggers{i}.Data.t';
            k(i)=loggers{i}.k;
            ti{i}=t{i}(1:k(i));
            sTime(i) = ti{i}(1) + startTime;
            eTime(i) = ti{i}(1) + endTime;
            spanIndex{i} = find(ti{i} <= eTime(i) & ti{i} >= sTime(i) );
            kf(i) = min(spanIndex{i});
            ke(i) = max(spanIndex{i});
            tt(i)=1;
       end
    end
        
    for i = 1:logNum
        lt(i)=ke(i)-kf(i);
        time{i}=zeros(1,lt(i));
        ref{i}=zeros(3,lt(i));
        est{i}=zeros(3,lt(i));
        err{i}=zeros(3,lt(i));
        
        if fExp ==1
            inp{i}=zeros(4,lt(i));
        else
            inp{i}=zeros(5,lt(i));
        end
        att{i}=zeros(3,lt(i));
        vel{i}=zeros(3,lt(i));
        w{i}=zeros(3,lt(i));
        uHL{i}=zeros(4,lt(i));
        z1{i}=zeros(2,lt(i));
        z2{i}=zeros(4,lt(i));
        z3{i}=zeros(4,lt(i));
        z4{i}=zeros(2,lt(i));
        j=1;
        for i2=kf(i):1:ke(i)
            time{i}(j)=ti{i}(i2)-tt(i);
            ref{i}(:,j)=loggers{i}.Data.agent.reference.result{1,i2}.state.p(1:3);
            est{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.p(1:3);
            err{i}(:,j)=est{i}(:,j)-ref{i}(:,j);%誤差        
            inp{i}(:,j)=loggers{i}.Data.agent.input{1,i2};
            att{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.q(1:3);
            vel{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.v(1:3);
            w{i}(:,j)=loggers{i}.Data.agent.estimator.result{1,i2}.state.w(1:3);
            uHL{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.uHL;
            z1{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z1;
            z2{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z2;
            z3{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z3;
            z4{i}(:,j)=loggers{i}.Data.agent.controller.result{1, i2}.z4;
            j=j+1;
        end
    end
end

%二乗誤差平均
% if fLogN ==1
%      RMSE = rmse(ref,est)
% %      fprintf('#%d RMSE_x    RMSE_y   RMSE_z \n',i);
% %         RMSE(i,1:3) = rmse(ref{1,i},est{1,i});
% %         fprintf('       %.4f    %.4f    %.4f \n',RMSE(i,1:3))
% elseif  fLogN == 2
%     RMSE_LS = rmse(ref1,est1)
%     RMSE_FT = rmse(ref2,est2)
% else
%     if isempty(c)
%         c = string(1:logNum);
%     end
%     RMSElog(1,1:13) = ["RMSE","x","y","z","vx","vy","vz","roll","pitch","yaw","wroll","wpitch","wyaw"];
%     RMSE = zeros(logNum,12);
%         for i =1:logNum
%             refs = zeros(3,k(i)-1);%kはtimeの長さ
%             RMSE(i,1:12) = [rmse(ref{1,i},est{1,i}),rmse(refs,vel{1,i}),rmse(refs,att{1,i}),rmse(refs,w{1,i})];
%             RMSElog(i+1,1:13) = [c(i),RMSE(i,1:12)];
%             fprintf('#%s RMSE\n',c(i));
%             fprintf('  x\t y\t z\t | vx\t vy\t vz\t| roll\t pitch\t yaw\t | wroll\t wpitch\t wyaw \n');
%             fprintf('  %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f |    %.4f    %.4f    %.4f \n',RMSElog(i+1,2:13));
%            
%         end
% end

% figure
%図:[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
figName=["t_p" "x_y" "t_x" "t_y" "t_z" "error" "input" "attitude" "velocity" "angular_velocity" "three_D" "uHL" "z1" "z2" "z3" "z4" "inner_input" "vf" "sigma" "pp" "pv" "pq" "pw"];
% allData.figName : (data, label, legendLabels, option)   
%option : titleName, lineWidth, fontSize, legend, aspect, campositon
%=====================================================
% allData.example = {struct('x',{{time1,time2}},'y',{{data1,data2,data3}}),...
%                                 struct('x','xlabel [dim]','y','ylabel [dim]','z','zlabel [dim]'),...
%                                 {'$xleg$','$yleg$','$zleg$'},...
%                                 add_option(["aspect","camposition"],option,addingContents)};
%=====================================================
if fLogN==1
            allData.t_p = {struct('x',{{time}},'y',{{ref,est}}), struct('x','time [s]','y','position [m]'), {'$x$ Refence','$y$ Refence','$z$ Refence','$x$ estimator','$y$ estimator','$z$ estimator'},add_option([],option,addingContents)};
            allData.x_y = {struct('x',{{ref(1,:),est(1,:)}},'y',{{ref(2,:),est(2,:)}}), struct('x','$x$ [m]','y','$y$ [m]'), {'Reference','Estimator'},add_option(["aspect"],option,addingContents)};
            allData.t_x = {struct('x',{{time}},'y',{{ref(1,:),est(1,:)}}), struct('x','time [s]','y','$x$ [m]'), {'Reference','Estimator'},add_option([],option,addingContents)};
            allData.t_y = {struct('x',{{time}},'y',{{ref(2,:),est(2,:)}}), struct('x','time [s]','y','$y$ [m]'), {'Reference','Estimator'},add_option([],option,addingContents)};
            allData.t_z = { struct('x',{{time}},'y',{{ref(3,:),est(3,:)}}), struct('x','time [s]','y','$z$ [m]'), {'Reference','Estimator'},add_option([],option,addingContents)};
            allData.error = { struct('x',{{time}},'y',{{err}}), struct('x','time [s]','y','error [m]'), {'$x$','$y$','$z$'},add_option([],option,addingContents)};
            allData.input = { struct('x',{{time}},'y',{{inp}}), struct('x','time [s]','y','input [N]'), {'1','2','3','4','dst'},add_option([],option,addingContents)};
            allData.attitude = {struct('x',{{time}},'y',{{att}}), struct('x','time [s]','y','attitude [rad]'), {'roll','pitch','yaw'},add_option([],option,addingContents)};
            allData.velocity = {struct('x',{{time}},'y',{{vel}}), struct('x','time [s]','y','velocity[m/s]'), {'$x$','$y$','$z$'},add_option([],option,addingContents)};
            allData.angular_velocity = { struct('x',{{time}},'y',{{w}}), struct('x','time [s]','y','angular velocity[rad/s]'), {'roll','pitch','yaw'},add_option([],option,addingContents)};
            allData.three_D = {struct('x',{{ref(1,:),est(1,:)}},'y',{{ref(2,:),est(2,:)}},'z',{{ref(3,:),est(3,:)}}), struct('x','$x$ [m]','y','$y$ [m]','z','$z$ [m]'), {'Reference','Estimator'},add_option(["aspect","camposition"],option,addingContents)};
            allData.uHL = { struct('x',{{time}},'y',{{uHL}}), struct('x','time [s]','y','inputHL'), {'z','x','y','yaw'},add_option([],option,addingContents)};
            allData.z1 = {struct('x',{{time}},'y',{{z1}}), struct('x','time [s]','y','z1'), {'z','dz'},add_option([],option,addingContents)};
            allData.z2 = {struct('x',{{time}},'y',{{z2}}), struct('x','time [s]','y','z2'), {'x','dx','ddx','dddx'},add_option([],option,addingContents)};
            allData.z3 = {struct('x',{{time}},'y',{{z3}}), struct('x','time [s]','y','z3'), {'y','dy','ddy','dddy'},add_option([],option,addingContents)};
            allData.z4 = {struct('x',{{time}},'y',{{z4}}), struct('x','time [s]','y','z4'), {'$\psi$','d$\psi$'},add_option([],option,addingContents)};
            allData.inner_input = {struct('x',{{time}},'y',{{ininp}}), struct('x','time [s]','y','inner input'), {},add_option([],option,addingContents)};
            allData.vf = {struct('x',{{time}},'y',{{vf}}), struct('x','time [s]','y','vf'), {'zu','dzu','ddzu','dddzu'},add_option([],option,addingContents)};
            allData.sigma = {struct('x',{{time}},'y',{{sigmax,sigmay}}), struct('x','time [s]','y','$\sigma$'), {'$\sigma_x$','$\sigma_y$'},add_option([],option,addingContents)};
%             allData.plant = {struct('x',{{time}},'y',{{plt}}), struct('x','time [s]','y','plant [m]'), {'Plant x','Plant y','Plant z'},add_option([],option,addingContents)};
%             allData.pp = {struct('x',{{time}},'y',{{est,pltp}}), struct('x','time [s]','y','p[m]'), {'x est','y est','z est','x plant','y plant','z plant'},add_option([],option,addingContents)};
%             allData.pv = {struct('x',{{time}},'y',{{vel,pltv}}), struct('x','time [s]','y','v[m/s]'), {'x est','y est','z est','x plant','y plant','z plant'},add_option([],option,addingContents)};
%             allData.pq = {struct('x',{{time}},'y',{{att,pltq}}), struct('x','time [s]','y','q[rad]'), {'roll est','pitch est','yaw est','roll plant','pitch plant','yaw plant'},add_option([],option,addingContents)};
%             allData.pw = {struct('x',{{time}},'y',{{w,pltw}}), struct('x','time [s]','y','w[rad/s]'), {'roll est','pitch est','yaw est','roll plant','pitch plant','yaw plant'},add_option([],option,addingContents)};
allData.attitude = {struct('x',{{time}},'y',{{att,w}}), struct('x','time [s]','y','attitude [rad]'), {'roll ','pitch ','yaw ','roll ','pitch ','yaw '},add_option([],option,addingContents)};
elseif fLogN == 2
%             allData.t_p = {struct('x',{{time}},'y',{{ref,est}}), struct('x','time [s]','y','p [m]'), {'x ref','y ref','z ref','x est','y est','z est'},add_option([],option,addingContents)};
% allData.x_y = {struct('x',{{ref1(1,:),est1(1,:),est2(1,:)}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}}), struct('x','$x$ [m]','y','$y$ [m]'), {'Reference',c1,c2},add_option(["aspect"],option,addingContents)};
            allData.x_y = {struct('x',{{ref1(1,:),est1(1,:),est2(1,:)}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}}), struct('x','$x$ [m]','y','$y$ [m]'), {'Reference',c1,c2},add_option(["aspect"],option,addingContents)};
            allData.t_x = {struct('x',{{time1,time1,time2}},'y',{{ref1(1,:),est1(1,:),est2(1,:)}}), struct('x','time [s]','y','$x$ [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.t_y = {struct('x',{{time1,time1,time2}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}}), struct('x','time [s]','y','$y$ [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.t_z = {struct('x',{{time1,time1,time2}},'y',{{ref1(3,:),est1(3,:),est2(3,:)}}), struct('x','time [s]','y','$z$ [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.error = { struct('x',{{time1,time2}},'y',{{err1,err2}}), struct('x','time [s]','y','error [m]'), {'x '+c1,'y '+c1,'z '+c1,'x '+c2,'y '+c2,'z '+c2},add_option([],option,addingContents)};
            if fExp ==1
                allData.input = { struct('x',{{time1,time2}},'y',{{inp1,inp2}}), struct('x','time [s]','y','input [N]'), {'1 '+c1,'2 '+c1,'3 '+c1,'4 '+c1,'1 '+c2,'2 '+c2,'3 '+c2,'4 '+c2},add_option([],option,addingContents)};
            else
                allData.input = { struct('x',{{time1,time2}},'y',{{inp1,inp2}}), struct('x','time [s]','y','input [N]'), {'1 '+c1,'2 '+c1,'3 '+c1,'4 '+c1,'dst '+c1,'1 '+c2,'2 '+c2,'3 '+c2,'4 '+c2,'dst '+c2},add_option([],option,addingContents)};
            end
            allData.attitude = {struct('x',{{time1,time2}},'y',{{att1,att2}}), struct('x','time [s]','y','attitude [rad]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
            allData.velocity = {struct('x',{{time1,time2}},'y',{{vel1,vel2}}), struct('x','time [s]','y','velocity[m/s]'), {'x '+c1,'y '+c1,'z '+c1,'x '+c2,'y '+c2,'z '+c2},add_option([],option,addingContents)};
            allData.angular_velocity = { struct('x',{{time1,time2}},'y',{{w1,w2}}), struct('x','time [s]','y','angular velocity[rad/s]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
            allData.three_D = {struct('x',{{ref1(1,:),est1(1,:),est2(1,:)}},'y',{{ref1(2,:),est1(2,:),est2(2,:)}},'z',{{ref1(3,:),est1(3,:),est2(3,:)}}), struct('x','$x$ [m]','y','$y$ [m]','z','$z$ [m]'), {'ref',c1, c2},add_option(["aspect","camposition"],option,addingContents)};
%             allData.uHL = { struct('x',{{time1,time2}},'y',{{uHL1(2,:),uHL2(2,:)}}), struct('x','time [s]','y','inputHL'), {c1,c2},add_option([],option,addingContents)};
%             allData.z1 = {struct('x',{{time}},'y',{{z1}}), struct('x','time [s]','y','z1'), {'z','dz'},add_option([],option,addingContents)};
%             allData.z2 = {struct('x',{{time}},'y',{{z2}}), struct('x','time [s]','y','z2'), {'x','dx','ddx','dddx'},add_option([],option,addingContents)};
%             allData.z3 = {struct('x',{{time}},'y',{{z3}}), struct('x','time [s]','y','z3'), {'y','dy','ddy','dddy'},add_option([],option,addingContents)};
%             allData.z4 = {struct('x',{{time}},'y',{{z4}}), struct('x','time [s]','y','z4'), {'\psi','d\psi'},add_option([],option,addingContents)};
%             allData.inner_input = {struct('x',{{time}},'y',{{ininp}}), struct('x','time [s]','y','inner input'), {},add_option([],option,addingContents)};
%             allData.vf = {struct('x',{{time}},'y',{{vf}}), struct('x','time [s]','y','vf'), {'zu','dzu','ddzu','dddzu'},add_option([],option,addingContents)};
%             allData.sigma = {struct('x',{{time}},'y',{{sigmax,sigmay}}), struct('x','time [s]','y','\sigma'), {'\sigma_x','\sigma_y'},add_option([],option,addingContents)};
% allData.attitude = {struct('x',{time},'y',{[att,w]}), struct('x','time [s]','y','attitude [rad]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
else
                refx = ref{1}(1,:);
                refy = ref{1}(2,:);
                refz = ref{1}(3,:);
            for i = 1:logNum
                estx{i} = est{i}(1,:);
                esty{i} = est{i}(2,:);
                estz{i} = est{i}(3,:);
            end
            allData.t_p = {struct('x',{[time{1},time]},'y',{{ref,est}}), struct('x','time [s]','y','position [m]'), {'$x$ Refence','$y$ Refence','$z$ Refence','$x$ estimator','$y$ estimator','$z$ estimator'},add_option([],option,addingContents)};
            allData.x_y = {struct('x',{[refx,estx]},'y',{[refy,esty]}), struct('x','$x$ [m]','y','$y$ [m]'), {'Reference',c1,c2},add_option(["aspect"],option,addingContents)};
            allData.t_x = {struct('x',{[time{1},time]},'y',{[refx,estx]}), struct('x','time [s]','y','$x$ [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.t_y = {struct('x',{[time{1},time]},'y',{[refy,esty]}), struct('x','time [s]','y','$y$ [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.t_z = {struct('x',{[time{1},time]},'y',{[refz,estz]}), struct('x','time [s]','y','$z$ [m]'), {'Reference',c1,c2},add_option([],option,addingContents)};
            allData.error = { struct('x',{time},'y',{err}), struct('x','time [s]','y','error [m]'), {'x '+c1,'y '+c1,'z '+c1,'x '+c2,'y '+c2,'z '+c2},add_option([],option,addingContents)};
            if fExp ==1
                allData.input = { struct('x',{time},'y',{inp}), struct('x','time [s]','y','input [N]'), {'1 '+c1,'2 '+c1,'3 '+c1,'4 '+c1,'1 '+c2,'2 '+c2,'3 '+c2,'4 '+c2},add_option([],option,addingContents)};
            else
                allData.input = { struct('x',{time},'y',{inp}), struct('x','time [s]','y','input [N]'), {'1 '+c1,'2 '+c1,'3 '+c1,'4 '+c1,'dst '+c1,'1 '+c2,'2 '+c2,'3 '+c2,'4 '+c2,'dst '+c2},add_option([],option,addingContents)};
            end
            allData.attitude = {struct('x',{time},'y',{att}), struct('x','time [s]','y','attitude [rad]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
%             allData.attitude = {struct('x',{time},'y',{[att,w]}), struct('x','time [s]','y','attitude [rad]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
            allData.velocity = {struct('x',{time},'y',{vel}), struct('x','time [s]','y','velocity[m/s]'), {'x '+c1,'y '+c1,'z '+c1,'x '+c2,'y '+c2,'z '+c2},add_option([],option,addingContents)};
            allData.angular_velocity = { struct('x',{time},'y',{w}), struct('x','time [s]','y','angular velocity[rad/s]'), {'roll '+c1,'pitch '+c1,'yaw '+c1,'roll '+c2,'pitch '+c2,'yaw '+c2},add_option([],option,addingContents)};
            allData.three_D = {struct('x',{[refx,estx]},'y',{[refy,esty]},'z',{[refz,estz]}), struct('x','$x$ [m]','y','$y$ [m]','z','$z$ [m]'), {'ref', 'est'},add_option(["aspect","camposition"],option,addingContents)};
%             allData.uHL = { struct('x',{time},'y',{{uHL1(2,:),uHL2(2,:)}}), struct('x','time [s]','y','inputHL'), {c1,c2},add_option([],option,addingContents)};
            allData.uHL = { struct('x',{time},'y',{uHL}), struct('x','time [s]','y','inputHL'), {c1,c2},add_option([],option,addingContents)};
            allData.z1 = {struct('x',{time},'y',{z1}), struct('x','time [s]','y','z1'), {'z','dz'},add_option([],option,addingContents)};
            allData.z2 = {struct('x',{time},'y',{z2}), struct('x','time [s]','y','z2'), {'x','dx','ddx','dddx'},add_option([],option,addingContents)};
            allData.z3 = {struct('x',{time},'y',{z3}), struct('x','time [s]','y','z3'), {'y','dy','ddy','dddy'},add_option([],option,addingContents)};
            allData.z4 = {struct('x',{time},'y',{z4}), struct('x','time [s]','y','z4'), {'\psi','d\psi'},add_option([],option,addingContents)};

end

%plot
if multiFigure.f == 1 && fspider ~=1%multiFigure
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
elseif multiFigure.f ~= 1&&fspider ~=1 %singleFigure
     for fN = 1:length(n) 
         f(fN)  = figure('Name',figName(n(fN)));
          plot_data_single(fN, figName(n(fN)), allData.(figName(n(fN))));
     end
elseif fspider ==1
    %x,dx,ddx,dddx,rmse
    %ang(roll pitch yaw),angver(roll pitch yaw)
    %inp:x,dx,ddx,dddxに加えられたとき
    figName = ["subsystem_x","angle_angleVel","angle_vel","err_RMSE","p","velocity","p_vel","subsystem_y","uHL","input","qw_RMSE","pv_RMSE"];%%
%     figName = ["angle_angleVel","angle_vel","pv","input","qw_RMSE","pv_RMSE"];%%
    %legend
    AL={{'$x$', '$dx$', '$ddx$', '$dddx$'},...
         {'$\theta_{roll}$ [rad]', '$\theta_{pitch}$ [rad]', '$\theta_{yaw}$ [rad]','$w_{roll}$ [rad/s]', '$w_{pitch}$ [rad/s]', '$w_{yaw}$ [rad/s]'},...
         {'$w_{roll}$ [rad/s]', '$w_{pitch}$ [rad/s]', '$w_{yaw}$ [rad/s]'},...
         {'$error_x$ [m]','$error_y$ [m]','$error_z$ [m]','$x$ RMSE [m]','$y$ RMSE [m]','$z$ RMSE [m]'},...
         {'$x$ [m]','$y$ [m]','$z$ [m]'}, ...
         {'$v_x$ [m/s]','$v_y$ [m/s]','$v_z$ [m/s]'}, ...
         {'$x$ [m]','$y$ [m]','$z$ [m]','$v_x$ [m/s]','$v_y$ [m/s]','$v_z$ [m/s]'},...
         {'$y$', '$dy$', '$ddy$', '$dddy$'},...
         {'$z$', '$x$', '$y$', '$yaw$'},...
         {'rotor$1$ [N]', 'rotor$2$ [N]', 'rotor$3$ [N]', 'rotor$4$ [N]'},...
         {'$\theta_{roll}$  [rad]','$\theta_{pitch}$  [rad]','$\theta_{yaw}$  [rad]'},...%          {'$\theta_{roll}$  [rad]','$\theta_{pitch}$  [rad]','$\theta_{yaw}$  [rad]','$w_{roll}$  [rad/s]','$w_{pitch}$  [rad/s]','$w_{yaw}$  [rad/s]'},...
         {'$x$  [m]','$y$  [m]','$z$  [m]'}};%{'$x$  [m]','$y$  [m]','$z$  [m]','$v_x$  [m/s]','$v_y$  [m/s]','$v_z$  [m/s]'}
    legend_str = c;
    lengthFN=length(figName);
    P =cell(1,lengthFN);
    D = cell(1,lengthFN);
     for i = 1:logNum
        D{1} = [z2{i}(1,end),z2{i}(2,end),z2{i}(3,end),z2{i}(4,end)];
        D{2} = [att{i}(1:3,end)',w{i}(1:3,end)'];
        D{3} = w{i}(1:3,end)';
        D{4} = [err{i}(1:3,end)',RMSE(i,1:3)];
        D{5} = est{i}(1:3,end)';
        D{6} = vel{i}(1:3,end)';
        D{7} = [est{i}(1:3,end)',vel{i}(1:3,end)'];
        D{8} = [z3{i}(1,end),z3{i}(2,end),z3{i}(3,end),z3{i}(4,end)];
        D{9} = uHL{i}(1:4,end)';
        D{10} = inp{i}(1:4,end)';
        D{11} = RMSE(i,7:9);%7:12
        D{12} = RMSE(i,1:3);%1:3
         for nFN = 1:lengthFN
            P{nFN} = abs([P{nFN}; D{nFN}]);
         end
     end
        nFN = 1;
        for nFN = 1:lengthFN
           ALmax(nFN) = max(max(P{nFN},[],2));
%            ALmin(nFN) = min(min(P{nFN},[],2));
           ALmin(nFN) = 0;
        end

     for fN = 1:lengthFN
            lAL = length(AL{fN});
            f(fN)  = figure('Name',figName(fN));
            axes_precision = 2;
            FS=26;
            if ALmax(fN)>0.1
                spider_plot(P{fN},...
                    'AxesLabels', AL{fN},...
                    'AxesInterval', 4,...
                    'AxesDisplay', 'one',...
                    'AxesLimits', [ALmin(fN)*ones(1,lAL); ALmax(fN)*ones(1,lAL)],...
                    'AxesInterpreter','latex',...
                    'AxesPrecision', axes_precision,...
                    'FillOption', 'on',...
                    'FillTransparency',0.1, ...
                    'LineWidth', 3,...
                    'AxesFontSize', FS,...
                    'LabelFontSize', FS,...
                    'AxesLabelsOffset', 0.24,...
                    'BackgroundColor','white',...
                    'AxesLabelsEdge', 'none',...
                    'MaxUnderEn1',0);
            else
                 spider_plot(P{fN},...
                    'AxesLabels', AL{fN},...
                    'AxesInterval', 4,...
                    'AxesDisplay', 'one',...
                    'AxesLimits', [ALmin(fN)*ones(1,lAL); ALmax(fN)*ones(1,lAL)],...
                    'AxesInterpreter','latex',...
                    'AxesPrecision', 1,...
                    'FillOption', 'on',...
                    'FillTransparency',0.1, ...
                    'LineWidth', 3,...
                    'AxesFontSize', FS,...
                    'LabelFontSize', FS,...
                    'AxesLabelsOffset', 0.24,...
                    'BackgroundColor','white',...
                    'AxesLabelsEdge', 'none',...
                    'MaxUnderEn1',1);
            end
%             'AxesDisplay', 'data'
%             legend_str = {'D1', 'D2','D3'};
            legend(legend_str,'Interpreter','latex','Location','northeast');
%             legend(legend_str,'Interpreter','latex','Position',[0.2 0.6 0.1 0.2]);
            set(gca,'FontSize',FS)
     end
end

%             'AxesLimits', [ALmin(fN)*ones(1,lAL); ALmax(fN)*ones(1,lAL)],...


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
ExpSimName='モデル誤差fig用';%実験名,シミュレーション名
% contents='FT_apx_max';%実験,シミュレーション内容
contents='km1';%実験,シミュレーション内容
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
n=[2,7,10,11];%spider
nf=length(n);
SaveTitle=strings(1,nf);
%保存する図を選ぶ場合[1:"t-p" 2:"x-y" 3:"t-x" 4:"t-y" 5:"t-z" 6:"error" 7:"input" 8:"attitude" 9:"velocity" 10:"angular_velocity" 11:"3D" 12:"uHL" 13:"z1" 14:"z2" 15:"z3" 16:"z4" 17:"inner_input" 18:"vf" 19:"sigma"]
for i=1:nf
%     SaveTitle(i)=strcat(date,'_',ExpSimName,'_',contents,'_',figName(n(i)));
    SaveTitle(i)=strcat(contents,'_',figName(n(i)));
%     saveas(f(na(i)), fullfile(FolderName, SaveTitle(i) ),'jpg');
    saveas(f(n(i)), fullfile(FolderNamef, SaveTitle(i)),'fig');
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
%%
%x,dx,ddx,dddx,rmse
%ang(roll pitch yaw),angver(roll pitch yaw)
%inp:x,dx,ddx,dddxに加えられたとき
% 
D1 = [5 3 9 1 2];
D2 = [5 8 7 2 9];
D3 = [8 2 1 4 6];
P = [D1; D2; D3];

% Spider plot
spider_plot(P,...
    'AxesLabels', {'S1', 'S2', 'S3', 'S4', 'S5'},...
    'AxesInterval', 5,...
    'AxesDisplay', 'one',...
    'AxesLimits', [0,0,0,0,0; 10,10,10,10,10],...
    'FillOption', 'on',...
    'FillTransparency',0.1, ...
    'LineWidth', 2,...
    'LineStyle',{'-','-','--'}, ...
    'AxesFontSize', 14,...
    'LabelFontSize', 18,...
    'BackgroundColor','white',...
    'AxesLabelsEdge', 'none');
%'AxesDisplay', 'data'
legend_str = {'D1', 'D2','D3'};
legend(legend_str);
set(gca,'FontSize',18)
%%
D1 = [5 2 3 4 4]; 
D2 = [2 1 5 5 4];
P = [D1; D2];

% Spider plot
spider_plot(P,...
    'AxesInterval', 1,...
    'AxesLimits', [0, 0, 0, 0, 0; 5, 5, 5, 5, 5],...
    'FillOption', 'on',...
    'FillTransparency', 0.1, ...
    'LineWidth', 2,...
    'AxesFontSize', 14,...
    'LabelFontSize', 10,...
    'AxesLabelsEdge', 'none');
% spider_plot(P,...
%     'AxesInterval', 5,...
%     'AxesPrecision', 0,...
%     'AxesDisplay', 'one',...
%     'AxesLimits', [0, 0, 0, 0, 0; 5, 5, 5, 5, 5],...
%     'FillOption', 'on',...
%     'FillTransparency', 0.1,...
%     'Color', [139, 0, 0; 240, 128, 128]/255,...
%     'LineWidth', 4,...
%     'Marker', 'none',...
%     'AxesFontSize', 14,...
%     'LabelFontSize', 10,...
%     'AxesColor', [0.8, 0.8, 0.8],...
%     'AxesLabelsEdge', 'none',...
%     'AxesRadial', 'off');
% Title and legend settings
title(sprintf('Excel-like Radar Chart'),...
    'FontSize', 14);
legend_str = {'D1', 'D2'};
legend(legend_str);


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
        RMSE = [RMSE_x RMSE_y RMSE_z];
    end

%     function f =plot_data_single(figureNumber, figName, branchData)
function plot_data_single(~, ~, branchData)
        data = branchData{1,1};
        label = branchData{1,2};
        legendLabels = branchData{1,3};
        option = branchData{1,4};
        plotNum = length(data.y);
        if ~isfield(data, 'z')
%                 f(figureNumber) = figure('Name',figName);
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
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
                if ~isempty(option.aspect)
                    daspect(option.aspect)
                end
                title(option.titleName)
                set(gca,'FontSize',option.fontSize)
                grid on
                hold off

        else
%                 f(figureNumber) = figure('Name',figName);
                hold on
                for i = 1:plotNum 
                    plot3(data.x{1,i}, data.y{1,i}, data.z{1,i}, 'LineWidth', option.lineWidth)
                end
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                zlabel(label.z,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
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
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
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
                xlabel(label.x,'Interpreter','latex')
                ylabel(label.y,'Interpreter','latex')
                zlabel(label.z,'Interpreter','latex')
                legend(legendLabels,'NumColumns',option.legendColumns,'Interpreter','latex')
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
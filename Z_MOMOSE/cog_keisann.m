%G
clear time tl mL pL
close all
logNum = length(loggers);
id = find(loggers{1, 1}.phase==102 );
pL0 = loggers{1, 1}.sensor.p(:,id(1):id(end));  
for i = 2:logNum
    time{i-1} = loggers{i, 1}.t(id(1):id(end),:);
    tl{i-1} = length(time{i-1});
    mL{i-1} = loggers{i, 1}.estimator.mL(:,id(1):id(end));
    pL{i-1} = loggers{i, 1}.estimator.pL(:,id(1):id(end));
end
mLAjust = ajust_index(time,logNum,tl,mL);
pLAjust = ajust_index(time,logNum,tl,pL);

M = zeros(1,tl{1});
for i = 1:logNum-1
    M = M + mLAjust{i};
end
G = zeros(3,tl{1});
for i = 1:logNum-1
    G = G + pLAjust{i}.*mLAjust{i}./M;
end
G = G - pL0;
i = 1;
f(i) = figure;
plot(time{1},G)
hold on
plot(time{1},pL0)
grid minor
i = i+1;

f(i) = figure;
plot3(G(1,:),G(2,:),G(3,:),"Marker","+","LineStyle","none","MarkerSize",0.5)
hold on
plot3(pL0(1,:),pL0(2,:),pL0(3,:),"Marker","+","LineStyle","none","MarkerSize",1)
grid minor
i = i+1;

f(i) = figure;
plot(G(1,:),G(2,:),"Marker","+","LineStyle","none","MarkerSize",0.5)
hold on
plot(pL0(1,:),pL0(2,:),"Marker","+","LineStyle","none","MarkerSize",1)
grid minor
i = i+1;
% m1=allData.mAll{1, 1}.y{1,1};
% m2=allData.mAll{1, 1}.y{1,2};
% m3=allData.mAll{1, 1}.y{1,3};
% mAll=allData.mAll{1, 1}.y{1,4};
% a1 = loggers{2, 1}.estimator.pL.*loggers{2, 1}.estimator.mL;
% a2 = loggers{3, 1}.estimator.pL.*loggers{3, 1}.estimator.mL;
% a3 = loggers{4, 1}.estimator.pL.*loggers{4, 1}.estimator.mL;


function vars =ajust_index(time,logNum,tl,vars)
        for i = 2:logNum-1
            if tl{i-1}<tl{i}%短い制御周期を長い物に合わせる
                tmp{i} = zeros(size(vars{i-1},1),tl{i-1});
                kNow = 1;
                for j = 1:tl{i-1}
                    tBase = time{i-1}(j);
                    for k = kNow:tl{i-1}
                            tNow =  time{i-1}(k);
                        if tBase<tNow 
                            if abs(tBase-time{i-1}(k))<abs(tBase-time{i-1}(k-1))
                                tmp{i}(:,j) = vars{i}(:,k);
                                kNow = k+1;
                            else
                                tmp{i}(:,j)= vars{i}(:,k-1);
                                kNow = k;
                            end
                            break
                        end
                        
                    end
                end
                vars{i}=tmp{i};
            elseif tl{i-1}>tl{i}%長い制御周期を短い物に合わせる
                tmp{i} = zeros(length(vars{i-1}),tl{i-1});
                kNow = 1;
                for j = 1:tl{i}
                    tBase = time{i}(j);
                    for k = kNow:tl{i-1}
                            tNow =  time{i-1}(:,k);
                        if tBase>tNow
                            tmp{i}(:,k) = vars{i}(:,j);
                        else
                            kNow = k;
                            break
                        end
                    end
                end
                vars{i}=tmp{i};
            end
        end
    end
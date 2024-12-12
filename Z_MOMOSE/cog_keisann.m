%G
% m1=allData.mAll{1, 1}.y{1};
% m2=allData.mAll{1, 1}.y{2};
% m3=allData.mAll{1, 1}.y{3};
% mAll=allData.mAll{1, 1}.y{4};
% a1 = loggers{2, 1}.estimator.pL.*m1;
% a2 = loggers{3, 1}.estimator.pL.*m2; 
% a3 = loggers{4, 1}.estimator.pL.*m3; 

rigid_num=199;
numberOFpc = 4;%pcの総数
PCId = 3;%pcの番号
N = round(rigid_num/2);%機体と分割後の牽引物の組数
s = N-1*mod(rigid_num,2);%牽引物の分を引く(複数牽引でなかったら引かない)
r = mod(s,numberOFpc);
sParPc = (s-r)/numberOFpc;%各PCでいくつの組を制御するか
Ns = ones(1,numberOFpc)*sParPc + [ones(1,r),zeros(1,numberOFpc-r)];%各PCで制御する組を決定
N = Ns(PCId)+1*mod(rigid_num,2);%(複数牽引でなかったら足さない)
addIds = zeros(1,length(Ns));%機体と分割後の牽引物分+牽引物分ずらしていく
for i = 1:length(Ns)-1
    addIds(i+1) = sum(Ns(1:i),2)+1*mod(rigid_num,2);
end
% addIds = [0,Ns(1:end-1)*2+1*mod(rigid_num,2)];%機体と分割後の牽引物分+牽引物分ずらしていく
addId = addIds(PCId);%このpcで加算するrigidのid

addIds
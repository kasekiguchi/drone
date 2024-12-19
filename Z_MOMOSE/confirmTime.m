% id = 799
% for i = 1:10
%     i
%     xd = aaa.reference.xd(:,id);
%     P = [gui.agent(1, 2).parameter.parameter(1:2),gui.agent(1, 2).parameter.parameter(6:17),gui.agent(1, 2).parameter.parameter(20:21)];
%     P(15)=aaa.estimator.mL(id);
%     x = [aaa.estimator.q(:,id);aaa.estimator.w(:,id);aaa.estimator.pL(:,id);aaa.estimator.vL(:,id);aaa.estimator.pT(:,id);aaa.estimator.wL(:,id)];
%     q =eul2quat(x(1:3)');
%     x=[q';x(4:end,1)];
% 
%     F1 = gui.agent(1, 2).controller.param .F1;
%     F2 = gui.agent(1, 2).controller.param .F2;
%     F3 = gui.agent(1, 2).controller.param .F3;
%     F4 = gui.agent(1, 2).controller.param .F4;
%     dt=0.025;
% 
%     vf = Vfd_SuspendedLoad(dt,x,xd',P,F1);
%     vs = Vs_SuspendedLoad(x,xd',vf,P,F2,F3,F4);
%     uf = Uf_SuspendedLoad(x,xd',vf,P);
%     tic;invbeta2 = inv_beta2_SuspendedLoad(x,xd',vf,vs',P);toc
%     tic;vs_alpha2 = vs_alpha2_SuspendedLoad(x,xd',vf,vs',P);toc
% 
%     uf = Uf_SuspendedLoad(x,xd',vf,P);
%     us = [0;invbeta2*vs_alpha2];
%     inpuy = uf+us;
% end
rigid_num = 9
numberOFpc = 2;%pcの総数
PCId = 1;%pcの番号
NdroneAndLoad = round(rigid_num/2);%機体と分割後の牽引物の組数
s = NdroneAndLoad -1*mod(rigid_num,2);%牽引物の分を引く(複数牽引でなかったら引かない)
r = mod(s,numberOFpc);
sParPc = (s-r)/numberOFpc;%各PCでいくつの組を制御するか
Ns = ones(1,numberOFpc)*sParPc + [ones(1,r),zeros(1,numberOFpc-r)];%各PCで制御する組を決定
N = Ns(PCId)+1*mod(rigid_num,2);%(複数牽引でなかったら足さない)
addIds = zeros(1,length(Ns));%機体と分割後の牽引物分+牽引物分ずらしていく
for i = 1:length(Ns) - 1 
    addIds(i+1) = sum(Ns(1:i+1),2);%pcごとに機体ずらす
end
addId = addIds(PCId);%このpcで加算するrigidのid
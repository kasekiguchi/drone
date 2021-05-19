function [eval] = LMPobjective(x, params)
% 評価値を計算する
%x(1) : optimal variables v
%x(2) : optimal variables omega
params.dis%wall distanse
params.alpha%wall angle
params.fai%raser angle
params.pos%robot position [x y theta]
params.t%control tic
params.DeltaOmega

hk1 = (params.dis - params.pos(1).*cos(params.alpha) - params.pos(2).*sin(params.alpha))./cos(params.fai - params.alpha + params.pos(3));
hk2 = (params.dis - (params.pos(1)+x(1).*cos(params.pos(3)).*params.t)*cos(params.alpha) - (params.pos(2)+x(1).*sin(params.pos(3)).*params.t).*sin(params.alpha))./cos(params.fai - params.alpha +(params.pos(3)+x(2).*params.t));

deltah = hk1 - hk2;%観測値差分
invdeltah = abs(x(2) - params.DeltaOmega + 1)./deltah;%観測値差分の逆数
eval = sum(invdeltah);
% diffomega = diff(invdeltah,omega);%観測値差分の逆数をωで微分
%     %-- 評価値計算
%     eval = sum(stageMidF + stageTrajectry + stageInput + stageSlack_s + stageSlack_r + stagevelocity) + terminalTrajectry + terminalvelocity +  terminalMidF;
end
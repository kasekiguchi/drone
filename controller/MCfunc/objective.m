function [MCeval] = objective(X, U, N, xrobject, inputv, refinput, Weight, WeightR, WeightRp)   % obj.~とする
coder.gpu.kernelfun
  % X = state_data(:,:,1:obj.N);       % 12 * 10 * N
  % U = obj.input.u(:,:,1:obj.N);                % 4  * 10 * N
  %% Referenceの取得、ホライズンごと
  Xd = repmat(xrobject, 1,1, N);
%       Z = X;% - state.ref(1:12,:);
  %% ホライズンごとに実際の誤差に変換する（リファレンス(1)の値からの誤差）
  Xh = X + Xd(:, 1, :);
  %% それぞれのホライズンのリファレンスとの誤差を求める
  Z = Xd - Xh;
%       Z = X;

  tildeUpre = U - inputv;          % agent.input 　前時刻入力との誤差
  tildeUref = U - refinput;  % 目標入力との誤差

  %-- 状態及び入力のステージコストを計算
  stageStateZ = sum(Z(:,1:end-1,:).*pagemtimes(Weight(:,:,N),Z(:,1:end-1,:)),[1,2]);%
  stageInputPre  = sum(tildeUpre(:,1:end-1,:).*pagemtimes(WeightR(:,:,N),tildeUpre(:,1:end-1,:)),[1,2]);%sum(tildeUpre' * param.RP.* tildeUpre',2);
  stageInputRef  = sum(tildeUref(:,1:end-1,:).*pagemtimes(WeightRp(:,:,N),tildeUref(:,1:end-1,:)),[1,2]);%sum(tildeUref' * param.R .* tildeUref',2);

  %-- 状態の終端コストを計算 状態だけの終端コスト
  terminalState = sum(Z(:,end,:).*pagemtimes(Weight(:,:,N),Z(:,end,:)),[1,2]);

  %-- 評価値計算
  MCEval = cell(1,5);
  MCEval{1} = stageStateZ + stageInputPre + stageInputRef + terminalState;  % 全体の評価値
  MCEval{2} = sum(Z(1:2,:,:)   .* pagemtimes(Weight(1:2,1:2,N),       Z(1:2,:,:)),[1,2]);   % Z
  MCEval{3} = sum(Z(3:6,:,:)   .* pagemtimes(Weight(3:6,3:6,N),       Z(3:6,:,:)),[1,2]);   % X
  MCEval{4} = sum(Z(7:10,:,:)  .* pagemtimes(Weight(7:10,7:10,N),    Z(7:10,:,:)),[1,2]);   % Y
  MCEval{5} = sum(Z(11:12,:,:) .* pagemtimes(Weight(11:12,11:12,N), Z(11:12,:,:)),[1,2]);   % YAW

  %-- 評価値をreshapeして縦ベクトルに変換
  MCeval1 = reshape(MCEval{1}, N, 1);
  MCeval2 = reshape(MCEval{2}, N, 1);
  MCeval3 = reshape(MCEval{3}, N, 1);
  MCeval4 = reshape(MCEval{4}, N, 1);
  MCeval5 = reshape(MCEval{5}, N, 1);
  
  MCeval = [MCeval1, MCeval2, MCeval3, MCeval4, MCeval5];

end
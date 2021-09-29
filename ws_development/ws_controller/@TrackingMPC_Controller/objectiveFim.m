function [eval] = objectiveFim(obj,x, params)
% モデル予測制御の評価値を計算するプログラム

%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:end, :);

%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
tildeX = X - params.Xr;
%     tildeU = U - params.Ur;
tildeU = U;
%
evFim = zeros(1,params.H);
for j = 1:params.H
    Fim = FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j), X(5,j), params.t, params.dis(1), params.alpha(1), params.phi(1));
%     arrayfun(@(N) FIM_ObserbSub(X(1,1), X(2,1), X(3,1), X(4,1), X(5,1), params.t, params.dis(N), params.alpha(N), params.phi(N)),1:length(params.dis),'UniformOutput',false);
    for i = 2:length(params.dis)
        Fim = Fim + FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j), X(5,j), params.t, params.dis(i), params.alpha(i), params.phi(i) );
    end
    Fim = (1/(2*params.NoiseR))*Fim;
%     e = 1e-20 * ones(2,2);
%     evFim(1,j) = 1/(det(Fim)+e);
    InvFim = inv(Fim);
%     diagFim = diag(InvFim);
%     evFim(:,j) = diagFim;
%     EigFim = min(eig(Fim));
%     evFim(1,j) = 1/EigFim;
%     InvFim = inv(Fim);
    evFim(1,j) = max(eig(InvFim));
end
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
% stageevFim = arrayfun(@(L) evFim(:,L)' * params.Th * evFim(:,L), 1:params.H);
stageevFim = evFim* params.T * evFim';
%-- 状態の終端コストを計算
terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
%-- 評価値計算
eval = sum(stageState + stageInput) + sum(stageevFim) + terminalState;
end
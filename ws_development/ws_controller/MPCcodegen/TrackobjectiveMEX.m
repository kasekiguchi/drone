function [eval] = TrackobjectiveMEX(x, params)
% モデル予測制御の評価値を計算するプログラム
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.total_size, :);
S = x(params.total_size+1:end,:);
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
tildeX = X - params.Xr;
%     tildeU = U - params.Ur;
tildeU = U;
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
%-- 状態の終端コストを計算
terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
%-- 評価値計算
eval = sum(stageState + stageInput) + terminalState;
end
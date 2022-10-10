function eval = GetobjectiveFimEval(obj,x)
% モデル予測制御の評価値を計算するプログラム
params = obj.param;
NoiseR = obj.NoiseR;
SensorRange = obj.SensorRange;
RangeGain= obj.RangeGain;
%-- MPCで用いる予測状態 Xと予測入力 Uを設定
X = x(1:params.state_size, :);
U = x(params.state_size+1:params.state_size+params.input_size, :);
% S = x(params.total_size+1:end,:);
%-- 状態及び入力に対する目標状態や目標入力との誤差を計算
tildeX = X - params.Xr;
%     tildeU = U - params.Ur;
tildeU = U;
%
evFim = zeros(1,params.H);
evObFim = zeros(1,params.H);
for j = 1:params.H
    t1 = params.phi;
    t2 = params.alpha;
    [~,tth]=min(abs(t1-t2),[],2);
    
    H = (params.dis(:) - X(1,j).*cos(params.alpha(:)) - X(2,j).*sin(params.alpha(:)))./cos(params.phi(tth)' - params.alpha(:) + X(3,j));%observation 
%     RangeLogic = H<SensorRange;
    RangeLogic = (tanh(RangeGain*(SensorRange - H))+1)/2;
%     Fim = RangeLogic(1) * FIM_ObserbSub(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j),params.dt, params.dis(1), params.alpha(1), params.phi(1));
    Fim = RangeLogic(1) * obj.FIM_ObserbSubAOmegaRungeKutta(X(1,j), X(2,j), X(3,j),X(4,j),U(2,j),U(1,j),params.dt, params.dis(1), params.alpha(1), params.phi(1));
    ObFim = RangeLogic(1) * obj.FIM_Observe(X(1,j), X(2,j), X(3,j), params.dis(1), params.alpha(1), params.phi(1));
    for i = 2:length(params.dis)
        Fim = Fim + RangeLogic(i) * obj.FIM_ObserbSubAOmegaRungeKutta(X(1,j), X(2,j), X(3,j),X(4,j),U(2,j),U(1,j),params.dt, params.dis(i), params.alpha(i), params.phi(i));
%         Fim = Fim + RangeLogic(i) * FIM_Ob    serbSub(X(1,j), X(2,j), X(3,j), X(4,j),U(2,j),params.dt, params.dis(i), params.alpha(i), params.phi(i));
        ObFim = ObFim + RangeLogic(i) * obj.FIM_Observe(X(1,j), X(2,j), X(3,j), params.dis(i), params.alpha(i), params.phi(i));
    end
    Fim = (1/(2*NoiseR))*(Fim+1e-2*eye(2));
    ObFim = (1/(NoiseR))*(ObFim + 1e-2*eye(3));%[ObFim + [1e-2,1e-2,1e-2;1e-2,1e-2,1e-2;1e-2,1e-2,1e-2]]);
    InvFim = [Fim(2,2) -Fim(1,2); -Fim(2,1), Fim(1,1)]/(det(Fim));
    InvObFim = inv(ObFim);
%     evFim(1,j) = max(eig(InvFim));
evFim(1,j) = trace(InvObFim)*trace(InvFim);
%evObFim(1,j) = trace(InvObFim);
end
%-- 状態及び入力のステージコストを計算
stageState = arrayfun(@(L) tildeX(:, L)' * params.Q * tildeX(:, L), 1:params.H);
stageInput = arrayfun(@(L) tildeU(:, L)' * params.R * tildeU(:, L), 1:params.H);
% stageSlack = arrayfun(@(L) S(:, L)' * params.WoS * S(:,L), 1:params.H);
eval.stageevFim = evFim* params.T *evFim';
%-- 状態の終端コストを計算
eval.terminalState = tildeX(:, end)' * params.Qf * tildeX(:, end);
%-- 評価値計算
eval.StageState = sum(stageState);
eval.StageInput = sum(stageInput);
% eval.StageSlack = sum(stageSlack);
eval.stageeObFim = 1;%evObFim* params.T * evObFim';
end
function Controller= Controller_CORRECT_OBSERVABILITY(dt,eps,K,name)
% 可観測性による入力補正用
Controller.eps = eps; %特異値のスレッショルドε
Controller.K = K; % 係数行列のチューニングパラメータK
Controller.funcname = name; %Lie微分による可観測性行列のfunction
func = str2func(name);
Controller.Obs_func = @(x,u) func(x,u);
% 設定確認
Controller.dt = dt;
% eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end

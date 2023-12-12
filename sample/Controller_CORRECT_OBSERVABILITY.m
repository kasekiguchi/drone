function Controller= Controller_CORRECT_OBSERVABILITY(dt,eps,name)
% 可観測性による入力補正用
Controller.eps = eps; %特異値のスレッショルドε
Controller.funcname = name; %可観測性行列のfunction
func = str2func(name);
Controller.Obs_func = @(x,u) func(x,u);
% 設定確認
Controller.dt = dt;
% eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end

function Controller= Controller_CORRECT_OBSERVABILITY(dt,eps,K,name1,name2,name3)
% 可観測性による入力補正用
Controller.eps = eps; %特異値のスレッショルドε
Controller.K = K; % 係数行列のチューニングパラメータK

Controller.funcnameF = name1; %f+guのf
func1 = str2func(name1);
Controller.F_func = @(x,p) func1(x,p);

Controller.funcnameG = name2; %f+guのg
func2 = str2func(name2);
Controller.G_func = @(x,p) func2(x,p);

Controller.funcname3 = name3; %Lie微分による可観測性行列のfunction
func3 = str2func(name3);
Controller.Obs_func = @(x,u) func3(x,u);
% 設定確認
Controller.dt = dt;
% eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end

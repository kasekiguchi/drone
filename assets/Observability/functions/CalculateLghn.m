function Lghn = CalculateLghn(file_name,est,name)
% 入力補正用　入力空間gと非線形関数hのLie微分Lghnを返す関数
% [Input]
% file_name : 保存するファイル名
% est : 推定モデル
% name : 可観測性行列の関数名
% [Output]
% Lghn : 入力空間gと非線形関数hのLie微分
    n = est.model.dim(1);
    x = sym('x',[n,1]);
    u = sym('u',[est.model.dim(2),1]);
    p = sym('p',[1,est.model.dim(3)]);
    Vn = sym('Vn',[n,1]);
    O_func = str2func(name); 
    O = O_func(x,u);
    g = G_RPY18(x,p);
    dhndx = zeros(size(O));
    for i=1:n
        A = jacobian(O(:,i),x);
        dhndx = dhndx + (A * Vn(i));
    end
    Lghn = dhndx * g;
    matlabFunction(Lghn,'File',strcat(file_name,".m"),'Vars',{x,u,p,Vn});
    Lghn=str2func('file_name');
end
 
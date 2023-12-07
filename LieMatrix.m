function LieMatrix=LieMatrix(file_name)
    % model methodの拡張線形化
    % JacobiF(x,p) : x 状態，　p 物理パラメータ
    n = 18;
    x = sym('x',[n,1]);
    u = sym('u',[4,1]);
    p = sym('p',[1,17]);
    h = On3_1_new(x,u);
    hn = h(:,n);
    g = G_RPY12(x,p);
    syms Lie;
    % 初期化
    Lfh = h;
    Lie = Lfh;
    for i = 2:3
        Lfh = jacobian(Lfh, x) * g;
        Lie = [Lie; Lfh];
        i
    end
    matlabFunction(Lie,'File','Lghn1','Vars',{x,u,p});
    LieMatrix=str2func(file_name);
end

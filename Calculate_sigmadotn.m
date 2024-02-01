function sigmadotn = Calculate_sigmadotn(file_name,est,name)
% Correct Obserbavility 用　Lghn計算
% file_name 保存するファイル名
% est 推定モデル
% name 可観測性行列の関数名
    n = est.model.dim(1);
    x = sym('x',[n,1]);
    u = sym('u',[est.model.dim(2),1]);
    O_func = str2func(name); 
    O = O_func(x,u);
    Odot = zeros(size(O));
    Un = sym('Un',[1,size(O,1)]);
    Vn = sym('Vn',[size(O,2),1]);
    'Calc start'
    for i=1:n
        Odot = jacobian(O(:,i),x);
        i
    end
    dhdx = Un * Odot * Vn;
    'function start'
    matlabFunction(dhdx,'File',strcat(file_name,".m"),'Vars',{x,u,Un,Vn});
    sigmadotn=str2func('file_name');
end
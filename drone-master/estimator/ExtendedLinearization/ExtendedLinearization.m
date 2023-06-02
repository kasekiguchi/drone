function JacobiF=ExtendedLinearization(file_name,model,varargin)
    % model methodの拡張線形化
    % JacobiF(x,p) : x 状態，　p 物理パラメータ
    n = model.dim(1);
    x = sym('x',[n,1]);
    u = sym('u',[model.dim(2),1]);
    p = sym('p',[1,model.dim(3)]);
    f=model.method(x,u*0,p);
    %matlabFunction(jacobian(f,x),'File',strcat("estimator/ExtendedLinearization/",file_name,".m"),'Vars',{x,p});
    matlabFunction(jacobian(f,x),'File',strcat(file_name,".m"),'Vars',{x,p});
    JacobiF=str2func(file_name);
end


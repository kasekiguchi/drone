function Lghn = CalculateLghn(file_name,est,name)
% Correct Obserbavility 用　Lghn計算
n = est.model.dim(1);
x = sym('x',[n,1]);
u = sym('u',[est.model.dim(2),1]);
p = sym('p',[1,est.model.dim(3)]);
O_func = str2func(name);
h = O_func(x,u);
hn = h(1:n,n);
% hn = h(n,:);
g = G_RPY12(x,p);
Lghn = jacobian(hn, x) * g;
matlabFunction(Lghn,'File',strcat(file_name,".m"),'Vars',{x,u,p});
Lghn=str2func('Lghn');
end
 
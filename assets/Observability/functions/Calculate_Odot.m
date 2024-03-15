%% 可観測性行列の微分計算
% Odot = U * Sigmadot * V 計算のため
n =18;
file_name = 'Odot';
syms x [n 1] real
p = [0.588400000000000	0.160000000000000	0.160000000000000	0.0800000000000000	0.0800000000000000	0.0600000000000000	0.0600000000000000	0.0600000000000000	9.81000000000000	0.0301000000000000	0.0301000000000000	0.0301000000000000	0.0301000000000000	8.00000000000000e-06	8.00000000000000e-06	8.00000000000000e-06	8.00000000000000e-06];
% syms p [1 17] real
F = F_RPY18(x,p); % F + G*u のF
G = G_RPY18(x,p); % F + G*u のG
syms u [4 1] real % 入力数
O = Onew(x,p); % 可観測性行列の関数
Og1= sym(zeros(size(O)));
Og2= sym(zeros(size(O)));
Og3= sym(zeros(size(O)));
Og4= sym(zeros(size(O)));
flag = 'Calc start'
for i =1:size(O,1)
    i
    for j = 1:size(O,2)
        [i,j]
        dOdx = jacobian(O(i,j),x);
        Og1(i,j) = dOdx * G(:,1);
        Og2(i,j) = dOdx * G(:,2);
        Og3(i,j) = dOdx * G(:,3);
        Og4(i,j) = dOdx * G(:,4);
    end
end
matlabFunction(Og1,'File',strcat('./estimator/Observability/function/','LgO1',".m"),'Vars',{x});
matlabFunction(Og2,'File',strcat('./estimator/Observability/function/','LgO2',".m"),'Vars',{x});
matlabFunction(Og3,'File',strcat('./estimator/Observability/function/','LgO3',".m"),'Vars',{x});
matlabFunction(Og4,'File',strcat('./estimator/Observability/function/','LgO4',".m"),'Vars',{x});


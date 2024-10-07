%%generate load mass system
syms mL g      real %牽引物質量，重力加速度
syms p [3,1]   real %牽引物位置
syms v [3,1]   real %牽引物速度
syms mu [3,1]  real %張力
e3 = [0;0;1]; 
x = [p;v;mL];
f = [v;-g*e3 + eye(3)*mu/mL;0];
matlabFunction(f,'file','load_model','vars',{x mu g},'outputs',{'dx'});
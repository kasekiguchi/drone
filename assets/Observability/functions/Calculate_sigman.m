%% 可観測性行列の特異値σnの微分
n =18; % 状態数
file_name = 'sigman';
x = sym('x',[n,1]);
p = sym('p',[1,17]);
On = Onew(x,p); % 可観測性行列の関数
Un = sym('Un',[1,size(On,1)]);  %右特異ベクトル
Vn = sym('Vn',[n,1]); % 左特異ベクトル
flag = 'Calc start'
sn = jacobian(Un*On*Vn,x);
flag = 'Snfunc start'
snfunc = @(x,p,Un,Vn) sn(x,p,Un,Vn)
flag = 'function start'
matlabFunction(sn,'File',strcat(file_name,".m"),'Vars',{x,p,Un,Vn});
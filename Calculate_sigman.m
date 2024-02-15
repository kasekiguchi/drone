fmethod = @(x,p) F_RPY18(x,p); %可観測行列生成のためのモデル f
wall_param = [0,1,0,-9]; 
hmethod = @(x,p) H_18(x,wall_param,p); %観測方程式
x = sym('x',[18,1]);
p = sym('p',[1 17]);
f=fmethod(x,p);
h = hmethod(x,p);
len = 21;
syms q [len 1] % Lieによる可観測性行列のサイズ指定 [size 1]のsize部分は拡大系の状態数以上かつ観測数の倍数
for i=1:(len/size(h,1))
    if i == 1
        Lfh = h;
        q(1:size(h,1)*i) = Lfh;
    else
        Lfh = jacobian(Lfh,x)*f;
        q(1+size(h,1)*(i-1):size(h,1)*i)= Lfh;
        i
    end
end
'O jacobian'
On = jacobian(q,x);
n =18;
file_name = 'sigman';
x = sym('x',[n,1]);
p = sym('p',[1,17]);
Vn = sym('Vn',[n,1]);
Un = sym('Un',[1,21]);
flag = 'Calc start'
sn = jacobian(Un*On*Vn,x);
flag = 'Snfunc start'
snfunc = @(x,p,Un,Vn) sn(x,p,Un,Vn)
flag = 'function start'
matlabFunction(sn,'File',strcat(file_name,".m"),'Vars',{x,p,Un,Vn});
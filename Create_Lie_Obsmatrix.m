%% Lie微分による可観測性行列の生成
name = ''; % 関数を保存するファイル名
tmpmethod = str2func(get_model_name("RPY 12")); % 拡大前のモデル
fmethod = @(t,x,p) [tmpmethod(t,x,p); zeros(6,1)]; %可観測行列生成のためのモデル f
wall_param = [0,1,0,-9]; 
hmethod = @(x,p) H_18(x,wall_param,p); %観測方程式
x = sym('x',[18,1]);
u = sym('u',[4,1]);
f=fmethod(x,u,param);
h = hmethod(x,param);
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
On = jacobian(q,x);
matlabFunction(On,'File',name,'vars',{x,u})

function Controller  = Controller_FT(dt)
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
Controller_param.F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt);                                % 
Controller_param.F2=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller_param.F3=lqrd(Ac4,Bc4,diag([100,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);                       % ヨー角 
syms sz1 [2 1] real
syms sF1 [1 2] real
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));
Controller_param.Vf = matlabFunction([-sF1*sz1, -sF1*(Ad1-Bd1*sF1)*sz1, -sF1*(Ad1-Bd1*sF1)^2*sz1, -sF1*(Ad1-Bd1*sF1)^3*sz1],"Vars",{sz1,sF1});
%有限整定制御用のVfを書く
% syms a real
% th=0;dth=0;ddth =0; dddth=0;
% for i=1:2
%     fz = 1/(1+exp(-a*2*sz1(i)));
%     tanh = 2*fz-1;
%     dtanh = 4*a*fz*(1-fz);
%     ddtanh = 8*a^2*fz*(1-fz)*(1*2*fz);
%     dddtanh = 16*a^3*fz*(1-fz)*(1-6*fz+6*fz^2);
%     
%     th = th + tanh;
%     dth = dth + dtanh;
%     ddth = ddth + ddtanh;
%     dddth = dddth + dddtanh;
% end
% A = Ad1-Bd1*sF1;
% Az = A*sz1;
% AAz = A*Az;
% AAAz = A*AAz;
% 
% Controller_param.VfFT = matlabFunction([-sF1*(th+1)*sz1, -sF1*(dth+1)*Az, -sF1*(ddth*Az.^2+(dth+1)*AAz), -sF1*(dddth*Az.^3+3*ddth*Az.*AAz+(dth+1)*AAAz)],"Vars",{sz1,sF1,a});
%
% syms al z(t) []positive
% uFT = -k*sign(sz(i))*abs(sz1(i))^al
% duFT = diff(uFT,)

syms sz2 [4 1] real
syms sF2 [1 4] real
syms sz3 [4 1] real
syms sF3 [1 4] real
syms sz4 [2 1] real
syms sF4 [1 2] real
Controller_param.Vs = matlabFunction([-sF2*sz2;-sF3*sz3;-sF4*sz4],"Vars",{sz2,sz3,sz4,sF2,sF3,sF4});

%% 再現実験
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
% Controller_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt); 
% % 極配置
% Eig=[-3.2,-2,-2.5,-2.1];
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
% % Controller_param.F2=place(diag([1,1,1],1),[0;0;0;1],Eig);
% % Controller_param.F3=place(diag([1,1,1],1),[0;0;0;1],Eig);
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ヨー角 

%% 入力のalphaを計算

anum=4;%変数の数
alpha=zeros(anum+1,1);
alpha(anum+1)=1;
alpha(anum)=0.8;%alphaの初期値

for a=anum-1:-1:1
    alpha(a)=(alpha(a+2)*alpha(a+1))/(2*alpha(a+2)-alpha(a+1));
end
Controller_param.alpha=alpha(anum);
Controller_param.ax=alpha;
Controller_param.ay=alpha;
% Controller_param.az=alpha(anum-1:anum,1);
% Controller_param.apsi=alpha(anum-1:anum,1);
%masui
Controller_param.az=alpha(1:2,1);
Controller_param.apsi=alpha(1:2,1);
%% 近似のパラメータ
fff=10;%%%%%%%%%%%%%%%%%%%%%%
faprxm1=1;%%%%%%%%%%%%%%%%%%%%

k=Controller_param.F2;
gain_ser1=zeros(4,2);
gain_ser2=zeros(4,4);

if fff==1
if faprxm1==1
    %fminserch tanh 1つ
    x0=[2,2];
    fvals12=zeros(4,1);
    er=0.1; %近似する範囲を指定
    gain_ser1=zeros(4,2);
    for i=1:4
        fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alpha(i) + x(1)*tanh(x(2)*e) + k(i)*e ) ,0, er));
        [x,fval] = fminsearch(fun,x0) ;
        fvals12(i) = 2*fval;
        gain_ser1(i,:)=x;% gain_ser1(4*2)["f1","a1"]*[x;dx;ddx;dddx]
    end
else
    %fminserch tanh 2つ
    x0=[5,5,5,5];
    fvals22=zeros(4,1); 
    er=0.1; %近似する範囲を指定
    gain_ser2=zeros(4,4);
    for i=1:4
        fun=@(x)(integral(@(e) abs( -k(i)*abs(e).^alpha(i) + x(1)*tanh(x(2)*e)+ x(3)*tanh(x(4)*e) + k(i)*e ) ,0, er));
        options = optimset('MaxFunEvals',1e5);
        [x,fval] = fminsearch(fun,x0,options);
        fvals22(i) = 2*fval;
        gain_ser2(i,:)=x;% gain_ser2(4*4)["f1","a1","f2","a2"]*[x;dx;ddx;dddx]
    end
end
end
Controller_param.gain1=gain_ser1;
Controller_param.gain2=gain_ser2;
%%
Controller_param.dt = dt;
 eig(diag([1,1,1],1)-[0;0;0;1]*Controller_param.F2)
Controller.type="FTC";
% Controller.name="ftc";
Controller.name="hlc";
Controller.param=Controller_param;

%assignin('base',"Controller_param",Controller_param); 

end

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
%有限整定の近似微分　一層
syms a b f1 g1 k [1 2] real 
fsingle = 1;%%%%%%%%%%%%%%%%%%%%
u=0;du=0;ddu=0;dddu=0;
if fsingle 
    for i = 1:2
        fza = 1/(1+exp(-a(i)*2*sz1(i)));
        tanha = 2*fza-1;
        dtanha = 4*a(i)*fza*(1-fza);
        ddtanha = 8*a(i)^2*fza*(1-fza)*(1-2*fza);
        dddtanha = 16*a(i)^3*fza*(1-fza)*(1-6*fza+6*fza^2);

        u = u -f1(i)*tanha -k(i)*sz1(i);
            dz = Ac2*sz1 + Bc2*u;
        du = du -f1(i)*dtanha*dz(i) -k(i)*dz(i);
            ddz = Ac2*dz + Bc2*du;
        ddu = ddu -f1(i)*ddtanha*(dz(i))^2 -f1(i)*dtanha*ddz(i) -k(i)*ddz(i);
            dddz = Ac2*ddz + Bc2*ddu;
        dddu = dddu -f1(i)*dddtanha*(dz(i))^3 -3*f1(i)*ddtanha*dz(i)*ddz(i) -f1(i)*dtanha*dddz(i) -k(i)*dddz(i);

    end
    Controller_param.VfFT = matlabFunction([u,du,ddu,dddu],"Vars",{f1,a,k,sz1});
else    
    for i = 1:2
        fza = 1/(1+exp(-a(i)*2*z(i)));
        tanha = 2*fza-1;
        dtanha = 4*a(i)*fza*(1-fza);
        ddtanha = 8*a(i)^2*fza*(1-fza)*(1*2*fza);
        dddtanha = 16*a(i)^3*fza*(1-fza)*(1-6*fza+6*fza^2);

        fzb = 1/(1+exp(-b(i)*2*z(i)));
        tanhb = 2*fzb-1;
        dtanhb = 4*b(i)*fzb*(1-fzb);
        ddtanhb = 8*b(i)^2*fzb*(1-fzb)*(1*2*fzb);
        dddtanhb = 16*b(i)^3*fzb*(1-fzb)*(1-6*fzb+6*fzb^2);

        u = u -f1(i)*tanha -g1(i)*tanhb -k(i)*sz(i);
            dz = Ac*sz1 + Bc*u;
        du = du -f1(i)*dtanha*a(i)*dz(i) -g1(i)*dtanhb*b(i)*dz(i) -k(i)*dz(i);
            ddz = Ac*dz + Bc*du;
        ddu = ddu -f1(i)*ddtanha*(a(i)*dz(i))^2 -g1(i)*ddtanhb*(b(i)*dz(i))^2 -f1(i)*dtanha*a(i)*ddz(i) -g1(i)*dtanhb*b(i)*ddz(i) -k(i)*dz(i);
            dddz = Ac*ddz + Bc*ddu;
        dddu = dddu -f1(i)*dddtanha*(a(i)*dz(i))^3 -g1(i)*dddtanhb*(b(i)*dz(i))^3 -3*f1(i)*ddtanha*a(i)^2*dz(i)*ddz(i) -3*g1(i)*dtanhb*b(i)^2*dz(i)*ddz(i) -f1(i)*dtanha*a(i)*dddz(i) -g1(i)*dtanhb*b(i)*dddz(i)-k(i)*dz(i);

    end
    Controller_param.VfFT = matlabFunction([u,du,ddu,dddu],"Vars",{f1,a,g1,b,k,sz1});
end


%% 二層
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
alpha(anum)=0.9;%alphaの初期値

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
fff=1;%%%%%%%%%%%%%%%%%%%%%%
faprxm1=1;%%%%%%%%%%%%%%%%%%%%

kf2=Controller_param.F2;
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
        fun=@(x)(integral(@(e) abs( -kf2(i)*abs(e).^alpha(i) + x(1)*tanh(x(2)*e) + kf2(i)*e ) ,0, er));
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

function Controller= Controller_HL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
A2 = [0 1;0 0];
A4 = diag([1,1,1],1);
B2 = [0; 1];
B4 = [0;0;0;1];
%↓ゲイン可変用1/3(Controller_HL内で2か所，HLCで1か所ある．
dtt=dt;%0.0055;%実際の平均周期%ゲイン可変用いらなかったら消す．
Controller.F1=lqrd(A2,B2,diag([100,1]),[0.1],dtt);                                % z 
 % Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([350,450,200,1]),[0.002],dtt); % ifight xdiag([400,450,150,1]),good([350,450,200,1]),0.002,←な部ちゃん,,→粉砕,[300,200,10,1],0.01
 Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([300,200,10,1]),[0.01],dtt);
 Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([300,200,10,1]),[0.01],dtt); % iflight ydiag([400,450,150,1])
 % Controller.F2=lqrd(A4,B4,diag([300,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])エーシン
 % Controller.F3=lqrd(A4,B4,diag([300,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])エーシン
Controller.F4=lqrd(A2,B2,diag([100,10]),[0.1],dtt);                       % ヨー角 
% ↑ゲイン可変用1/3

% %制御周期 dt=0.025用（0.025は勝手に入ってくる
% Controller.F1=lqrd(A2,B2,diag([100,1]),[0.1],dt);                                % z 
%  Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,10,10,1]),[0.001],dt); % ifight xdiag([400,450,150,1]),good([350,450,200,1]),0.002,←な部ちゃん,,→粉砕,[300,200,10,1],0.01
%  Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,10,10,1]),[0.001],dt); % iflight ydiag([400,450,150,1])
%  % Controller.F2=lqrd(A4,B4,diag([300,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])エーシン
%  % Controller.F3=lqrd(A4,B4,diag([300,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])エーシン
% Controller.F4=lqrd(A2,B2,diag([100,10]),[0.1],dt);         

% % dt = 0.2 くらいの時用
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
% Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,1,1,1]),[1],dt); % xdiag([100,10,10,1])
% Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,1,1,1]),[1],dt); % ydiag([100,10,10,1])
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);                       % ヨー角 


% 極配置
% Controller.F2=place(diag([1,1,1],1),[0;0;0;1],Eig);
% Controller.F3=place(diag([1,1,1],1),[0;0;0;1],Eig);

%係数行列とゲインを求める関数を分ける場合
% syms tt  positive
% [A2d,B2d]=c2d(A2,B2,tt);
% [A4d,B4d]=c2d(A4,B4,tt);
% Controller.AdBd = matlabFunction(A2d,B2d,A4d,B4d,"Vars",{tt});%任意の離散時間のA,B行列に変換。tt=任意の刻み時間
% [pA2d,pB2d,pA4d,pB4d] =Controller.AdBd(dt);
% Controller.p2=eig(pA2d-pB2d*Controller.F1);%F1,F4用の極→HLCで使う
% Controller.p4=eig(pA4d-pB4d*Controller.F2);

% ↓ゲイン可変用2/3
%関数一つで書く場合
[pA2d,pB2d]=c2d(A2,B2,dtt);
[pA4d,pB4d]=c2d(A4,B4,dtt);
p2=eig(pA2d-pB2d*Controller.F1);%F1,F4用の極→HLCで使う
p4=eig(pA4d-pB4d*Controller.F2);%F2,F3用の極→HLCで使う
Controller.gainFunc = @(tt) deal(place([1,tt;0,1], [tt^2/2;tt],p2),...
    place([1,tt,tt^2/2, tt^3/6;0,1,tt,tt^2/2;0,0, 1,tt;0,0, 0,1],[tt^4/24;tt^3/6;tt^2/2;tt],p4),...
    place([1,tt,tt^2/2, tt^3/6;0,1,tt,tt^2/2;0,0, 1,tt;0,0, 0,1],[tt^4/24;tt^3/6;tt^2/2;tt],p4),...
    place([1,tt;0,1], [tt^2/2;tt],p2));%意図した極（p2,p4）になるようにゲインを計算。
%↑ゲイン可変用2/3



%離散時間係数行列
% A2d = 
% [1, tt]
% [0,  1]
% B2d =
% [tt^2/2]
% [tt    ]
% A4d =
% [1, tt, tt^2/2, tt^3/6]
% [0,  1,     tt, tt^2/2]
% [0,  0,      1,     tt]
% [0,  0,      0,      1]
% B4d =
% [tt^4/24]
% [tt^3/6 ]
% [tt^2/2 ]
% [   tt  ]

% 設定確認
Controller.dt = dt;
eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end

%% 定義
syms d alpha fai real
syms v omega t real
syms x y theta real
syms DeltaOmega real

hk1 = (d - x*cos(alpha) - y*sin(alpha))/cos(fai - alpha +theta);
hk2 = (d - (x+v*cos(theta)*t)*cos(alpha) - (y+v*sin(theta)*t)*sin(alpha))/cos(fai - alpha +(theta+omega*t));

deltah = hk1 - hk2;%観測値差分
%%
invdeltah = abs(omega - DeltaOmega)/deltah;%観測値差分の逆数
diffomega = diff(invdeltah,omega);%観測値差分の逆数をωで微分
diffv = diff(invdeltah,omega);

Fomega = solve(diffomega ==0,omega);

matlabFunction(Fomega,'File','InputSouce','Vars',[fai alpha theta t]);




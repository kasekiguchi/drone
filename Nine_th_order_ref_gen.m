%% reference 
close all;
teref = te; % かける時間
z0 = 1; % z初期値
ze = 1; % z収束値
v0 = 0; % 初期速度
ve = 0; % 終端速度 収束させるなら０；　速度持ったまま落下なら-1とか -0.5
t = 0:0.025:te;
Params.refZ = curve_interpolation_9order(t',teref,z0,v0,ze,ve);
x0 = 0; % -1
xe = 2;
v0 = 0;
ve = 0;
Params.refX = curve_interpolation_9order(t',teref,x0,v0,xe,ve);
y0 = 0;
ye = 0;
v0 = 0;
ve = 0;
Params.refY = curve_interpolation_9order(t',teref,y0,v0,ye,ve);
data.Zdis(1) = 0;
%
figure(1)
plot(t, Params.refX(round(t/dt)+1,1), t, Params.refY(round(t/dt)+1,1), t, Params.refZ(round(t/dt)+1,1));
legend("X", "Y", "Z")
figure(2)
plot(t, Params.refX(round(t/dt)+1,2), t, Params.refY(round(t/dt)+1,2), t, Params.refZ(round(t/dt)+1,2));
legend("Vx", "Vy", "Vz")
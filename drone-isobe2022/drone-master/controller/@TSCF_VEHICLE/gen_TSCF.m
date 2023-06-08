clear
syms V th x y dth dx dy thr Vr dV dVr dthr real
syms p [3 1] real
syms pr [3 1] real
syms k1 k2 real

dp = pr - p;
Vv = [V*cos(th);V*sin(th);0];
Vrv = [Vr*cos(thr);Vr*sin(thr);0];
dVa = k1*(dp'*Vv)/V + k2*((Vrv'*Vv)/V-V); % 3x1
eby = Rodrigues([0,0,1],th)*[0;1;0];
%d = dp'*eby;
d = norm(dp)
dp1 = Vv(1);
dp2 = Vv(2);
dpr1 = Vrv(1);
dpr2 = Vrv(2);
dd = simplify(pdiff(d,[p1;p2;th;pr1;pr2;V;Vr;thr])*[dp1;dp2;dth;dpr1;dpr2;dV;dVr;dthr])
ddd =  simplify(pdiff(dd,[p1;p2;th;pr1;pr2;V;Vr;thr])*[dp1;dp2;dth;dpr1;dpr2;dV;dVr;dthr])
%%
syms Z D real
er1 = Rodrigues([0,0,1],thr)*[1;0;0]
er2 = Rodrigues([0,0,1],thr)*[0;1;0]
solz = solve([dp(1:2)==-Z*er2(1:2);dp'*er1==0],[Z;p2])
%z = sqrt(dp(1)^2+dp(2)^2)*cos(thr-th);
%dz =  simplify(pdiff(z,[p1;p2;th;pr1;pr2;V;Vr;thr])*[dp1;dp2;dth;dpr1;dpr2;dV;dVr;dthr])
%%
eq= Z*er2+D*er1 - dp ==0;
eq1 = lhs(eq(1));
eq2 = lhs(eq(2));
sol=solve(eq(1:2),[D,Z]);
%z = simplify(sol.Z);
d = simplify(sol.D);
z = simplify(Z*eq1-D*eq2);
dz =  simplify(pdiff(z,[p1;p2;th;pr1;pr2;V;Vr;thr])*[dp1;dp2;dth;dpr1;dpr2;dV;dVr;dthr])
dd =  simplify(pdiff(d,[p1;p2;th;pr1;pr2;V;Vr;thr])*[dp1;dp2;dth;dpr1;dpr2;dV;dVr;dthr])
syms F1 F2 real
sol2=solve([dz==-F1*z;dd==-F2*d],[V,dth])
%z1 = solz.Z
%z2 = solz.Z
%%
dz = -V*sin(thr-th);
ddz =  simplify(pdiff(dz,[p1;p2;th;pr1;pr2;V;Vr;thr])*[dp1;dp2;dth;dpr1;dpr2;dV;dVr;dthr])

vv=input_vel([1;0;0],1,[1.5;1;0],1,0.1,1,[1 2],0.1)
input_delta([1;0;0],vv,0.1,0,[1.5;1;0],1,0.1,[1,1])

function v = input_vel(p,th,pr,thr,V,Vr,K,dt)
if V == 0
    v(2,1) = K(2)*Vr; % -K(2)*(V-Vr)
else
    v(2,1) = - K(2)*(V - (V*Vr*cos(th)*cos(thr) + V*Vr*sin(th)*sin(thr))/V) - (K(1)*(V*cos(th)*(p(1) - pr(1)) + V*sin(th)*(p(2) - pr(2))))/V;
end
v(1,1) = V + v(2,1)*dt;
end

function u = input_delta(p,V,dV,th,dth,pr,thr,dthr,F)
if sin(thr)==0
    statez(1,1) = (p(2) - pr(2))/cos(thr);
else
    statez(1,1) = -(p(1) - pr(1))/sin(thr);
end
statez(2,1) = -V*sin(thr-th);
u = -(dV*sin(th - thr) + V*dth*cos(th - thr) - V*dthr*cos(th - thr)) - F*statez;
end




function pd = pdiff(flist, vars)
% % flistをvarsで微分したもののシンボリック配列を返す？
    flist = flist(:);
    vars = vars(:);
%    pd = arrayfun(@(x) diff(flist(1), x), vars)';
    pdiff_tmp = @(flist, vars) arrayfun(@(func) arrayfun(@(x) diff(func, x), vars)',flist,'UniformOutput',false);
    pd = cell2sym(pdiff_tmp(flist,vars));
end
function dh = LieD(h,f,x)
    x = x(:);
    dh = pdiff(h,x)*f;
end
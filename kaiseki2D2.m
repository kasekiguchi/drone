clc
clear
close all
syms p [2 1] real
syms Rb [2 2] real
syms y y2 real 
syms Rs [2 2] real
syms Rn [2 2] real
syms psb [2 1] real
syms a b c  real

A = [a b];
X = Rb*p +Rb*psb + y*Rb*Rs*[1;0];
X2 = Rb*p +Rb*psb + y2*Rb*Rs*Rn*[1;0];
%%
eq =[A c]*[X;1];
eq2 =[A c]*[X2;1];
var=[a.*psb',b.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs))];
for i = 1:length(var)
Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
end
for i = 1:length(var)
Cf2(i) = subs(simplify(eq2-subs(expand(eq2),var(i),0)),var(i),1);
end
Cf = [p1,p2,Cf];
Cf2 = [p1,p2,Cf2];
var = [a,b,var]/c;
simplify([eq/c;eq2/c] - [Cf;Cf2]*var' ) 
Cf12 = [Cf;Cf2];
%% 
% matlabFunction(Cf12,"file","Cf2D","vars",{p Rb y y2 Rn});

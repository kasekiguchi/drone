clc
clear
close all
syms p [3 1] real
syms Rb [3 3] real
syms y y2 real 
syms Rs [3 3] real
syms Rn [3 3] real
syms psb [3 1] real
syms a b c d real

A = [a b c];
X = p +Rb*psb + y*Rb*Rs*Rn*[1;0;0];
%%
eq =[A d]*[X;1];
var=[y];
for i = 1:length(var)
Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
end
simplify([eq/d;eq2/d] - [Cf;Cf2]*var' ) 
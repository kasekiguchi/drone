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
X = p +Rb*psb + y*Rb*Rs*[1;0];
X2 = p +Rb*psb + y2*Rb*Rs*Rn*[1;0];
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

clc
clear
close all    
% Known Parameters
syms p [2 1] real
syms qb [4 1] real
syms y real 
syms y2 real 
% Unknown Parameters
syms Rs [3 3] real
syms psb [3 1] real
syms a b c d real
syms R_num [3 3] real
A = [a b c];
X = p +quat_times_vec(qb,psb) + y*quat_times_vec(qb,Rs*[1;0;0]);
X2 = p +quat_times_vec(qb,psb) + y2*quat_times_vec(qb,Rs*R_num*[1;0;0]);
%%
% eq = [A d]*[X;1];
% eq2= [A d]*[X2;1];
eq=[A d]*[X;1];
eq2= [A d]*[X2;1];
var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
for j = 1:length(var)
    Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
end
for j = 1:length(var)
    Cf2(j) = subs(simplify(eq2-subs(expand(eq2),var(j),0)),var(j),1);
end
Cf = simplify([p1,p2,p3,Cf]);
Cf2 = simplify([p1,p2,p3,Cf2]);
var = [a,b,c,var]/d;
simplify([eq/d;eq2/d] - [Cf;Cf2]*var' )
Cf12 = [Cf;Cf2];
%% 
matlabFunction(Cf12,"file","Cf2_sens","vars",{p qb y y2 R_num});

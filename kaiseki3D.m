clc
clear
close all
syms p [3 1] real
syms Rb [3 3] real
syms y real 
syms y2 real 
syms Rs [3 3] real
syms Rn [3 3] real
syms psb [3 1] real
syms a b c d real

A = [a b c];
X = p +Rb*psb + y*Rb*Rs*[1;0;0];
X2 = p +Rb*psb + y2*Rb*Rs*Rn*[1;0;0];

%%
eq =[A d]*[X;1]+[A d]*[X2;1];
clear Cf
var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
for i = 1:length(var)
Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
end
Cf = [2*p1,2*p2,2*p3,Cf];
ds=find(Cf==0)
Cf(ds)=[];
var = [a,b,c,var]/d;
var(ds)=[];
simplify(eq/d - Cf*var' ) 

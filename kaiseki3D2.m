clc
clear
close all
syms p [3 1] real
syms Rb [3 3] real
syms y real 
syms Rs1 [3 1] real
syms Rs23 [3 2] real
syms Rn [3 3] real
syms psb [3 1] real
syms a b c d real

A = [a b c];
X = p +Rb*psb + y*Rb*[Rs1,Rs23]*Rn*[1;0;0];

%%
eq =[A d]*[X;1];
var=[reshape(a*Rs23,1,numel(Rs23)),reshape(b*Rs23,1,numel(Rs23)),reshape(c*Rs23,1,numel(Rs23))];
for i = 1:length(var)
Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
end
Cf = [(Rb*psb)'+(Rn1_1*y*Rb*Rs1)'+[p1,p2,p3],Cf];
% Cf = [p1,p2,p3,Cf];
ds=find(Cf==0)
Cf(ds)=[];
var = [a,b,c,var]/d;
var(ds)=[];
simplify(eq/d - Cf*var' ) 

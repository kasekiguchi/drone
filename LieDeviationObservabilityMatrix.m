%Lie deviation Observability matrix
clear all;close all;clc;
syms x y theta v w real
syms d psi alpha
syms d2 alpha2
vecx = [x y theta v w d alpha d2 alpha2];
F = [v*cos(theta), v*sin(theta), w , 0, 0, 0, 0, 0, 0]';
z = (d - x*cos(alpha) - y*sin(alpha)) / cos(psi - alpha + theta);
L(1,:) = jacobian(z,vecx);
Lout = L(1,:);
outputs = {'Lout'};
filename = strcat('Ldim', num2str(0));
matlabFunction(Lout, 'file', filename, 'vars', {x,y,theta,v,w,d,alpha,d2,alpha2,psi}, 'outputs', outputs);
LinearSys = jacobian(F,vecx);
dim = 2;
D = 9;
%%
while dim<=D
    L(dim,:) = L(dim-1,:) * LinearSys + (jacobian(L(dim-1,:)',vecx) * F)' ;
    Lout = L(dim,:);
    outputs = {'Lout'};
    filename = strcat('Ldim', num2str(dim-1));
    matlabFunction(Lout, 'file', filename, 'vars', {x,y,theta,v,w,d,alpha,d2,alpha2,psi}, 'outputs', outputs);
    dim = dim + 1;
end

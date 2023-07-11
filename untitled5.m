clc
clear
close all    
% Known Parameters
    syms p [3 1] real
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
    eq=[A d]*[X+X2;2];% [A d]*[X;1]+[A d]*[X2;1] = 0
    var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
    for j = 1:length(var)
        Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
    end
    Cf = simplify([2*p1,2*p2,2*p3,Cf]);
    var = [a,b,c,var]/d;
    simplify(eq/d - Cf*var' )
%% 
matlabFunction(Cf',"file","Cf2_sens","vars",{p qb y y2 R_num});
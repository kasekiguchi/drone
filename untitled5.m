clc
clear
close all    
% Known Parameters
    syms p [3 1] real
    syms qb [4 1] real
    syms y real 
    % Unknown Parameters
    syms Rs [3 3] real
    syms psb [3 1] real
    syms a b c d real
    syms R_num [3 3] real
    A = [a b c];
    X = p +quat_times_vec(qb,psb) + y*quat_times_vec(qb,Rs*[1;0;0]);
    X2 = p +quat_times_vec(qb,psb) + y*quat_times_vec(qb,Rs*R_num*[1;0;0]);
    %%
    eq = [A d]*[X;1];
    eq2= [A d]*[X2;1];
    eq=[A d]*[X+X2;1];
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
    % Cf2 = simplify([p1,p2,p3,Cf2]);
%% 
% matlabFunction(Cf',"file","Cfa","vars",{p qb y R_num});
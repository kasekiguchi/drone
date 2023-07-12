%% 1本目により推定されるオフセット，回転の1本目分かってる前提プログラム
clc
clear
close all
% set path
clear
cf = pwd;
if contains(mfilename('fullpath'),"mainGUI")
  cd(fileparts(mfilename('fullpath')));
else
  tmp = matlab.desktop.editor.getActive; 
  cd(fileparts(tmp.Filename));
end
[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split');
cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
% cd(cf); close all hidden; clear all; userpath('clear');
% Known Parameters
    syms p [3 1] real
    syms qb [4 1] real
    syms y real 
    syms y2 real 
    % Unknown Parameters
    syms Rs1 [3 1] real
    syms Rs23 [3 2] real
    syms psb [3 1] real
    syms a b c d real
    syms Rn [3 3] real
    A = [a b c];
    Rs = [Rs1,Rs23];
    X = p +quat_times_vec(qb,psb) + y*quat_times_vec(qb,[Rs1,Rs23]*Rn*[1;0;0]);
    %%
    eq=[A d]*[X;1];
    var=[reshape(a*Rs23,1,numel(Rs23)),reshape(b*Rs23,1,numel(Rs23)),reshape(c*Rs23,1,numel(Rs23))];
    for j = 1:length(var)
        Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
    end
    Cf = simplify([(quat_times_vec(qb,psb))'+(Rn1_1*y*quat_times_vec(qb,Rs1))'+[p1,p2,p3],Cf]);
    var = [a,b,c,var]/d;
    simplify(eq/d - Cf*var' )
%% 
matlabFunction(Cf',"file","Cf1known","vars",{p qb y Rn psb Rs1});
function [controllable, V] = checkControllable(A,B)
%CHECKCONTROLLABLE 与えた線形状態方程式の可制御性と可制御行列を返す
%   [controllable, V] = checkControllable(A,B)
%   controlleable : 可制御なら1，可制御でないなら0を返す
%   V   : 可制御行列 V = [B, AB, (A^2)B, ..., (A^N-1)B] ただし A∈R^(N*N)
%   A,B : 線形状態方程式 dx/dt = Ax + Bu の係数行列
% 
% **エラー時**
%   A が正方行列でない場合         : controllable に 8 を返す
%   A の列数と B の行数が異なる場合 : controllable に 9 を返す

[NA, MA] = size(A);
[NB, ~] = size(B);

%error check
if(NA~=MA)
    disp('Error!! Aが正方行列でありません')
    controllable = 8;
    V = 0;
elseif(MA~=NB)
    disp('Error!! Aの列数とBの行数が異なっています')
    controllable = 9;
    V = 0;
else
    V = B;
    for i = 1:1:NA-1
        V = [V, (A^i)*B];
    end
    
    Vrank = rank(V)
    [Vsize, ~] = size(V);
    
    if Vrank==Vsize
        disp('システムは可制御です')
        controllable = 1;
    else
        disp('システムは可制御ではありません')
        controllable = 0;
    end
end

end

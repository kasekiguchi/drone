clc
clear
%% MEX
mex test.c
tic
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [1, 2, 3; 4, 5, 6; 7, 8, 9];
result = test(A, B);
calend = toc;
disp(result);
disp(['計算にかかった時間 : ',num2str(calend), '秒']);

%% MATLAB
tic
A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
% A = [1, 2, 3, 4, 5, 6, 7, 8, 9; 1, 2, 3, 4, 5, 6, 7, 8, 9; 1, 2, 3, 4, 5, 6, 7, 8, 9];
% B = A';
% B = [1, 2, 3; 4, 5, 6; 7, 8, 9];
H = 10;
R = diag([1; 1; 1]);

for i = 1:H-1
    result2(1,i)  = A(:, i)'*R*A(:, i);
end
% result2 = A*B;
calend2 = toc;
disp(result2);
disp(['計算にかかった時間 : ',num2str(calend2), '秒']);

%% 
tic
A = [1, 2, 3, 4, 5, 6, 7, 8, 9; 1, 2, 3, 4, 5, 6, 7, 8, 9; 1, 2, 3, 4, 5, 6, 7, 8, 9];
% B = A';
% B = [1, 2, 3; 4, 5, 6; 7, 8, 9];
H = 10;
R = diag([1; 1; 1]);

result3 = arrayfun(@(L) A(:, L)' * R * A(:, L), 1:H-1);

calend3 = toc;
disp(result3);
disp(['計算にかかった時間 : ',num2str(calend3), '秒']);


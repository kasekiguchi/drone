clc
clear
mex test.c

A = [1, 2, 3; 4, 5, 6; 7, 8, 9];
B = [1, 2, 3; 4, 5, 6; 7, 8, 9];
result = test(A, B);
disp(result);

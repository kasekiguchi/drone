%% 
main_KoopmanLinearByData(struct("bilinear",1),'6_8_experiment_1.mat',"hoge");
%% 
A = [1 2 3; 4 5 6];
B = [1 2;3 4];
kron(A,B)

Z = [1;2;3;4];
repmat(Z,1,4)

%%
syms U [3 1] real
syms Z [4 1] real
syms E [4 4] real
E*repmat(Z,1,3)*U

syms X [16 1] real

F = @quaternions_all_26;
oF = matlabFunction(F(X),"vars",{X});
matlabFunction(F(X),"file","fF.m","vars",{X});
%%
clc
tic
rng(1);
for i = 1:1000
  oF(rand(16,1));
end
toc

tic4
rng(1);
for i = 1:1000
  fF(rand(16,1));
end
toc

tic
rng(10 );
for i = 1:1000
  F(rand(16,1));
end
toc


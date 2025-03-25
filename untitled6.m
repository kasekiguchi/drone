load("Hf.mat");
%%


m = 4;
n = 282;
n^2+m*n
size(tH,1)
%%
clear H
H = tH(3*n+1:200*n,:);
%%
H2 = tH(200*n+1:n^2,:);
%%
H3 = tH(n^2+3*m+1:end,:);
%%
z_ids = [1:3*n,n^2+1:n^2+3*m];   
%%
H(:,z_ids) = [];
%%
H2(:,z_ids) = [];
H3(:,z_ids) = [];
%%
HH = [H;H2;H3];
%%
save("H.mat","HH","-v7.3");
%%
save("f.mat","f");
%%
clear H H2 H3 ans
var = quadprog(HH,f);
%%


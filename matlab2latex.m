%% matlab to latex
syms P [1 3] 
syms Q [1 3]
syms V [1 3]
syms W [1 3]
syms q [1 3]
syms m Lx Ly lx ly lz jx jy jz
syms gravity km k
sym length

b = quaternions_all_save;

%%
syms phi theta psi omega_1 omega_2 omega_3 j_x j_y j_z
BB = [W1, W2, W3, Q1, Q2, Q3, jx, jy, jz];
CC = [omega_1, omega_2, omega_3, phi, theta, psi, j_x, j_y, j_z];
B = subs(b(27:end), BB, CC);

%%
texB1 = texlabel(B(1:5));
texB2 = texlabel(B(6:10));
texB3 = texlabel(B(11:15));
texB4 = texlabel(B(16:20));
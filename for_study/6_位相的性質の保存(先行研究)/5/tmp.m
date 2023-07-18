%%
close all; clear; clc;
set(0, 'defaultAxesFontName', 'Times New Roman');
set(0, 'defaultTextFontName', 'Times New Roman');
rng(0)
%%
syms x1 x2
x = [x1;x2];
y = asinh(x);
dy11 = diff(y(1),x1);
dy12 = diff(y(1),x2);
dy21 = diff(y(2),x1);
dy22 = diff(y(2),x2);
dy = [dy11 dy12;dy21 dy22]
dy_inv = dy^-1
inv(dy)





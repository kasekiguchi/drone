clear all;clc;close all;
syms alpha d psi x y theta v w t real
r = (d - x*cos(alpha) - y*sin(alpha)) / cos( psi - alpha + theta);
Nextr = (d - (x + v*cos(theta) * t)*cos(alpha) - (y + v*sin(theta) * t)*sin(alpha)) / cos( psi - alpha + (theta + w * t));
Diffr = Nextr - r;
diffDiffrx = diff(Diffr,x);
diffx = diff(r,x);
% % diffv = diff(r,v);

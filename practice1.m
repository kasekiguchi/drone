clear
clc

syms ddx0 [3 1] real ; syms dol0 [3 1] real; syms dosi [3 1] real; syms doli [3 1] real
syms A [3,3] real; syms B [3,3] real; syms C [3,3] real
syms P1 [3,1] real; syms P2 [3,1] real
syms J0 [3,3] real; syms Ji [3,3] real; syms li [3,3] real; syms qi [3,3] real
syms qihat [3,3] real; syms R0 [3,3] real; syms ro [3,1] real; syms rohat [3,3] real
syms ge3 [3,1] real; syms uip [3,1] real; syms oh02 [3,3] real
syms mi real


enq1 = ddx0 == A*dol0 + P1;
enq2 = B*dol0 == -C*ddx0 + P2;

ddx0 = A*dol0 + P1;
dol0 = simplifyFraction (inv(B)*(-C*ddx0 + P2));
ddx0_2 = simplifyFraction (A*dol0 + P1);
dosi = inv(li)*qi*(ddx0_2-ge3-R0*rohat*dol0+R0*oh02*ro) -inv(mi*li)*qihat*uip;
AA = mi*qi*qi'*R0*rohat;
BB = J0 - mi*rohat*R0'*qi*qi'*R0*rohat;
CC = mi*rohat*R0'*qi*qi';
S = subs(dosi,[A,B,C],[AA,BB,CC]);
ddx0_new = subs(ddx0_2,[A,B,C],[AA,BB,CC]);
dol0_new = subs(dol0,[A,B,C],[AA,BB,CC]);
dosi_new = S;

syms xx yy zz o p q 
subs(xx+yy+zz,[xx,yy,zz],[o,p,q])

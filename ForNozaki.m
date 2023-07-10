clc
clear
close all
syms p [3 1] real
syms Rb [3 3] real
syms y real 

syms Rs [3 3] real
syms psb [3 1] real
syms a b c d real
% Rt=rot3(0,0,0);
syms Rt [3 3] real
A = [a b c];
X = p +Rb*psb + y*Rb*Rs*Rt*[1;0;0];
%%
eq = [A d]*[X;1];
clear Cf
var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
for i = 1:length(var)
    Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
end
Cf = [p1,p2,p3,Cf];
ds=find(Cf==0);
Cf(ds)=[];
var = [a,b,c,var]/d;
var(ds)=[];
simplify(eq/d- Cf*var' ) 


function R  = rot3(roll,pitch,yaw)
    
    Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
    Ry = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
    Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
    R = Rx * Ry * Rz;
    
end

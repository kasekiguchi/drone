clc
clear
close all
syms p [3 1] real
syms Rb [3 3] real
syms y real 

syms Rs [3 3] real
syms Rn [3 3] real
syms psb [3 1] real
syms a b c d real

A = [a b c];
X = p +Rb*psb + y*Rb*Rs*[1;0;0];
X2 = p +Rb*psb + y*Rb*Rs*Rn*[1;0;0];

%%
eq =[A d]*[X;1]+[A d]*[X2;1];
clear Cf
var=[a.*psb',b.*psb',c.*psb',reshape(a*Rs,1,numel(Rs)),reshape(b*Rs,1,numel(Rs)),reshape(c*Rs,1,numel(Rs))];
for i = 1:length(var)
Cf(i) = subs(simplify(eq-subs(expand(eq),var(i),0)),var(i),1);
end
Cf = [p1,p2,p3,Cf];
ds=find(Cf==0)
Cf(ds)=[];
var = [a,b,c,var]/d;
var(ds)=[];
% (Rs2_1*b)/d, (Rs2_2*b)/d, (Rs2_3*b)/d, (Rs3_1*c)/d, (Rs3_2*c)/d, (Rs3_3*c)/d
% var=var(1:length(Cf))
% for i=1:size(delete_value,1)
%     var(length(var)-length(delete_value)+1:length(var))=var(length(var)-length(delete_value)+1:length(var))+delete_value(i,:);
% end

% varn=var(:,1:15)
simplify(eq/d - Cf*var' ) 
% simplify(eq/d - Cfn*varn' -Cf(:,16:21)*var(:,16:21)' )% => 1 となる
% eq/d = Cf*var' +1  == 0
% Cf*var' == -1
% A = [Cf1;Cf2;.....];
% X = var';eq/d - Cf*var'
% B = -1*ones(N,1);
% X = pinv(A)*B;

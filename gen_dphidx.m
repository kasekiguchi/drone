syms x [2 1] real
% syms w [1 3] real
% syms b [1 3] real
syms w1 [2 2] real
syms w2 [2 2] real
syms w3 [2 2] real
syms b1 [2 2] real
syms b2 [2 2] real
syms b3 [2 2] real
%f = asinh(w(3)*asinh(w(2)*asinh(w(1)*x+b(1))+b(2))+b(3));
f = asinh(w3*asinh(w2*asinh(w1*x+b1)+b2)+b3);
df1 = diff(f,x1)
df2 = diff(f,x2)
matlabFunction([df1,df2],"File","dphidx","vars",{x w1 w2 w3 b1 b2 b3})
%df = (w1*w2*w3)/(((b3 + w3*asinh(b2 + w2*asinh(b1 + w1*x)))^2 + 1)^(1/2)*((b2 + w2*asinh(b1 + w1*x))^2 + 1)^(1/2)*((b1 + w1*x)^2 + 1)^(1/2));
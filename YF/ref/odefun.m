function result = odefun(t,x,A,B,input,dt)

%  sysd = ss(A,B,A,0);
%  input = [input;0;0;0;0];
 result = B*input;
%  result = result'
end
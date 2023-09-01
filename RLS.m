function [Xn,Pn] = RLS(A,X,B,P,rho)
    Pn = (P - (P*A'*inv(rho*eye(size(A,1))+ A*P*A')*(A)*P))/rho;
    Xn = X + (P*A'*inv(rho*eye(size(A,1))+ A*P*A'))* (B - A *X);
end

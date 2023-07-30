function [Xn,Pn] = param_analysis_eq(A,X,B,P,rho)
    Pn = (P - (P*A*inv(rho*eye(size(A,2))+ A'*P*A)*(A')*P))/rho;
    % Pn = inv(inv(P)+A*A');
    % Xn = X + Pn * A * (B - A' *X);
     Xn = X + (P*A*inv(rho*eye(size(A,2))+ A'*P*A))* (B - A' *X);
end
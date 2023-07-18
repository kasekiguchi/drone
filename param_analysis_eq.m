function [Xn,Pn] = param_analysis_eq(A,X,B,P)
    % Pn = P - (P*A*(eye(size(A,2))+ A'*P*A)*(A')*P);
    Pn = inv(inv(P)+A*A');
    Xn = X + Pn * A * (B - A' *X);
end
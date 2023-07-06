function [Xn,Pn] = param_analysis_eq(A,X,P)
    Pn = P - (P*A*(A')*P)/(1+A'*P*A);
    Xn = X + Pn * A * (-1 - A' *X);
end
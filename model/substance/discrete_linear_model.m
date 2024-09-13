function X = discrete_linear_model(x,u,P)
% u : force to x,y,z axis and 0
    if isfield(P,'A')
        A=P.A;
    else
        error("This model requires A and B fields on param.");
    end
    if isfield(P,'B')
        B = P.B;
    else
        error("This model requires A and B fields on param.");
    end
    %使用した観測量に応じて変更---
    z = quaternions_all(x);
    %----------------------------
    % X(1:3) = x()
    Z = A*z+B*u;
    X = P.C*Z;
    %% without position observables
    % X = [x(1:3) + 0.025 * X(1:3); X];
end

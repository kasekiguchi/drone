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
    x = observables_quaternion_base(x);
    X = A*x+B*u;
    X = P.C*X;
end

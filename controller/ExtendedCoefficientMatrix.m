%-- ベクトル化するための関数
function [ECM] = ExtendedCoefficientMatrix(Param)
    % ECM:Extended Coeifficient Matrix
    A = Param{1};
    B = Param{2};
    Horizon = Param{3};
    Xnum = Param{4};

    S = zeros(Horizon*Xnum, Horizon*length(B(1,:)));

    % ホライズンの値によらない
    % A行列
    Am = [];
    for i = 1:Horizon
        Am = [Am; A^i]; %A
    end
    % B行列
    for i  = 1:Horizon
        for j = 1:Horizon
            if j <= i
                S(1+length(B(:,1))*(i-1):length(B(:,1))*i,1+length(B(1,:))*(j-1):length(B(1,:))*j) = A^(i-j)*B;
            end
        end
    end
    ECM.A = Am;
    ECM.B = S;

end
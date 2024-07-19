%quadprogを使用するために評価関数を変換するための関数
%x^THx+f^Txにする必要がある x:最適化変数
%[input]
%Param.A:クープマンモデルの係数行列
%Param.B:クープマンモデルの入力ベクトル
%Param.C:クープマンモデルの出力ベクトル
%Param.weight:MPCの各重み
%Param.H:MPCのホライズン数
%Param.ref:目標値
%------------------------------------------------
%[output]
%H:評価関数変形後のH
%f:評価関数変形後のf
%------------------------------------------------

function [H, F] = change_equation_drone(Param)
    A = Param.A;
    B = Param.B;
    C = Param.C;

    Q = Param.weight;
    R = Param.weightR;
    Qf = Param.weightF;
    Horizon = Param.H;

    % Qrep = repmat(Q, 1, Horizon);
    % Q = Qrep .* linspace(1, 0.5, Horizon);

    CQC = C' * Q * C;
    CQfC = C' * Qf * C;
    QC = Q * C;
    QfC = Qf * C;
    S = zeros(Horizon*size(A,1), Horizon*length(B(1,:)));

    % ホライズンの値によらない
    Rm = cell(1,Horizon);
    Qm = cell(1,Horizon);
    qm = cell(1,Horizon);
    Am = [];
    for i = 1:Horizon
        Rm{i} = R;   %R
        Qm{i} = CQC; %Q
        qm{i} = QC;  %Q'
        Am = [Am; A^i]; %A
    end
    endidx = Horizon - 1;
    Rm = blkdiag(Rm{1:endidx}, zeros(4)); 
    Qm = blkdiag(Qm{1:endidx}, CQfC);
    qm = blkdiag(qm{1:endidx}, QfC);

    for i  = 1:Horizon
        for j = 1:Horizon
            if j <= i
                S(1+length(B(:,1))*(i-1):length(B(:,1))*i,1+length(B(1,:))*(j-1):length(B(1,:))*j) = A^(i-j)*B;
            end
        end
    end
    
    H = S' * Qm * S + Rm;
    H = (H+H')/2;
    F = [Am' * Qm * S; -qm * S; -Rm];

    %fはmexファイル内で行う 
    % f = @(x, r, ur) [x', r', ur'] * F;
end
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

function [H, f] = change_equation(Param)
    A = Param.A;
    B = Param.B;
    C = Param.C;

    % Q = blkdiag(Param.weight.P, Param.weight.V, Param.weight.QW);
    Q = Param.weight;
    R = Param.weightR;
    % Qf = blkdiag(Param.weight.Pf, Param.weight.Vf, Param.weight.QWf);
    Qf = Param.weightF;
    Horizon = Param.param.H;

    % 使用した観測量に応じて変更-----------------------------------------
    % Xc = quaternions_all(Param.current_state); %現在状態,観測量：状態+非線形項
    % クープマン以外のとき-----------------------------------------------
    Xc = Param.current_state; 
    %-------------------------------------------------------------------
    r  = Param.reference.xr(1:12,:);
    r = r(:); %目標値、列ベクトルに変換
    ur = Param.reference.xr(13:16,:);
    ur = ur(:); %目標入力、列ベクトルに変換

    CQC = C' * Q * C;
    CQfC = C' * Qf * C;
    QC = Q * C;
    QfC = Qf * C;
    
    % Rm = blkdiag(R, R, R, R, R, R, R, R, R, zeros(4)); %R
    % Am = [A; A^2; A^3; A^4; A^5; A^6; A^7; A^8; A^9; A^10]; %A
    % Qm = blkdiag(CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQfC); %Q
    % qm = blkdiag(QC, QC, QC, QC, QC, QC, QC, QC, QC, QfC); %Q'

    % ホライズンの値によらない
    Am = [];
    for i = 1:Horizon
        Rm{i} = R;   %R
        Qm{i} = CQC; %Q
        qm{i} = QC;  %Q'
        Am = [Am; A^i]; %A
    end
    Rm = blkdiag(Rm{1:end-1}, zeros(4)); 
    Qm = blkdiag(Qm{1:end-1}, CQfC);
    qm = blkdiag(qm{1:end-1}, QfC);

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
    f = [Xc', r', ur'] * F;

end
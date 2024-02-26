function [H, f] = change_equation(Param)
    A = Param.A;
    B = Param.B;
    C = Param.C;

    Q = blkdiag(Param.weight.P, Param.weight.V, Param.weight.QW);
    R = Param.weight.R;
    Qf = blkdiag(Param.weight.Pf, Param.weight.Vf, Param.weight.QWf);
    Horizon = Param.H;

    Xc = quaternions(Param.current); %現在状態,観測量：状態+非線形項
    % Xc = [Param.current;1];
    r  = Param.ref(1:12,:);
    r = r(:); %目標値、列ベクトルに変換
    ur = Param.ref(13:end,:);
    ur = ur(:); %目標入力、列ベクトルに変換

    CQC = C' * Q * C;
    CQfC = C' * Qf * C;
    QC = Q * C;
    QfC = Qf * C;
    
    Rm = blkdiag(R, R, R, R, R, R, R, R, R, zeros(4)); %R
    Am = [A; A^2; A^3; A^4; A^5; A^6; A^7; A^8; A^9; A^10]; %A
    Qm = blkdiag(CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQfC); %Q
    qm = blkdiag(QC, QC, QC, QC, QC, QC, QC, QC, QC, QfC); %Q'

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
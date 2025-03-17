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
    Rp = Param.weightRp;
    Qf = Param.weightF;
    Horizon = Param.H;

    % Qrep = repmat(Q, 1, Horizon);
    % Q = Qrep .* linspace(1, 0.5, Horizon);

    CQC = C' * Q * C;
    CQfC = C' * Qf * C;
    QC = Q * C;
    QfC = Qf * C;
    S = zeros(Horizon*size(A,1), Horizon*length(B(1,:)));

    %% ホライズンの値によらない
    Rm = cell(1,Horizon);
    Qm = cell(1,Horizon);
    qm = cell(1,Horizon);
    Am = []; % 空の配列の方が記述が楽だった + コンストラクタのみ実行だから速度は問題なし
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

    %% ホライズンH=10 固定値 from kiyama
    % Rm = blkdiag(R, R, R, R, R, R, R, R, R, zeros(4)); %R
    % Rmp = blkdiag(Rp, Rp, Rp, Rp, Rp, Rp, Rp, Rp, Rp, zeros(4)); %Rp
    % Am = [A; A^2; A^3; A^4; A^5; A^6; A^7; A^8; A^9; A^10]; %A
    % Qm = blkdiag(CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQC, CQfC); %Q
    % qm = blkdiag(QC, QC, QC, QC, QC, QC, QC, QC, QC, QfC); %Q'

    for i  = 1:Horizon
        for j = 1:Horizon
            if j <= i
                S(1+length(B(:,1))*(i-1):length(B(:,1))*i,1+length(B(1,:))*(j-1):length(B(1,:))*j) = A^(i-j)*B;
            end
        end
    end
    
    H = S' * Qm * S + Rm; %default
    % H = S' * Qm * S + Rm + Rmp;
    H = (H+H')/2;
    F = [Am' * Qm * S; -qm * S; -Rm]; % default
    % F = [Am' * Qm * S; -qm * S; -Rm; -Rmp];

    %fはmexファイル内で行う 
    % f = @(x, r, ur) [x', r', ur'] * F;
end
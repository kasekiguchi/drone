function output = KL(X,U,Y,F,flg)
%KL クープマン線形化によって線形アフィン系状態方程式の係数行列ABCを求める
%   output = KoopmanLinear(X,U,Y)
%   outuput.A .B  観測量空間における線形アフィン系の係数行列 Z[k+1] = A*Z[k]+Bu[k]
%          .C     観測量空間から状態空間に送る線形状態方程式の係数行列 X[k] = C*Z[k]
%   X, U, Y       観測する状態Xに入力Uを与えた際の出力Yを集めたデータセット
%                 列：データ, 行：時系列
%   F             観測量 関数ハンドル
tic
%Xlift,Yliftを計算する
remi = round(size(X,2) / 5); j = 0;
for i = 1:size(X,2)%1:Data.num
    % if flg.hermite
        dx = [X(:,i);U(:,i)]; % hermite
        dy = [Y(:,i);U(:,i)];
    % else
        % dx = X(:,i); % ふつう
        % dy = Y(:,i);
    % end
    Xlift(:,i) = F(dx); 
    Ylift(:,i) = F(dy);
    if rem(i, remi) == 0
        j = j+1;
        fprintf('convert %d times observables \n', remi*j);
        toc
    end
end

[numX, ~] = size(Xlift); %[numX, ~]=size(Xlift): Xliftのサイズ=(A行,B列)のとき，A行の値をnumXに入れ，B列の値は使わない(~:notの意味)
[numU, ~] = size(U);

% %ABをまとめて計算する 参考資料記載のやりかた
% M = Ylift * pinv([Xlift; U]);
% A = M(1 : numX, 1 : numX);
% B = M(1 : numX, numX + 1:numX + numU);
% C = X*pinv(Xlift);

%% A,Bをまとめて計算するデータ数が多い場合のやりかた
if flg.weight 
    % 磯部とエルミートで重みわける code23
    % Q_isobe = blkdiag(flg.weight_Qisobe, eye(26-12));
    % Q_hermite_k1_k2 = eye(256); % 状態以外の観測量部分は1とする
    % Q_hermite_k3_k4 = eye(256) * flg.weight_Qhermite;
    % Q_hermite = blkdiag(Q_hermite_k1_k2, Q_hermite_k3_k4);
    % Q = blkdiag(Q_isobe, Q_hermite);

    Q = blkdiag(flg.weight_Qisobe, eye(26-12)); % 00
    % Q = blkdiag(flg.weight_Qisobe, eye(36-12)); % 02
    % Q = blkdiag(flg.weight_Qisobe(4:end,4:end), eye(23-9)); % 10

    % code22
    % Q = blkdiag(flg.weight_Qisobe, eye(4), eye(256), eye(256)*flg.weight_Qhermite);

    % code26, code27
    % Q = blkdiag(flg.weight_Qisobe, eye(14), eye(256)*flg.weight_Qhermite);
    
    % code28
    % Q = blkdiag(flg.weight_Qisobe, eye(14), eye(32)*flg.weight_Qhermite);

    % 磯部のうち、[回転行列,1]以外は重み
    % Q = blkdiag(flg.weight_Qisobe, eye(4), eye(10)*1.00001);

    % Q = blkdiag(flg.weight_Qp, flg.weight_Qq, flg.weight_Qv, flg.weight_Qw, eye(numX-12)); 
    % 汎用性のためにflgにweightを格納
    G = [Xlift ; U]*[Xlift ; U]'; fprintf('finished get G\n');           % size(G) = (numX+numU, numX+numU)
    V = (Q*Ylift)*[(Q*Xlift) ; U]'; fprintf('finished get V\n');         % size(V) = (numX,      numX+numU)
    M = V * pinv(G); fprintf('finished get V*pinv(G) \n');               % size(M) = (numX,      numX+numU)
    output.A = M(1:numX, 1:numX); fprintf('finished get A \n');          % size(.A) = (numX, numX)
    output.B = M(1:numX, numX+1:numX+numU); fprintf('finished get B \n');% size(.B) = (numX, numU)
    if flg.without_pos
        output.C = (Q(1:9,1:9)*X)*pinv(Q*Xlift); fprintf('finished get C\n');
    else
        output.C = (Q(1:12,1:12)*X)*pinv(Q*Xlift); fprintf('finished get C\n');
    end
else
    G = [Xlift ; U]*[Xlift ; U]'; % size(G) = (numX+numU, numX+numU)
    V = Ylift*[Xlift ; U]';       % size(V) = (numX,      numX+numU)
    M = V * pinv(G);              % size(M) = (numX,      numX+numU)
    output.A = M(1:numX, 1:numX); % size(.A) = (numX, numX)
    output.B = M(1:numX, numX+1:numX+numU); % size(.B) = (numX, numU)
    output.C = X*pinv(Xlift); % C: Z->X の厳密な求め方 pinv: Moore-Penrose疑似逆行列  size(.C) = (size(X), numX)
end
toc
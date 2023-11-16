function out = mattimesvec(m,v)
%MATTIMES 行列*ベクトル(列)の乗算
%   要素毎を手動で掛け算
%   dlarray型の場合にラベルによる不具合が発生するため作成
%   m：A行列
%   v：状態ベクトル

s = size(m); % A行列サイズ
r = s(1); % 行
c = s(2); % 列

out = zeros(r,1); % 出力初期化
for i = 1:r
    term = 0;
    for j = 1:c
        term = term + m(i,j) * v(j,1);
    end
    out(i,1) = term;
end


end


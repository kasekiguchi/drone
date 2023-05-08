    function [xr] = Reference2(H, Y, dT)
        % 参照軌道を計算するプログラム
        % 入力引数: ホライゾン H, 目標入力 Ur, 現在時刻で得られた観測値 Y, モデル予測制御の刻み幅 dT
        xr = zeros(4, H);
        % 予測したX座標が2.5 m以上であるときY座標を1 mに設定
            for L = 1:H
                if Y(1) + 0.5*(L-1)*dT >= 2.5
                    xr(:, L) = [Y(1) + 0.5*(L-1)*dT; 1.; 0.5; 0];
                else
                    xr(:, L) = [Y(1) + 0.5*(L-1)*dT; 0.; 0.5; 0];
                end
            end
    end
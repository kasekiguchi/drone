function [uOpt, fval] = clustering(obj, pw, pu, px)
    % 制約から外れているものはサンプルから取り除く
    % サンプル数が減るためリサンプリング時に増やす(頭数を合わせる処理が別に必要？)
    % ここ以降ではpxがpu,pwとインデックス的に対応しなくなることに注意
	DT = obj.dt;
	
    k_sigma = 10.0;
    thr = k_sigma; 
    
    % 最適解の算出(リサンプリング前に評価関数の値に基づいて抜き出し，入力列間の距離に応じてクラスタリングする方法)
    [sortFval, sortIdx] = sort(pw);
    % リサンプリング前に評価値の良いものから並べ替え，トップからx%を抜き出し
    sortIdxT = sortIdx(1:ceil(0.05 * length(pw)));
    pwT = pw(sortIdxT);
    puT = pu(:, :, sortIdxT);
    pxT = px(:, :, sortIdxT);
    
%     figure
%     for i = 1:length(sortIdxT)
%         plot(pxT(1,:,i),pxT(2,:,i));hold on
%     end
%     axis equal
    % 1番いいものを1つ目のクラスタとする
    pcT = zeros(1,length(pwT));
    pcT(1) = 1;
    cNum = 1;
    
    % 2番目以降を存在するクラスタ(2番目においては1つ目のクラスタのみ)全てと距離比較
    % 距離が閾値以下なら同じクラスタに追加，閾値より大きいなら新しいクラスタにする　ここを抜き出したサンプル分繰り返す
    for i = 2:length(pwT)
        for j = 1:cNum
%             dist(j) = norm(puT(:,:,i) - mean(puT(:,:,pcT==j),3)); % i番目のサンプルとj番目のクラスタの距離を求める
            dist(j) = sum((pxT(:, :, i) - mean(pxT(:, :, pcT == j), 3)).^2,'all');
        end
        [minDist, minIdx] = min(dist);
        if minDist < thr(minIdx)
            pcT(i) = minIdx;
%             thr(minIdx) = minDist;
        else
            cNum=cNum+1;
            pcT(i) = cNum;
            thr(cNum) = k_sigma;
        end
    end
    % クラスタごとに重み付き平均をとり，入力列と評価値をクラスタ数分だけ出力する
%     if isempty(puT)
%         fval = [];
%     else
% 自分の状態方程式に直す．
        for j=1:cNum
            uOpt.u(j).u = mean(puT(:, :, pcT == j), 3);
            fval.f(j).f = mean(pwT(pcT == j));
        end
        for j = 1:cNum
            uOpt.u(j).x = px(:, 1, 1);
            for i = 1:length(DT)
                uOpt.u(j).x(1, i + 1) = uOpt.u(j).x(1, i) + uOpt.u(j).u(1, i) * DT;
                uOpt.u(j).x(2, i + 1) = uOpt.u(j).x(2, i) + uOpt.u(j).u(1, i) * DT;
            end
        end
%     end
    uOpt.cNum = cNum;
    uOpt.pcT = pcT;
    uOpt.puT = puT;
    uOpt.pxT = pxT;
%     cNum
end
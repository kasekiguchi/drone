function attitude_norm = checkQuaternionNorm(Q,thre)
%CHECKQUATERNIONNORM クォータニオンのノルムをチェック
% 閾値を下回った or 上回った場合注意文を表示
% Q :クォータニオン ↓状態 →時系列
% thre :閾値
for i=1:size(Q,2)
    attitude_norm(i) = norm(Q(:,i));
end
over_threshold=attitude_norm(attitude_norm>1+thre);
lower_threshold=attitude_norm(attitude_norm<1-thre);
if find(over_threshold)
    disp('Caution! Quaternions over the norm 1 are included.')
    disp('Press any key to continue the simulation.')
    pause
end
if find(lower_threshold)
    disp('Caution! Quaternions lower the norm 1 are included.')
    disp('Press any key to continue the simulation.')
    pause
end

end


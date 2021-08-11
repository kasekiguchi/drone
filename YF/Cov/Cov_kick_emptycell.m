function data = Cov_kick_emptycell(data)
%arrayfun から出てくる形態で送る
 ind = cellfun(@isempty,data); % セル内の空の値を検出
 r_ind = all(ind,1); % 全ての行が 空の列を検出
 data(:,r_ind) = []; % セルから削除
 ind(:,r_ind) = []; % 上記に同期してインデックスも削除
 c_ind = all(ind,2); % 全ての列が 空の行を検出
 data(c_ind,:) = []; % セルから削除
end
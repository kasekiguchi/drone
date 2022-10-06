function parameter = UKFCombiningLines(obj, s)
% s : estimator.LSA_param
% 既存線分(obj.map_param)と観測線分(s)の統合を行う
% 論文の3.2.3に該当
% 関口チェック済み
map = obj.map_param;
C = obj.constant;
if isempty(map)
    parameter = s;
else
    for i = 1:size(s.id,1)
        % Select matching line : all をとることで始点と終点両方が満たしているもののみ取り出す．
        close_ids = find(all(abs(map.a * s.x(i, :) + map.b * s.y(i, :) + map.c) < C.LineThreshold, 2));
        % Check the distance of line segments in map and s
        lap_ids = IsClose(s.x(i,:),s.y(i,:),map.x(close_ids,:),map.y(close_ids,:),C.LineDistance); % close_idsのなかのid
        match_ids = close_ids(lap_ids);
        flag_id= match_ids;
        if ~isempty(flag_id) % 結合すべきラインがある場合
            % Combine map and measurement. Expect for first is not considered because it is the role for 'OptimizeMap' function.
            param = UKFCombiningTwoLines(obj, flag_id(1), s, i, C);
            map.x(flag_id(1), :) = param.x;
            map.y(flag_id(1), :) = param.y;
        else
            % Append the measurement into the map
            map.id(end + 1, :) = s.id(i, :);
            map.x(end + 1, :) = s.x(i, :);
            map.y(end + 1, :) = s.y(i, :);
            map.a(end + 1, :) = s.a(i, :);
            map.b(end + 1, :) = s.b(i, :);
            map.c(end + 1, :) = s.c(i, :);
        end
    end
    % assignment of map
    parameter = map;
end
end

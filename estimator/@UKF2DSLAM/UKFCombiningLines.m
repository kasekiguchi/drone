function parameter = UKFCombiningLines(obj, s, p)
% s : estimator.LSA_param
% 既存線分(obj.map_param)と観測線分(s)の統合を行う
% 論文の3.2.3に該当
map = obj.map_param;
C = obj.constant;
if isempty(map)
    parameter = s;
else
  % map の中でセンサーレンジ内のmap内の壁面インデックスを抽出
  I = extract_in_range_wall_index(map,obj.constant.SensorRange,p(1:2));
    
    for i = 1:size(s.x,1)
        % Select matching line : all をとることで始点と終点両方が満たしているもののみ取り出す．
        close_ids = I(all(abs(map.a(I) * s.x(i, :) + map.b(I) * s.y(i, :) + map.c(I)) < C.SegmentThreshold, 2));
        % Check the distance of line segments in map and s
        T = [s.x(i,:);s.y(i,:)];
        T = abs(T(:,2)-T(:,1));
        if T(1) > T(2) % x に注目する場合
            lap_ids = IsOverlap(s.x(i,1),s.x(i,2),map.x(close_ids,1),map.x(close_ids,2)); % close_idsのなかのid
        else
            lap_ids = IsOverlap(s.y(i,1),s.y(i,2),map.y(close_ids,1),map.y(close_ids,2)); % close_idsのなかのid
        end
        flag_id = close_ids(lap_ids);
        if ~isempty(flag_id) % 結合すべきラインがある場合
            % Combine map and measurement. Expect for first is not considered because it is the role for 'OptimizeMap' function.
            j = flag_id(1);
            param = extract_max_line_segment([map.x(j,:)',map.y(j,:)';s.x(i,:)',s.y(i,:)']);
            map.x(flag_id(1), :) = param.x;
            map.y(flag_id(1), :) = param.y;
        else
            % Append the measurement into the map
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

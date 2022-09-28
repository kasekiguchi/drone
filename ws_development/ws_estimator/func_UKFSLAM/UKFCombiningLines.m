function parameter = UKFCombiningLines(map, s, C)
% map : estimated map : estimator.map_param
% s : estimator.LSA_param
% C : estimator.constant 
% 既存線分と観測線分の統合を行う
% 論文の3.2.3に該当
% 関口チェック済み
    if isempty(map)
        parameter = s;
%         parameter = struct;
%         parameter.index = [];
%         parameter.x = [];
%         parameter.y = [];
%         parameter.a = [];
%         parameter.b = [];
%         parameter.c = [];
%         % Assign s value to parameter including enough number of points
%         for i = 1:size(s.index,1)
%             if s.index(i, 2) - s.index(i, 1) < C.GroupNumberThreshold
%                 continue;
%             end
%             parameter.index(end + 1, :) = s.index(i, :);
%             parameter.x(end + 1, :) = s.x(i, :);
%             parameter.y(end + 1, :) = s.y(i, :);
%             parameter.a(end + 1, :) = s.a(i, :);
%             parameter.b(end + 1, :) = s.b(i, :);
%             parameter.c(end + 1, :) = s.c(i, :);
%         end
    else
        for i = 1:size(s.index,1)
            % If there are not enough number of points, s value is not map.
%             if s.index(i, 2) - s.index(i, 1) < C.GroupNumberThreshold
%                 continue;
%             end
            % Select matching line : all をとることで始点と終点両方が満たしているもののみ取り出す．
            close_ids = find(all(abs(map.a * s.x(i, :) + map.b * s.y(i, :) + map.c) < C.LineThreshold, 2));
            % Check the distance of line segments in map and s
            lap_ids = IsClose(s.x(i,:),s.y(i,:),map.x(close_ids,:),map.y(close_ids,:),C.LineDistance); % close_idsのなかのid
            %             if s.a(i) > -1 && s.a(i) < 1  
%                 Flag2 = IsOverlap(s.x(i, 1), s.x(i, 2), map.x(:, 1), map.x(:, 2));
%             else
%                 Flag2 = IsOverlap(s.y(i, 1), s.y(i, 2), map.y(:, 1), map.y(:, 2));
%             end
            % checking line distance            
%             ssFlag3 = sqrt((map.x(:, 1) - s.x(i,1)).^2 + (map.y(:, 1) - s.y(i,1)).^2)< C.LineThreshold;%マップの始点との距離
%             seFlag3 = sqrt((map.x(:, 1) - s.x(i,2)).^2 + (map.y(:, 1) - s.y(i,2)).^2)< C.LineThreshold;%始点と終点の距離
%             esFlag3 = sqrt((map.x(:, 2) - s.x(i,1)).^2 + (map.y(:, 2) - s.y(i,1)).^2)< C.LineThreshold;%既存マップの終点と観測マップの始点との距離
%             eeFlag3 = sqrt((map.x(:, 2) - s.x(i,2)).^2 + (map.y(:, 2) - s.y(i,2)).^2)< C.LineThreshold;%既存マップの終点と観測マップの終点との距離
%             %Flag3はいらない可能性がある
%             Flag3 = ssFlag3 | seFlag3 | esFlag3 | eeFlag3;
%             % Searching valid values
%             Flag4 = Flag1 & Flag2 & Flag3;
    match_ids = close_ids(lap_ids);
%flag_index = find(Flag4);
flag_index= match_ids;
            if ~isempty(flag_index) % 結合すべきラインがある場合
                % Combine map and measurement. Expect for first is not considered because it is the role for 'OptimizeMap' function.
                param = UKFCombiningTwoLines(map, flag_index(1), s, i, C);
                map.x(flag_index(1), :) = param.x;
                map.y(flag_index(1), :) = param.y;
            else
                % Append the measurement into the map
                map.index(end + 1, :) = s.index(i, :);
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

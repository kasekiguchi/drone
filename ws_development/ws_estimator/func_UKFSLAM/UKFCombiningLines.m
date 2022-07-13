function parameter = UKFCombiningLines(map, measured, Constant)
% 既存線分と観測線分の統合を行う
% 論文の3.2.3に該当
    if isempty(map)
        parameter = struct;
        parameter.index = [];
        parameter.x = [];
        parameter.y = [];
        parameter.a = [];
        parameter.b = [];
        parameter.c = [];
        % Assign measured value to parameter including enough number of points
        for i = 1:size(measured.index,1)
            if measured.index(i, 2) - measured.index(i, 1) < Constant.GroupNumberThreshold
                continue;
            end
            parameter.index(end + 1, :) = measured.index(i, :);
            parameter.x(end + 1, :) = measured.x(i, :);
            parameter.y(end + 1, :) = measured.y(i, :);
            parameter.a(end + 1, :) = measured.a(i, :);
            parameter.b(end + 1, :) = measured.b(i, :);
            parameter.c(end + 1, :) = measured.c(i, :);
        end
    else
        for i = 1:size(measured.index,1)
            % If there are not enough number of points, measured value is not map.
            if measured.index(i, 2) - measured.index(i, 1) < Constant.GroupNumberThreshold
                continue;
            end
            % Checking the error from line of map less than threshold
            Flag1 = all(abs(map.a * measured.x(i, :) + map.b * measured.y(i, :) + map.c) < Constant.LineThreshold, 2);
            % Checking the overlap of each line
            if measured.a(i) > -1 && measured.a(i) < 1  
                Flag2 = IsOverlap(measured.x(i, 1), measured.x(i, 2), map.x(:, 1), map.x(:, 2));
            else
                Flag2 = IsOverlap(measured.y(i, 1), measured.y(i, 2), map.y(:, 1), map.y(:, 2));
            end
            % checking line distance            
            ssFlag3 = sqrt((map.x(:, 1) - measured.x(i,1)).^2 + (map.y(:, 1) - measured.y(i,1)).^2)< Constant.LineThreshold;%マップの始点との距離
            seFlag3 = sqrt((map.x(:, 1) - measured.x(i,2)).^2 + (map.y(:, 1) - measured.y(i,2)).^2)< Constant.LineThreshold;%始点と終点の距離
            esFlag3 = sqrt((map.x(:, 2) - measured.x(i,1)).^2 + (map.y(:, 2) - measured.y(i,1)).^2)< Constant.LineThreshold;%既存マップの終点と観測マップの始点との距離
            eeFlag3 = sqrt((map.x(:, 2) - measured.x(i,2)).^2 + (map.y(:, 2) - measured.y(i,2)).^2)< Constant.LineThreshold;%既存マップの終点と観測マップの終点との距離
            %Flag3はいらない可能性がある
            Flag3 = ssFlag3 | seFlag3 | esFlag3 | eeFlag3;
            % Searching valid values
            Flag4 = Flag1 & Flag2 & Flag3;
            flag_index = find(Flag4);
            if ~isempty(flag_index)
                % Combine map and measurement. Expect for first is not considered because it is the role for 'OptimizeMap' function.
                param = UKFCombiningTwoLines(map, flag_index(1), measured, i, Constant);
                map.x(flag_index(1), :) = param.x;
                map.y(flag_index(1), :) = param.y;
            else
                % Append the measurement into the map
                map.index(end + 1, :) = measured.index(i, :);
                map.x(end + 1, :) = measured.x(i, :);
                map.y(end + 1, :) = measured.y(i, :);
                map.a(end + 1, :) = measured.a(i, :);
                map.b(end + 1, :) = measured.b(i, :);
                map.c(end + 1, :) = measured.c(i, :);
            end
        end
        % assignment of map
        parameter = map;
    end
end

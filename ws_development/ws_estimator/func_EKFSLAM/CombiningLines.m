function parameter = CombiningLines(Map, LSAPram, Constant)
    if isempty(Map)
        parameter = struct;
        parameter.index = [];
        parameter.x = [];
        parameter.y = [];
        parameter.a = [];
        parameter.b = [];
        parameter.c = [];
        % Assign measured value to parameter including enough number of points
        for i = 1:size(LSAPram.index,1)
            if LSAPram.index(i, 2) - LSAPram.index(i, 1) < Constant.GroupNumberThreshold
                continue;
            end
            parameter.index(end + 1, :) = LSAPram.index(i, :);
            parameter.x(end + 1, :) = LSAPram.x(i, :);
            parameter.y(end + 1, :) = LSAPram.y(i, :);
            parameter.a(end + 1, :) = LSAPram.a(i, :);
            parameter.b(end + 1, :) = LSAPram.b(i, :);
            parameter.c(end + 1, :) = LSAPram.c(i, :);
        end
    else
        for i = 1:size(LSAPram.index,1)
            % If there are not enough number of points, measured value is not map.
            if LSAPram.index(i, 2) - LSAPram.index(i, 1) < Constant.GroupNumberThreshold
                continue;
            end
            % Checking the error from line of map less than threshold%マップの点としてずれていないかを判定
            flag_1 = all(abs(Map.a * LSAPram.x(i, :) + Map.b * LSAPram.y(i, :) + Map.c) < Constant.LineThreshold, 2);
            % Checking the overlap of each line
            if LSAPram.a(i) > -1 && LSAPram.a(i) < 1
                flag_2 = IsOverlap(LSAPram.x(i, 1), LSAPram.x(i, 2), Map.x(:, 1), Map.x(:, 2));
            else
                flag_2 = IsOverlap(LSAPram.y(i, 1), LSAPram.y(i, 2), Map.y(:, 1), Map.y(:, 2));
            end
            % Searching valid values
            flag_3 = flag_1 & flag_2;
            flag_index = find(flag_3);
            if ~isempty(flag_index)
                % Combine map and measurement. Expect for first is not considered because it is the role for 'OptimizeMap' function.
                param = CombiningTwoLines(Map, flag_index(1), LSAPram, i, Constant);
                Map.x(flag_index(1), :) = param.x;
                Map.y(flag_index(1), :) = param.y;
            else
                % Append the measurement into the map
                Map.index(end + 1, :) = LSAPram.index(i, :);
                Map.x(end + 1, :) = LSAPram.x(i, :);
                Map.y(end + 1, :) = LSAPram.y(i, :);
                Map.a(end + 1, :) = LSAPram.a(i, :);
                Map.b(end + 1, :) = LSAPram.b(i, :);
                Map.c(end + 1, :) = LSAPram.c(i, :);
            end
        end
        % assignment of map
        parameter = Map;
    end
end

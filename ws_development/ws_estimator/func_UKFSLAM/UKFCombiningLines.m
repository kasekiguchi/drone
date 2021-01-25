function parameter = UKFCombiningLines(map, measured, Constant)
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
            flag_1 = all(abs(map.a * measured.x(i, :) + map.b * measured.y(i, :) + map.c) < Constant.LineThreshold, 2);
            % Checking the overlap of each line
            if measured.a(i) > -1 && measured.a(i) < 1  
                flag_2 = IsOverlap(measured.x(i, 1), measured.x(i, 2), map.x(:, 1), map.x(:, 2));
            else
                flag_2 = IsOverlap(measured.y(i, 1), measured.y(i, 2), map.y(:, 1), map.y(:, 2));
            end
            % Searching valid values
            flag_3 = flag_1 & flag_2;
            flag_index = find(flag_3);
            if ~isempty(flag_index)
                % Combine map and measurement. Expect for first is not considered because it is the role for 'OptimizeMap' function.
                param = CombiningTwoLines(map, flag_index(1), measured, i, Constant);
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

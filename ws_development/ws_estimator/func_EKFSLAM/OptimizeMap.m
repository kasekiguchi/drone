function [opt_map, removing_flag] = OptimizeMap(map, Constant)
    % Initialize each variable
    opt_map = struct;
    opt_map.index = [];
    opt_map.x = [];
    opt_map.y = [];
    opt_map.a = [];
    opt_map.b = [];
    opt_map.c = [];
    add_array = false(1, length(map.index));
    removing_flag = false(1, length(map.index));
    for i = 1:length(map.index)
        % Searching the line which is able to be conbined
        if map.a(i) > -1 && map.a(i) < 1
            % When the line is not vertical, comparing with 'y' values
            flag_1 = all(abs(map.a(i,:) * map.x + map.b(i,:) * map.y + map.c(i,:)) < Constant.LineThreshold, 2);
            flag_2 = vecnorm(map.y(i, 1) - map.y(:, 1), 2, 2) < Constant.LineThreshold;
            flag_3 = vecnorm(map.y(i, 2) - map.y(:, 2), 2, 2) < Constant.LineThreshold;
            flag_4 = IsOverlap(map.x(i, 1), map.x(i, 2), map.x(:, 1), map.x(:, 2));
        else
            % When the line is vertical, comparing with 'x' values
            flag_1 = all(abs(map.a(i,:) * map.x + map.b(i,:) * map.y + map.c(i,:)) < Constant.LineThreshold, 2);
            flag_2 = vecnorm(map.x(i, 1) - map.x(:, 1), 2, 2) < Constant.LineThreshold;
            flag_3 = vecnorm(map.x(i, 2) - map.x(:, 2), 2, 2) < Constant.LineThreshold;
            flag_4 = IsOverlap(map.y(i, 1), map.y(i, 2), map.y(:, 1), map.y(:, 2));
        end
        % Checking the non-self index
        flag_5 = true(size(map.index, 1), 1);
        flag_5(i) = false;
        % Making condition
        cond = flag_1 & flag_2 & flag_3 & flag_4 & flag_5;
        % Extracting index from condition
        matching_list = find(cond);
        add_array(1, cond) = true;
        if ~add_array(1, i)
            if isempty(matching_list)
                % Appending
                opt_map.index(end + 1, :) = map.index(i, :);
                opt_map.x(end + 1, :) = map.x(i, :);
                opt_map.y(end + 1, :) = map.y(i, :);
                opt_map.a(end + 1, :) = map.a(i, :);
                opt_map.b(end + 1, :) = map.b(i, :);
                opt_map.c(end + 1, :) = map.c(i, :);
            else
                % Combining maps
                param = map;
                for k = 1:length(matching_list)
                    tmp = CombiningTwoLines(param, i, map, matching_list(k, 1), Constant);
                    param.x(i, :) = tmp.x;
                    param.y(i, :) = tmp.y;
                    removing_flag(matching_list(k, 1)) = true;
                end
                % Appending
                opt_map.index(end + 1, :) = param.index(i, :);
                opt_map.x(end + 1, :) = param.x(i, :);
                opt_map.y(end + 1, :) = param.y(i, :);
                opt_map.a(end + 1, :) = param.a(i, :);
                opt_map.b(end + 1, :) = param.b(i, :);
                opt_map.c(end + 1, :) = param.c(i, :);
            end
        end
    end
end

function [OptMap, RegistFlag] = UKFOptimizeMap(obj)
% 要確認
    map = obj.map_param;
    C = obj.constant;
    % Initialize each variable
    OptMap = struct;
    OptMap.x = [];
    OptMap.y = [];
    OptMap.a = [];
    OptMap.b = [];
    OptMap.c = [];
    RegistFlag = false(1, size(map.a,1));
    for i = 1:size(map.a,1)
        % Searching the line which is able to be combined
        if map.a(i) > -1 && map.a(i) < 1
            % When the line is not vertical, comparing with 'y' values
            flag_1 = vecnorm(map.y(i, 1) - map.y(:, 1), 2, 2) < C.LineThreshold;
            flag_2 = vecnorm(map.y(i, 2) - map.y(:, 2), 2, 2) < C.LineThreshold;
            flag_3 = IsOverlap(map.x(i, 1), map.x(i, 2), map.x(:, 1), map.x(:, 2));
        else
            % When the line is vertical, comparing with 'x' values
            flag_1 = vecnorm(map.x(i, 1) - map.x(:, 1), 2, 2) < C.LineThreshold;
            flag_2 = vecnorm(map.x(i, 2) - map.x(:, 2), 2, 2) < C.LineThreshold;
            flag_3 = IsOverlap(map.y(i, 1), map.y(i, 2), map.y(:, 1), map.y(:, 2));
        end
        % Checking the non-self and non-before id
        flag_4 = true(size(map.a, 1), 1);
        flag_4(1:i,1) = false;%現在のマップ番号および以前のマップ番号のインデックスをfalseに（対エラー用）

        % Making condition
        Conditions = flag_1 & flag_2 & flag_3 & flag_4;
        % Extracting id from condition
        matching_list = find(Conditions);
        RegistFlag(1, Conditions) = true;
        if ~RegistFlag(1, i)
            if isempty(matching_list)
                % Appending
                OptMap.x(end + 1, :) = map.x(i, :);
                OptMap.y(end + 1, :) = map.y(i, :);
                OptMap.a(end + 1, :) = map.a(i, :);
                OptMap.b(end + 1, :) = map.b(i, :);
                OptMap.c(end + 1, :) = map.c(i, :);
            else
                % Combining maps
                param = map;
                for k = 1:length(matching_list)
                    j = matching_list(k, 1);
                    tmp = extract_max_line_segment([map.x(i,:)',map.y(i,:)';map.x(j,:)',map.y(j,:)']);
                    param.x(i, :) = tmp.x;
                    param.y(i, :) = tmp.y;
                end
                % Appending
                OptMap.x(end + 1, :) = param.x(i, :);
                OptMap.y(end + 1, :) = param.y(i, :);
                OptMap.a(end + 1, :) = param.a(i, :);
                OptMap.b(end + 1, :) = param.b(i, :);
                OptMap.c(end + 1, :) = param.c(i, :);
            end
        end
    end
end

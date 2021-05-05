function parameter = PointCloudToLine(LaserDistance, LaserAngles, State, Constant)
    %% Clustering
    % Searching first non-zero value
    FirstIdx = 1;
    while LaserDistance(FirstIdx) < Constant.ZeroThreshold
        FirstIdx = FirstIdx + 1;
    end
    % Initialize each variable
    IdxList = []; % index list,端点のレーザインデックス
    SegmentFlag = 2; % 1:searching start point, 2:searching end point
    i = FirstIdx + 1; % loop-counter
    StartIdx = FirstIdx; % index of start point
    while 1
        % Searching 'zero value' or 'separated from the distance one before'
        if SegmentFlag == 2 && (LaserDistance(i) < Constant.ZeroThreshold || abs(LaserDistance(i) - LaserDistance(i - 1)) > Constant.CluteringThreshold)
            % Saving the index and changing mode
            IdxList(end + 1, :) = [StartIdx, i - 1];
            SegmentFlag = 1;
            % i-th value may be available. so, variable 'i' is not increment.
            continue;
        % Searching non-zero value
        elseif SegmentFlag == 1 && LaserDistance(i) > Constant.ZeroThreshold
            % Saving the index and changing mode
            StartIdx = i;
            SegmentFlag = 2;
        end
        i = i + 1;
        if i > length(LaserDistance)
            % If terminal value is available, appending the index to list
            if SegmentFlag == 2
                IdxList(end + 1, :) = [StartIdx, length(LaserDistance)];
            end
            break;
        end
    end
    %% Making the line
    %まず，事前の直線を作る．
    % Calculation of a and b which means "y = a*x + b"
    x = State(1) + LaserDistance(IdxList) .* cos(LaserAngles(IdxList) + State(3));
    y = State(2) + LaserDistance(IdxList) .* sin(LaserAngles(IdxList) + State(3));
    DiffX = x(:, 2) - x(:, 1);
    a = (y(:, 2) - y(:, 1)) ./ DiffX;
    % If x(:, 2) and x(:, 1) is same, 'diff_x' is nan. Nan is not able to caluculate.
    a(abs(DiffX) < Constant.ZeroThreshold) = 1e10;
    b = ones(size(a));
    c = y(:, 1) - a .* x(:, 1);
    % Separating the cluster using the distance from line drawing start and end point in the cluster
    i = 1;
    parameter.x = zeros(0, 2);
    parameter.y = zeros(0, 2);
    while true
        % Caluculation of coordinate of the measutement
        dist = LaserDistance(IdxList(i, 1) : IdxList(i, 2));
        ang = LaserAngles(IdxList(i, 1) : IdxList(i, 2));
        x_0 = State(1) + dist .* cos(ang + State(3));
        y_0 = State(2) + dist .* sin(ang + State(3));
        % Caluculation of the distance between the line and the measurement
        d = abs(a(i) * x_0 - y_0 + c(i)) ./ sqrt(a(i)^2 + 1);
        % Finding the maximum value and its index
        [val, idx] = max(d);
        % Changing the beginning index from 1 to global
        idx = idx + IdxList(i, 1) - 1;%怪しい
        if val > Constant.PointThreshold
            % Caluculation of new coefficient in "y = a*x + b"
            new_index = [IdxList(i, 1), idx; idx, IdxList(i, 2)];
            x = State(1) + LaserDistance(new_index) .* cos(LaserAngles(new_index) + State(3));
            y = State(2) + LaserDistance(new_index) .* sin(LaserAngles(new_index) + State(3));
            DiffX = x(:, 2) - x(:, 1);
            new_a = (y(:, 2) - y(:, 1)) ./ DiffX;
            new_a(abs(DiffX) < Constant.ZeroThreshold) = 1e10;
            new_c = y(:, 1) - new_a .* x(:, 1);
            % Updating the list of the cluster
            IdxList = [IdxList(1:(i - 1), :); new_index; IdxList((i + 1):end, :)];
            a = [a(1:(i - 1)); new_a; a((i + 1):end)];
            c = [c(1:(i - 1)); new_c; c((i + 1):end)];
        else
            [a(i), b(i), c(i), parameter.x(i, :), parameter.y(i, :)] = LinearizePoints(x_0, y_0);
            parameter.x_raw{i, 1} = x_0;
            parameter.y_raw{i, 1} = y_0;
            i = i + 1;
        end
        % If separating the cluster is finished, i breaks the loop.
        if i > size(a, 1)
            break;
        end
    end
    
    % Store the parameters
    parameter.index = IdxList;
    parameter.a = a;
    parameter.b = b;
    parameter.c = c;
end
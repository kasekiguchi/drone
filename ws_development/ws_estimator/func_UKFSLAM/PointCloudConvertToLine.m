function parameter = PointCloudConvertToLine(LaserDis, LaserAngles, State, Param)
    %% Clustering
    % Searching first non-zero value
    FirstIndex = 1;
    while LaserDis(FirstIndex) < Param.ZeroThreshold
        FirstIndex = FirstIndex + 1;
    end
    % Initialize each variable
    IndexList = []; % index list
    SegmentFlag = 1; % 0:searching start point, 1:searching end point
    idx = FirstIndex + 1; % loop-counter
    start_index = FirstIndex; % index of start point
    while true
        % Searching 'zero value' or 'separated from the distance one before'
        if SegmentFlag == 2 && (LaserDis(idx) < Param.ZeroThreshold || abs(LaserDis(idx) - LaserDis(idx - 1)) > Param.CluteringThreshold)
            % Saving the index and changing mode
            IndexList(end + 1, :) = [start_index, idx - 1];
            SegmentFlag = 1;
            % i-th value may be available. so, variable 'i' is not increment.
            continue;
        % Searching non-zero value
        elseif SegmentFlag == 1 && LaserDis(idx) > Param.ZeroThreshold
            % Saving the index and changing mode
            start_index = idx;
            SegmentFlag = 2;
        end
        idx = idx + 1;
        if idx > length(LaserDis)
            % If terminal value is available, appending the index to list
            if SegmentFlag == 2
                IndexList(end + 1, :) = [start_index, length(LaserDis)];
            end
            break;
        end
    end
    %% Making the line
    % Calculation of a and b which means "y = a*x + b"
    x = State(1) + LaserDis(IndexList) .* cos(LaserAngles(IndexList) + State(3));
    y = State(2) + LaserDis(IndexList) .* sin(LaserAngles(IndexList) + State(3));
    diff_x = x(:, 2) - x(:, 1);
    a = (y(:, 2) - y(:, 1)) ./ diff_x;
    % If x(:, 2) and x(:, 1) is same, 'diff_x' is nan. Nan is not able to caluculate.
    a(abs(diff_x) < Param.ZeroThreshold) = 1e10;
    b = ones(size(a));
    c = y(:, 1) - a .* x(:, 1);
    % Separating the cluster using the distance from line drawing start and end point in the cluster
    idx = 1;
    parameter.x = zeros(0, 2);
    parameter.y = zeros(0, 2);
    while true
        % Caluculation of coordinate of the measutement
        dist = LaserDis(IndexList(idx, 1) : IndexList(idx, 2));
        ang = LaserAngles(IndexList(idx, 1) : IndexList(idx, 2));
        x_0 = State(1) + dist .* cos(ang + State(3));
        y_0 = State(2) + dist .* sin(ang + State(3));
        % Caluculation of the distance between the line and the measurement
        d = abs(a(idx) * x_0 - y_0 + c(idx)) ./ sqrt(a(idx)^2 + 1);
        % Finding the maximum value and its index
        [val, idx] = max(d);
        % Changing the beginning index from 1 to global
        idx = idx + IndexList(idx, 1) - 1;
        if val > Param.PointThreshold
            % Caluculation of new coefficient in "y = a*x + b"
            new_index = [IndexList(idx, 1), idx; idx, IndexList(idx, 2)];
            x = State(1) + LaserDis(new_index) .* cos(LaserAngles(new_index) + State(3));
            y = State(2) + LaserDis(new_index) .* sin(LaserAngles(new_index) + State(3));
            diff_x = x(:, 2) - x(:, 1);
            new_a = (y(:, 2) - y(:, 1)) ./ diff_x;
            new_a(abs(diff_x) < Param.ZeroThreshold) = 1e10;
            new_c = y(:, 1) - new_a .* x(:, 1);
            % Updating the list of the cluster
            IndexList = [IndexList(1:(idx - 1), :); new_index; IndexList((idx + 1):end, :)];
            a = [a(1:(idx - 1)); new_a; a((idx + 1):end)];
            c = [c(1:(idx - 1)); new_c; c((idx + 1):end)];
        else
            [a(idx), b(idx), c(idx), parameter.x(idx, :), parameter.y(idx, :)] = LinearizePoints(x_0, y_0);
            parameter.x_raw{idx, 1} = x_0;
            parameter.y_raw{idx, 1} = y_0;
            idx = idx + 1;
        end
        % If separating the cluster is finished, i breaks the loop.
        if idx > size(a, 1)
            break;
        end
    end
    
    % Store the parameters
    parameter.index = IndexList;
    parameter.a = a;
    parameter.b = b;
    parameter.c = c;
end


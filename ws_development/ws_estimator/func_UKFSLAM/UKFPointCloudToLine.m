function parameter = UKFPointCloudToLine(RaserDis, RaserAngle, State, Constant)
    %% Clustering
    % Searching first non-zero value
    Startidx = 1;% index of start point of before search
    while RaserDis(Startidx) < Constant.ZeroThreshold
        Startidx = Startidx + 1;
    end
    % Initialize each variable
    index_list = []; % index list
    segment_flag = 2; % 1:searching start point, 2:searching end point
    i = Startidx + 1; % loop-counter 
    while 1
        % Searching 'zero value' or 'separated from the distance one before'
        if segment_flag == 2 && (RaserDis(i) < Constant.ZeroThreshold || abs(RaserDis(i) - RaserDis(i - 1)) > Constant.CluteringThreshold)
            % Saving the index and changing mode
            index_list(end + 1, :) = [Startidx, i - 1];
            segment_flag = 1;
            % i-th value may be available. so, variable 'i' is not increment.
            continue;
        % Searching non-zero value
        elseif segment_flag == 1 && RaserDis(i) > Constant.ZeroThreshold
            % Saving the index and changing mode
            Startidx = i;
            segment_flag = 2;
        end
        i = i + 1;
        if i > length(RaserDis)
            % If terminal value is available, appending the index to list
            if segment_flag == 2
                index_list(end + 1, :) = [Startidx, length(RaserDis)];
            end
            break;
        end
    end
    %% Making the line
    % Calculation of a and b which means "y = a*x + b"
    x = State(1) + RaserDis(index_list) .* cos(RaserAngle(index_list) + State(3));
    y = State(2) + RaserDis(index_list) .* sin(RaserAngle(index_list) + State(3));
    diff_x = x(:, 2) - x(:, 1);
    a = (y(:, 2) - y(:, 1)) ./ diff_x;
    % If x(:, 2) and x(:, 1) is same, 'diff_x' is nan. Nan is not able to caluculate.
    a(abs(diff_x) < Constant.ZeroThreshold) = 1e10;
    b = ones(size(a));
    c = y(:, 1) - a .* x(:, 1);
    % Separating the cluster using the distance from line drawing start and end point in the cluster
    i = 1;
    parameter.x = zeros(0, 2);
    parameter.y = zeros(0, 2);
    while true
        % Caluculation of coordinate of the measutement
        dist = RaserDis(index_list(i, 1) : index_list(i, 2));
        ang = RaserAngle(index_list(i, 1) : index_list(i, 2));
        x_0 = State(1) + dist .* cos(ang + State(3));
        y_0 = State(2) + dist .* sin(ang + State(3));
        % Caluculation of the distance between the line and the measurement
        d = abs(a(i) * x_0 - y_0 + c(i)) ./ sqrt(a(i)^2 + 1);
        % Finding the maximum value and its index
        [val, idx] = max(d);
        % Changing the beginning index from 1 to global
        idx = idx + index_list(i, 1) - 1;
        if val > Constant.PointThreshold
            % Caluculation of new coefficient in "y = a*x + b"
            new_index = [index_list(i, 1), idx; idx, index_list(i, 2)];
            x = State(1) + RaserDis(new_index) .* cos(RaserAngle(new_index) + State(3));
            y = State(2) + RaserDis(new_index) .* sin(RaserAngle(new_index) + State(3));
            diff_x = x(:, 2) - x(:, 1);
            new_a = (y(:, 2) - y(:, 1)) ./ diff_x;
            new_a(abs(diff_x) < Constant.ZeroThreshold) = 1e10;
            new_c = y(:, 1) - new_a .* x(:, 1);
            % Updating the list of the cluster
            index_list = [index_list(1:(i - 1), :); new_index; index_list((i + 1):end, :)];
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
    parameter.index = index_list;
    parameter.a = a;
    parameter.b = b;
    parameter.c = c;
end


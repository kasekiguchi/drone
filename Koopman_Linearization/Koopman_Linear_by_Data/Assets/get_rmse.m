function result = get_rmse(data, t)
    state = data.simResult.state;
    ref = data.simResult.reference.est;
    rmse_func = @(x) sqrt(sum(x.^2, 2) / size(x, 2));

    for k = 1:3
        rmse_p(k) = rmse_func(state.p(k, t) - ref.p(t, k)');
        rmse_q(k) = rmse_func(state.q(k, t) - ref.q(t, k)');
        rmse_v(k) = rmse_func(state.v(k, t) - ref.v(t, k)');
        rmse_w(k) = rmse_func(state.w(k, t) - ref.w(t, k)');

        error_p(k,:) = state.p(k, t) - ref.p(t, k)';
        error_q(k,:) = state.q(k, t) - ref.q(t, k)';
        error_v(k,:) = state.v(k, t) - ref.v(t, k)';
        error_w(k,:) = state.w(k, t) - ref.w(t, k)';
    end
    
    result = struct("p", rmse_p, "q", rmse_q, "v", rmse_v, "w", rmse_w);

    %% 
    error = [error_p; error_q; error_v; error_w];
    N = size(error, 2);
    figure(1); sgtitle('error');
    subplot(2,2,1); plot(1:N, error(1:3,:));
    subplot(2,2,2); plot(1:N, error(4:6,:));
    subplot(2,2,3); plot(1:N, error(7:9,:));
    subplot(2,2,4); plot(1:N, error(10:12,:));

    figure(2); sgtitle('error .^ 2');
    subplot(2,2,1); plot(1:N, error(1:3,:).^2);
    subplot(2,2,2); plot(1:N, error(4:6,:).^2);
    subplot(2,2,3); plot(1:N, error(7:9,:).^2);
    subplot(2,2,4); plot(1:N, error(10:12,:).^2);

    SUM_error = [sum(error(1:3,:).^2,2), sum(error(4:6,:).^2,2), sum(error(7:9,:).^2,2), sum(error(10:12,:).^2,2)]
    DIV_error = [SUM_error./N]
    RMSE = [sqrt(DIV_error)]
    
end
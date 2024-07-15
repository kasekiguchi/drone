function output = data_increased(data, sigma, N)
    X = data.X;
    Y = data.Y;
    U = data.U;
    output.X = [X];
    output.Y = [Y];
    output.U = [U];
    %% 各時間にランダムな値を足す
    for i = 1:N-1
        randX = sigma * randn(size(X));
        randY = sigma * randn(size(Y));
        randU = sigma * randn(size(U));
        output.X = [output.X, X + randX];
        output.Y = [output.Y, Y + randY];
        output.U = [output.U ,U + randU];
    end
    disp('Increased dataset.');
end
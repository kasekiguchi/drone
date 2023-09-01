% 真値
Params = [2.5, 1.3]';

% シミュレーション用データの生成
num_points = 100000;
A = rand(num_points, numel(Params));
y_true = A * Params;
noise = 0.5 * randn(num_points, 1);
y = y_true + noise;

% 逐次最小二乗法によるモデル推定
theta = zeros(size(Params));
P = eye(size(theta,2));
for i = 1:num_points
    x_i = A(i, :);
    y_i = y(i);
    % [theta,P]=RLS(theta,P,x_i,y_i,1);
    [theta,P]=RLS(x_i,theta,y_i,P,1);
end

% 結果の表示
disp('真値:');
disp(Params);
disp('推定値:');
disp(theta);

% データと回帰直線のプロット
figure(1)
scatter(A(:, 1), y, 'DisplayName', 'Simulated Data');
xlabel('X');
ylabel('y');
figure(2)
plot(A(:, 1), A * theta , 'r', 'DisplayName', 'Estimated Line');
xlabel('X');
ylabel('y');

% 逐次最小二乗の関数
function [Xn,Pn] = RLS(A,X,B,P,rho)
    Pn = (P - (P*A'*inv(rho*eye(size(A,1))+ A*P*A')*(A)*P))/rho;
    Xn = X + (P*A'*inv(rho*eye(size(A,1))+ A*P*A'))* (B - A *X);
end

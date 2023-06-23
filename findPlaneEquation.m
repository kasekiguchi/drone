function planeEquation = findPlaneEquation(env)
    % 原点に最も近い三角形のインデックスを見つける
    distances = sqrt(sum(env.Points.^2, 2));
    [~, closestTriangleIndex] = min(distances);

    % 三角形の頂点座標を取得
    vertices = env.Points(env.ConnectivityList(closestTriangleIndex, :), :);

    % 三角形の頂点座標を使って方程式を計算
    p1 = vertices(1, :);
    p2 = vertices(2, :);
    p3 = vertices(3, :);

    normal = cross(p2 - p1, p3 - p1);  % 法線ベクトルの計算
    d = -dot(normal, p1);  % 定数項の計算

    % 方程式を表す行列 [A, B, C, D]
    planeEquation = [normal, d];
end
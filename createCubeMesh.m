env = createCube(1, 0, 0, -10);
triplot(env)
function env = createCube(a, b, c, d)
    % 平面の方程式の係数を設定
    coefficients = [a, b, c, d];

    % 平面の方程式を使って頂点座標を計算
    p1 = [-a -b -c];
    p2 = [-a -b c];
    p3 = [-a b -c];
    p4 = [-a b c];
    p5 = [a -b -c];
    p6 = [a -b c];
    p7 = [a b -c];
    p8 = [a b c];

    Points = [p1; p2; p3; p4; p5; p6; p7; p8];
    Tri = [1 2 3; 2 3 4; 5 6 7; 6 7 8; 1 5 7; 1 7 3; 1 2 6; 1 6 5; 2 3 7; 2 7 6; 3 4 8; 3 8 7; 1 4 8; 1 8 5];
    
    env = triangulation(Tri, Points);
end
function parameter = CombiningTwoLines(map, index_map, measured, index_measured, Constant)
    % Define variable
    Map1x = map.x(index_map, 1);
    Map2x = map.x(index_map, 2);
    Map1y = map.y(index_map, 1);
    Map2y = map.y(index_map, 2);
    if map.a(index_map) > -1 && map.a((index_map)) < 1
        % Calcultation od start and end points using "y = ax + c"
        New1x = measured.x(index_measured, 1);
        New2x = measured.x(index_measured, 2);
        New1y = measured.y(index_measured, 1);
        New2y = measured.y(index_measured, 2);
%         New1y = map.a(index_map) * measured.x(index_measured, 1) + map.c(index_map);
%         New2y = map.a(index_map) * measured.x(index_measured, 2) + map.c(index_map);
    else
        % Calcultation od start and end points using "x = by + c"
%         New1x = map.b(index_map) * measured.y(index_measured, 1) + map.c(index_map);
%         New2x = map.b(index_map) * measured.y(index_measured, 2) + map.c(index_map);
        New1x = measured.x(index_measured, 1);
        New2x = measured.x(index_measured, 2);
        New1y = measured.y(index_measured, 1);
        New2y = measured.y(index_measured, 2);
    end
    % Calculation of new start and end points
    dist = sqrt((Map1x - New1x) ^ 2 + (Map1y - New1y) ^ 2);%新マップの始点とマップの始点の距離
    Num = 1;
    distC = sqrt((Map1x - New2x) ^ 2 + (Map1y - New2y) ^ 2);%マップの始点と新マップの終点の距離
    if distC > dist
       dist = distC;
       Num = 2;
    end
    distC = sqrt((Map2x - New2x) ^ 2 + (Map2y - New2y) ^ 2);%マップの終点と新マップの終点の距離
    if distC > dist
       dist = distC;
       Num = 3;
    end
    distC = sqrt((Map2x - New1x) ^ 2 + (Map2y - New1y) ^ 2);%マップの終点と新マップの始点との距離
    if distC > dist
       dist = distC;
       Num = 4;
    end
    distC = sqrt((Map2x - Map1x) ^ 2 + (Map2y - Map1y) ^ 2);%マップの始点と終点の距離
    if distC > dist
       dist = distC;
       Num = 5;
    end
    distC = sqrt((New2x - New1x) ^ 2 + (New2y - New1y) ^ 2);%新マップの始点と終点の距離
    if distC > dist
       Num = 6;
    end
    % Assign new start and end points to returned values
    switch(Num)
       case 1
           parameter.x = [Map1x, New1x];
           parameter.y = [Map1y, New1y];

       case 2
           parameter.x = [Map1x, New2x];
           parameter.y = [Map1y, New2y];

       case 3
           parameter.x = [Map2x, New2x];
           parameter.y = [Map2y, New2y];

       case 4
           parameter.x = [Map2x, New1x];
           parameter.y = [Map2y, New1y];

       case 5
           parameter.x = [Map1x, Map2x];
           parameter.y = [Map1y, Map2y];

       case 6
           parameter.x = [New1x, New2x];
           parameter.y = [New1y, New2y];
    end
end

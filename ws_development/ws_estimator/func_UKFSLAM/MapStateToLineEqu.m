function map = MapStateToLineEqu(MapParam,NLP)
%MapParam = [d,alpha,xs,xe,ys,ye];
% return map = struct(a,b,c)
% 関口確認済み
d = MapParam(1:NLP:end);
th = MapParam(2:NLP:end);
ep = [cos(th),sin(th)]; % 直線に対する垂線の単位ベクトル
xp = d.*ep;
map.a = ep(:,1);
map.b = ep(:,2);
map.c = -(map.a.*xp(:,1) + map.b.*xp(:,2)); % c = -(ax+by)

sc = sign(map.c);
map.a(sc~=0) = sc(sc~=0).*map.a(sc~=0);
map.b(sc~=0) = sc(sc~=0).*map.b(sc~=0);
map.c(sc~=0) = sc(sc~=0).*map.c(sc~=0);


% MapNum = length(MapParam)/NLP;%because MapParam has 6 param
% Mapdis = MapParam(1:NLP:end);
% Mapdelta = MapParam(2:NLP:end);
% Mapxs = MapParam(3:NLP:end);
% Mapxe = MapParam(4:NLP:end);
% Mapys = MapParam(5:NLP:end);
% Mapye = MapParam(6:NLP:end);
% % Initalise each variables
% map.a = zeros(MapNum, 1);
% map.b = zeros(MapNum, 1);
% map.c = zeros(MapNum, 1);
% % map.x = zeros(MapNum, 2);
% % map.y = zeros(MapNum, 2);
% % Calculation of each parameter
% for i = 1:MapNum
%     % Calculation of inclination of line using relationship of normal vector
%     delta = -1 / tan(Mapdelta(i));
%     % Calculation of intersection point
%     x = Mapdis(i) * cos(Mapdelta(i));
%     y = Mapdis(i) * sin(Mapdelta(i));
%     if abs(delta) < pi()
%         % Calculatiobn of "y = ax + c"
%         map.a(i) = delta;
%         map.b(i) = -1;
%         map.c(i) = y - map.a(i) * x;
% %         map.x(i,:) = [Mapxs(i),Mapxe(i)];
% %         map.y(i,:) = [Mapys(i),Mapye(i)];
%     else
%         % Calculatiobn of "x = by + c"
%         map.a(i) = -1;
%         map.b(i) = 1 / delta;
%         map.c(i) = x - map.b(i) * y;
% %         map.x(i,:) = [Mapxs(i),Mapxe(i)];
% %         map.y(i,:) = [Mapys(i),Mapye(i)];
%     end
% end

end

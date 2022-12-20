function Param = MapStateToLineEqu(obj,MapParam,NLP)
%MapParam = [d,alpha,xs,xe,ys,ye];
% return Param = struct(a,b,c)
% 関口確認済み
d = MapParam(1:NLP:end);
th = MapParam(2:NLP:end);
ep = [cos(th),sin(th)]; % 直線に対する垂線の単位ベクトル
xp = d.*ep;
Param.a = ep(:,1);%-ep(:,2);
Param.b = ep(:,2);%ep(:,1);
Param.c = -(Param.a.*xp(:,1) + Param.b.*xp(:,2)); %s c = -(ax+by)

% MapNum = length(MapParam)/NLP;%because MapParam has 6 param
% Mapdis = MapParam(1:NLP:end);
% Mapdelta = MapParam(2:NLP:end);
% Mapxs = MapParam(3:NLP:end);
% Mapxe = MapParam(4:NLP:end);
% Mapys = MapParam(5:NLP:end);
% Mapye = MapParam(6:NLP:end);
% % Initalise each variables
% Param.a = zeros(MapNum, 1);
% Param.b = zeros(MapNum, 1);
% Param.c = zeros(MapNum, 1);
% % Param.x = zeros(MapNum, 2);
% % Param.y = zeros(MapNum, 2);
% % Calculation of each parameter
% for i = 1:MapNum
%     % Calculation of inclination of line using relationship of normal vector
%     delta = -1 / tan(Mapdelta(i));
%     % Calculation of intersection point
%     x = Mapdis(i) * cos(Mapdelta(i));
%     y = Mapdis(i) * sin(Mapdelta(i));
%     if abs(delta) < pi()
%         % Calculatiobn of "y = ax + c"
%         Param.a(i) = delta;
%         Param.b(i) = -1;
%         Param.c(i) = y - Param.a(i) * x;
% %         Param.x(i,:) = [Mapxs(i),Mapxe(i)];
% %         Param.y(i,:) = [Mapys(i),Mapye(i)];
%     else
%         % Calculatiobn of "x = by + c"
%         Param.a(i) = -1;
%         Param.b(i) = 1 / delta;
%         Param.c(i) = x - Param.b(i) * y;
% %         Param.x(i,:) = [Mapxs(i),Mapxe(i)];
% %         Param.y(i,:) = [Mapys(i),Mapye(i)];
%     end
% end

end

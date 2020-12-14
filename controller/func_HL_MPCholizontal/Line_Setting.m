function [p_return] = Line_Setting(Sectionnumber,Sectionpoint,bfjudge,S_limit)
%経路を作るためのセクションポイントの再設計
%軌道を直角にしないための処理
Sections_point = Sectionpoint;
if bfjudge ==1
    sn = Sectionnumber-1;
    if sn<1
        sn =1;
    end
else
    sn = Sectionnumber;
    if sn+2>S_limit
        sn=sn-1;
    end    
end
if Sections_point(sn+1,1)==Sections_point(sn+2,1)
    x1 = linspace(Sections_point(sn,1),Sections_point(sn+1,1)-0.1,10);
    y1 = linspace(Sections_point(sn,2),Sections_point(sn+1,2),10);
    x2 = linspace(Sections_point(sn+1,1)-0.1,Sections_point(sn+2,1),10);
    y2 = linspace(Sections_point(sn+1,2),Sections_point(sn+2,2),10);
elseif Sections_point(sn,1)==Sections_point(sn+1,1)
    x1 = linspace(Sections_point(sn,1)-0.1,Sections_point(sn+1,1),10);
    y1 = linspace(Sections_point(sn,2),Sections_point(sn+1,2)-0.1,10);
    x2 = linspace(Sections_point(sn+1,1),Sections_point(sn+2,1),10);
    y2 = linspace(Sections_point(sn+1,2)-0.1,Sections_point(sn+2,2),10);
else
    x1 = linspace(Sections_point(sn,1),Sections_point(sn+1,1),10);
    y1 = linspace(Sections_point(sn,2),Sections_point(sn+1,2),10);
    x2 = linspace(Sections_point(sn+1,1),Sections_point(sn+2,1),10);
    y2 = linspace(Sections_point(sn+1,2),Sections_point(sn+2,2),10);
end
xx = [x1 x2(2:end)];
yy = [y1 y2(2:end)];
p_return = [xx;yy];
% Line_struct = pchip([x1 x2(2:end)],[y1 y2(2:end)]);
end
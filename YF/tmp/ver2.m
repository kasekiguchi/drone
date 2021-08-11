%論文の多層最小適応ほ
clear all
close all
p=[20 3];
x = p(1);y = p(2);
syms hat_x hat_y
phi_e1 = fphi_e1(hat_x,hat_y);

hat_Ve1 = [hat_x;hat_y]'*[1 0; 0 20]*[hat_x;hat_y];
diff_Ve1(1,1) = diff(hat_Ve1,hat_x);
diff_Ve1(1,2) = diff(hat_Ve1,hat_y);
saveX = [];
for i = 1:0.1:30
    x = p(1);y = p(2);
    s = fs(x,y,phi_e1,hat_y);
    if s.flag ==1
        diffphi_e1(1,1) = diff(phi_e1.A(1),hat_x);
        diffphi_e1(1,2) = diff(phi_e1.A(1),hat_y);
        diffphi_e1(2,1) = diff(phi_e1.A(2),hat_x);
        diffphi_e1(2,2) = diff(phi_e1.A(2),hat_y);
    else
        diffphi_e1(1,1) = diff(phi_e1.B(1),hat_x);
        diffphi_e1(1,2) = diff(phi_e1.B(1),hat_y);
        diffphi_e1(2,1) = diff(phi_e1.B(2),hat_x);
        diffphi_e1(2,2) = diff(phi_e1.B(2),hat_y);
        
    end
    u = -double(vpa(subs(subs(diff_Ve1/diffphi_e1,[hat_x hat_y],s.s'),[hat_x hat_y],s.s')))
    p = ode45(@(x,t) 0.1*u',[0 0.1],p(1:2));
    p = p.y(:,end);
    saveX = [saveX,p];
end
figure
plot(saveX(1,:),saveX(2,:))
axis equal; grid on;

function result = fphi_e1(hat_x,hat_y)
de1 = 7/(hat_y^2+1);
de11 = 1+de1;
re1a = hat_x;
re1b = 2/pi * de1 *atan((hat_x*pi)/(2*de1));
result.A = [(re1a+de11)*cos(hat_y)-de11;(re1a+de11)*sin(hat_y)];
result.B = [(re1b+de11)*cos(hat_y)-de11;(re1b+de11)*sin(hat_y)];
result.re.a = re1a ;
result.re.b = re1b;
result.de1 = de1;

end
function result = fs(x,y,phi_e1,hat_y)
bar_de1 = 7/(angle(x+8+y*1i)+1);
de1 = 7/(hat_y^2+1);
se11 = [sqrt((x+8)^2+y^2)-1-bar_de1;angle(x+8+y*1i)];
if se11(1)>=0
    se12 = [se11(1);se11(2)];
    result.s = se12;
    result.flag = 1;
else
    se12 = [2/pi * de1 *atan((se11(1)*pi)/(2*de1));se11(2)];
    result.s = se12;
    result.flag = 2;
end

end
%%ABMモデルの動作の角度計算をしている
L = 2;
a = [1 1];
b = [3.5 0];
ath = pi/12;
bth = atan2(b(2)-a(2),b(1)-a(1));
D = norm(b-a,2);
Omega = b(1)-a(1)-D*cos(bth-ath)*cos(ath);
Xdist = b(1)-Omega*L*sin(ath)/norm(Omega);
Ydist = b(2)+Omega*L*cos(ath)/norm(Omega);


figure(2)
scatter(a(1),a(2));
hold on;grid on;
text(a(1),a(2),'X');
scatter(b(1),b(2));
text(b(1),b(2),'Xb');
scatter(Xdist,Ydist);
text(Xdist,Ydist,'Xint');
xlim([0 6]);ylim([0 6])
hold off

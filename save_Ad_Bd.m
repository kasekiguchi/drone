
dt = 0.025;
Ac2 = [0,1;0,0];
Bc2 = [0;1];
Ac4 = diag([1,1,1],1);
Bc4 = [0;0;0;1];
[Ad1,Bd1,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));
[Ad2,Bd2,~,~] = ssdata(c2d(ss(Ac4,Bc4,[1,0,0,0],[0]),dt));
[Ad3,Bd3,~,~] = ssdata(c2d(ss(Ac4,Bc4,[1,0,0,0],[0]),dt));
[Ad4,Bd4,~,~] = ssdata(c2d(ss(Ac2,Bc2,[1,0],[0]),dt));

Ad = blkdiag(Ad1,Ad2,Ad3,Ad4);
Bd = blkdiag(Bd1,Bd2,Bd3,Bd4);

F1=lqrd(Ac2,Bc2,diag([100,1]),[0.1],dt);                                % 
F2=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
F3=lqrd(Ac4,Bc4,diag([100,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])
F4=lqrd(Ac2,Bc2,diag([100,10]),[0.1],dt);

F = blkdiag(F1,F2,F3,F4);

clearvars -except Ad Bd F dt

save("./Data/Ad_Bd_F.mat")
function Controller= Controller_HL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([5000,10000,2000,10]),0.0001,dt); % xdiag([100,10,10,1])
Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([5000,10000,2000,10]),0.0001,dt); % ydiag([100,10,10,1])
Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);                       % ヨー角 

% % dt = 0.2 くらいの時用
% Controller.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
% Controller.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,1,1,1]),[1],dt); % xdiag([100,10,10,1])
% Controller.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,1,1,1]),[1],dt); % ydiag([100,10,10,1])
% Controller.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);                       % ヨー角 


% 極配置
% Controller.F2=place(diag([1,1,1],1),[0;0;0;1],Eig);
% Controller.F3=place(diag([1,1,1],1),[0;0;0;1],Eig);

% 設定確認
Controller.dt = dt;
eig(diag([1,1,1],1)-[0;0;0;1]*Controller.F2)
end

function Controller= Controller_HL(dt)
% 階層型線形化コントローラの設定
%% dt = 0.025 くらいの時に有効（これより粗いdtの時はZOH誤差を無視しているためもっと穏やかなゲインの方が良い）
Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([5,1]),[0.1],dt);                                % z 
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt); 
% Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([40,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([40,20,10,1]),[0.01],dt); % ydiag([100,10,10,1])
%3D_Simple(v)
% Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([30,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([40,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])
% %3D_Simple_reverce(v)
% Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([35,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([40,10,10,1]),[0.01],dt); % ydiag([100,10,10,1])

%3D_enviroment_hv3(v)
Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([40,10,10,1]),[0.01],dt); % xdiag([100,10,10,1])
Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([50,20,10,1]),[0.01],dt); % ydiag([100,10,10,1])

% Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([100,100,10,1]),[0.01],dt); % ydiag([100,10,10,1])
Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);                       % ヨー角 

% % dt = 0.2 くらいの時用
% Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[0.1],dt);                                % z 
% Controller_param.F2=lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,1,1,1]),[1],dt); % xdiag([100,10,10,1])
% Controller_param.F3=lqrd(diag([1,1,1],1),[0;0;0;1],diag([1,1,1,1]),[1],dt); % ydiag([100,10,10,1])
% Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,10]),[0.1],dt);                       % ヨー角 


% 極配置
% Controller_param.F2=place(diag([1,1,1],1),[0;0;0;1],Eig);
% Controller_param.F3=place(diag([1,1,1],1),[0;0;0;1],Eig);

% 設定確認
Controller_param.dt = dt;
eig(diag([1,1,1],1)-[0;0;0;1]*Controller_param.F2)

 
Controller.type="HLC";
Controller.name="hlc";
Controller.param=Controller_param;
end

function u_trans_param=InputTransform_toHL_drone(dt,varargin)
%% Input transformer
u_trans_param.F1=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
u_trans_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
u_trans_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
u_trans_param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
u_trans_param.dt = dt;
end

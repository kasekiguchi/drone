function u_trans_param = InputTransform_REFtoHL_drone(dt)
    %% Input transformer
    u_trans_param.type="REF2HL_DRONE";
    u_trans_param.name="p2hl";
    u_trans_param.param.F1=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
    u_trans_param.param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
    u_trans_param.param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
    u_trans_param.param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
    u_trans_param.param.dt = dt;
end

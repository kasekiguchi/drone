function u_trans_param = InputTransform_REFtoHL_drone(dt,varargin)
    %% Input transformer
    u_trans_param.type="REFtoHL_drone";
    u_trans_param.name="p2hl";
    if ~isempty(varargin)
        u_trans_param.param.P=varargin{1};
    else
        u_trans_param.param.P=getParameter();
    end
    u_trans_param.param.F1=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
    u_trans_param.param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
    u_trans_param.param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
    u_trans_param.param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);
    u_trans_param.param.dt = dt;
end

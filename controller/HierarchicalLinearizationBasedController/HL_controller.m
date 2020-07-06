function u = HL_controller(Xh,Xd,Param)
    % u = HL_controller(Xh,Xd,Param)
    % Xh : ���肵��state obj
    % Xd : �Q�Ə�Ԃ̍\����
    % Param : required field : P, F1,F2,F3,F4
    %        P : physical parameters
    %        Fi : feedback gain for i-th virtual subsystem
    P = Param.P;
    F1 = Param.F1;
    F2 = Param.F2;
    F3 = Param.F3;
    F4 = Param.F4;
    state = Xh;
    ref = Xd;
    x = [state.getq('compact');state.p;state.v;state.w]; % [q, p, v, w]�ɕ��בւ�
    if isprop(ref,'xd') || isfield(ref,'xd')
        xd = ref.xd; % 20�����̖ڕW�l�ɑΉ�����悤
    else
        xd = ref.get();
    end
    xd=[xd;zeros(20-size(xd,1),1)];% ����Ȃ����͂O�Ŗ��߂�D
    
    if isfield(Param,'dt')
        dt = Param.dt;
        vf = Vfd(dt,x,xd',P,F1);
    else
        vf = Vf(x,xd',P,F1);
    end
    vs = Vs(x,xd',vf,P,F2,F3,F4);
    u = Uf(x,xd',vf,P) + Us(x,xd',vf,vs',P);
end

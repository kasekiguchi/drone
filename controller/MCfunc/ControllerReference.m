function xd = ControllerReference(obj)
coder.gpu.kernelfun
%REFERENCE この関数の概要をここに記述
%   詳細説明をここに記述
    xd = zeros(12, obj.param.H);
    RefTime = obj.self.reference.timeVarying.func;    % 時間関数の取得
    for h = 0:obj.param.H-1
%         t = obj.param.t + obj.param.dt * h;
        Ref = RefTime(obj.param.t + obj.param.dt * h);
        xd(1:2, h+1) = [Ref(3); Ref(7)];
        xd(3:6, h+1) = [Ref(1); Ref(5); Ref(9); Ref(13)];
        xd(7:10,h+1) = [Ref(2); Ref(6); Ref(10);Ref(14)];
        xd(11:12,h+1)= [Ref(4); Ref(8)];
        %% 単純に　Ref　から対象を抽出する % x(1) y(2) z(3) yaw(4) vx(5) vy(6) vz(7) vyaw(8) ax(9) ay(10) az(11) ayaw(12)
        % z dz           3 7
        % x dx ddx dddx  1 5 9 13
        % y dy ddy dddy  2 6 10 14
        % yaw dyaw       4 8 
    end
end
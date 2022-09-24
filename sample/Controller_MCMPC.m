function Controller = Controller_MCMPC(dt)
%UNTITLED この関数の概要をここに記述
%   詳細説明をここに記述

%     Controller_param.dt = dt;
    Controller_param.fFirst = 0;

    Controller.name = "MCMPC_controller";
    Controller.type = "mcmpc";
    Controller.param = Controller_param;

end
function Controller = Controller_PID(dt,param)
arguments
  dt
  param.Kc % 比例ゲイン
  param.Tc = 0; % 振動周期
  param.type = "P"; % P or PI or PID  : ジーグラ・ニコルスの限界感度法
end
% PIDコントローラ設計用
Controller.dt = dt;
Controller.Ki = 0;
Controller.Kd = 0;
switch param.type
  case "P"
    Controller.Kp = 0.5*param.Kc;
  case "PI"
    Controller.Kp = 0.45*param.Kc;
    Controller.Ki = param.Tc/1.2;    
  case "PID"
    Controller.Kp = 0.6*param.Kc;
    Controller.Ki = param.Tc/2;
    Controller.Kd = param.Tc/8;
end
Controller.gen_e = @(estate,rstate) estate.p - rstate.p(1:length(estate.p));
Controller.gen_ei = @(ei,estate,rstate) ei + dt*(estate.p - rstate.p(1:length(estate.p))); % optional
Controller.gen_ed = @(estate,rstate) estate.v - rstate.v(1:length(estate.v)); % optional
end


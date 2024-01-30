clc
ts = 0; % initial time
dt = 0.025; % sampling period
te = 10000; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) in_prog(app);
post_func = @(app) post(app);
logger = LOGGER(1, size(ts:dt:te, 2), 1, [],[]);

motive = Connector_Natnet('192.168.1.2'); % connect to Motive
motive.getData([], []); % get data from Motive
rigid_ids = [1]; % rigid-body number on Motive
sstate = motive.result.rigid(rigid_ids);
initial_state.p = sstate.p;
initial_state.q = sstate.q;
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "udp", [1, 252]));
agent.parameter = DRONE_PARAM("DIATONE");
agent.estimator = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)), ["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
 
agent.reference = TIME_VARYING_REFERENCE(agent,{"Case_study_trajectory",{[0,0,0]},"HL"});
% agent.controller = MPC_CONTROLLER_KOOPMAN_fmincon(agent,Controller_MPC_Koopman(agent)); %最適化手法：SQP
% agent.controller = MPC_CONTROLLER_KOOPMAN_quadprog(agent,Controller_MPC_Koopman(agent)); %最適化手法：QP

% run("ExpBase");

%% 

agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.controller.mpc = MPC_CONTROLLER_KOOPMAN_quadprog(agent,Controller_MPC_Koopman(agent)); %最適化手法：QP
agent.controller.result.input = [0;0;0;0];
agent.controller.do = @controller_do;

run("ExpBase");

%fでコントローラを切り替え-------------------------
% function result = controller_do(varargin)
%     controller = varargin{5}.controller;
%     if varargin{2} == 'f'
%         result.hlc = controller.hlc.do(varargin);
%         result.mpc = controller.mpc.do(varargin);
%         if result.mpc.fTime > 10 
%             result = result.mpc;
%         else
%             result = result.hlc;
%         end
%    else
%         result = controller.hlc.do(varargin);
%    end
%     varargin{5}.controller.result = result;
% end
%--------------------------------------------------

%aからMPC回すバージョン--------------------------------------
function result = controller_do(varargin)
    controller = varargin{5}.controller;
    if varargin{2} == 'a'
        % result.hlc = controller.hlc.do(varargin);
        result = controller.mpc.do(varargin);
    elseif varargin{2} == 't'
        result.hlc = controller.hlc.do(varargin);
        result.mpc = controller.mpc.do(varargin);
        result = result.hlc;
    elseif varargin{2} == 'f'
        result.hlc = controller.hlc.do(varargin);
        result.mpc = controller.mpc.do(varargin);
        result = result.hlc;
        % result = controller.mpc.do(varargin);
    else
        result = controller.hlc.do(varargin);
   end
    varargin{5}.controller.result = result;
end

% function result = input_transform_do(varargin)
%     input_transform = varargin{5}.input_transform;
%     if varargin{2} == 'f'
%         result = input_transform.mpc;
%     else
%         result = input_transform.hlc;
%     end
%     varargin{5}.input_transform.result = result;
% end
%--------------------------------------------------

function post(app)
% app.logger.plot({1, "p1-p2-p3", "e"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);

Graphplot(app)
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end
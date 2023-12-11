ts = 0; % initial time
dt = 0.025; % sampling period
te = 25; % terminal time
time = TIME(ts,dt,te); % instance of time class
in_prog_func = @(app) dfunc(app); % in progress plot
post_func = @(app) dfunc(app); % function working at the "draw button" pushed.
motive = Connector_Natnet_sim(1, dt, 0); % imitation of Motive camera (motion capture system)
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]); % instance of LOOGER class for data logging

agent = DRONE;
agent.parameter = DRONE_PARAM("DIATONE");
    initial_state.p = arranged_position([0, 0], 1, 1, 0);
    initial_state.q = [1; 0; 0; 0];%rollpi/2[2^0.5/2;2^0.5/2;0;0], pitchpi/2[2^0.5/2;0;2^0.5/2;0],yawpi/2[2^0.5/2;0;0;2^0.5/2]
    % initial_state.q = [2^0.5/2;2^0.5/2;0;0];
    initial_state.v = [0; 0; 0];
    initial_state.w = [0; 0; 0];
    initial_state.Trs = [agent.parameter.mass*agent.parameter.gravity; 0];%重力を打ち消すため最初はTr=m*g

    % agent.parameter = DRONE_PARAM("DIATONE","row","mass",0.6,"lx",0.18,"ly",0.12);%モデル誤差
    agent.parameter = DRONE_PARAM("DIATONE");
    agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1),0);
% 外乱を与える==========
% agent.plant = MODEL_CLASS(agent,Model_EulerAngle_With_Disturbance(dt, initial_state, 1));%外乱用モデル
% agent.input_transform = ADDING_DISTURBANCE(agent,InputTransform_Disturbance_drone(time)); % 外乱付与
%=====================
% agent.parameter.set(["mass","lx","ly"],struct("mass",0.5884,"lx",0.16,"ly",0.16))%モデル誤差
% agent.estimator = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
% agent.input_transform = THRUST2FORCE_TORQUE_FOR_MODEL_ERROR(agent); %モデル誤差
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[1,1,0.2]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.5;0.5;0.5],"g",[0.2;0.2;0.5],"h",[0;0.2;1],"j",[0;0;1],"k",[0.1;0.1;0.8]),3});%縦ベクトルで書く,
% agent.reference = POINT_REFERENCE(agent);

% fFT=0;%1:FT, other:LS
% agent.controller = ELC(agent,Controller_EL(dt,fFT));
% run("ExpBase");

%% コントローラー切換
%estimator
agent.estimator.hlc = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.estimator.elc = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
agent.estimator.do = @estimator_do;
%senser
tmp.estimator = agent.estimator;
agent.estimator = tmp.estimator.elc;
agent.sensor.elc = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.estimator = tmp.estimator.hlc;
agent.sensor.hlc = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.estimator = tmp.estimator;
agent.sensor.do = @sensor_do;
%refernce
% agent.reference = TIME_VARYING_REFERENCE(tmp1,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
tmp.estimator = agent.estimator;
agent.estimator = tmp.estimator.elc;
agent.reference.elc = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
agent.estimator = tmp.estimator.hlc;
agent.reference.hlc = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
agent.estimator = tmp.estimator;
agent.reference.do = @reference_do;
%controller
tmp.estimator = agent.estimator;
agent.estimator = tmp.estimator.elc;
agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.estimator = tmp.estimator.hlc;
fFT=0;%1:FT, other:LS
agent.controller.elc = ELC(agent,Controller_EL(dt,fFT));
agent.estimator = tmp.estimator;
agent.controller.result.input = [0;0;0;0];
agent.controller.result.u = [0;0;0;0];
agent.controller.do = @controller_do;

run("ExpBase");
function result = estimator_do(varargin)
    estimator = varargin{5}.estimator;
    tmp.controller = varargin{5}.controller;
    if varargin{2} == 'f'
        varargin{5}.controller = tmp.controller.elc;
        result = estimator.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    else
        varargin{5}.controller = tmp.controller.hlc;
        result = estimator.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
   end
    varargin{5}.estimator.result = result;
    varargin{5}.controller = tmp.controller;
end

function result = sensor_do(varargin)
    sensor = varargin{5}.sensor;
    if varargin{2} == 'f'
        result = sensor.elc.do(varargin);
   else
        result = sensor.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
   end
    varargin{5}.sensor.result = result;
end

function result = reference_do(varargin)
    reference = varargin{5}.reference;
    if varargin{2} == 'f'
        result = reference.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
   else
        result = reference.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
   end
    varargin{5}.reference.result = result;
end

function result = controller_do(varargin)
    tmp.estimator = varargin{5}.estimator;
    % varargin{5}.estimator = tmp.estimator.elc;
    controller = varargin{5}.controller;
    % result_hlc = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % result_elc = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    if varargin{2} == 'f'
        % result.hlc = controller.hlc.do(varargin);
        % result.elc = controller.elc.do(varargin);
        % if result.hlc.fTime > 10
        % result = controller.elc.do(varargin);
        varargin{5}.estimator = tmp.estimator.elc;
        result = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
        % result = result_elc;
            % result = result.elc;
        % else
        %     result = result.hlc;
        % end
   else
        varargin{5}.estimator = tmp.estimator.hlc;
        result = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
        % result = result_hlc;
   end
    varargin{5}.estimator = tmp.estimator;
    varargin{5}.controller.result = result;
end

function dfunc(app)
app.logger.plot({1, "p", "pre"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "q", "s"},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "er"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.t]);
end
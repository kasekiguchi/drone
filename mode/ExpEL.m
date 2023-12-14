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

agent = DRONE;
agent.parameter = DRONE_PARAM("DIATONE");
initial_state.p = sstate.p;
initial_state.q = sstate.q;
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
initial_state.Trs = [agent.parameter.mass*agent.parameter.gravity; 0];%重力を打ち消すため最初はTr=m*g
% initial_state.Trs=[0;0];
agent.plant = DRONE_EXP_MODEL(agent,Model_Drone_Exp(dt, initial_state, "udp", [1, 252]));
% agent.estimator = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
% agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[1,1,0.0]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[0,0,0]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[0,0,1]},"HL"});
% agent.reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),5,1));
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.5;0.5;0.6],"g",[2;-0.5;1.3]),30});%縦ベクトルで書く,
fFT=0;%z directional controller flag 1:FT, other:LS
% agent.controller = ELC(agent,Controller_EL(dt,fFT));
run("ExpBase");

%% コントローラー切換
%estimator
agent.estimator.hlc = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.estimator.elc = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
% agent.estimator.result.el = agent.estimator.elc.result;
% agent.estimator.result.hl = agent.estimator.hlc.result;
agent.estimator.result= agent.estimator.hlc.result;
agent.estimator.do = @estimator_do;
%senser
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
% %refernce
agent.reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[0,0,1]},"HL"});
%controller
fFT=0;%1:FT, other:LS
agent.estimator.model = agent.estimator.elc.model;
agent.controller.elc = ELC(agent,Controller_EL(dt,fFT));
agent.estimator.model = agent.estimator.hlc.model;
agent.controller.hlc = HLC(agent,Controller_HL(dt));
% agent.controller.result.el = agent.controller.elc.result;
% agent.controller.result.hl = agent.controller.hlc.result;
agent.controller.result = agent.controller.hlc.result;
agent.controller.do = @controller_do;
%input
tmp.estimator = agent.estimator;
agent.estimator = tmp.estimator.elc;
agent.input_transform.elc = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
agent.estimator = tmp.estimator.hlc;
agent.input_transform.hlc = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
agent.estimator = tmp.estimator;
agent.input_transform.param = agent.input_transform.hlc.param;
agent.input_transform.do = @input_transform_do;

run("ExpBase");
function result = estimator_do(varargin)
    estimator = varargin{5}.estimator;
    % varargin{5}.estimator.result =  estimator.elc.result.el;
    % result.el = estimator.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % varargin{5}.estimator.result =  estimator.hlc.result.hl;
    % result.hl = estimator.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % if varargin{2} == 'f'
    %     result = result.el;
    % else
    %     result = result.hl;
    % end
    if varargin{2} == 'f'
        if ~isfield(varargin{5}.controller.result,"u")
            varargin{5}.controller.result.u = [0;varargin{5}.controller.result.input(2:4)];
            T = varargin{5}.controller.result.input(1);
            result = estimator.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
            result.state.Trs(1) = T; 
        else
            result = estimator.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
        end
    else
        result = estimator.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    end
    varargin{5}.estimator.result = result;
end

function result = input_transform_do(varargin)
    input_transform = varargin{5}.input_transform;
    % controller = varargin{5}.controller;
    % if varargin{2} ~= 'f'
    %     varargin{5}.estimator.model = varargin{5}.estimator.elc.model;
    % end
    % result_el = input_transform.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % if varargin{2} ~= 'f'
    %     varargin{5}.estimator.model = varargin{5}.estimator.hlc.model;
    % end
    % result_hl = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % 
    % if varargin{2} == 'f'
    %     result = result_el;
    % else
    %     result = result_hl;
    % end
    if varargin{2} == 'f'
        varargin{5}.estimator.model = varargin{5}.estimator.elc.model;
        % varargin{5}.controller.result = controller.result.el;
        result = input_transform.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    else
        if isfield(varargin{5}.estimator,"elc")
            varargin{5}.estimator.model = varargin{5}.estimator.hlc.model;
        end
        % varargin{5}.controller.result = controller.result.hl;
        result = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
   end
    varargin{5}.input_transform.result = result;
end

function result = controller_do(varargin)
    controller = varargin{5}.controller;
    % estimator = varargin{5}.estimator;
    % varargin{5}.controller.result =  controller.elc.result;
    % varargin{5}.estimator.result =  estimator.elc.result;
    % result.el = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % varargin{5}.controller.result =  controller.hlc.result;
    % varargin{5}.estimator.result =  estimator.hlc.result;
    % result.hl = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % if varargin{2} == 'f'
    %     result = result.el;
    % else
    %     result = result.hl;
    % end

    if varargin{2} == 'f'
        result = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    else
        result = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    end
    varargin{5}.controller.result = result;
end

function post(app)
app.logger.plot({1, "p", "er"},"ax",app.UIAxes,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes2,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "v", "e"},"ax",app.UIAxes3,"xrange",[app.time.ts,app.time.te]);
app.logger.plot({1, "input", ""},"ax",app.UIAxes4,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "input", ""},"ax",app.UIAxes5,"xrange",[app.time.ts,app.time.te]);
% app.logger.plot({1, "inner_input", ""},"ax",app.UIAxes6,"xrange",[app.time.ts,app.time.te]);
end
function in_prog(app)
app.Label_2.Text = ["estimator : " + app.agent(1).estimator.result.state.get()];
end
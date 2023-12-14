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
agent.estimator = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
agent.sensor = MOTIVE(agent, Sensor_Motive(1,0, motive));
agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[1,1,0.0]},"HL"});
% agent.reference = TIME_VARYING_REFERENCE(agent,{"gen_ref_saddle",{"freq",10,"orig",[0;0;1],"size",[0,0,0]},"HL"});
agent.reference = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[0,0,1]},"HL"});
% agent.reference = MY_WAY_POINT_REFERENCE(agent,way_point_ref(readmatrix("waypoint.xlsx",'Sheet','Sheet1_15'),5,1));
% agent.reference = MY_POINT_REFERENCE(agent,{struct("f",[0.5;0.5;0.6],"g",[2;-0.5;1.3]),30});%縦ベクトルで書く,
fFT=0;%z directional controller flag 1:FT, other:LS
agent.controller = ELC(agent,Controller_EL(dt,fFT));
run("ExpBase");

%% コントローラー切換
%estimator
agent.estimator.hlc = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
agent.estimator.elc = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
agent.estimator.result = [0;0;0;0];
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
agent.reference.result =[0;0;0;0];
agent.reference.do = @reference_do;
%controller
tmp.estimator = agent.estimator;
agent.estimator = tmp.estimator.elc;
agent.controller.hlc = HLC(agent,Controller_HL(dt));
agent.estimator = tmp.estimator.hlc;
fFT=0;%1:FT, other:LS
agent.controller.elc = ELC(agent,Controller_EL(dt,fFT));
agent.estimator = tmp.estimator;
agent.controller.result.u = [0;0;0;0];
agent.controller.result.input = [0;0;0;0];
agent.controller.do = @controller_do;
%input
% tmp.estimator = agent.estimator;
% tmp.controller = agent.controller;
% agent.estimator = tmp.estimator.elc;
% agent.controller = tmp.controller.elc;
% agent.input_transform.elc = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% agent.estimator = tmp.estimator.hlc;
% agent.controller = tmp.controller.hlc;
% agent.input_transform.hlc = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% agent.estimator = tmp.estimator;
% agent.controller = tmp.controller;
agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
agent.input_transform.do = @input_transform_do;

run("ExpBase");
function result = estimator_do(varargin)
    estimator = varargin{5}.estimator;
    result = estimator.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    if varargin{2} == 'f'
        result = merge_result(result,estimator.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6}));
    end
    varargin{5}.estimator.result = result;
end

function result = sensor_do(varargin)
    sensor = varargin{5}.sensor;
    result = sensor.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    if varargin{2} == 'f'
        result = sensor.elc.do(varargin);
    end
    varargin{5}.sensor.result = result;
end

function result = input_transform_do(varargin)
    input_transform = varargin{5}.input_transform;
    result = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % tmp.controller = varargin{5}.controller;
    % tmp.estimator = varargin{5}.estimator;
    if varargin{2} == 'f'
        % varargin{5}.controller = tmp.controller.elc;
        % varargin{5}.estimator = tmp.estimator.elc;
        result = merge_result(result,input_transform.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6}));
    % else %varargin{2} == 't' || varargin{2} == 'l'
    %     varargin{5}.controller = tmp.controller.hlc;
    %     varargin{5}.estimator = tmp.estimator.hlc;
    %     result = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % % else
    % %     varargin{5}.controller = tmp.controller;
    % %     varargin{5}.estimator = tmp.estimator;
    % %     result = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
   end
    varargin{5}.input_transform.result = result;
    % varargin{5}.controller = tmp.controller;
    % varargin{5}.estimator = tmp.estimator;
end

function result = reference_do(varargin)
    reference = varargin{5}.reference;
    result = reference.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % tmp.input_transform = varargin{5}.input_transform;
    if varargin{2} == 'f'
        varargin{5}.input_transform = tmp.input_transform.elc;
        result = reference.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % else
    %     varargin{5}.input_transform = tmp.input_transform.hlc;
    %     result = reference.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    end
    % varargin{5}.input_transform = tmp.input_transform;
    varargin{5}.reference.result = result;
end

function result = controller_do(varargin)
    % tmp.estimator = varargin{5}.estimator;
    % varargin{5}.estimator = tmp.estimator.elc;
    controller = varargin{5}.controller;
    result = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % result_hlc = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    % result_elc = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    if varargin{2} == 'f'
        % result.hlc = controller.hlc.do(varargin);
        % result.elc = controller.elc.do(varargin);
        % if result.hlc.fTime > 10
        % result = controller.elc.do(varargin);
        % varargin{5}.estimator = tmp.estimator.elc;
        result = merge_result(result,controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6}));
        % result = result_elc;
            % result = result.elc;
        % else
        %     result = result.hlc;
        % end
   % else
        % varargin{5}.estimator = tmp.estimator.hlc;
        % result = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
        % result = result_hlc;
   end
    % varargin{5}.estimator = tmp.estimator;
    varargin{5}.controller.result = result;
end

% %% コントローラー切換
% %estimator
% agent.estimator.hlc = EKF(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1)),["p", "q"]));
% agent.estimator.elc = EKF_EXPAND(agent, Estimator_EKF(agent,dt,MODEL_CLASS(agent,Model_EulerAngle_Expand(dt, initial_state, 1)),["p", "q"]));
% agent.estimator.result = [0;0;0;0];
% agent.estimator.do = @estimator_do;
% %senser
% tmp.estimator = agent.estimator;
% agent.estimator = tmp.estimator.elc;
% agent.sensor.elc = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.estimator = tmp.estimator.hlc;
% agent.sensor.hlc = MOTIVE(agent, Sensor_Motive(1,0, motive));
% agent.estimator = tmp.estimator;
% agent.sensor.do = @sensor_do;
% %refernce
% % agent.reference = TIME_VARYING_REFERENCE(tmp1,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
% tmp.estimator = agent.estimator;
% agent.estimator = tmp.estimator.elc;
% agent.reference.elc = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
% agent.estimator = tmp.estimator.hlc;
% agent.reference.hlc = TIME_VARYING_REFERENCE(agent,{"My_Case_study_trajectory",{[1,1,1]},"HL"});
% agent.estimator = tmp.estimator;
% agent.reference.result =[0;0;0;0];
% agent.reference.do = @reference_do;
% %controller
% tmp.estimator = agent.estimator;
% agent.estimator = tmp.estimator.elc;
% agent.controller.hlc = HLC(agent,Controller_HL(dt));
% agent.estimator = tmp.estimator.hlc;
% fFT=0;%1:FT, other:LS
% agent.controller.elc = ELC(agent,Controller_EL(dt,fFT));
% agent.estimator = tmp.estimator;
% agent.controller.result.u = [0;0;0;0];
% agent.controller.result.input = [0;0;0;0];
% agent.controller.do = @controller_do;
% %input
% % tmp.estimator = agent.estimator;
% % tmp.controller = agent.controller;
% % agent.estimator = tmp.estimator.elc;
% % agent.controller = tmp.controller.elc;
% % agent.input_transform.elc = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% % agent.estimator = tmp.estimator.hlc;
% % agent.controller = tmp.controller.hlc;
% % agent.input_transform.hlc = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% % agent.estimator = tmp.estimator;
% % agent.controller = tmp.controller;
% agent.input_transform = THRUST2THROTTLE_DRONE(agent,InputTransform_Thrust2Throttle_drone()); % 推力からスロットルに変換
% agent.input_transform.do = @input_transform_do;
% 
% run("ExpBase");
% function result = estimator_do(varargin)
%     estimator = varargin{5}.estimator;
%     tmp.controller = varargin{5}.controller;
%     if varargin{2} == 'f'
%         varargin{5}.controller = tmp.controller.elc;
%         result = estimator.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     else
%         varargin{5}.controller = tmp.controller.hlc;
%         result = estimator.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%    end
%     varargin{5}.estimator.result = result;
%     % varargin{5}.controller = tmp.controller;
% end
% 
% function result = sensor_do(varargin)
%     sensor = varargin{5}.sensor;
%     if varargin{2} == 'f'
%         result = sensor.elc.do(varargin);
%    else
%         result = sensor.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%    end
%     varargin{5}.sensor.result = result;
% end
% 
% function result = input_transform_do(varargin)
%     input_transform = varargin{5}.input_transform;
%     tmp.controller = varargin{5}.controller;
%     tmp.estimator = varargin{5}.estimator;
%     if varargin{2} == 'f'
%         varargin{5}.controller = tmp.controller.elc;
%         varargin{5}.estimator = tmp.estimator.elc;
%         result = input_transform.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     else %varargin{2} == 't' || varargin{2} == 'l'
%         varargin{5}.controller = tmp.controller.hlc;
%         varargin{5}.estimator = tmp.estimator.hlc;
%         result = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     % else
%     %     varargin{5}.controller = tmp.controller;
%     %     varargin{5}.estimator = tmp.estimator;
%     %     result = input_transform.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%    end
%     varargin{5}.input_transform.result = result;
%     varargin{5}.controller = tmp.controller;
%     varargin{5}.estimator = tmp.estimator;
% end
% 
% function result = reference_do(varargin)
%     reference = varargin{5}.reference;
%     tmp.input_transform = varargin{5}.input_transform;
%     if varargin{2} == 'f'
%         varargin{5}.input_transform = tmp.input_transform.elc;
%         result = reference.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     else
%         varargin{5}.input_transform = tmp.input_transform.hlc;
%         result = reference.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     end
%     varargin{5}.input_transform = tmp.input_transform;
%     varargin{5}.reference.result = result;
% end
% 
% function result = controller_do(varargin)
%     tmp.estimator = varargin{5}.estimator;
%     % varargin{5}.estimator = tmp.estimator.elc;
%     controller = varargin{5}.controller;
%     % result_hlc = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     % result_elc = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%     if varargin{2} == 'f'
%         % result.hlc = controller.hlc.do(varargin);
%         % result.elc = controller.elc.do(varargin);
%         % if result.hlc.fTime > 10
%         % result = controller.elc.do(varargin);
%         varargin{5}.estimator = tmp.estimator.elc;
%         result = controller.elc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%         % result = result_elc;
%             % result = result.elc;
%         % else
%         %     result = result.hlc;
%         % end
%    else
%         varargin{5}.estimator = tmp.estimator.hlc;
%         result = controller.hlc.do(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%         % result = result_hlc;
%    end
%     varargin{5}.estimator = tmp.estimator;
%     varargin{5}.controller.result = result;
% end


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
ts = 0;
dt = 0.025;
te = 10;
time = TIME(ts,dt,te);
debug_func = @(app) dfunc(app);
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);
motive = Connector_Natnet_sim(1, dt, 0);              % 3rd arg is a flag for noise (1 : active )

env = stlread('3F.stl');
  % a = 1;
  % b = 2;
  % c = 3;
  % Points = [4 0 0]+[-a -b -c;a -b -c;a b -c; -a b -c;-a -b c;a -b c;a b c; -a b c]; 
  % Tri  = [1,4,3;1,3,2;5 6 7;5 7 8;1 5 8;1 8 4;1 2 6;1 6 5; 2 3 7;2 7 6;3 4 8;3 8 7];
  % env = triangulation(Tri,Points);

initial_state.p = arranged_position([0, 0], 1, 1, 0);
initial_state.q = [1; 0; 0; 0];
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];

agent = DRONE;
agent.plant = MODEL_CLASS(agent,Model_Quat13(dt, initial_state, 1));
agent.parameter = DRONE_PARAM("DIATONE");
agent.model = MODEL_CLASS(agent,Model_EulerAngle(dt, initial_state, 1));
agent.sensor.lidar = LiDAR3D_SIM(agent,Sensor_LiDAR3D(1, 'env', env, 'theta_range', pi / 2, 'phi_range', -pi:0.1:pi, 'noise', 3.0E-2, 'seed', 3).param); % 2D lidar
agent.sensor.motive = MOTIVE(agent, Sensor_Motive(1,0, motive).param);
agent.sensor.do = @sensor_do;
agent.estimator = EKF(agent, Estimator_EKF(agent, ["p", "q"]).param);
agent.reference = TIME_VARYING_REFERENCE(agent,Reference_Time_Varying("gen_ref_saddle",{"freq",5,"orig",[0;0;1],"size",[2,2,0.5]}).param);
agent.controller = HLC(agent,Controller_HL(dt).param);

function result = sensor_do(varargin)
sensor = varargin{5}.sensor;
result = sensor.lidar.do(varargin);
result = merge_result(result,sensor.motive.do(varargin));
varargin{5}.sensor.result = result;
end

function dfunc(app)
%app.agent.animation(app.logger, "target", 1, "opt_plot", ["sensor", "lidar"]);
%agent.show(["sensor", "lidar"], "FH", FH, "param", struct("fLocal", true,'fFiled',1));%false));
app.agent.show(["sensor", "lidar"], "ax", app.UIAxes, "param", struct("fLocal", false));
end
function r1 = merge_result(r1,r2)
F = fieldnames(r2);

                for j = 1:length(F)

                    if strcmp(F{j}, 'state')
                        r1.(F{j}) = state_copy(r2.(F{j}));
                    else
                        r1.(F{j}) = r2.(F{j});
                    end

                end
end
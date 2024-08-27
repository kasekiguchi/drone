ts = 0; % initial time
dt = 0.00001; % sampling period
te = 10; % termina time
time = TIME(ts,dt,te);
in_prog_func = @(app) [];
post_func = @(app) [];
logger = LOGGER(1, size(ts:dt:te, 2), 0, [],[]);

motive = Connector_Natnet('192.168.100.131'); % connect to Motive
motive.getData([], []); % get data from Motive
rigid_ids = [1]; % rigid-body number on Motive
sstate = motive.result.rigid(rigid_ids);
initial_state.p = sstate.p;
initial_state.q = sstate.q;
initial_state.v = [0; 0; 0];
initial_state.w = [0; 0; 0];
do_calculation = @(app) label2(app);

function label2(app)
ModelDescription = app.motive.NatnetClient.getModelDescription;
rigid_num = ModelDescription.RigidBodyCount;
Frame = app.motive.NatnetClient.getFrame;
time = Frame.Timestamp;
l_marker=System.Array.IndexOf(Frame.LabeledMarker, []);
u_marker=System.Array.IndexOf(Frame.UnlabeledMarker, []);
app.Label_2.Text = ["Connection to MOTIVE success","received data", "number of rigid body : " + rigid_num,"number of labeled marker : "+ l_marker,"number of unlabeled marker : "+ u_marker,"Current time in motive : "+time];
end

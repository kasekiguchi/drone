%tmp = matlab.desktop.editor.getActive;
%cd(fileparts(tmp.Filename));
%[~, tmp] = regexp(genpath('.'), '\.\\\.git.*?;', 'match', 'split'); cellfun(@(xx) addpath(xx), tmp, 'UniformOutput', false);
logger = LOGGER("Data/AROB2022_Prop400s_Log(submit)");
%logger=LOGGER("Data/Log(31-Aug-2022_18_46_59).mat");
name = 'prop_';
%logger = LOGGER("Data/AROB2022_Comp400s_Log(submit)"); %AROB2022_Comp300s_Log(18-Sep-2022_23_40_39)");
%name = 'comp_';
dirname = "AROB";
close all
%%
ct = logger.data(1, "controller.result.calc_time", "c");
sum(ct) / length(ct)
%% time response
trange = [0, 30];
t = logger.data(0, "t", "", "ranget", trange);
p = logger.data(1, "p", "p", "ranget", trange);
q = logger.data(1, "q", "p", "ranget", trange);
v = logger.data(1, "v", "p", "ranget", trange);
pe = logger.data(1, "p", "e", "ranget", trange);
qe = logger.data(1, "q", "e", "ranget", trange);
ve = logger.data(1, "v", "e", "ranget", trange);
pr = logger.data(1, "p", "r", "ranget", trange);
qr = logger.data(1, "q", "r", "ranget", trange);
vr = logger.data(1, "v", "r", "ranget", trange);
u = logger.data(1, "input", "", "ranget", trange);

is_area = find(p(:, 1) >= 15, 1);
%figure
%subplot(3,1,1);
area([t(1), t(is_area(1)), t(is_area(1)), t(end)], [-10, -10, 40, 40]', -10, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on
pbaspect([2 1 1]);
grid on
p = plot(t, p(:, 1), 'k-', t, p(:, 2), 'k-.', t, pe(:, 1), 'b--', t, pe(:, 2), 'g--', 'LineWidth', 2); %,[t(is_area(1));t(is_area(1))],[-100;100],'k-.');
p(1).LineWidth = 1;
p(2).LineWidth = 1;
area([t(1), t(is_area(1)), t(is_area(1)), t(end)], -10 * [1, 1, 1, 1]', -10, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
legend("", "true $x$", "true $y$", "est. $x$", "est. $y$", "Insufficient area", 'Interpreter', 'latex', 'location', 'northwest')
%hold on
%Square_coloring([t(1),t(end)], [1 0.5 0.5],[75,75],15);
xlabel("$t$ [s]", 'Interpreter', 'latex');
ylabel("$x$, $y$ [m]", 'Interpreter', 'latex');
xlim(trange)
ylim([-5, 30])
ax = gca;
hold off
filename = strcat(name, 'xy_[0,30]', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);

%% subplot(3,1,2);
area([t(1), t(is_area(1)), t(is_area(1)), t(end)], [-2, -2, 10, 10]', -2, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on
pbaspect([2 1 1]);
grid on
p = plot(t, v, 'k-', t, ve, 'b--', 'LineWidth', 2); %,[t(is_area(1));t(is_area(1))],[-100;100],'k-.');
p(1).LineWidth = 1;
area([t(1), t(is_area(1)), t(is_area(1)), t(end)], -2 * [1, 1, 1, 1]', -2, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
legend("", "true $v$", "est. $v$", "Insufficient area", 'Interpreter', 'latex', 'location', 'southeast');
xlabel("$t$ [s]", 'Interpreter', 'latex');
ylabel("$v$ [m/s]", 'Interpreter', 'latex');
xlim(trange);
ylim([0.5, 1.5]);
ax = gca;
hold off
filename = strcat(name, 'v_[0,30]', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);

%% subplot(3,1,3);
area([t(1), t(is_area(1)), t(is_area(1)), t(end)], [-2, -2, 1, 1]', -2, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on
pbaspect([2 1 1]);
grid on
p = plot(t, q, 'k-', t, qe, 'b--', 'LineWidth', 2);
p(1).LineWidth = 1;
% dummy
area([t(1), t(is_area(1)), t(is_area(1)), t(end)], -2 * [1, 1, 1, 1]', -2, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
legend("", "true $\theta$", "est. $\theta$", "Insufficient area", 'Interpreter', 'latex', 'location', 'northwest');
xlabel("$t$ [s]", 'Interpreter', 'latex');
ylabel("$\theta$ [rad]", 'Interpreter', 'latex');
xlim(trange);
ylim([-0.8, 0.8]);
ax = gca;
hold off
filename = strcat(name, 'th_[0,30]', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);
%% trajectory
close all
t = logger.data(0, "t", "");
trange = [0, t(end)];
p = logger.data(1, "p", "p", "ranget", trange);
q = logger.data(1, "q", "p", "ranget", trange);
v = logger.data(1, "v", "p", "ranget", trange);
pe = logger.data(1, "p", "e", "ranget", trange);
qe = logger.data(1, "q", "e", "ranget", trange);
ve = logger.data(1, "v", "e", "ranget", trange);
pr = logger.data(1, "p", "r", "ranget", trange);
qr = logger.data(1, "q", "r", "ranget", trange);
vr = logger.data(1, "v", "r", "ranget", trange);
u = logger.data(1, "input", "", "ranget", trange);
map_param = logger.data(1, "map_param", "e", "ranget", trange);

% insufficient information area
is_area = [find(p(:, 1) >= 15, 1), find(p(:, 1) >= 75, 1) - 1, find(p(:, 2) >= 15, 1), find(p(:, 2) >= 75, 1) - 1];
si = is_area(end) + 1;
is_area = [is_area, is_area(end) + [find(p(si:end, 1) <= 75, 1), find(p(si:end, 1) <= 15, 1) - 1, find(p(si:end, 2) <= 75, 1), find(p(si:end, 2) <= 15, 1) - 1]];
si = is_area(end) + 10;
is_area = [is_area, is_area(end) + [find(p(si:end, 1) >= 15, 1), find(p(si:end, 1) >= 75, 1) - 1, find(p(si:end, 2) >= 15, 1), find(p(si:end, 2) >= 75, 1) - 1]];

p_Area = polyshape(logger.Data.env_vertices{1});

% 初期状態
PlantFinalState = p(1, :);
PlantFinalStatesquare = PlantFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1]';
PlantFinalStatesquare = polyshape(PlantFinalStatesquare);
PlantFinalStatesquare = rotate(PlantFinalStatesquare, 180 * q(1) / pi, p(1, :));
PlotFinalPlant = plot(PlantFinalStatesquare, 'FaceColor', [0.5020, 0.5020, 0.5020], 'FaceAlpha', 0.5);
grid on
axis equal
hold on
plot(polyshape([15 15 75 75; -5 0 0 -5]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([-5 -5 0 0; 15 75 75 15]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([90 90 95 95; 15 75 75 15]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([15 15 75 75; 90 95 95 90]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
xmin = -5;
xmax = 95;
ymin = -5;
ymax = 95;
xlim([xmin - 5, xmax + 5]); ylim([ymin - 5, ymax + 5])
Wall = plot(p_Area, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
% dummy
ah = area([-5 15 15 75 75 95], -30 * [1 1 1 1 1 1]', -100, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
xlabel("$x$ [m]", "Interpreter", "latex");
ylabel("$y$ [m]", "Interpreter", "latex");
legend("Initial position", "", "", "", "", "True walls", "Insufficient area", 'Location', 'northoutside', 'NumColumns', 3, 'Interpreter', 'latex')
ax = gca;
filename = strcat("", 'environment', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);
hold off

%% plantFinalState
PlantFinalState = p(end, :);
PlantFinalStatesquare = PlantFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1]';
PlantFinalStatesquare = polyshape(PlantFinalStatesquare);
PlantFinalStatesquare = rotate(PlantFinalStatesquare, 180 * q(end) / pi, p(end, :));
PlotFinalPlant = plot(PlantFinalStatesquare, 'FaceColor', [0.5020, 0.5020, 0.5020], 'FaceAlpha', 0.5);
grid on
axis equal
hold on
%modelFinalState
EstFinalState = pe(end, :);
EstFinalStatesquare = EstFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1]';
EstFinalStatesquare = polyshape(EstFinalStatesquare);
EstFinalStatesquare = rotate(EstFinalStatesquare, 180 * qe(end) / pi, pe(end, :));
PlotFinalEst = plot(EstFinalStatesquare, 'FaceColor', [0.0745, 0.6235, 1.0000], 'FaceAlpha', 0.5);
Ewall = map_param(end);
Ewallx = reshape([Ewall.x, NaN(size(Ewall.x, 1), 1)]', 3 * size(Ewall.x, 1), 1);
Ewally = reshape([Ewall.y, NaN(size(Ewall.y, 1), 1)]', 3 * size(Ewall.y, 1), 1);

plot(polyshape([15 15 75 75; -5 0 0 -5]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([-5 -5 0 0; 15 75 75 15]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([90 90 95 95; 15 75 75 15]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([15 15 75 75; 90 95 95 90]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);

plot(pe(:, 1), pe(:, 2), 'Color', '#4DBEEE', 'LineWidth', 2);
plot(p(:, 1), p(:, 2), 'Color', '#333333', 'LineWidth', 2);
xmin = min(-5, min(Ewallx));
xmax = max(95, max(Ewallx));
ymin = min(-5, min(Ewally));
ymax = max(95, max(Ewally));
xlim([xmin - 5, xmax + 5]); ylim([ymin - 5, ymax + 5])
Wall = plot(p_Area, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
plot(Ewallx, Ewally, 'r-');
ah = area([-5 15 15 75 75 95], -30 * [1 1 1 1 1 1]', -100, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
xlabel("$x$ [m]", "Interpreter", "latex");
ylabel("$y$ [m]", "Interpreter", "latex");
legend("", "", "", "", "", "", "Est. trajectory", "True trajectory", "True walls", "Est. walls", "Insufficient area", 'Location', 'northoutside', 'NumColumns', 3, 'Interpreter', 'latex')
hold off

ax = gca;
filename = strcat(name, 'MapAndTrajectory', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);
%%
tid = 401;
PlantFinalState = p(tid, :);
PlantFinalStatesquare = PlantFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1]';
PlantFinalStatesquare = polyshape(PlantFinalStatesquare);
PlantFinalStatesquare = rotate(PlantFinalStatesquare, 180 * q(tid) / pi, p(tid, :));
PlotFinalPlant = plot(PlantFinalStatesquare, 'FaceColor', [0.5020, 0.5020, 0.5020], 'FaceAlpha', 0.5);

grid on
axis equal
hold on
%modelFinalState
EstFinalState = pe(tid, :);
EstFinalStatesquare = EstFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1]';
EstFinalStatesquare = polyshape(EstFinalStatesquare);
EstFinalStatesquare = rotate(EstFinalStatesquare, 180 * qe(tid) / pi, pe(tid, :));
PlotFinalEst = plot(EstFinalStatesquare, 'FaceColor', [0.0745, 0.6235, 1.0000], 'FaceAlpha', 0.5);
Ewall = map_param(tid);
Ewallx = reshape([Ewall.x, NaN(size(Ewall.x, 1), 1)]', 3 * size(Ewall.x, 1), 1);
Ewally = reshape([Ewall.y, NaN(size(Ewall.y, 1), 1)]', 3 * size(Ewall.y, 1), 1);

plot(polyshape([15 15 75 75; -5 0 0 -5]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([-5 -5 0 0; 15 75 75 15]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([90 90 95 95; 15 75 75 15]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);
plot(polyshape([15 15 75 75; 90 95 95 90]'), "FaceColor", "#EEAAAA", "LineStyle", 'none', "FaceAlpha", 0.5);

plot(pe(1:tid, 1), pe(1:tid, 2), 'Color', '#4DBEEE', 'LineWidth', 2);
plot(p(1:tid, 1), p(1:tid, 2), 'Color', '#333333', 'LineWidth', 2);
xmin = 0;
xmax = 40;
ymin = 0;
ymax = -5;
xlim([xmin - 5, xmax + 5]); ylim([ymin - 5, ymax + 5])
Wall = plot(p_Area, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
plot(Ewallx, Ewally, 'r-');
ah = area([-5 15 15 75 75 95], -30 * [1 1 1 1 1 1]', -100, 'FaceColor', '#EEAAAA', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
xlabel("$x$ [m]", "Interpreter", "latex");
ylabel("$y$ [m]", "Interpreter", "latex");
legend("", "", "", "", "", "", "Est. trajectory", "True trajectory", "True walls", "Est. walls", "Insufficient area", 'Location', 'northoutside', 'NumColumns', 3, 'Interpreter', 'latex')
hold off

ax = gca;
filename = strcat(name, 'MapAndTrajectory_part', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);

%%
close all
figure
Plots = DataPlot(logger, dirname, name, "RMSE", {2}, [0, 20]);
%Plots = DataPlot(logger,dirname,name,"Input",{2},[0,30]);
%Plots = DataPlot(logger, dirname, name, "Eval", {is_area(1)}, [0, 30]);

%% snapshot
%name = "comp_"
close all
initial.p = [0, -1];
initial.q = 0;
initial.v = 0;
agent = DRONE(Model_WheelChairA(1, 0.1, 'plant', initial));
agent(1).set_property("env", Env_FloorMap_sim_circle(1)); %四角経路
% 1s
snapshot(0.95, logger, agent, 0)
ax = gca;
filename = strcat(name, '1s', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);
% 30s
snapshot(30, logger, agent, 0)
ax = gca;
filename = strcat(name, '30s', '.pdf');
exportgraphics(ax, filename);
movefile(filename, dirname);

function snapshot(t, logger, agent, flag)
tid = find(logger.Data.t - t >= 0, 1);
time.t = logger.Data.t(tid)
logger.overwrite("plant", time.t, agent, 1);
logger.overwrite("estimator", time.t, agent, 1);
agent.estimator.ukfslam_WC.map_param = agent.estimator.result.map_param;
agent.estimator.ukfslam_WC.result = agent.estimator.result;
logger.overwrite("sensor", time.t, agent, 1);
agent.sensor.LiDAR.result = agent.sensor.result;
logger.overwrite("reference", time.t, agent, 1);
agent.reference.TrackWpointPathForMPC.result.PreTrack = agent.reference.result.state.p;
logger.overwrite("controller", time.t, agent, 1);
agent.controller.TrackingMPCMEX_Controller.self = agent;
agent.controller.TrackingMPCMEX_Controller.result = agent.controller.result;
logger.overwrite("input", time.t, agent, 1);

figure()
grid on
axis equal
hold on
MapIdx = size(agent.env.Floor.param.Vertices, 3);

for ei = 1:MapIdx
    tmpenv(ei) = polyshape(agent.env.Floor.param.Vertices(:, :, ei));
end

area([15, 75], [0, 0], -5, 'FaceColor', '#EEAAAA', 'EdgeColor', 'none', 'LineStyle', 'none', 'ShowBaseLine', 'off', 'FaceAlpha', 0.5);
p_Area = union(tmpenv(:));
%plantFinalState
PlantFinalState = agent.plant.state.p(:, end);
PlantFinalStatesquare = PlantFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1];
PlantFinalStatesquare = polyshape(PlantFinalStatesquare');
PlantFinalStatesquare = rotate(PlantFinalStatesquare, 180 * agent.plant.state.q(end) / pi, agent.plant.state.p(:, end)');
PlotFinalPlant = plot(PlantFinalStatesquare, 'FaceColor', [0.5020, 0.5020, 0.5020], 'FaceAlpha', 0.5);
%modelFinalState
EstFinalState = agent.estimator.result.state.p(:, end);
EstFinalStatesquare = EstFinalState + 0.5 .* [1, 1.5, 1, -1, -1; 1, 0, -1, -1, 1];
EstFinalStatesquare = polyshape(EstFinalStatesquare');
EstFinalStatesquare = rotate(EstFinalStatesquare, 180 * agent.estimator.result.state.q(end) / pi, agent.estimator.result.state.p(:, end)');
PlotFinalEst = plot(EstFinalStatesquare, 'FaceColor', [0.0745, 0.6235, 1.0000], 'FaceAlpha', 0.5);
Ewall = agent.estimator.result.map_param;
Ewallx = reshape([Ewall.x, NaN(size(Ewall.x, 1), 1)]', 3 * size(Ewall.x, 1), 1);
Ewally = reshape([Ewall.y, NaN(size(Ewall.y, 1), 1)]', 3 * size(Ewall.y, 1), 1);
%reference state
RefState = agent.reference.result.state.p(1:3, :);
fWall = agent.reference.result.focusedLine;

Ref = plot(RefState(1, :), RefState(2, :), 'ro', 'LineWidth', 1);
quiver(RefState(1, :), RefState(2, :), 2 * cos(RefState(3, :)), 2 * sin(RefState(3, :)));
Wall = plot(p_Area, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
plot(Ewallx, Ewally, 'r-', 'LineWidth', 2);
plot(fWall(:, 1), fWall(:, 2), 'r-', 'LineWidth', 2);
O = agent.reference.result.O;
%plot(O(1),O(2),'r*');
%xlim([PlantFinalState(1)-10, PlantFinalState(1)+10]);ylim([PlantFinalState(2)-10,PlantFinalState(2)+10])
if isstring(flag)
    xmin = min(-5, min(Ewallx));
    xmax = max(95, max(Ewallx));
    ymin = min(-5, min(Ewally));
    ymax = max(95, max(Ewally));
    xlim([xmin - 5, xmax + 5]); ylim([ymin - 5, ymax + 5])
else
    l = 5;
    xlim([EstFinalState(1) - l, EstFinalState(1) + l]); ylim([EstFinalState(2) - l, EstFinalState(2) + l])
end

area([15, 75], [-5, -5], -5, 'FaceColor', '#EEAAAA', 'EdgeColor', 'none');
xlabel("$x$ [m]", "Interpreter", "latex");
ylabel("$y$ [m]", "Interpreter", "latex");
legend("", "true position", "est. position", "ref. point", "ref.direction", "", "est. wall", "")
% pbaspect([20 20 1])
hold off
end

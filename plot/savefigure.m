%%
% SigmaData = zeros(4, te/dt);
% te = 10;
close all
clear
% fprintf("%f秒\n", totalT)
Fontsize = 15;  
set(0, 'defaultAxesFontSize',15);
set(0,'defaultTextFontsize',15);
set(0,'defaultLineLineWidth',1.5);
set(0,'defaultLineMarkerSize',15);
figtype = 1;
flg.MPC = 0; % without TIMEVARYING

% load("../データセット/Exp_2_4_150.mat");
% load('Data/KMPC_100s.mat');
load('Koopman_Linearization\Sim_P2Py_previous_sigmoid.mat');
% load('Koopman_Linearization\Sim_P2Py_X20_sigmoid.mat');
%% Importing data
if exist("app") ~= 7        % GUI実行中
    logt = app.logger.Data.t;
    xmax = app.time.t-app.time.dt;
    logAgent = app.logger.Data.agent;
elseif exist("log") == 1    % matを読み込んだ
    logt = log.Data.t(1:find(log.Data.t(2:end)==0, 1, 'first'));
    xmax = log.Data.t(find(log.Data.t(2:end)==0, 1, 'first'));
    logAgent = log.Data.agent;
elseif exist("logger") == 1
    logt = logger.Data.t(1:find(logger.Data.t(2:end)==0, 1, 'first'));
    xmax = logger.Data.t(find(logger.Data.t(2:end)==0, 1, 'first'));
    logAgent = logger.Data.agent;
else                        % GUIを閉じた
    logt = gui.logger.Data.t;
    xmax = gui.time.t-gui.time.dt;
    logAgent = gui.logger.Data.agent;
end

Data.est = cell2mat(arrayfun(@(N) logAgent.estimator.result{N}.state.get(),1:length(logt)-1,'UniformOutput',false));
Data.input = cell2mat(arrayfun(@(N) logAgent.input{N},1:length(logt)-1,'UniformOutput',false));
if ~flg.MPC
    Data.ref = [cell2mat(arrayfun(@(N) logAgent.reference.result{N}.state.p,1:length(logt)-1,'UniformOutput',false));
                zeros(3, length(logt)-1);
                cell2mat(arrayfun(@(N) logAgent.reference.result{N}.state.v,1:length(logt)-1,'UniformOutput',false));
                zeros(10, length(logt)-1)];
    Data.inputv = zeros(4, length(logt)-1);
else
    Data.ref = cell2mat(arrayfun(@(N) logAgent.controller.result{N}.xr(:,1),1:length(logt)-1,'UniformOutput',false));
    Data.inputv = cell2mat(arrayfun(@(N) logAgent.controller.result{N}.input_v,1:length(logt)-1,'UniformOutput',false));
end
% いずれここなくしたい-------
logt = logt(1:end-1); % time
Pdata = Data.est(1:3,:); % position
Qdata = Data.est(4:6,:); % attitude
Vdata = Data.est(7:9,:); % velocity
Wdata = Data.est(10:12,:); % angular velocity
Rdata = [Data.ref(1:12,:); Data.ref(17:19, :)]; % X, acceralation
InputV = Data.inputv;
Idata = Data.input;
Diff = Pdata - Rdata(1:3, :);
% ---------------------------
cutT = 0;
close all

m = 3; n = 2;

% exportgraphics(gcf, "path"); % save image file
% saveas(fig_number,"path")

if figtype == 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    figure(1); plot(logt, Pdata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    figure(2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    figure(3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    figure(4); plot(logt, Idata, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    figure(5); plot(logt, InputV); legend("Z", "X", "Y", "YAW");
elseif figtype ~= 1
    % Title = strcat('LandingFreeFall', '-N', num2str(data.param.Maxparticle_num), '-', num2str(te), 's-', datestr(datetime('now'), 'HHMMSS'));
    subplot(m,n,1); plot(logt, Pdata); hold on; plot(logt, Rdata(1:3, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Position [m]"); legend("x.state", "y.state", "z.state", "x.reference", "y.reference", "z.reference",  "Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Position"); 
    % attitude
    subplot(m,n,2); plot(logt, Qdata); hold on; plot(logt, Rdata(4:6, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Attitude [rad]"); legend("roll", "pitch", "yaw", "roll.reference", "pitch.reference", "yaw.reference", "Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Atiitude");
    % velocity
    subplot(m,n,3); plot(logt, Vdata); hold on; plot(logt, Rdata(7:9, :), '--'); hold off;
    xlabel("Time [s]"); ylabel("Velocity [m/s]"); legend("vx", "vy", "vz", "vx.ref", "vy.ref", "vz.ref", "Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % title("Time change of Velocity"); 
    % input
    subplot(m,n,4); plot(logt, Idata, "LineWidth", 1.5); hold on;
    xlabel("Time [s]"); ylabel("Input [N]"); legend("input.total", "input.roll", "input.pitch", "input.yaw","Location","best");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    ytickformat('%.1f');
    % virtual input
    subplot(m,n,5); plot(logt, InputV); legend("Z", "X", "Y", "YAW");
    xlabel("Time [s]"); ylabel("Imaginary input");
    grid on; xlim([0 xmax]); ylim([-inf inf]);
    % 3D plot
    subplot(m,n,6); plot3(Pdata(1,:), Pdata(2,:), Pdata(3,:)); hold on;
    plot3(Pdata(1,1), Pdata(2,1), Pdata(3,1),'+', 'MarkerSize', 15)
    xlabel("Time [s]"); ylabel("Position [m]"); grid on;
    set(gca,'FontSize',Fontsize);  grid on; title("");
    xlabel("Time [s]");
    
    set(gcf, "WindowState", "maximized");
    set(gcf, "Position", [960 0 960 1000])
end
%


%
cd(strcat(fileparts(matlab.desktop.editor.getActive().Filename), '../../')); % drone/のこと

%% いろいろテストするところ
% close all 
% syms t
% a = 0.5;
% ttt = 20;
% 
% x = 0;
% y = 1./(1+exp(a*(-t + ttt./2)));
% z = 1;
% 
% vx = diff(x, t);
% vy = diff(y, t);
% vz = diff(z, t);
% 
% Ti = 0:0.025:20;
% subplot(1,2,1); plot(Ti, [subs(x, t, Ti); subs(y, t, Ti); subs(z, t, Ti)]); legend("x", "y", "z");
% subplot(1,2,2); plot(Ti, [subs(vx, t, Ti); subs(vy, t, Ti); subs(vz, t, Ti)]); legend("vx", "vy", "vz");

%% 目標軌道までスプライン補間
% close all
% npts = 2;
% t = linspace(0,8*pi,npts);
% z = linspace(-1,1,npts);
% omz = sqrt(1-z.^2);
% xyz = [cos(t).*omz; sin(t).*omz; z];
% plot3(xyz(1,:),xyz(2,:),xyz(3,:),'ro','LineWidth',2);
% text(xyz(1,:),xyz(2,:),xyz(3,:),[repmat('  ',npts,1), num2str((1:npts)')])
% ax = gca;
% ax.XTick = [];
% ax.YTick = [];
% ax.ZTick = [];
% box on
% 
% hold on
% fnplt(cscvn(xyz(:,[1:end 1])),'r',2)
% hold off
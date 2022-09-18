tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
[~,tmp]=regexp(genpath('.'),'\.\\\.git.*?;','match','split');cellfun(@(xx) addpath(xx),tmp,'UniformOutput',false);
logger = LOGGER("Data/AROB2022_Comp300s_Log(19-Sep-2022_05_18_59)");%AROB2022_Comp300s_Log(18-Sep-2022_23_40_39)");
name = 'comp_';
dirname = "AROB";
close all
%% time response
trange = [0,20];
t = logger.data(0,"t","","ranget",trange);
p = logger.data(1,"p","p","ranget",trange);
q = logger.data(1,"q","p","ranget",trange);
v = logger.data(1,"v","p","ranget",trange);
pe = logger.data(1,"p","e","ranget",trange);
qe = logger.data(1,"q","e","ranget",trange);
ve = logger.data(1,"v","e","ranget",trange);
pr = logger.data(1,"p","r","ranget",trange);
qr = logger.data(1,"q","r","ranget",trange);
vr = logger.data(1,"v","r","ranget",trange);
u = logger.data(1,"input","","ranget",trange);

is_area=find(p(:,1)>=15,1);
figure
subplot(2,1,1);
plot(t,p,t,pe,[t(is_area(1));t(is_area(1))],[-100;100],'k-.');
legend("true $x$","true $y$","est. $x$","est. $y$",'Interpreter','latex','location','east')
hold on
Square_coloring([t(1),t(end)], [1 0.5 0.5],[75,75],15);
xlabel("$t$ [s]",'Interpreter','latex');
ylabel("$x$, $y$ [m]",'Interpreter','latex');
xlim(trange)
ylim([-5,30])
ax = gca;

filename = strcat(name,'xy_[0,20]','.pdf');
exportgraphics(ax,filename);
movefile(filename,dirname);

subplot(2,1,2);
plot(t,v,t,ve,[t(is_area(1));t(is_area(1))],[-100;100],'k-.');
legend("true $v$","est. $v$",'Interpreter','latex','location','southeast');
xlabel("$t$ [s]",'Interpreter','latex');
ylabel("$v$ [m/s]",'Interpreter','latex');
xlim(trange);
ylim([0,2]);
ax = gca;
filename = strcat(name,'v_[0,20]','.pdf');
exportgraphics(ax,filename);
movefile(filename,dirname);
%% trajectory
close all 
t = logger.data(0,"t","");
trange = [0,t(end)];
p = logger.data(1,"p","p","ranget",trange);
q = logger.data(1,"q","p","ranget",trange);
v = logger.data(1,"v","p","ranget",trange);
pe = logger.data(1,"p","e","ranget",trange);
qe = logger.data(1,"q","e","ranget",trange);
ve = logger.data(1,"v","e","ranget",trange);
pr = logger.data(1,"p","r","ranget",trange);
qr = logger.data(1,"q","r","ranget",trange);
vr = logger.data(1,"v","r","ranget",trange);
u = logger.data(1,"input","","ranget",trange);
map_param = logger.data(1,"map_param","e","ranget",trange);

% insufficient information area
is_area=[find(p(:,1)>=15,1),find(p(:,1)>=75,1)-1,find(p(:,2)>=15,1),find(p(:,2)>=75,1)-1];
si = is_area(end)+1;
is_area=[is_area,is_area(end)+[find(p(si:end,1)<=75,1),find(p(si:end,1)<=15,1)-1,find(p(si:end,2)<=75,1),find(p(si:end,2)<=15,1)-1]];
si = is_area(end)+1;
is_area=[is_area,is_area(end)+[find(p(si:end,1)>=15,1),find(p(si:end,1)>=75,1)-1,find(p(si:end,2)>=15,1),find(p(si:end,2)>=75,1)-1]];


p_Area=polyshape(logger.Data.env_vertices{1});
    grid on
    axis equal
    hold on
%plantFinalState
PlantFinalState = p(end,:);
PlantFinalStatesquare = PlantFinalState + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1]';
PlantFinalStatesquare =  polyshape( PlantFinalStatesquare);
PlantFinalStatesquare =  rotate(PlantFinalStatesquare,180 * q(end) / pi, p(end,:));
PlotFinalPlant = plot(PlantFinalStatesquare,'FaceColor',[0.5020,0.5020,0.5020],'FaceAlpha',0.5);
%modelFinalState
EstFinalState = pe(end,:);
EstFinalStatesquare = EstFinalState + 0.5.*[1,1.5,1,-1,-1;1,0,-1,-1,1]';
EstFinalStatesquare =  polyshape( EstFinalStatesquare);
EstFinalStatesquare =  rotate(EstFinalStatesquare,180 * qe(end) / pi, pe(end,:));
PlotFinalEst = plot(EstFinalStatesquare,'FaceColor',[0.0745,0.6235,1.0000],'FaceAlpha',0.5);
Ewall = map_param(end);
Ewallx = reshape([Ewall.x,NaN(size(Ewall.x,1),1)]',3*size(Ewall.x,1),1);
Ewally = reshape([Ewall.y,NaN(size(Ewall.y,1),1)]',3*size(Ewall.y,1),1);


ah = area([-5 15 15 75 75 95],[15 15 -5 -5 15 15;60 60 100 100 60 60]',-100,'FaceColor','#EEAAAA','FaceAlpha',0.5,'EdgeColor','none');
ah(1).FaceColor = [1 1 1];

plot(p(:,1),p(:,2),'Color','#333333');
plot(pe(:,1),pe(:,2),'Color','#4DBEEE');
    xmin = min(-5,min(Ewallx));
    xmax = max(95,max(Ewallx));
    ymin = min(-5,min(Ewally));
    ymax = max(95,max(Ewally));
    xlim([xmin-5, xmax+5]);ylim([ymin-5,ymax+5])
Wall = plot(p_Area,'FaceColor','blue','FaceAlpha',1);
plot(Ewallx,Ewally,'r-');
ah = area([-5 15 15 75 75 95],-30*[1 1 1 1 1 1]',-100,'FaceColor','#EEAAAA','FaceAlpha',0.5,'EdgeColor','none');
xlabel("$x$ [m]","Interpreter","latex");
ylabel("$y$ [m]","Interpreter","latex");
legend("","","","","True trajectory","Est. trajectory","True walls","Est. walls","Insufficient area",'Location','northoutside','NumColumns',3,'Interpreter','latex')
hold off

ax = gca;
filename = strcat(name,'MapAndTrajectory','.pdf');
exportgraphics(ax,filename);
movefile(filename,dirname);
%%
Plots = DataPlot(logger,dirname,name,"Eval",{is_area});
Plots = DataPlot(logger,dirname,name,["RMSE","Input"],{2,3});
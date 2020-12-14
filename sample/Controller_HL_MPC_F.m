function Controller_HL_MPC_F(agent,i,arranged_pos)
%% controller class demo (1) : construct
% controller property をController classのインスタンス配列として定義

%隊列飛行のコントローラの設定
Controller_param.H =10;
Controller_param.dt = 0.25;
[~,Controller_param.N] = size(arranged_pos);
Controller_param.P_chips = 0;
%セクションポイント
Sections_point = [0,0;4,0;4,2.5];%目標経路のセクションポイントの座標
Initial_Section = 1;%初期セクション　1
Controller_param.wall_width_x = [0,4.5;3.4,4.6];%経路幅のパラメータ　x座標
Controller_param.wall_width_y = [-0.6,0.6;-0.6,3];%y座標
Controller_param.wall_width_xx = zeros(11,2);
Controller_param.wall_width_yy = zeros(11,2);
Controller_param.Sectionconect = zeros(11,2);
Pdata.Target = [4.0,0;4.0,2.5];
Pdata.flag=1;
Pdata.v=0.5;%0.2
Controller_param.Pdata = Pdata;
Controller_param.P_limit = size(Pdata.Target,1);
Controller_param.Section_change = ones(1,4);
Controller_param.sectionpoint = Sections_point;
Controller_param.Sectionnumber = Initial_Section;
Controller_param.Cdis = zeros(1,11);
Controller_param.Line_Y = zeros(1,11);

Controller_param.arranged_pos=arranged_pos;
dt = agent(1).model.dt;
Controller_param.P=getParameter();
Controller_param.F1=lqrd([0 1;0 0],[0;1],diag([10,1]),[1],dt);                                % z 
Controller_param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[1],dt); % x
Controller_param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,10,10,1]),[1],dt); % y
Controller_param.F4=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);                       % ヨー角 
% Controller_param.F1=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
% Controller_param.F2=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[0.1]);
% Controller_param.F3=lqr([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[0.1]);
% Controller_param.F4=lqr([0 1;0 0],[0;1],diag([1,1]),[1]);
Controller_param.dt = dt;
% Controller_param.agent(i).controller = 1;
%  eig(diag([1,1,1],1)-[0;0;0;1]*Controller_param.F2)
Controller.type="Follower_HL_MPCholizontal";
Controller.name="mpc_f";
Controller.param=Controller_param;
agent(i).set_controller(Controller);

%assignin('base',"Controller_param",Controller_param);

end

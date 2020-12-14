%隊列飛行のコントローラの設定
Controller.param.H =10;
Controller.param.dt = 0.25;
Controller.param.N = N;
Controller.param.P_chips = 0;
%セクションポイント
Sections_point = [0,0;4,0;4,2.5];%目標経路のセクションポイントの座標
Initial_Section = 1;%初期セクション　1
Controller.param.wall_width_x = [0,4.5;3.4,4.6];%経路幅のパラメータ　x座標
Controller.param.wall_width_y = [-0.6,0.6;-0.6,3];%y座標
Pdata.Target = [4.0,0;4.0,2.5];
Pdata.flag=1;
Pdata.v=0.2;
Controller.param.Pdata = Pdata;
Controller.param.P_limit = size(Pdata.Target,1);
Controller.param.Section_change = ones(1,4);


Controller.param.sectionpoint = Sections_point;
Controller.param.Sectionnumber = Initial_Section;

Controller.type="Leader_HL_MPCholizontal";Controller.name = "mpc_f"; agent(1).set_controller(Controller)
for i = 2:N-1;  Controller.type="Follower_HL_MPCholizontal";Controller.name = "mpc_f";agent(i).set_controller(Controller);
    end
if N~=1
    dt = agent(1).model.dt;
    EndController.param.P=getParameter();
    EndController.param.F1=lqrd([0 1;0 0],[0;1],diag([100,1]),[1],dt);
    EndController.param.F2=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
    EndController.param.F3=lqrd([0 1 0 0;0 0 1 0;0 0 0 1; 0 0 0 0],[0;0;0;1],diag([100,1,1,1]),[1],dt);
    EndController.param.F4=lqrd([0 1;0 0],[0;1],diag([1,1]),[1],dt);

    EndController.type="HLController_quadcopter";EndController.name = "hlcontroller";agent(N).set_controller(EndController);
end
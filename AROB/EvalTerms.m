function eval = EvalTerms(logger)
%評価値を算出して返すプログラム
%観測値差分，角速度変化，目標値角度との誤差からなる．
%---Get robot state---%
t = logger.data(0,"t","");
dt = t(2)-t(1);
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
ai = logger.data(1,"AssociationInfo","e");
Slength=logger.data(1,"length","s");
Sangle = logger.data(1,"angle","s");
RobotState = [pe qe];
%----------------------%
for k = 1:length(t)
%---マップ情報をとる---%
LineParam = CF_ConvertLineParam(map_param(k));
AssociationInfo = ai(k);
%---------------------%

%---センサ情報をとる---%
Measured.ranges = Slength(k);
Measured.angles = Sangle;% - RobotState(k,3);%
if iscolumn(Measured.ranges)
    Measured.ranges = Measured.ranges';% Transposition
end
if iscolumn(Measured.angles)
    Measured.angles = Measured.angles';% Transposition
end
%---------------------%

%Global planningから供給される目標位置のデータ
Xd = pr(k,:);
%目標位置までの角度差を出す．
LineTheta = atan2(Xd(2) - RobotState(2),Xd(1) - RobotState(1));
Theta = RobotState(3);
DeltaTheta = LineTheta - Theta;
Deltaomega = DeltaTheta/dt;%目標位置に向かうための角速度
%---対応づけしたレーザ（壁にあたってるレーザ）の角度faiおよびその壁のdとalpahaを取得---%
AssociationAvailableIndex = find(AssociationInfo.index ~= 0);%Index corresponding to the measured value
AssociationAvailableount = length(AssociationAvailableIndex);%Count
Dis = zeros(1,length(Measured.angles));
Alpha = zeros(1,length(Measured.angles));
for i = 1:AssociationAvailableount
    MesuredRef = AssociationAvailableIndex(i);
    idx = AssociationInfo.index(MesuredRef);
    Dis(MesuredRef) = LineParam.d(idx);
    Alpha(MesuredRef) = LineParam.delta(idx);
end
%Dis = Dis(Dis~=0);
%Alpha = Alpha(Alpha~=0);
Dis = Dis(AssociationAvailableIndex);
Alpha = Alpha(AssociationAvailableIndex);
AssoFai = Measured.angles(AssociationAvailableIndex);
%----------------------------------------------------------------------------------%

%---最適化計算用のパラメータを算出---%
params.dis = Dis;%wall distanse
params.alpha = Alpha;%wall angle
params.phi = AssoFai;%raser angle
params.pos = RobotState;%robot position [x y theta]
%             params.t = %control tic
params.DeltaOmega = Deltaomega;
params.t = dt;
params.v = 1;
params.k1 = 1;
params.k2 = 1;
params.k3 = 1;
%             params.Oldw = oldinput(2);
%params.Oldw = obj.target.estimator.result.state.w;
params.ipsiron = 1e-5;
%----------------------------------%


hk1 = (params.dis - params.pos(1).*cos(params.alpha) - params.pos(2).*sin(params.alpha))./cos(params.phi - params.alpha + params.pos(3));
hk2 = (params.dis - (params.pos(1)+u(1).*cos(params.pos(3)).*params.t)*cos(params.alpha) - (params.pos(2)+u(1).*sin(params.pos(3)).*params.t).*sin(params.alpha))./cos(params.phi - params.alpha +(params.pos(3)+u(2).*params.t));

deltah = (hk1 - hk2) * (hk1 - hk2)';%観測値差分の２乗のsum
% eval = 1/(deltah + params.ipsiron) + params.k1 *(u(2) - params.DeltaOmega)^2 + params.k2 * (u(2) - params.Oldw)^2 + params.k3 * (u(1) - params.v)^2;%観測値差分の逆数と目標に向かう角速度
eval(k) = 1/(deltah + params.ipsiron);
end
end
function parameter = CF_ConvertLineParam(map_param)
    % Initialize each variable
    MapStruct = map_param;
    map_size = length(MapStruct.index);
    parameter.d = zeros(map_size, 1);
    parameter.delta = zeros(map_size, 1);
    for i = 1:length(MapStruct.index)
        % Calculation of distance using the formula of distance between point and line
        parameter.d(i) = abs(MapStruct.c(i)) / sqrt(MapStruct.a(i) ^ 2 + MapStruct.b(i) ^ 2);
        % Calculation of angle using the formula of normal vector
        t = -MapStruct.c(i) / (MapStruct.a(i) ^ 2 + MapStruct.b(i) ^ 2);
        parameter.delta(i) = atan2(t * MapStruct.b(i), t * MapStruct.a(i));
    end
end

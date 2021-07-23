function InvFim = ObserbSubFIM(obj)
%評価値を算出して返すプログラム
%観測値差分，角速度変化，目標値角度との誤差からなる．
%---Get robot state---%
RobotState = [obj.target.estimator.result.state.p(1) , obj.target.estimator.result.state.p(2) , obj.target.estimator.result.state.q];
%----------------------%

%---Get paramerter u---%
if cell2mat(strfind(obj.target.model.state.list,'v'))
    u = [obj.target.estimator.result.state.v,obj.target.estimator.result.state.w];
else
    u = obj.target.input;
end
%---------------------%

%---マップ情報をとる---%
LineParam = CF_ConvertLineParam(obj);
AssociationInfo = obj.target.estimator.result.AssociationInfo;
%---------------------%

%---センサ情報をとる---%
Sensor = obj.target.sensor.result;
Measured.ranges = Sensor.length;
Measured.angles = Sensor.angle - RobotState(3);%
if iscolumn(Measured.ranges)
    Measured.ranges = Measured.ranges';% Transposition
end
if iscolumn(Measured.angles)
    Measured.angles = Measured.angles';% Transposition
end
%---------------------%

%Global planningから供給される目標位置のデータ
Xd = obj.target.reference.result.state.xd;
%目標位置までの角度差を出す．
LineTheta = atan2(Xd(2) - RobotState(2),Xd(1) - RobotState(1));
Theta = RobotState(3);
DeltaTheta = LineTheta - Theta;
Deltaomega = DeltaTheta/obj.target.model.dt;%目標位置に向かうための角速度
%---対応づけしたレーザ（壁にあたってるレーザ）の角度faiおよびその壁のdとalpahaを取得---%
AssociationAvailableIndex = find(AssociationInfo.index ~= 0);%Index corresponding to the measured value
AssociationAvailableount = length(AssociationAvailableIndex);%Count
Dis = zeros(1,length(Measured.angles));
Alpha = zeros(1,length(Measured.angles));
for i = 1:AssociationAvailableount
    MesuredRef = AssociationAvailableIndex(i);
    idx = AssociationInfo.index(AssociationAvailableIndex(i));
    Dis(MesuredRef) = LineParam.d(idx);
    Alpha(MesuredRef) = LineParam.delta(idx);
end
Dis = Dis(Dis~=0);
Alpha = Alpha(Alpha~=0);
AssoFai = Measured.angles(AssociationAvailableIndex);
%----------------------------------------------------------------------------------%
Fim = FIM_ObserbSub(RobotState(1), RobotState(2), RobotState(3), u(1), u(2), obj.target.model.dt, Dis(1), Alpha(1), AssoFai(1));
for i = 2:AssociationAvailableount
    Fim = Fim + FIM_ObserbSub(RobotState(1), RobotState(2), RobotState(3), u(1), u(2), obj.target.model.dt, Dis(i), Alpha(i), AssoFai(i) );
end
Name = obj.target.estimator.name;
sigma2 = obj.target.estimator.(Name).R;
Fim = (1/(2*sigma2))*Fim;
InvFim = inv(Fim);
end

function parameter = CF_ConvertLineParam(obj)
    % Initialize each variable
    MapStruct = obj.target.estimator.result.map_param;
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

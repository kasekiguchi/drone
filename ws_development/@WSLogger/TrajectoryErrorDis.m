function dis = TrajectoryErrorDis(obj)
%評価値を算出して返すプログラム
%観測値差分，角速度変化，目標値角度との誤差からなる．
%---Get robot state---%
RobotState = [obj.target.estimator.result.state.p(1) , obj.target.estimator.result.state.p(2) , obj.target.estimator.result.state.q];
%----------------------%

%---Get reference---%
RefState = [obj.target.reference.GlobalPlanning.result.state(1),obj.target.reference.GlobalPlanning.result.state(2)];
%-------------------%

%---Make reference---%
StartState = FindStartPoint(obj,'estimator.result.state.p');
Line_a = (StartState(2) - RefState(2))/(StartState(1) - RefState(1));
Line_b = StartState(2) - Line_a*StartState(1);
%---------------------%
dis = abs(Line_a*RobotState(1) + 1 * RobotState(2) + Line_b)/sqrt(Line_a^2 + 1);
end

function data = FindStartPoint(logger,Name)
tmp = regexp(logger.items,Name);
tmp = cellfun(@(c) ~isempty(c),tmp);
Index = find(tmp);
if isempty(Index)
    data = 0;
else
    dimension = size(logger.Data.agent{1,Index},1);
    data = zeros(dimension,1);
    for pI = 1:dimension
        data(pI,:) = logger.Data.agent{1,Index}(pI);
    end
end
end

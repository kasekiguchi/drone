% 创建场景
Scenario = uavScenario("UpdateRate", 10);

% 添加圆柱体障碍物
addMesh(Scenario, "cylinder", {[0 0 1] [0 .01]}, [0 1 0]);

% 初始化UAV位置和姿态3
InitialPosition = [0 0 0];
InitialOrientation = [0 0 0];  % [roll, pitch, yaw]

% 创建UAV平台
platUAV = uavPlatform("UAV", Scenario, ...
    "ReferenceFrame", "ENU", ...
    "InitialPosition", InitialPosition, ...
    "InitialOrientation", eul2quat(InitialOrientation));

% 更新UAV模型
updateMesh(platUAV, "quadrotor", {3}, [1 0 0], [0 0 0], eul2quat([0 0 0]));

% 设置场景
setup(Scenario);

% 创建图形窗口
figure('Position', [100 100 800 600]);
ax = gca;
hold(ax, 'on');
grid(ax, 'on');
view(ax, 3);
title('UAV Trajectory with Predicted Path');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
view(45, 30);

% 初始化轨迹存储
trajectory = InitialPosition;
idx = 1;

% 轨迹线对象
trajLine = plot3(ax, trajectory(:,1), trajectory(:,2), trajectory(:,3), 'b-', 'LineWidth', 2);
numPredPoints = 10;
predLine = plot3(ax, nan(numPredPoints,1), nan(numPredPoints,1), nan(numPredPoints,1), ...
    'g-', 'LineWidth', 3, 'DisplayName', 'Predicted Path');

% 角度变化初始化
yawAngle = 0;
rollAngle = 0;
pitchAngle = 0;

while idx < 30
    % 清除前一帧的场景显示
    clf;
    ax = gca;
    hold(ax, 'on');
    grid(ax, 'on');
    view(45, 30);
    axis equal;

    % 计算新位置
    step = [1 0.5 0.2] * 0.8; % 调整步长，使运动更平滑
    newPosition = InitialPosition + step;
    
    % 计算新的姿态（使运动更自然）
    deltaYaw = atan2(step(2), step(1));  % 计算偏航角度
    yawAngle = yawAngle * 0.8 + deltaYaw * 0.2; % 平滑变化
    
    rollAngle = -0.2 * step(2);  % 模拟横向倾斜
    pitchAngle = -0.1 * step(3); % 模拟俯仰角
    
    % 更新无人机位置和姿态
    move(platUAV, [newPosition, zeros(1,6), eul2quat([rollAngle, pitchAngle, yawAngle]), zeros(1,3)]);

    % 存储轨迹点
    trajectory = [trajectory; newPosition];

    numPredSegments = 11; % 11 个预测点
numPredLines = 50;   % 500 条预测轨迹
maxDeviation = 3.0;   % 最大扰动幅度（用于颜色控制）
lookbackSteps = min(5, size(trajectory, 1)); % 计算最近 5 帧的方向

% 计算【正确路径】（基于历史轨迹的延伸）
correctPath = zeros(numPredSegments+1, 3);
correctPath(1, :) = newPosition; % 起点是 UAV 当前位置

% 计算 UAV 运动趋势（从最近 5 帧计算方向）
if lookbackSteps > 1
    recentMotion = trajectory(end, :) - trajectory(end-lookbackSteps+1, :);
    direction = recentMotion / norm(recentMotion); % 归一化方向
else
    direction = [1, 0, 0]; % 初始默认方向
end

% 计算 11 个正确的预测点（主路径）
for i = 2:numPredSegments+1
    correctPath(i, :) = correctPath(i-1, :) + direction * 1.0; % 方向一致，每步 1.0
end

% 绘制【主预测路径】（绿色）
for i = 1:numPredSegments
    plot3([correctPath(i,1), correctPath(i+1,1)], ...
          [correctPath(i,2), correctPath(i+1,2)], ...
          [correctPath(i,3), correctPath(i+1,3)], ...
          'g-', 'LineWidth', 2.5, 'HandleVisibility', 'off'); % 主路径加粗
end

% 生成【花苞状散开路径】
for j = 1:numPredLines
    predictedPath = zeros(numPredSegments+1, 3);
    predictedPath(1, :) = newPosition; % 预测路径的起点是 UAV 当前位置
    
    % 计算偏离正确轨迹的预测点
    for i = 2:numPredSegments+1
        deviation = (rand(1,3) - 0.5) * maxDeviation * (i / numPredSegments); % 远离程度增加
        predictedPath(i, :) = correctPath(i, :) + deviation;
    end

    % 计算轨迹整体偏离程度（用于颜色控制）
    totalDeviation = sum(vecnorm(predictedPath - correctPath, 2, 2)) / numPredSegments;
    deviationRatio = min(totalDeviation / maxDeviation, 1); % 归一化到 [0,1]

    % 计算颜色：绿 → 黄 → 红
    color = [(1 - deviationRatio), (1 - 0.5 * deviationRatio), 0]; % RGB 计算

    % 绘制【散开的预测轨迹】
    for i = 1:numPredSegments
        plot3([predictedPath(i,1), predictedPath(i+1,1)], ...
              [predictedPath(i,2), predictedPath(i+1,2)], ...
              [predictedPath(i,3), predictedPath(i+1,3)], ...
              'Color', color, 'LineWidth', 0.5, 'HandleVisibility', 'off'); % 细线避免视觉混乱
    end
end


    % 碰撞检测
   % collisionCheck = checkCollision(predictedPath);
    
    % 显示当前场景
    show3D(Scenario);
    
    % 绘制历史轨迹
    plot3(trajectory(:,1), trajectory(:,2), trajectory(:,3), 'b-', 'LineWidth', 2);

    % 绘制预测轨迹
 

    % 更新标签
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('UAV Trajectory with Predicted Path');
    
    % 更新图形
    drawnow;
    pause(0.1);

    % 更新位置
    InitialPosition = newPosition;
    idx = idx + 1;
    updateSensors(Scenario);
end

% 碰撞检测函数
function collisionFlags = checkCollision(path)
    collisionFlags = rand(size(path,1),1) > 0.7;
end

function [COMs,rigid_IDs,motive] = build_MASystem_with_motive(ClientIP)
%% 機能
% 床においた複数のドローンに順次ロール回転入力を印加し姿勢変化させる
% その時のmotive情報から各ドローンのmotive上の剛体番号とx軸の向きを同定するプログラム
% x軸を補正することで剛体定義の際のドローンの向きを気にしなくて良くなる
% COMs : 各ドローンのCOM番号
% IDs  : 各ドローンのmotive上の剛体番号
% How to use
% 1. Connect the drone with battery on betaflight configulator
% 2. Do "Initialize settings" on main.m
% 3. Execute this file
% 4. Check the transmitter signal on betaflight
% Function : send time varying message to transmitter system
% ch : time varying channel
% Expected result : transmitter signal increase by time

% TODO : 傾いた面において初期化する場合への対応
%% 初期設定
clear all
stop_throttle = [500 500 0 500 0 0 0 0];      % Disarm
COMs = serialportlist("available");       % 利用可能なシリアルポート
motive = Connector_Natnet('ClientIP', ClientIP); % Connect to Motive
disconnectCOM = 0*COMs;                   % droneに接続されていないポートリスト
rigid_IDs = COMs;                               % IDs 初期化（値に意味は無い）
yaws = COMs;                            % ヨー角 初期化（値に意味は無い）

for i = 1:length(COMs)
  agent = Drone(Model_Drone_Exp(1, 'plant', [0;0;0], "serial", [COMs(i)])); % for exp % 機体番号（ArduinoのCOM番号）
  result = agent.plant.connector.getData();
  pause(0.1); % to be tune
  if strcmp(result,"Start") % droneにつながっているか確認
    [~,~,initq] = calc_rotate_angle(motive); % Primeで計測している剛体のYaw角
    u = 0;
    rotate_role_throttle = [500 + u 500 0 500 1000 0 0 0]; % arming
    agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
    while sum(abs(roll) < 0.2) || u < 200  % to be tune
      u = u+10; % to be tune
      rotate_role_throttle = [500 + u 500 0 500 1000 0 0 0]; % 傾けるための入力
      agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
      pause(0.1); % to be tune
      [roll,yaw,~] = calc_rotate_angle(motive,initq);
    end
    agent.plant.connector.sendData(gen_msg(stop_throttle));
    rigid_IDs(i) = find(abs(roll)<0.2); % 姿勢変化したドローンのmotive上での剛体番号
    yaws(i) = yaw(rigid_IDs(i));          % 姿勢変化したドローンのyaw角
    % TODO :ドローン上のIMU情報が取ってこれるようになれば傾斜地においた状態からでも初期化できるようになる。
    % その場合はinitq(rigid_IDs(i))でオイラーパラメータとして設定すれば良い?
  else
    disconnectCOM(i) = 1;
  end
end
COMs(disconnectCOM==1) = [];
rigid_IDs(disconnectCOM==1) = [];
yaws(disconnectCOM==1) = [];
pause(1);
for i = 1:length(COMs)
  agent = Drone(Model_Drone_Exp(1, 'plant', [0;0;0], "serial", [COMs(i)])); % for exp % 機体番号（ArduinoのCOM番号）
  pause(0.1); % to be tune
    u = 0;
    while sum(abs(roll) > 0.1) || u < 200  % to be tune
      u = u+10; % to be tune
      return_throttle = [500 - u 500 0 500 1000 0 0 0]; % 傾けるための入力
      agent.plant.connector.sendData(gen_msg(return_throttle));
      pause(0.1); % to be tune
      roll = calc_rotate_angle(motive,initq);
    end
end
motive = Connector_Natnet('ClientIP', ClientIP, 'rigid_list',rigid_IDs,'init_yaw_angle',yaws);
end
%% local functions
function [roll,yaw,q] = calc_rotate_angle(motive,initq)
% yaw is inital rotation angle when the rigid body is set on Motive.
% roll is rotation angle wrt x axis on body frame
arguments
  motive
  initq quaternion = quaternion([1,0,0,0]) % 
end
motive.getData([], []);
q = quaternion(motive.result.rigid.q'); % unit quaternion
q = conj(initq)*q;
E = mod(euler(q,'ZXY','frame'),pi);        % mod : for 
roll = E(:,2);                           % extract roll angles
yaw = -E(:,1);                           % extract yaw angles
end
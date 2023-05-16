function [COMs, rigid_IDs, motive, init_yaw_angle] = build_MASystem_with_motive(ClientIP, COMs)
% [a,b,c,d,e]=build_MASystem_with_motive('192.168.1.9',"COM29")
%% 機能
% 床においた複数のドローンに順次ロール回転入力を印加し姿勢変化させる
% その時のmotive情報から各ドローンのmotive上の剛体番号とx軸の向きを同定するプログラム
% x軸を補正することで剛体定義の際のドローンの向きを気にしなくて良くなる
% COMs : 各ドローンのCOM番号
% rigid_IDs  : 各ドローンのmotive上の剛体番号
% motive : NATNET_CONNECTOR instance
% init_yaw_angle : initial direction of body-x axis
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
% clear all
arguments
    ClientIP
    COMs = serialportlist("available")
end
stop_throttle = [500 500 0 500 0 0 0 0];            % Disarm
%COMs = serialportlist("available");              % 利用可能なシリアルポート
motive = Connector_Natnet('ClientIP', ClientIP);    % Connect to Motive
disconnectCOM = zeros(size(COMs));                  % droneに接続されていないポートリスト
rigid_IDs = zeros(motive.result.rigid_num, 1);      % IDs 初期化（値に意味は無い）
init_yaw_angle = zeros(1, motive.result.rigid_num); % ヨー角 初期化（値に意味は無い）
motive.getData([], []);
yaw0 = euler(quaternion([motive.result.rigid.q]'),'ZXY','frame');
yaw0 = yaw0(:,1);
yaw0*180/pi
try
    for i = 1:length(COMs)
        agent = Drone(Model_Drone_Exp(1, 'plant', [0; 0; 0], "serial", [COMs(i)])); % for exp % 機体番号（ArduinoのCOM番号）
        result = agent.plant.connector.getData();
        tmpt = 0;
        starton = 0;
        while (~starton && tmpt <= 4)
            if strcmp(result, "Start") % droneにつながっているか確認
                starton = 1
            end
            pause(1);
            tmpt = tmpt + 1;
            result = agent.plant.connector.getData();
        end
        if starton
            agent.plant.connector.sendData(gen_msg(stop_throttle));
            pause(1);
            %                 [roll, ~, initq] = calc_rotate_angle(motive);
            arm_throttle = [500 500 0 500 1000 0 0 0]; % arming
            disp("arming");
            agent.plant.connector.sendData(gen_msg(arm_throttle));
            pause(1);
            %                 q = quaternion([1 0 0 0]);
            %                 euler(initq,'ZXY','frame')*180/pi()
            motive.getData([], []);
            p0 = [motive.result.rigid.p]; % unit quaternion
            thp = 0.002;
            u = 50;
            p = p0;
            maxi =60;
            rotate_role_throttle = [600 500 u 500 1000 0 0 0]; % 傾けるための入力
            agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
            while max(p-p0) < thp && u < maxi
                %while min(abs(roll) < 0.1) && u < 65
                pause(0.1);
                u = u + 1
                %                    rotate_role_throttle = [600 500 u 500 1000 0 0 0]; % 傾けるための入力
                %                    agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
                %                     [roll, yaw, q, q0] = calc_rotate_angle(motive, initq);
%                 rotate_role_throttle = [600 500 u 500 1000 0 0 0]; % 傾けるための入力
%                 agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
                motive.getData([], []);
                p = [motive.result.rigid.p]; % unit quaternion
            end
            agent.plant.connector.sendData(gen_msg(arm_throttle));
            rigid_IDs(i) = find(max(p-p0)>= thp, 1); % 姿勢変化したドローンのmotive上での剛体番号
            dp1 = p(:,rigid_IDs(i))-p0(:,rigid_IDs(i))

            pause(0.5);
            motive.getData([], []);
            p0 = [motive.result.rigid.p]; % unit quaternion
            u = 50;
            p = p0;
            rotate_role_throttle = [400 500 u 500 1000 0 0 0]; % 傾けるための入力
            agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
            while max(p-p0) < thp && u < maxi
                %while min(abs(roll) < 0.1) && u < 65
                pause(0.1);
                u = u + 1
                %                    rotate_role_throttle = [600 500 u 500 1000 0 0 0]; % 傾けるための入力
                %                    agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
                %                     [roll, yaw, q, q0] = calc_rotate_angle(motive, initq);
                motive.getData([], []);
                p = [motive.result.rigid.p]; % unit quaternion
            end
            agent.plant.connector.sendData(gen_msg(arm_throttle));
            dp2 = p(:,rigid_IDs(i))-p0(:,rigid_IDs(i))


            pause(1);
            motive.getData([], []);
            p0 = [motive.result.rigid.p]; % unit quaternion
            u = 50;
            p = p0;
            rotate_role_throttle = [500 600 u 500 1000 0 0 0]; % 傾けるための入力
            agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
            while max(p-p0) < thp && u < maxi
                %while min(abs(roll) < 0.1) && u < 65
                pause(0.1);
                u = u + 1
                %                    rotate_role_throttle = [600 500 u 500 1000 0 0 0]; % 傾けるための入力
                %                    agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
                %                     [roll, yaw, q, q0] = calc_rotate_angle(motive, initq);
                motive.getData([], []);
                p = [motive.result.rigid.p]; % unit quaternion
            end
            agent.plant.connector.sendData(gen_msg(arm_throttle));
            dp3 = p(:,rigid_IDs(i))-p0(:,rigid_IDs(i))

            pause(1);
            motive.getData([], []);
            p0 = [motive.result.rigid.p]; % unit quaternion
            u = 50;
            p = p0;
            rotate_role_throttle = [500 400 u 500 1000 0 0 0]; % 傾けるための入力
            agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
            while max(p-p0) < thp && u < maxi
                %while min(abs(roll) < 0.1) && u < 65
                pause(0.1);
                u = u + 1
                %                    rotate_role_throttle = [600 500 u 500 1000 0 0 0]; % 傾けるための入力
                %                    agent.plant.connector.sendData(gen_msg(rotate_role_throttle));
                %                     [roll, yaw, q, q0] = calc_rotate_angle(motive, initq);
                motive.getData([], []);
                p = [motive.result.rigid.p]; % unit quaternion
            end
            agent.plant.connector.sendData(gen_msg(stop_throttle));
            dp4 = p(:,rigid_IDs(i))-p0(:,rigid_IDs(i))
            dp = dp1;

            %                 rotate_role_throttle = [500 500 0 500 1000 0 0 0]; % arming
            %                 agent.plant.connector.sendData(gen_msg(stop_throttle));
            %                 T1= 180*euler(q0,'ZXY','frame')/pi-180*euler(initq,'ZXY','frame')/pi;
            agent.plant.connector.sendData(gen_msg(stop_throttle));
            rigid_IDs(i) = find(max(p(1:2,:)-p0(1:2,:))>= thp, 1); % 姿勢変化したドローンのmotive上での剛体番号
            dp = p(:,rigid_IDs(i))-p0(:,rigid_IDs(i))
            init_yaw_angle(i) = yaw0(rigid_IDs(i)) - atan2(dp(1),-dp(2));% bx の向きを表すベクトル = [-p2;p1]
            % TODO :ドローン上のIMU情報が取ってこれるようになれば傾斜地においた状態からでも初期化できるようになる。
            % その場合はinitq(rigid_IDs(i))でオイラーパラメータとして設定すれば良い?
            %               R0 = quat2rotm(initq);
            %                R = quat2rotm(q0);
            %                 T= 180*euler(q0,'ZXY','frame')/pi-180*euler(initq,'ZXY','frame')/pi;
            %                 180*atan2(T1(3),T1(2))/pi - (180 + 180*atan2(T(3),T(2))/pi)
            %                 if 1-R0(3,3)<1e-3
            %                     disp("1")
            %                     180*atan2(-R(3,1),R(3,2))/pi
            %                 else
            %                     disp("2")
            %                     180*atan2(-R(3,1),R(3,2))/pi- 180*atan2(-R0(3,1),R0(3,2))/pi
            %                 end


        else
            disconnectCOM(i) = 1;
        end
    end
    COMs(disconnectCOM == 1) = [];
    rigid_IDs(disconnectCOM == 1) = [];
    init_yaw_angle(disconnectCOM == 1) = [];

    if isempty(rigid_IDs)
        error("ACSL : No transmitter is connected.");
        %        else
        %            motive = Connector_Natnet('ClientIP', ClientIP);
    end

catch ME % for error
    % with FH
    agent.plant.connector.sendData(gen_msg(stop_throttle));
    warning('ACSL : Emergency stop! Check the connection.');
    rethrow(ME);
end

end
%% local functions
function [roll, yaw, q, q0] = calc_rotate_angle(motive, initq)
% yaw is inital rotation angle when the rigid body is set on Motive.
% roll is rotation angle wrt x axis on body frame
arguments
    motive
    initq quaternion = quaternion([1, 0, 0, 0]) %
end
motive.getData([], []);
q0 = quaternion([motive.result.rigid.q]'); % unit quaternion
q = conj(initq) .* q0;
%E = mod(euler(q, 'ZXY', 'frame'), pi);  % mod : for
E = euler(q, 'ZYX', 'frame');              % mod : for
roll = E(:, 3);                            % extract roll angles
yaw = -E(:, 1);                            % extract yaw angles
end

% initq  0.3645   -0.0016    0.0059
% q0   0.3697   -0.0005   -0.1897
% q  0.0052    0.0010   -0.1956
% initq  -0.98344 +  0.001295i - 0.0027413j -   0.18123k
% q0  -0.97854 - 0.017177i + 0.093162j -  0.18298k
% q  0.99522 + 0.00077461i -   0.097652j +  0.0025369k

% initq = quaternion([-0.98344 0.001295 -0.0027413 -0.18123]);
% q0 =quaternion([-0.97854 -0.017177 0.093162 -0.18298]);
% q = quaternion([0.99522 0.00077461 -0.097652 0.0025369]);

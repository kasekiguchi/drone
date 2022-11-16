clear all
close all
agent = DRONE(Model_Drone_Exp(0.025,[0;0;0], "udp", [50,132]),DRONE_PARAM("DIATONE"));
pause(1);
agent.plant.connector.sendData(gen_msg([500,500,0,500,0,0,0,0]));% arming
%%
% while 1
%     agent.plant.connector.sendData(gen_msg([500,500,20,500,1000,0,0,0]));% arming
%     pause(0.025);
% end
%%
FH = figure('position', [0 0 eps eps], 'menubar', 'none');
type receiver
dt_s = 0.001;%刻み時間
end_time = 15;%終了時間
portnumber = 8025;%自ポート番号
RemoteIPPort = 8024;%ESPr側のポート番号
RemoteIPAddress = '192.168.50.127';%送信してくる側のアドレス
ReceiveBufferSize = 1;%バッファサイズ
%%
disp("Press Enter");
dt = 0.75;
throttle = 20;
w = waitforbuttonpress;
disp("start");
disp("arming");
agent.plant.connector.sendData(gen_msg([500,500,0,500,1000,0,0,0]));% arming
pause(5);
%%
try
    for i = 0:10:throttle
        t = 0;
        Timer = tic;

        while t < dt
            drawnow
            cha = get(FH, 'currentcharacter');
            if (cha == 'q')
                error("ASCL : stop signal");
            end
            t = toc(Timer);
        end
        disp(i)
        agent.plant.connector.sender(gen_msg([500,500,i,500,1000,0,0,0]));
        if i == throttle
            disp("Press Enter");
            w = waitforbuttonpress;
            disp("sensor ON");
            udpr.receiver = dsp.UDPReceiver('RemoteIPAddress',RemoteIPAddress,'LocalIPPort',portnumber,'ReceiveBufferSize',ReceiveBufferSize,'MaximumMessageLength',15);
            setup(udpr.receiver);
            Timer_sensor = tic;%時間の定義
            s=0;
            while toc(Timer_sensor) < end_time%刻み時間分の
                t = 0;
                Timer = tic;
                while t < dt_s
                    drawnow
                    cha = get(FH, 'currentcharacter');
                    if (cha == 'q')
                        close(1)
                        error("stop signal");
                    end
                    t = toc(Timer);
                end
                ReceiveDate = udpr.receiver();%通信の取得
                if isempty(ReceiveDate)==0%受け取ったデータの確認用
                    T(s+1) = toc(Timer_sensor);%dt*i;%時間
                    ReceiveDates = strsplit(strcat(native2unicode(ReceiveDate')),',');%取得したデータの分割
                    udpr1 = str2double(ReceiveDates(1));%赤外線センサchar→double
                    udpr2 = str2double(ReceiveDates(2));%超音波センサchar→double
                    %disp(udpr1,udpr2);%表示
                    disp("udpr1,udpr2");
                    X1(s+1) = udpr1;%i+1番目にセンサの値を代入↑
                    X2(s+1) = udpr2;%subセンサー
                    s=s+1;
                end
            end
            disp("Press Enter");
            w = waitforbuttonpress;
            disp("end");
            close(1)
            error("stop signal");
        end
    end
catch ME
    agent.plant.connector.sender(gen_msg([500,500,0,500,0,0,0,0]));
    rethrow(ME);
end
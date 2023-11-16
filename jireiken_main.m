%% ROS2 講座 
% 実施日：2023/10/31
% 作成者：緒方 翔一
%% reset
close all; clear; clc;
%% 2.MATLABからのPublish
node1=ros2node("/nodeP",23); % ノードをたてる
[Pub, msg]=ros2publisher(node1,"/topic","geometry_msgs/Pose"); % トピック名とメッセージタイプを定義
msg.position.x = 10; % メッセージに実際の値を代入
send(Pub, msg); % メッセージを送信

%% 3.MATLABでのSubscribe
node2=ros2node("/nodeS",23); % ノードをたてる

% % receive
% Sub = ros2subscriber(node2, "/topic","geometry_msgs/Pose"); % トピック名とメッセージタイプを定義
% message = receive(Sub); % receiveでメッセージを受信

% % callback
% ros2subscriber(node2, "/topic","geometry_msgs/Pose",@callback_topic); % トピック名とメッセージタイプとcallbackを定義
% function callback_topic(message) % "messege"はルール上固定の名前
% %バックグラウンドで回り続ける関数
% x=message.position.x;
% disp(x);
% end

%% 5. %265のmsgをsubscribe
node3=ros2node("nodeT",23);
subscriber = ros2subscriber(node3, "/camera/pose/sample", "nav_msgs/Odometry", @T265_callback,"Reliability","besteffort");
function T265_callback(message)
x=message.pose.pose.position;
disp(x);
end

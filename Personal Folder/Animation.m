clc
clear all
close all

D = load('.mat'); %描画したいアニメーションのデータを読み込む
% D = load('1_5_NMPC_立体.mat');
param = DRONE_PARAM("DIATONE"); %DRONEのパラメータ読み込み
target = 1; %機体数
realtime = 0; %実時間
change_torque = 0; %1:総推力に変換

%% 動画保存
% save_mp4 = 0; %1:動画をmp4で保存
videoFile = strcat('.mp4'); %保存する際の名前
writerObj = VideoWriter(videoFile, 'MPEG-4');
writerObj.FrameRate = 30; % フレームレートの設定

num = input('＜出力するグラフを選択してください＞ \n[x-y : 0]  [x-z : 1]  [y-z : 2]  [x-y-z : 3]：','s'); %0:各グラフで出力,1:いっぺんに出力
num = str2double(num); %文字列を数値に変換
mp4 = input('\n＜動画を保存しますか＞ \n0:保存しない，1:保存する ：','s');
save_mp4 = str2double(mp4);

%% ドローンの機体作成

%4入力を総推力に変換
if change_torque == 1
    for i = 1:find(D.log.Data.t,1,'last')
        D.log.Data.agent.input{i}(:,1) = Change_torque(param,D.log.Data.agent.input{i}(:,1));
    end
end

data = datachange(D,target,"p","e");
tM = max(data);
tm = min(data);
M = [max(tM(1:3:end)),max(tM(2:3:end)),max(tM(3:3:end))];
m = [min(tm(1:3:end)),min(tm(2:3:end)),min(tm(3:3:end))];
L = [param.Lx,param.Ly];
figure();   fprintf("\n＜Enterキーで動画の作成を開始します＞\n");   pause();
ax = axes('XLim',[m(1)-L(1) M(1)+L(1)],'YLim',[m(2)-L(2) M(2)+L(2)],'ZLim',[0 M(3)+1]);
xlabel(ax,"x [m]");
ylabel(ax,"y [m]");
zlabel(ax,"z [m]");
obj.fig = ax;

if num == 0
    view(2)
elseif num == 1
    view(0,0)
elseif num == 2
    view(90,0)
else
    view(3)
end

grid on
daspect([1 1 1]);
hold on

% rotor setup
r = param.rotor_r;
[xr,yr,zr] = cylinder([0 r]); % rotor
zr = 0.001*zr;

% body setup
[xb,yb,zb] = ellipsoid(0,0,0, 1.2*L(1)/4, 0.8*L(2)/4, 0.02);
d = L/2; % 重心からローター１の位置ベクトル
rp = [d(1),d(2),0.02;-d(1),d(2),0.02;d(1),-d(2),0.02;-d(1),-d(2),0.02]; % relative rotor position
c = ["red","green","blue","cyan",'#4DBEEE'];

% arm setup
[x,y,z] = cylinder(0.01);
z = z*vecnorm(d)*2;
R1 = rotmat(quaternion([L(2),-L(1),0]*pi/(vecnorm(L)*2),"rotvec"),'point');
R2 = rotmat(quaternion([L(2),L(1),0]*pi/(vecnorm(L)*2),"rotvec"),'point');
F1 = [R1*[x(1,:);y(1,:);z(1,:)];R1*[x(2,:);y(2,:);z(2,:)]]+[d(1);d(2);0;d(1);d(2);0];
F2 = [R2*[x(1,:);y(1,:);z(1,:)];R2*[x(2,:);y(2,:);z(2,:)]]+[-d(1);d(2);0;-d(1);d(2);0];
for n = 1
    for i = 4:-1:1
        h(n,i) = surface(ax,xr+rp(i,1),yr+rp(i,2),zr+rp(i,3),'FaceColor',c(i)); % rotor 描画
        T(n,i) = quiver3(ax,rp(i,1),rp(i,2),rp(i,3),0,0,1,'FaceColor',c(i)); % 推力ベクトル描画
        tt(n,i) = hgtransform('Parent',ax); set(T(n,i),'Parent',tt(n,i)); % 推力を慣性座標と紐づけ
    end
    h(n,5) = surface(ax,[F1(1,:);F1(4,:);NaN(1,size(F1,2));F2(1,:);F2(4,:)], ...
        [F1(2,:);F1(5,:);NaN(1,size(F1,2));F2(2,:);F2(5,:)], ...
        [F1(3,:);F1(6,:);NaN(1,size(F1,2));F2(3,:);F2(6,:)],'FaceColor',c(5)); % アーム部
    h(n,6) = surface(ax,xb,yb,zb,'FaceColor',c(5)); % ボディ楕円体
    h(n,7) = trisurf([5 1 2;5 2 3; 5 3 4; 5 4 1], ...
        [0.02;0.02;0.02;0.02;4*1.2*L(1)/8], ...
        0.8*L(2)*[1;-1;-1;1;0]/6, ...
        0.01*[1;1;-1;-1;0],'FaceColor',c(5)); % 前を表す四角錐

    t(n) = hgtransform('Parent',ax); set(h(n,:),'Parent',t(n)); % ドローンを慣性座標と紐づけ
end
obj.frame = t;
obj.thrust = tt;

%% 描画
p = datachange(D,target,"p","e");
q = datachange(D,target,"q","e");
u = datachange(D,target,"input");
r = datachange(D,target,"p","r");
p = reshape(p,size(p,1),3,length(target));
q = reshape(q,size(q,1),size(q,2)/length(target),length(target));
u = reshape(u,size(u,1),4,length(target));
r = reshape(r,size(r,1),3,length(target));
for n = 1:length(target)
    switch size(q(:,:,n),2)
        case 3
            Q1 = quaternion(q(:,:,n),'euler','XYZ','frame');
        case 4
            Q1 = quaternion(q(:,:,n));
        case 9
            Q1 = quaternion(q(:,:,n),'rotmat','frame');
    end
    Q1 = rotvec(Q1);
    tmp = vecnorm(Q1,2,2);
    Q(:,:,n) = zeros(size(Q1,1),4);
    Q(tmp==0,:,n) = 0;
    Q(tmp==0,1,n) = 1;
    Q(tmp~=0,:,n) = [Q1(tmp~=0,:)./tmp(tmp~=0),tmp(tmp~=0)];
end

t = D.log.Data.t;
tRealtime = tic;
if save_mp4 == 1
    open(writerObj);
    for i = 1:size(p,1)
        for n = 1:length(target)
            plot3(r(:,1,n),r(:,2,n),r(:,3,n),'k','LineStyle','--','LineWidth',1.2);
            draw(obj.frame(target(n)),obj.thrust(target(n),:),p(i,:,n),Q(i,:,n),u(i,:,n));
        end
        if realtime
            delta = toc(tRealtime);
            if t(i+1)-t(i) > delta
                pause(t(i+1)-t(i) - delta);
            end
            tRealtime = tic;
        else
            pause(0.01);
        end
        currentFrame = getframe(gcf);
        writeVideo(writerObj, currentFrame);
    end
else
    for i = 1:size(p,1)
        for n = 1:length(target)
            plot3(r(:,1,n),r(:,2,n),r(:,3,n),'k','LineStyle','--','LineWidth',1.2);
            draw(obj.frame(target(n)),obj.thrust(target(n),:),p(i,:,n),Q(i,:,n),u(i,:,n));
        end
        if realtime
            delta = toc(tRealtime);
            if t(i+1)-t(i) > delta
                pause(t(i+1)-t(i) - delta);
            end
            tRealtime = tic;
        else
            pause(0.01);
        end
    end
end

if save_mp4 == 1
    close(writerObj);
    movefile(videoFile,'Graph/Video')
    disp('＜動画の保存・ファイルの移動が完了しました＞');
end

%% 関数
function [data, vrange] = datachange(D, target, variable, attribute, option)
    arguments
        D
        target
        variable string = "p"
        attribute string = "e"
        option.time (1, 2) double = [0 D.log.Data.t(size(D.log.Data.t,1)-1)]
    end 
    if D.log.fExp == 1
        option.time = [0 D.log.Data.t(find(D.log.Data.t,1,'last')-1)];
    end
    data = cell2mat(arrayfun(@(i) data_org(D, i, variable, attribute,"time",option.time), target, 'UniformOutput', false));
    [~, vrange] = full_var_name(variable, attribute);
end

function [data, vrange] = data_org(D, n, variable, attribute, option)
    arguments
        D
        n
        variable string = "p"
        attribute string = "e"
        option.time (1, 2) double = [0 D.log.Data.t(size(D.log.Data.t,1)-1)]
    end
    [variable, vrange] = full_var_name(variable, attribute);
    attribute = "";
    data_range = find((D.log.Data.t - option.time(1)) > 0, 1):find((D.log.Data.t - option.time(2)) >= 0, 1);
    if sum(strcmp(n, {'time', 't'}))     % 時間軸データ
        data = D.log.Data.t(data_range);
    elseif n == 0                        % n : agent number.  n=0 => obj.itmesのデータ
        % variable = split(variable, '.'); % member毎に分割
        % data = [obj.Data.(variable{1})];
        % for j = 2:length(variable)
        %     data = [data.(variable{j})];
        % end
        % data = [data{1, data_range}]';
    else                                 % agentに関するデータ
        variable = split(variable, '.'); % member毎に分割
        data = [D.log.Data.agent(n)];
        switch variable
            case "inner_input" % 横ベクトルの場合
                data = [data.(variable)];
                data = [data{1, data_range}];
                data = reshape(data, [8, length(data) / 8])';
            otherwise
                for j = 1:length(variable)
                    data = [data.(variable{j})];
                    if iscell(data) % 時間方向はcell配列
                        data = [data{1, data_range}]';
                        data = return_state_prop(variable(j + 1:end), data);
                        break
                    end
                end
        end
    end
    if ~isempty(vrange)
        data = obj.mtake(data, [], vrange);
    end
end

function [name, vrange] = full_var_name(var, att)
    switch att
        case 's' % sensor
            name = "sensor.result";
        case 'e' % estimator
            name = "estimator.result";
        case 'r' % reference
            name = "reference.result";
        case 'p' % plant
            name = "plant.result";
        case 'i' %
            name = "input";
        otherwise
            name = "";
    end
    variable = regexprep(var, "[0-9:]", "");
    vrange = regexp(var, "[0-9:]", 'match');
    if ~isempty(vrange)
        vrange = str2num(strjoin(vrange));
    end
    switch variable
        case 'p'
            name = strcat(name, ".state.p");
        case 'q'
            name = strcat(name, ".state.q");
        case 'v'
            name = strcat(name, ".state.v");
        case 'w'
            name = strcat(name, ".state.w");
        case 'input'
            name = "input";
        otherwise
            if ~isempty(variable)
                if ~contains(variable, "result") & name ~= "" % attribute が指定されている場合
                    name = strcat(name, '.', variable);
                else
                    name = variable;
                end
            end
    end
end

function data = return_state_prop(variable, data)
  % function for data_org
  for j = 1:length(variable)
    %data = [data.(variable(j))];
    data = vertcat(data.(variable(j)));

    if strcmp(variable(j), 'state')

      for k = 1:length(data)
        ndata(k, :, :) = data(k).(variable(j + 1))(1:data(k).num_list(strcmp(data(k).list, variable(j + 1))), :);
      end

      data = ndata;
      break % WRN : stateから更に深い構造には対応していない
    end

  end

end

function draw(frame,thrust,p,q,u)
    % obj.draw(p,q,u)
    % p : 一ベクトル
    % q = [x,y,z,th] : 回転軸[x,y,z]にth回転
    % u (optional): 入力
    arguments
        frame
        thrust
        p
        q
        u = [1;1;1;1];
    end

    % Rotation matrix
    R = makehgtform('axisrotate',q(1:3),q(4));
    % Translational matrix
    Txyz = makehgtform('translate',p);
    % Scaling matrix
    for i = 1:4
        if u(i) > 0
            S = makehgtform('scale',[1,1,u(i)]);
        elseif u(i) < 0
            S1 = makehgtform('xrotate',pi);
            S = makehgtform('scale',[1,1,-u(i)])*S1;
        else
            S = eye(4);
            S(3,3) = 1e-5;
        end
        set(thrust(i),'Matrix',Txyz*R*S);
    end
    % Concatenate the transforms and
    % set the transform Matrix property
    set(frame,'Matrix',Txyz*R);
    drawnow
end

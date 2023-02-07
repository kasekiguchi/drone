%clear all 
close all

%Skull=stlread('Skull.stl');   %% stlファイルの読み込み
Skull = stlread('3F.stl');
v=Skull.Points;                  %%パッチ用の頂点を抽出
f=Skull.ConnectivityList;    %%パッチ用の面を抽出


bld.Faces=f; bld.Vertices=v;  
%CData=linspace(0,1,249970);   %%stlファイルには色データーははいっていないので、自分でつくる。頂点の数と一緒ならOK
%bld.CData=CData;

bld.FaceAlpha = 0.5;           % remove the transparency
bld.FaceColor = 'b'%;'interp';    % set the face colors to be interpolated
bld.LineStyle = '-';%'none';      % remove the lines
%bld.CDataMapping='scaled'
%colormap(winter)



%f1=figure(1)
%f1.WindowState='maximized'; f1.Color='white'

h1=patch(bld);
grid on
xlabel("x");
ylabel("y");
zlabel("z");
lighting gouraud
l = light('Position',[-0.4 0.2 0.9],'Style','infinite')      %%リアル感を出すにはこのライティングが重要
%material shiny
axis equal off  
view([1 -2 1])
%view([34.378627753193037,16.869006296042777])

% Video= VideoWriter('SkullRotation', 'MPEG-4');  %%%%%  ここでファイルを書き込むオブジェクトの定義%%%
% Video.Quality = 100;  %% ビデオの画質の設定
% Video.FrameRate=30;    %%ビデオのフレームレートの設定
% open(Video);                %%録画開始
% for i=1:360
%    z=-pi/180 * i;  
%    Rotz=[cos(z)  -sin(z)  0 ;  sin(z)  cos(z)  0 ;   0  0  1]; % Z軸回りの回転
%    vz=v*Rotz; %%回す
%    set(h1,'Vertices',vz); 
%    drawnow
%    
%      frame = getframe(gcf);             %%ここでフレームを取得
%     writeVideo(Video,frame);          %%フレームを書き込み
% end
% close(Video)                                   %%録画終了
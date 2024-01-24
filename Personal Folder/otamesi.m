% サンプルのアニメーションを作成するスクリプト

% アニメーションのフレーム数を指定
numFrames = 100;

% 動画を保存するファイル名
videoFile = 'animation.mp4';

% VideoWriter オブジェクトを作成
writerObj = VideoWriter(videoFile, 'MPEG-4');
writerObj.FrameRate = 30; % フレームレートの設定

% VideoWriter オブジェクトをオープン
open(writerObj);

% アニメーションの各フレームを生成して保存
for frame = 1:numFrames
    % ここにアニメーションの各フレームを生成するコードを追加
    
    % 例: プロットを使用した単純なアニメーション
    plot(sin(linspace(0, 2*pi, 100) + frame/10)); 
    title(['Frame: ' num2str(frame)]);
    
    % 現在のフレームを取得
    currentFrame = getframe(gcf);
    
    % VideoWriter オブジェクトにフレームを書き込む
    writeVideo(writerObj, currentFrame);
end

% VideoWriter オブジェクトをクローズして動画を保存
close(writerObj);

disp('動画が保存されました。');

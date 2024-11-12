classdef DRONE < handle
  % classdef a < b aクラスはbクラスを継承するaクラスはbクラスのサブクラス（子クラス） となり、b クラスに定義されているプロパティやメソッドを継承
  % DRONEはhandleのサブクラスでhandleはmatlab公式で以下の特徴がある
  % ハンドルクラスのオブジェクトを他の変数に代入すると、同じオブジェクトの参照がコピーされる．つまり，別の変数で同じオブジェクトを共有
  % ある変数でオブジェクトのプロパティを変更すると，他の変数でも変更が反映される
  % 値クラスの場合，別の変数にコピーすると独立した別のインスタンスが作成される（値のコピー）
  % Drone class
  %対象がドローンの時に使用されているファイル
  properties %(Access = private)
    fig
    plant
    parameter
    sensor
    estimator
    reference
    controller
    input_transform
    id = 1
  end

  methods

    function obj = DRONE(args) %SimHLやExpHLで使用されている　対象物の定義
      arguments %関数の入力引数を宣言 引数が宣言されていないときはargsがstruct("type","sim")となる
        args = struct("type","sim"); %フィールドtypeがデフォルトで"sim"に設定されている　つまり普段はシミュレーション
      end
      obj.input_transform.do = @(varargin) []; 
      %varargin.m:matlab公式の変数で任意の数の入力引数を関数で受け入れ可能にする関数定義ステートメントの入力変数
      %実行後vararginは１行N列のcell配列になる．Nは明示的に宣言された入力の後に関数が受け取る入力の数で，入力を受け取らない場合は空となる
      if contains(args.type, "EXP") %args.type内にEXPがあるなら実行
        obj.plant = DRONE_EXP_MODEL(args); %DRONE_EXP_MODEL.m
      end
    end
  end
  methods
    function animation(obj,logger,varargin)
      % obj.animation(logger,param)
      % logger : LOGGER class instance
      % param.realtime (optional) : t-or-f : logger.data('t')を使うか
      % param.target = 1:4 描画するドローンのインデックス
      % param.gif = 0 or 1 gif画像として出力するか選択（1で出力＆Dataフォルダに保存）
      % param.Motive_ref = 0 or 1 動画内の目標軌道をMotiveみたいに徐々に消える形にするか選択（1でMotiveモード）
      % param.fig_num = 1 gif出力するfigure番号の選択（デフォルトはfigure１）
      % param.mp4 = 0 or 1 mp4形式として出力するか選択（1で出力＆Dataフォルダに保存）
      mov = DRAW_DRONE_MOTION(logger,varargin{:});%"target",param.target,"fig_num",param.fig_num,"mp4",param.mp4);
      mov.animation(logger,varargin{:});%"realtime",true,"target",param.target,"fig_num",param.fig_num,"gif",param.gif,"Motive_ref",param.Motive_ref);
    end
    function ax=show(obj,str,varargin)
      % str : list of target class
      %  example ["sensor","lidar";"estimator","ekf"]
      tmp = obj;
      for j = 1:size(str,1)
        for i = str(j,:)
          tmp = tmp.(i);
        end
        ax = tmp.show(varargin{:});
      end
    end

  end

end

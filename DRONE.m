classdef DRONE < handle
  % Drone class
  properties %(Access = private)
    fig
    plant
    model
    parameter
    sensor
    estimator
    reference
    controller
    input
    input_transform
    id = 1
  end

  methods

    function obj = DRONE(args)
      arguments
        args = struct("type","sim");
      end
      obj.input_transform.do = @(varargin) [];
      if contains(args.type, "EXP")
        obj.plant = DRONE_EXP_MODEL(args);
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

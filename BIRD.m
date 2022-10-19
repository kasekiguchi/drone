classdef BIRD < ABSTRACT_SYSTEM
    % Bird class
    properties %(Access = private)
        fig
    end
    methods
        function obj = BIRD(args,param)
            arguments
                args
                param
            end
            obj=obj@ABSTRACT_SYSTEM(args,param);
            if contains(args.type,"EXP")
                obj.plant = DRONE_EXP_MODEL(args);
            end
            obj.parameter = param;
        end
    end
    methods
        function animation(obj,logger,logger_bird,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            % param.target = 1:4 描画するドローンのインデックス
            % param.gif = 0 or 1 gif画像として出力するか選択（1で出力＆Dataフォルダに保存）
            % param.Motive_ref = 0 or 1 動画内の目標軌道をMotiveみたいに徐々に消える形にするか選択（1でMotiveモード）
            % param.fig_num = 1 gif出力するfigure番号の選択（デフォルトはfigure１）
            % param.mp4 = 0 or 1 mp4形式として出力するか選択（1で出力＆Dataフォルダに保存）
            arguments
                obj
                logger
                logger_bird
                param.drone = 1;
                param.bird = 1;
                param.gif = 0;
                param.Motive_ref = 0;
                param.fig_num = 1;
                param.mp4 = 0;
            end
            p = obj.parameter;
            DRAW_BIRD_MOTION(logger,logger_bird,"frame_size",[p.Lx,p.Ly],"rotor_r",p.rotor_r,"animation",true,"drone",param.drone,"bird",param.bird,"gif",param.gif,"Motive_ref",param.Motive_ref,"fig_num",param.fig_num,"mp4",param.mp4);
        end
    end
end

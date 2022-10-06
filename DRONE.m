classdef DRONE < ABSTRACT_SYSTEM
% Drone class
properties %(Access = private)
    fig
end

methods

    function obj = DRONE(args, param)

        arguments
            args
            param
        end

        obj = obj@ABSTRACT_SYSTEM(args, param);

        if contains(args.type, "EXP")
            obj.plant = DRONE_EXP_MODEL(args);
        end
    end
end
methods
        function animation(obj,logger,param)
            % obj.animation(logger,param)
            % logger : LOGGER class instance
            % param.realtime (optional) : t-or-f : logger.data('t')を使うか
            % param.target = 1:4 描画するドローンのインデックス
            % param.gif = 0 or 1 gif画像として出力するか選択（1で出力＆Dataフォルダに保存）
            % param.Motive_ref = 0 or 1 動画内の目標軌道をMotiveみたいに徐々に消える形にするか選択（1でMotiveモード）
            % param.fig_num = 1 gif出力するfigure番号の選択（デフォルトはfigure１）
            arguments
                obj
                logger
                param.target = 1;
                param.gif = 0;
                param.Motive_ref = 0;
                param.fig_num = 1;
            end
            p = obj.parameter;
            DRAW_DRONE_MOTION(logger,"frame_size",[p.Lx,p.Ly],"rotor_r",p.rotor_r,"animation",true,"target",param.target,"gif",param.gif,"Motive_ref",param.Motive_ref,"fig_num",param.fig_num);
        end
end

end

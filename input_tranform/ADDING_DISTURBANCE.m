classdef ADDING_DISTURBANCE < handle
%クワッドコプタのシステムに外乱を付与するクラス
%入力は変換しないが外乱をシステムに反映するために入力の配列の後ろに外乱の配列を追加する
properties
    self
    dst
    result
end

methods

    function obj = ADDING_DISTURBANCE(self, param)
        obj.self = self;
        obj.dst = param;%生成した外乱を受け取る
    end

    function u = do(obj, varargin)
        %% u = [uthr, uroll, upitch, uyaw, dst]
            i = varargin{1, 1}.k ;
            obj.result = [varargin{1, 5}.controller.result.input;obj.dst(:,i)];%各時刻の入力の後ろに外乱の配列を追加する
            u = obj.result;
            obj.self.controller.result.input= obj.result;
    end

end
end

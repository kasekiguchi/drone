classdef NDT < handle
% classdef NDT < MODEL_CLASS
    
    properties
        result
        self
        model
    end

    properties
        fixedSeg
        tform
        initialtform
        PCdata_use
    end
    
    methods
        function obj = NDT(self,param)
            % コンストラクタ
            obj.self = self; % agent that 
            obj.model = param.model;
            param = param.param;
            obj.initialtform = param.initialtform;
            obj.fixedSeg = param.fixedSeg;
            obj.result.state=state_copy(obj.model.state);
        end


        function [result] = do(obj,~)
            obj.PCdata_use = obj.self.sensor.result;
            obj.result.tform = pcregisterndt(obj.PCdata_use,obj.fixedSeg,0.5,"InitialTransform",obj.initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
            
        end
        
        % function result=do(obj,varargin)
        %     result=obj.result;
        % end
    end
end
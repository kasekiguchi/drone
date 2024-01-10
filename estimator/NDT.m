classdef NDT < handle
% classdef NDT < MODEL_CLASS
    
    properties
        result
        self
        model

        state
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
            model = param.model;
            obj.model = model;
            param = param.param;
            obj.initialtform = param.initialtform;
            obj.fixedSeg = param.fixedSeg;
            obj.result.state=state_copy(obj.model.state);
        end


        function [result] = do(obj,varargin)
            obj.PCdata_use = obj.self.sensor.result{1};
            if isempty(obj.fixedSeg)
                obj.fixedSeg = obj.PCdata_use;
            end
            tmpvalue = [0,0,0];
            if ~isempty(obj.self.controller.result)
                for j = 1:3
                    % A(j) = subs(obj.self.controller.e(j),"t",varargin{1}.t);
                    A(j) = obj.self.controller.e(j);
                end
                A = cast(A,"double");
                Trans = [A(1:2) 0];
                Rot = eul2rotm(deg2rad([0 0 A(3)]),'XYZ'); %回転行列(roll,pitch,yaw)
                obj.initialtform = rigidtform3d(Rot,Trans);
                % obj.result.tform = pcregisterndt(obj.PCdata_use,obj.fixedSeg.map,0.5,"InitialTransform",obj.initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
                tmpvalue = obj.result.tform.Translation';                
            end

            obj.result.tform = pcregisterndt(obj.PCdata_use,obj.fixedSeg.map,0.5,"InitialTransform",obj.initialtform,"OutlierRatio",0.1,"Tolerance",[0.01 0.1]);%マッチング
            if obj.fixedSeg == obj.PCdata_use
                ndt_PCdata = pctransform(obj.PCdata_use,obj.result.tform);
                obj.fixedSeg = pcmerge(obj.fixedSeg,ndt_PCdata,0.5);
            end
            % tmpvalue = obj.result.tform.Translation';
            obj.result.state.set_state(tmpvalue);%%%%%推定結果
            obj.model.state.set_state(tmpvalue);%%%%%%モデルの更新
        end
        
        % function result=do(obj,varargin)
        %     result=obj.result;
        % end
    end
end
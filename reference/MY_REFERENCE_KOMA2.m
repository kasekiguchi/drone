classdef MY_REFERENCE_KOMA2 < handle
  properties
    self
    result
  end

  properties
      ref
      t
  end

  methods
      function obj = MY_REFERENCE_KOMA2(self,varargin)
          obj.self = self;
          var = varargin{1};
          te = var{3};
          dt = self.plant.dt;
          % obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
          obj.result.state = STATE_CLASS(struct('state_list',["xd","p", "q","v"],'num_list',[20,3,3,3]));
          obj.result.state.set_state("xd",zeros(6,1));
          obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
          obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
          obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));
          obj.t.endidx = round(te/dt); 
          obj.t.startidx = 1;
          obj.t.idx = 0;

          if var{2} == 1 % matファイルから読み込んだ目標値を設定する
              load(strcat(var{1}, ".mat")); % log
              startIDX = find(log.Data.phase == 102, 1, "first");
              endIDX = find(log.Data.phase == 102, 1, "last");
              obj.ref.p = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.p,startIDX:endIDX,'UniformOutput',false));
              obj.ref.q = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.q,startIDX:endIDX,'UniformOutput',false));
              obj.ref.v = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.v,startIDX:endIDX,'UniformOutput',false));
              obj.ref.xd = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.xd,startIDX:endIDX,'UniformOutput',false));
              obj.t.startidx = startIDX;
              obj.t.endidx = endIDX;
          elseif var{2} == 2 % spline補間-9次
              % ref = curve_interpolation_9order()
              teref = te; % かける時間
              t = 0:0.025:te;
              % z0:初期値, ze:収束地, v0:初期速度, ve:終端速度
              p0 = [0 0 1]; pe = [2 0 1]; v0 = [0 0 0]; ve = [0 0 0]; 
              tmp = zeros(3, 5, length(t)); ref.p = zeros(3, length(t)); ref.v = zeros(3, length(t));
              for i = 1:3
                  tmp(i,:,:) = curve_interpolation_9order(t',teref,p0(i),v0(i),pe(i),ve(i))';
                  ref.p(i,:) = reshape(tmp(i,1,:), 1, []);
                  ref.v(i,:) = reshape(tmp(i,2,:), 1, []);
              end
              figure(1)
              subplot(1,2,1); plot(t, ref.p(1,round(t/dt)+1), t, ref.p(2,round(t/dt)+1), t, ref.p(3,round(t/dt)+1)); legend("X", "Y", "Z");
              subplot(1,2,2); plot(t, ref.v(1,round(t/dt)+1), t, ref.v(2,round(t/dt)+1), t, ref.v(3,round(t/dt)+1)); legend("Vx", "Vy", "Vz");
              disp("Press enter to next"); pause();
              obj.ref = ref;
              obj.ref.q = zeros(3, length(t));
              obj.ref.xd = [obj.ref.p; obj.ref.q; obj.ref.v];
          end
      end
      function  result= do(obj,varargin)      
          obj.t.idx = min(obj.t.endidx-obj.t.startidx+1, obj.t.idx + 1);
          obj.result.state.p = obj.ref.p(:,obj.t.idx);
          obj.result.state.q = obj.ref.q(:,obj.t.idx);
          obj.result.state.v = obj.ref.v(:,obj.t.idx);
          obj.result.state.xd = obj.ref.xd(:,obj.t.idx); 
          result = obj.result;
      end

  end
end

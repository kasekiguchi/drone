classdef REFERENCE_FROM_MAT < handle
  properties
    self
    result
  end

  properties
      ref
  end

  methods
      function obj = REFERENCE_FROM_MAT(self,varargin)
          obj.self = self;
          % obj.result.state = STATE_CLASS(struct('state_list',["xd","p","v"],'num_list',[20,3,3]));
          obj.result.state = STATE_CLASS(struct('state_list',["xd","p", "q","v"],'num_list',[20,3,3,3]));
          obj.result.state.set_state("xd",zeros(6,1));
          obj.result.state.set_state("p",obj.self.estimator.result.state.get("p"));
          obj.result.state.set_state("q",obj.self.estimator.result.state.get("q"));
          obj.result.state.set_state("v",obj.self.estimator.result.state.get("v"));

          load(strcat(varargin{1}, ".mat")); % log
          % ref = log.Data.agent.reference.result.state.p

          startIDX = find(log.Data.phase == 102, 1, "first");
          endIDX = find(log.Data.phase == 102, 1, "last");
          obj.ref.p = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.p,startIDX:endIDX,'UniformOutput',false));
          obj.ref.q = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.q,startIDX:endIDX,'UniformOutput',false));
          obj.ref.v = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.v,startIDX:endIDX,'UniformOutput',false));
          obj.ref.xd = cell2mat(arrayfun(@(N) log.Data.agent.reference.result{N}.state.xd,startIDX:endIDX,'UniformOutput',false));

          obj.ref.idx = 0;
          obj.ref.startidx = startIDX;
          obj.ref.endidx = endIDX;
      end
      function  result= do(obj,varargin)      
          obj.ref.idx = min(obj.ref.endidx-obj.ref.startidx+1, obj.ref.idx + 1);
          obj.result.state.p = obj.ref.p(:,obj.ref.idx);
          obj.result.state.q = obj.ref.q(:,obj.ref.idx);
          obj.result.state.v = obj.ref.v(:,obj.ref.idx);
          obj.result.state.xd = obj.ref.xd(:,obj.ref.idx); 
          result = obj.result;
      end

  end
end

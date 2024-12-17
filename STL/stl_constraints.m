function [removeF, removeX, survive] = stl_constraints(obj)
% 状態制約
removeX = find(obj.state.predict_state(1, 1, 1:obj.N) < -0.5);
%             removeX = find(removeFe);
obj.input.Evaluationtra(1,removeX) = obj.param.ConstEval;
removeF = size(removeX, 1);
removeX = [];
survive = obj.N;
end
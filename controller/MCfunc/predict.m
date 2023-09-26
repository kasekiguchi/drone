function [predict_state] = predict(obj)
  u = obj.input;
  obj.state(:,1,1:obj.N) = repmat(obj.current_state,1,1,obj.N);  % サンプル数分初期値を作成
  for i = 1:obj.H-1
    obj.state(:,i+1,1:obj.N) = pagemtimes(obj.A(:,:,1:obj.N),obj.state(:,i,1:obj.N)) + pagemtimes(obj.B(:,:,1:obj.N),u(:,i,1:obj.N));
  end
  predict_state = obj.state;
end
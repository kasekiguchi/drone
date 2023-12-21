function [predict_state] = predict_gpu(u, state, current_state, N, H, A, B)
  % u = input;
  state(:,1,1:N) = repmat(current_state,1,1,N);  % サンプル数分初期値を作成
  for i = 1:H-1
    state(:,i+1,1:N) = pagemtimes(A(:,:,1:N),state(:,i,1:N)) + pagemtimes(B(:,:,1:N),u(:,i,1:N));

    %% 加速度
    % v_pre = [state(4,i,:); state(8,i,:)];
    % v = [state(4,i+1,:); state(8,i+1,:)];
    % state_acc(:,i+1,1:N) = (v - v_pre) ./ dt;
  end
  predict_state = state;
end
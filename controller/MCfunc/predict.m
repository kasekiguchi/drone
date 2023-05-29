function [predict_state] = predict(u,N,H,current_state,state_data,A,B)
    coder.gpu.kernelfun
    
    % u = obj.input.u;
    state_data(:,1,1:N) = repmat(current_state,1,1,N);
    %       state.initial(:,:,1:N) = repmat(current_state,1,1,N);  % 12 * param.H * N
    for i = 1:H-1
        state_data(:,i+1,1:N) = pagemtimes(A(:,:,1:N),state_data(:,i,1:N)) + pagemtimes(B(:,:,1:N),u(:,i,1:N));
    end
    predict_state = state_data;
end
function [predict_state] = predict(OBJ)
    u = OBJ.input.u;
    OBJ.state.state_data(:,1,1:OBJ.N) = repmat(OBJ.current_state,1,1,OBJ.N);  % サンプル数分初期値を作成
    %       obj.state.initial(:,:,1:obj.N) = repmat(obj.current_state,1,1,obj.N);  % 12 * obj.param.H * obj.N
    for i = 1:OBJ.param.H-1
        OBJ.state.state_data(:,i+1,1:OBJ.N) = pagemtimes(OBJ.A(:,:,1:OBJ.N),OBJ.state.state_data(:,i,1:OBJ.N)) + pagemtimes(OBJ.B(:,:,1:OBJ.N),u(:,i,1:OBJ.N));
    end
    predict_state = OBJ.state.state_data;
end
function result = wark_falg(flag,N,agent,xd,num,t,te,load)
state = agent(num).estimator.result.state.p;
if flag==0
    result = randi([0,1],1,N);
else
    result = flag;
end
    rt = randi([0,te],1,1);

% ランダムなやつが移動開始
rstart= randi([1,N],1,1);
if result(rstart)==0&&rt<t
    result(rstart) =1;
end


%% 収束条件
%ゴールに１ｍより近づいたらゴール
judge = Cov_distance(state,xd{num},0);
if judge<1.0
    result(num) = 2;
end




end
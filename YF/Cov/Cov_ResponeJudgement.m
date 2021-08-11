function result = Cov_ResponeJudgement(Informetion)
%ゴールを判定して１０お送るやつ．環境ごとにゴール判定が違うからいい感じにする．
FieldType = Informetion.env.huma_load.param.txt;
result =    0;
if strcmp(FieldType,'Like H')
    if  norm(Informetion.estimator.result.state.p-Informetion.reference.(Informetion.reference.name{1}).xd,inf)<2
        result = 1;
    end
elseif strcmp(FieldType,'Like 6')     
    if  norm(Informetion.estimator.result.state.p-Informetion.reference.(Informetion.reference.name{1}).xd,inf)<2
        result = 1;
    end    
elseif strcmp(FieldType,'TCU 2F')
    if  norm(Informetion.estimator.result.state.p-Informetion.reference.(Informetion.reference.name{1}).xd,inf)<2
        result = 1;
    end    
elseif strcmp(FieldType,'8widths straight')||strcmp(FieldType,'3widths straight')||strcmp(FieldType,'straight')
    if  abs(Informetion.estimator.result.state.p(2)-Informetion.reference.(Informetion.reference.name{1}).xd(2))<1.2
        result = 1;
    end
else
    if  norm(Informetion.estimator.result.state.p-Informetion.reference.(Informetion.reference.name{1}).xd,inf)<=4
        result = 1;
    end    
    
end







end
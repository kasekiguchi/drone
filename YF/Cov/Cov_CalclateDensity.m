function result = Cov_CalclateDensity(agent,areasetting,infometion)
N = length(agent);
state = cell(1,N);
feald = agent(1).env.huma_load.param.txt;
InoutTF = zeros(N,1);
ObservationAre = polyshape(areasetting);
%個体の位置情報取得と
for i=1:N
    state{i} = agent(i).estimator.result.state.p; 
    InoutTF(i,1) =  isinterior(ObservationAre,state{i}(1),state{i}(2));
    
    
    
end
Density = sum(InoutTF)/area(ObservationAre);
result.Dencity = Density;
result.InoutLabel = InoutTF;

if ~isempty(infometion.save.agent{1}.state)
    result.flow =  infometion.dencity.flow;
switch feald
    case '3widths straight'
      ObservationLine = min(areasetting(:,2));
      for i=1:N
          JudgeAgent = state{i}(2)-ObservationLine;
          JudgePre = infometion.save.agent{i}.state(2,end)-ObservationLine;
          if (JudgePre>0&&JudgeAgent<0)||(JudgePre<0&&JudgeAgent>0)
              result.flow =  result.flow+1     ;    
          end              
      end
    otherwise
       result.flow =  infometion.dencity.flow ;
end
end
end
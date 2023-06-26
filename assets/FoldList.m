function V = FoldList(fn,In,Ou,type)
% scalar type
% FoldList(@(a,b)sum([a,b]),1:10,0)
% a = rand(4,1)
% FoldList(@(a,b)max([a,b]),a,min(a))
% 
% matrix type 
% A = [1 sqrt(3);-sqrt(3),1]; 
% FoldList(@(A,B) A*B,cellrepmat(A,1,3),{eye(2)},"mat");
% FoldList(@(a,b)sum([a,b]),mat2cell(1:10,1,ones(1,10)),{0},"mat")
arguments
  fn
  In
  Ou
  type = "scalar"
end
if isempty(In)
  V= Ou(2:end);
else
  if type == "mat"
    Ou = {Ou{:},fn(Ou{end},In{1})};
  else
    Ou = [Ou,fn(Ou(end),In(1))];
  end
  V = FoldList(fn,In(2:end),Ou,type);
end
end
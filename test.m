 syms p [3 1] real
   syms Rb [3 3] real
   syms y real 
    
   syms R_sens [3 3] real
   syms R_num [3 2] real
   syms psb [3 1] real
   syms a b c d real
   A = [a b c];
   X = p +Rb*psb + y*Rb*R_sens*[R_num,[0;0;1]]*[1;0;0];
   %%
   eq = [A d]*[X;1];
   clear Cf
   var=[a.*psb',b.*psb',c.*psb',reshape(a*R_sens,1,numel(R_sens)),reshape(b*R_sens,1,numel(R_sens)),reshape(c*R_sens,1,numel(R_sens))];
   for j = 1:length(var)
     Cf(j) = subs(simplify(eq-subs(expand(eq),var(j),0)),var(j),1);
   end
   Cf = [p1,p2,p3,Cf];
   ds=find(Cf==0);
   Cf(ds)=[];
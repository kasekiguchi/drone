%%%conjuntion = condition 1 | condition 2 
function result = stl_disjunction (data1,data2,time,varargin)
      if varargin(1)<time(1) || varargin{2}>time(length(time))
     error('the time is out of the limit');
     else
     startIdx1 = find(time >= varargin(1), 1);
     endIdx1 = find(time <= varargin(2), 1, 'last');
     result1 = all(data1(startIdx1:endIdx1) > varargin(3));
     
     startIdx2 = find(time >= varargin(4), 1);
     endIdx2 = find(time <= varargin(5), 1, 'last');
     result2 = any(data2(startIdx2:endIdx2) > varargin(6));
   
      end  
      result = result1 | result2; 

end
function result=stl_until (data1,data2,time,varargin)
% Specifies that a condition holds true until another condition becomes true.
% the sample is when cond1 is true at the time t1 and  cond2 will become true at the time t1 till t2 .
if varargin(1)<time(1) || varargin{2}>time(length(time))
    error('the time is out of the limit');
else
    startIdx1 = find(time >= varargin(1), 1);
    endIdx1 = find(time <= varargin(2), 1,"last");
    result= false;
    if any(data1(startIdx1:endIdx1) < varargin(3))
        if  all(data2(endIdx1:varargin(2))>varargin(4))
            result = true;
            return;
        end
    end

end

end
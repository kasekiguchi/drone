function obj=stl_until (a,b,varargin)% a から b の間のある時刻t′ でϕ2 を満たし，a1 からその時刻t′ までの間はずっとϕ1 を満たす」
if(a>b)
    error('a must be less than b ');
else
    obj.param.t = varargin{1,1}.t;
    obj.param.vmax = varargin{2};
     obj.param.vmin= varargin{3};
     obj.param.posmax = varargin{4};
     obj.param.posmin = varargin{5};
end
    
end
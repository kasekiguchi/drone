function result = roll_potential(xdx,xdy,px,py,symx,symy)
aaa = atan2(xdy-py,xdx-px);
thd = aaa+pi/4;
th_x = symx-px;
th_y = symy-py;
th = atan2(th_y,th_x);
result = abs(tanh(1/(thd-th)));


end
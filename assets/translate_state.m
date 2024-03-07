function X = translate_state(x,from,to)
% translate state x "from" to "to" type
% inside the function orientation is represented as a unit quaternion.
% [Input]
% x : state vector
% from : initial type
% to : target type
% [Output]
% X : output state vector
switch from
  case "euler_parameter_qpvw"
    q = x(1:4,1);
    p = x(5:7,1);
    v = x(8:10,1);
    w = x(11:13,1);
  otherwise
%  case "euler_angle_pqvw"
    q = Eul2Quat(x(4:6,1));
    p = x(1:3,1);
    v = x(7:9,1);
    w = x(10:12,1);
end

switch to
  case "euler_parameter_qpvw"
    X = [q;p;v;w];
  %case "euler_angle_pqvw"
  otherwise
    X = [p;Quat2Eul(q);v;w];
end
end
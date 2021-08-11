function result = Cov_vatan2(point1,point2)
%ベクトルに対してatan2をそのままできるようにしたやつ．（相対位置の引き算とかいちいちしなくていい）
%前が始点，後ろが終点
result = atan2(point2(2)-point1(2),point2(1)-point1(1));
end
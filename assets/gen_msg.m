function msg = gen_msg(input)
% Function : generate msg to send through the transmitter
% How to use : gen_msg([500 500 0 500 0 0 0 0])
% The values correspond roll pitch throttle yaw aux1 aux2 aux3 aux4 channel
for j = 1:1:8
    pw(1, j + 0)   = fix(input(1, j) / 100);
    pw(1, j + 8)   = rem(input(1, j),  100);
end
msg = uint8(pw);
end


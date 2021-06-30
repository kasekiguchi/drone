function msg = gen_msg(input)
for j = 1:1:8
    pw(1, j + 0)   = fix(input(1, j) / 100);
    pw(1, j + 8)   = rem(input(1, j),  100);
end
msg = uint8(pw);
end


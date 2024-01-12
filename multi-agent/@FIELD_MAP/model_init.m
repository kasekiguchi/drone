%% model init
function model_init(obj,fFPosition,W_vec)
N = obj.N;
Il = obj.ti;
nx = obj.nx;
ny = obj.ny;
% fFPositionに応じてmap 中心から見て４象限に火災エリアの初期値配置
if numel(fFPosition) == 1
    switch fFPosition
        case 0  % build=3の場合に使用　延焼確認
            init_fx=50;
            init_fy=1;
        case 6 % 手動糸魚川
            init_fx=50;
            init_fy=11;
            init_fx=54;
            init_fy=8;
        case 7
            init_fx=41;
            init_fy=11;
        case 8
            init_fx=28;
            init_fy=8;
        case 9 % 世田谷500m南西
            init_fx=17;
            init_fy=3;
        case 10 % 世田谷500m南東
            init_fx=71;
            init_fy=2;
        case 11 % 世田谷500m北東
            init_fx=91;
            init_fy=92;
        case 12 % 世田谷500m北東中
            init_fx=66;
            init_fy=86;
        case 13 % 世田谷500m北東下
            init_fx=62;
            init_fy=66;
        case 14 % 世田谷300m北東下
            init_fx=35;
            init_fy=42;
        case 15 % 世田谷300m北東
            init_fx=85;
            init_fy=85;
        case 16 % 世田谷300m北東中
            init_fx=42;
            init_fy=77;
    end
elseif numel(fFPosition) == 2
    init_fx = fFPosition(1);
    init_fy = fFPosition(2);
else
    disp("初期出火点が不明ですぞ!");
end
init_I = sparse(N,1);
% r=randi(20,numel(init_fx),numel(init_fy))-10;
r=randi(1,numel(init_fx),numel(init_fy));
W_vec2 = logical(mod(W_vec,0));     %W_vecを0と1のみのlogical値に変換．これをしないと初期引火点が何時までも消火しない

init_I(ny*(init_fx-1)+init_fy) = 1.*W_vec2(ny*(init_fx-1)+init_fy);
init_R = sparse(N,1);
obj.initialize_each_grid(init_I,init_R);
end
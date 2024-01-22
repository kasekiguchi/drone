%% model init
function model_init(obj,Outbreak)
W_vec = reshape(obj.W,obj.N,1);
N = obj.N;
ny = obj.ny;
init_fx = Outbreak(:,1);
init_fy = Outbreak(:,2);
init_I = sparse(N,1);
W_vec2 = logical(mod(W_vec,0));     %W_vecを0と1のみのlogical値に変換．これをしないと初期引火点が何時までも消火しない
init_I(ny*(init_fx-1)+init_fy) = 1.*W_vec2(ny*(init_fx-1)+init_fy);
init_R = sparse(N,1);
obj.initialize_each_grid(init_I,init_R);
end
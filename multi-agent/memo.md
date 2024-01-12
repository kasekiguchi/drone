#

weight_map : const
[ES,EF] = adjacency_matrix(wind(k),weight_map) % 隣接行列
E = ES+EF;
X = SIR(k,X,E) %

% BestID = zeros(size(data.pathJ,2), 1);
% countMax = size(data.pathJ,2);
% for count = 1:countMax -1
%     for i = 1:size(pathJN{count}, 2)
%         if data.bestx(count,:) == data.path{count}(1,:,i)
%             BestID(count,1) = i;
%         end
%     end
% end
% 
% %%
% pathJ_sort = data.pathJ;
% % pathJsort = zeros(size(pathJ_sort{}))
% for m = 1:size(pathJ_sort, 2)
%     pathJsort{m} = sort(pathJ_sort{m}(1,:), 2); % 0 ~ サンプル数　までで正規化
% end

%% TODO サンプルごとに評価値を小さい順に並び変えて　青：良い評価　暖色：悪い評価になるように色を変化させる

% 評価値、ホライズンの配列を作成
% cell data.pathJ : evaluation 1*N
% cell data.path  : all state  12*10*N

% ある時刻 index = 100
% Jt = data.pathJ{100};% 1*N
% pt = data.path{100}; % 12*10*N
% 
% [Jtsort, I] = sort(Jt);
% Jorder{100} = [Jtsort; I];



%%

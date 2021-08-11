function result = Cov_auto_wallpoint(wallpoint , buff,result)
%% 自動で壁全部作ってくれるやつ
%角を指定してnanで区切る
load.p=wallpoint;
R = rmmissing(load.p);%nanを削除
[m,~] = size(load.p);
i =1;
while(1)
    S = load.p(i,:);
    E = load.p(i+1,:);%直線を作成
    judge = abs(S-E);%引き算してｘとｙの差を出してる
    if isnan(judge)%短点がnanならやり直し
        i=i+1;
        continue;
    else
        n = max(judge);
        if judge(1)==0%ｘ方向の差が０のとき
            load.point{i} = horzcat(ones(n*2,1).*S(1),linspace(S(2),E(2),n*2)');%等間隔のポイント作成linespaceで何個作るかを決めている．
            CP = S(1);
            if i==1
                load.poly.point{i} =[load.point{i}(:,1)-buff,load.point{i}(:,2)];%壁にバッファを与えている
                
                if load.point{i}(1,2)>load.point{i}(end,2)
                    load.poly.point{i} = sortrows(load.poly.point{i},2,'ascend' );
                else
                    load.poly.point{i} = sortrows(load.poly.point{i},2,'descend' );
                end
                
            else
                tmp = [S(1)-buff;S(1)+buff];
                [~,row] =max(abs(CP-tmp));
                load.poly.point{i} = horzcat(ones(n*2,1).*tmp(row),load.point{i}(:,2));
                if load.point{i}(1,2)>load.point{i}(end,2)
                    load.poly.point{i} = sortrows(load.poly.point{i},2,'ascend' );
                else
                    load.poly.point{i} = sortrows(load.poly.point{i},2,'descend' );
                end
            end
        else%ｙのが０のとき
            load.point{i} = horzcat(linspace(S(1),E(1),n*2)', ones(n*2,1).*S(2));
            CP = S(2);
            if i==1
                load.poly.point{i} =[load.point{i}(:,1),load.point{i}(:,2)-buff];
                
                if load.point{i}(1,1)>load.point{i}(end,1)
                    load.poly.point{i} = sortrows(load.poly.point{i},1,'ascend' );
                else
                    load.poly.point{i} = sortrows(load.poly.point{i},1,'descend' );
                end
            else
                tmp = [S(2)+buff;S(2)-buff];
                [~,row] =min(abs(CP-tmp));
                load.poly.point{i} = horzcat(load.point{i}(:,1),ones(n*2,1).*tmp(row));
                if load.point{i}(1,1)>load.point{i}(end,1)
                    load.poly.point{i} = sortrows(load.poly.point{i},1,'ascend' );
                else
                    load.poly.point{i} = sortrows(load.poly.point{i},1,'descend' );
                end
            end
        end
    end
    if i>=m-1
        break;
    end
    i=i+1;
end
load.poly.point = Cov_kick_emptycell(load.poly.point);
load.point = Cov_kick_emptycell(load.point);
load.poly.use=[];
for i = 1:length(load.point)
    tmp = [load.point{i};load.poly.point{i}];
    load.poly.use = [load.poly.use;nan nan;tmp];
end
result.poly = polyshape(load.poly.use);
result.wall = load.point;
result.spone_area = polyshape(R);
end




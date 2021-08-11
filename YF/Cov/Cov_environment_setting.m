function result = Cov_environment_setting(wallpoint , buff,result)
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
    n = fix(max(judge));
    if sum(double(isnan(judge)))~=0||n<=0%短点がnanならやり直しもしくは１ｍ以下ならやり直し
        if i>=m-1
            break;
        end
        i=i+1;
        continue;
    else
        
        if judge(1)==0%ｘ方向の差が０のとき
            load.point{i,1} = horzcat(ones(2*(n)+1,1).*S(1),linspace(S(2),E(2),2*(n)+1)');%等間隔のポイント作成linespaceで何個作るかを決めている．
        else%ｙのが０のとき
            load.point{i,1} = horzcat(linspace(S(1),E(1),2*(n)+1)', ones(2*(n)+1,1).*S(2));
        end
        if i>=m-1
            break;
        end
        i=i+1;
    end
    
end
load.point = Cov_kick_emptycell(load.point);
result.wall = (cell2mat(load.point));
end




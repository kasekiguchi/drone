function  data = Normalization(Data)
% 正規化(平均:0,標準偏差:1)

%平均値の算出
for i = 1:size(Data.X,1)
    meanValue.x(i,:) = mean(Data.X(i,:));
    meanValue.y(i,:) = mean(Data.Y(i,:));
end

for i = 1:4
    meanvalue.u(i,:) = mean(Data.U(i,:));
end


%標準偏差の算出
for i = 1:size(Data.X,1)
    stdValue.x(i,:) = std(Data.X(i,:));
    stdValue.y(i,:) = std(Data.Y(i,:));
end

for i = 1:4
    stdValue.u(i,:) = std(Data.U(i,:));
end


%列のサイズ調整
Data_size = size(Data.X,2);
meanValue.x = repmat(meanValue.x,1,Data_size);
meanValue.y = repmat(meanValue.y,1,Data_size);
meanValue.u = repmat(meanvalue.u,1,Data_size);
% stdValue.u = repmat(stdValue.u,4,1);

%データの正規化
for i = 1:size(Data.X,1)
    normalizedData.x(i,:) = Data.X(i,:) - meanValue.x(i,:);
    normalizedData.y(i,:) = Data.Y(i,:) - meanValue.y(i,:);
    data.X(i,:) = (1/stdValue.x(i,:))*normalizedData.x(i,:);
    data.Y(i,:) = (1/stdValue.y(i,:))*normalizedData.y(i,:);
end

for i = 1:4
    data.U(i,:) = (1/stdValue.u(i,:))*(Data.U(i,:)-meanValue.u(i,:));
end

data.meanValue.x = meanValue.x;
data.meanValue.y = meanValue.y;
data.stdValue.x = stdValue.x;
data.stdValue.y = stdValue.y;

end
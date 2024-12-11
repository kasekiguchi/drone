%G
m1=allData.mAll{1, 1}.y{1};
m2=allData.mAll{1, 1}.y{2};
m3=allData.mAll{1, 1}.y{3};
mAll=allData.mAll{1, 1}.y{4};
a1 = loggers{2, 1}.estimator.pL.*m1;
a2 = loggers{3, 1}.estimator.pL.*m2; 
a3 = loggers{4, 1}.estimator.pL.*m3; 
%% データセット同士を結合する
clear
common_path = "drone/Koopman_Linearization/Integration_Dataset/";

Data1 = load(strcat(common_path, "Koma2_Exp_YDataset_20data.mat"));
Data2 = load(strcat(common_path, "Kiyama_Exp_Dataset_AddXdirection_20data.mat"));

Data.HowmanyDataset = Data1.Data.HowmanyDataset + Data2.Data.HowmanyDataset;
Data.X = [Data1.Data.X, Data2.Data.X];
Data.Y = [Data1.Data.Y, Data2.Data.Y];
Data.U = [Data1.Data.U, Data2.Data.U];
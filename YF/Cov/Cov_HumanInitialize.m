function result = Cov_HumanInitialize()
%% Tyasuiとownaerの存在する方を選択できる
cd 'C:\Users'
TFa = exist('Tyasui','dir');
TFb = exist('owner','dir');
if TFa==7&&TFb==0
    result ='Tyasui';
elseif TFb==7&&TFa==0
    result = 'owner';
end
end

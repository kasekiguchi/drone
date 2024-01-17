% サンプル構造体の作成
myStruct.name = 'John';
myStruct.age = 25;
myStruct.height = 175.5;

% 構造体そのものを別の変数にコピー
myCopy = struct('name', myStruct.name, 'age', myStruct.age, 'height', myStruct.height);

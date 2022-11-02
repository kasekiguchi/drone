$$
\gdef\B{\color{blue}}
\gdef\bm#1{\bf #1}
\gdef\smatrix#1{\begin{bmatrix} #1 \end{bmatrix}}%行列簡略化
\gdef\pmat#1{\begin{pmatrix} #1 \end{pmatrix}}%行列簡略化
\gdef\R{\mathbb{R}}
\gdef\one{\mathbb{1}}
$$

# 平面の扱い

平面の表現 pl = [a,b,c,d];

$ ax + by + cz + d = [a,b,c,d][x;y;z;1] = 0$

ただし

- $a,b,c$ は正規化
- $d <= 0 $
とする．

このフォルダの関数は以下の事実に基づく．
またファイル名に現れる略記号は以下の意味を持つ

|  記号  |  意味  |
| ---- | ---- |
|  p  |  1つの点  |
|  P  |  複数の点  |
|  l  |  1つの直線  |
|  L  |  複数の直線  |

p2L_distanceなら１つの点から複数直線までの距離を計算する関数

## 基本的な性質は二次元空間上の直線と同じ

## 方向ベクトルと面分との交点

方向ベクトル : $e$ (単位ベクトル)
面分：$p_1, p_2, p_3 \in \R^3$

交点を持つ場合
$$ de = a p_1 + b p_2 + c p_3$$
と表せる．ただし$[a,b,c]$の長さは1．
係数についてまとめると

$$\smatrix{a\\b\\c\\-d} = \smatrix{P&e\\\one&0}^{-1}\smatrix{0\\0\\0\\1}$$
ブロック行列の逆行列から

$$\smatrix{a\\b\\c\\-d} = \smatrix{\ast& -P^{-1}eS^{-1}\\\ast&S^{-1}}\smatrix{0\\0\\0\\1}$$
ここで$S = -\one P^{-1}e$ である．

以上より
$$\smatrix{a\\b\\c\\-d} = \frac{1}{S}\smatrix{-P^{-1}e\\1}$$

交点座標は $p = de = -\frac{1}{S}e$.

$[a,b,c]^T$の和は１となる．
さらに各成分が$[0,1]$の範囲なら$p$ は面分$[p_1,p_2,p_3]$の内分点である．

## 単位球面への等距離射影

空間上の点を単位球面上へ球の中心（原点）に向かって射影する．

$P = \smatrix{x\\y\\z} \Rightarrow p = \frac{1}{|P|}\smatrix{x\\y\\z}$$
【性質】

- 空間上の直線は球面上の直線に射影される
- 空間上直線で区切られた閉領域は球面上でも直線で区切られた閉領域に射影される

## 単位球面から極座標への同型射

単位球面の位置$e$ を３次元デカルト座標として$e = (x,y,z)$ (ただし $ \|e\| = 1$ ) とすると，極座標$\phi, \theta$を使って以下のように表せる

$$
x = \sin\theta\cos\phi\\
y = \sin\theta\sin\phi\\
z= \cos\theta
$$

逆変換より

$$
\theta = \arccos (z)\\
\phi = sgn(y)\arccos\left(\frac{x}{\sqrt{x^2+y^2}}\right)
$$

$$ e = x e_x + y e_y + z e_z = \phi e_\phi + \theta e_\theta$$

$$
dx = \cos\theta\cos\phi d\theta - \sin\theta\sin\phi d\phi\\
dy = \cos\theta\sin\phi d\theta + \sin\theta\cos\phi d\phi\\
dz= -\sin\theta d\theta
$$

$$
\smatrix{dx\\dy\\dz} = \smatrix{\cos\phi&-\sin\phi&0\\\sin\phi&\cos\phi&0\\0&0&1}\smatrix{\cos\theta & 0\\0&\sin\theta\\-\sin\theta&0}\smatrix{d\theta\\d\phi}
$$

$$ de = e_x dx + e_y dy + e_z dz = e_\phi d\phi + e_\theta d\theta$$

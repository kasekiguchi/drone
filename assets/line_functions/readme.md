
$$
\gdef\B{\color{blue}}
\gdef\bm#1{\bf #1}
\gdef\smatrix#1{\begin{bmatrix} #1 \end{bmatrix}}%行列簡略化
\gdef\pmat#1{\begin{pmatrix} #1 \end{pmatrix}}%行列簡略化
$$

# ２次元空間上の直線の扱い

$ ax + by + c = [a,b,c][x;y;1] = 0$

ただし

- $a,b$ は正規化
- $c <= 0 $
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

## 基本的な性質

このように規定することで以下の性質を持つ

1. $[x;y] = [a;b]$ が直線の法線単位ベクトル

---

**_証明:_**
$p_1, p_2$ を直線上の２点とすると，$p_2-p_1$ は直線に沿ったベクトルとなる．
このベクトルと $[a;b]$ の内積を取ると
$$([a;b],p_2-p_1) = [a,b]p_2-[a,b]p_1 = [a,b,c][p_2;1]-[a,b,c][p_1;1] =0$$
であり直交する．(Q.E.D)

---

2. $-c$ が原点から直線までの距離

---

**_証明:_**
$p$ を原点から直線に降ろした垂線の足とすると $k>=0$ が存在し $p = k[a;b]$ となる．
また$p$は直線上の点なので$[a;b]$が単位ベクトルであることに注意して $[a,b]p + c = k + c = 0$となる．(Q.E.D)

---

3. $[x;y] = [-b-c/a;a]$ が直線上の点

## 任意の点と直線の関係

直線を上述の条件を満たす $l = (a,b,c)$ で表し，$\perp = [a;b]$ とする．任意の点を $p = [x;y]$ とすると以下を満たす．

4. $p=[x;y]$ から直線までの距離は $|-c-(p,\perp)| = |- ax -by -c| = |-[a,b,c]\smatrix{p\\1}|$

---

**_証明:_**
$p$から下した垂線の足は 求める距離$k$ を用いて $p+k\perp$ と表せる．これと $\perp$ の内積を取ると原点から直線の距離になる．(Q.E.D)

$$\perp^T (p+k\perp) = \perp^Tp + k = -c$$

---

5. 点$p$ から下ろした垂線の足の座標は $p + \left(-[a,b,c]\smatrix{p\\1}\right)\perp$（符号含め成立）

## 直線へのフィッティング

データ $[X,Y] = [x_1,y_1;x_2,y_2,;...]$ に対し最小二乗誤差を取る直線 $l = (a,b,c)$ は以下で求まる．

$$ (a,b) = {\rm eigvec}(A)$$

$$ c = -\frac{1}{N}\smatrix{\sum X&\sum Y}\smatrix{a\\b}$$

ただし，$A$ はデータの共分散を表す以下の行列であり，$N$ はデータ数を表す．$c$が負となるように$(a,b) $ の符号を決める．

$$ A = \frac{1}{N}\left(\smatrix{X^TX&X^TY\\Y^TX&Y^TY}-\frac{1}{N}\smatrix{(\sum X)^2& (\sum X)(\sum Y) \\(\sum X)(\sum Y)&(\sum Y)^2}\right)$$

---

**_証明:_**
3より$ d = -[X,Y,{\bm 1}]\smatrix{a\\b\\c}$は直線からの距離を表す．求める直線は以下を最小化するものである．

$$ J = d^T d $$
subject to $\|x\| = 1$.

ただし $ x = [a;b]$ である．

等式拘束付き最小化問題なのでラグランジュ乗数 $\lambda$ を用いて以下の拘束なしの最小化問題に変形できる．

$$ J' = J - \lambda (x^Tx-1)$$

この評価関数を最小とする $x$ は以下を満たす．

$$ \frac{\partial J'}{\partial [a,b,c]}^T = 2\smatrix{X^T\\Y^T\\{\bm 1}^T}\smatrix{X &Y &{\bm 1}}\smatrix{x\\c} - \smatrix{2\lambda x\\0} = 0$$

$$\smatrix{X^TX&X^TY& \sum X\\Y^TX&Y^TY&\sum Y\\\sum X&\sum Y&N}\smatrix{x\\c}-\lambda\smatrix{x\\0} = 0$$

最下行より

$$ c = -\frac{1}{N}\smatrix{\sum X&\sum Y}x $$

残りに代入し

$$ N A x = \lambda x$$

を得る．Q.E.D

---

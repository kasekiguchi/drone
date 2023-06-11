# Change log
To merge your program into this common project, follow 
* obj.self.input => obj.self.controller.result.input
* obj.input => obj.controller.result.input

# 基本ルール
estimator.result.state ：現在時刻の状態
controller.result.input : 入力

# 共通プログラムを用いた開発の手順

* github上にアカウントを作り，関口先生にアカウントを連絡する．
* 共通プログラムのcollaborator へのinvitationが送られてくるので承認する．
* git clone する．
* localで開発用ブランチを作る．
* 日々の変更をadd, commitで記録しながら開発を進める．
* 定期的にリモートにpushする（　git push origin branch-name　）
* 手法の実装として一通り動くようになったらpull requestをおこなう．

# ルール

共通プログラムの書き方のルール

## 【変数名】

目的：名前だけである程度の情報を得られるようにする．

| 属性 | 命名ルール | 例 |
|---|---|---|
|クラス名|大文字＋アンダーバー 区切り| C_MPC|
|プロパティ，クラスインスタンス|小文字＋大文字区切り|weightQ|
|メソッド，自作関数|小文字＋アンダーバー区切り|gen_noise()，initialize_states()|
|base workspace 変数|小文字大文字区切り（極力区切りが必要ないようにする）|agent|
|フラグ|f＋大文字始まり＋大文字区切り|fInitialPosition|

１単語の場合は以下のようにする
| 属性 | 命名ルール | 例 |
|---|---|---|
|関数（method）| 動詞 | do |
|変数（property）| 名詞 | model |

【例外】

* 高頻度に使うもので共通認識にすべきものはこの限りではない．
 例えば共通プログラムでは"N"をエージェントの数としている．
* tmpなど意味の無い言葉は極力使わない．使う場合もスコープを最小に保ち一画面で見渡せる範囲に留めること．
* for文で使う i, j ももっと適切な名前が無いか考えよう．
例えば行列の行方向の繰り返しならi より row の方が明確になる場合もある．
ただ，長くなりすぎるとこの文字列がうるさくなりすぎるのでバランスが必要．

## プログラムの中で使われる用語

|単語 | 意味 | 例 |
|---|---|---|
|agent| Drone classのインスタンス ||
| obj | class instance ||
|self | 各プロパティに設定するagent instance ||
|param | parameter | |
|f*** | *** 用フラグ | fExp |

# agent

1機のドローンを表すクラスインスタンスをagentとしている．
agentはプロパティとして飛行に必要な以下のプロパティを持っている

|プロパティ名 | 役割 | 属性* | 備考 |
| plant | 制御対象 | single ||
| model | 制御モデル | single | TODO:estimatorに合わせる |
| sensor | センサー | parallel ||
| estimator | 推定器 | cascade ||
| reference | 参照軌道 or 経路| cascade ||
| controller | 制御器 | cascade ||
| input_transform | 入力変換 | single ||
| connector | 外部デバイスとの通信器 | parallel ||
| parameter | 物理パラメータ | single | TODO:モデルのあり方によって変える |

属性については下で説明する．

## プロパティに設定するクラスについて

estimatorのサブクラスEKFを例に説明する．

単体でクラスインスタンスを作成する場合
estimator = EKF(agent.model,param);
と設定するがagentに推定器を設定する場合はagentのmethod であるset_propertyを用いる
agent.set_property("estimator",Param);
この時，Paramは
Param = struct('type','EKF','name','ekf','param',param);
となる．
EKFの第一引数であるagent.modelはset_estimatorの中で設定される．
EKFの第二引数であるparamはParamのparamフィールドに設定するものと同じ．
set_estimatorの場合typeやnameフィールドを持たせるが，typeでEKFというクラス名を指定し，
nameは複数の推定器を設定する場合に参照するための文字列となる．

単体で作成した場合は
estimator 自体がEKFクラスのインスタンスであるが，
set_propertyを使った場合
agent.estimator.ekf がEKFクラスのインスタンスになる．

### estimator, reference, controller プロパティ

例えばローパスフィルタをかけてから後退差分近似で速度を求める場合など，複数の処理をカスケードにおこなうことが求められるクラスがある．estimator,reference,controllerはカスケードなつながりに対応するプロパティである．
これらはnameというフィールドを持つ．nameは登録した（例えば）推定器の名前の配列
カスケードな処理はnameの配列順におこなわれる．
例：estimator.name : ['lpf','adiff']
の場合ローパスフィルタをかけた情報を使って後退差分近似微分をおこなうことを意味する．

### sensor プロパティ

sensorプロパティに設定する複数のセンサーはカスケードな関係ではなくパラレルの関係にある．
agent.sensor は必ずname, resultプロパティを持つ
nameは登録したセンサー名配列
resultは全てのセンサー値を集約したもの．ただし重複するフィールドを持つ場合上書きされる点に注意

> agent.sensor.rpos = RangePos_sim(agent,struct('r',1));

# 自律飛行ドローンについて

オシロスコープで各信号を確認することで以下がわかる

FUTABA トレーナーコードでの信号はPPM

FUTABA recieverからの信号はSBUS
<https://rikei-tawamure.com/entry/2020/03/17/120606>

PixharkからESC(Tekko32 F3 ESC(35A))はDshot150

# 新しい機体の導入法

TODO：ゲインのチューニングの際指標となるデータの生成

1. throttle以外の入力変換のゲインを0，offsetも0にしてtake offする（throttleのゲインは小さい値からチューニングが必要）
2. take off で浮上しなければ最終のthrottle値をoffsetに設定
3. 2を繰り返し浮上させる．（水平に流れるのですぐlandingさせること）
4. リファレンス変化中に浮上すれば浮上した時のthrottle値から少し小さい値をthrottleのoffsetに設定する．
5. roll, pitch, yawのゲインをチューニングする．

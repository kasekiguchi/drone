# 回避すべき設定

* EulerAngle+Quad13+EKF + dt=0.25 : サンプリングが粗いと誤差蓄積で破綻

# 注意すべき設定

* DIRECT_ESTIMATOR を使うときはSENSORもDIRECTを選ぶ

classdef NDSL2 < handle
    %NDSL 先行研究の検証に用いるクラスファイル Ver. 2
    %   「軌道の位相的性質を保証する非線形動的システム学習」
    %   事前学習を採用

    properties
        t % シミュレーション時間(ベクトル)
        ts % 開始時刻
        tstep % 時間刻み
        te % 終了時刻
        numStep % 1初期点あたりの時間発展ステップ数
    end

    properties(Constant)
        inputSize_xi = 2; % ξ入力層
        hiddenSize_xi = 2; % ξ中間層
        outputSize_xi = 2; % ξ出力層

        inputSize_alpha = 2; % α入力層
        hiddenSize_alpha = 7; % α中間層
        outputSize_alpha = 1; % α出力層

        extension = '.mat'; % 読込・保存用の拡張子
    end

    methods
        function obj = NDSL()
            %NDSL コンストラクタ
            %   初期値の代入
            obj.numStep = 1000;
            obj.ts = 0;
            obj.tstep = 0.03;
            obj.te = obj.tstep * obj.numStep - obj.tstep;
            obj.t = obj.ts:obj.tstep:obj.te;
        end

        function ae = buildAE(~, in1, in2, x)
            %METHOD1 NNの材料となる3層AEを構築
            %   in1：入出力ユニット数
            %   in2：中間層ユニット数
            %   x：学習データ
            rng(1) % 乱数固定
            autoenc = trainAutoencoder(x,in2,...
                'MaxEpochs',5,...
                'EncoderTransferFunction','logsig',...
                'DecoderTransferFunction','purelin');
            aenet = network;
            aenet.numInputs = 1;
            aenet.numLayers = 2;
            ly1 = [0 0];
            ly2 = [1 0];
            aenet.layerConnect = [ly1;ly2];
            aenet.biasConnect = [1;1];
            aenet.inputConnect = [1;0];
            aenet.outputConnect = [0 1];
            aenet.inputs{1}.size = in1;
            aenet.layers{1}.size = in2;
            aenet.layers{2}.size = in1;
            aenet.layers{1}.transferFcn = 'elliotsig';
            aenet.layers{2}.transferFcn = 'elliotsig';
            aenet.divideFcn = 'dividetrain';
            aenet.trainFcn = 'trainscg';
            aenet.IW{1,1} = autoenc.EncoderWeights;
            aenet.b{1} = autoenc.EncoderBiases;
            aenet.LW{2,1} = autoenc.DecoderWeights;
            aenet.b{2} = autoenc.DecoderBiases;
            aenet.trainParam.epochs = 100;
            ae = train(aenet,x,x);
        end

        function xn = calculateHidden(~, ae, x)
            %METHOD2 NNの多層化に必要な中間層の値の計算
            %   材料AEの中間層への入力データとする
            %   ae：材料AEの情報
            %   x：学習データ
            xn = {};
            for i = 1:length(x)
                xn{1,i}(:,1) = ae.IW{1,1} * x{1,i}(:) + ae.b{1};
            end
        end

        function tnet = buildXi(~, ae1, ae2, x, t)
            %METHOD3 5層NNの事前学習(ξ)
            %   AEの学習ではなくAEと同等なNNの学習
            %   AEでありながら活性化関数の融通が利くようになる
            %   ae1：外側の層の材料AE
            %   ae2：内側の層の材料AE
            %   x：学習データ
            %   t：教師データ
            rng(1)
            net = network;
            net.numInputs = 1;
            net.numLayers = 4;
            ly1 = [0 0 0 0];
            ly2 = [1 0 0 0];
            ly3 = [0 1 0 0];
            ly4 = [0 0 1 0];
            net.layerConnect = [ly1;ly2;ly3;ly4];
            net.biasConnect = [1;1;1;1];
            net.inputConnect = [1;0;0;0];
            net.outputConnect = [0 0 0 1];
            net.inputs{1}.size = ae1.inputs{1}.size;
            net.layers{1}.size = ae1.layers{1}.size;
            net.layers{2}.size = ae2.layers{1}.size;
            net.layers{3}.size = ae2.layers{1}.size;
            net.layers{4}.size = ae1.layers{1}.size;
            net.layers{1}.transferFcn = 'elliotsig';
            net.layers{2}.transferFcn = 'elliotsig';
            net.layers{3}.transferFcn = 'elliotsig';
            net.layers{4}.transferFcn = 'elliotsig';
            net.divideFcn = 'dividetrain';
            net.trainFcn = 'trainscg';
            net.IW{1,1} = ae1.IW{1,1};
            net.b{1} = ae1.b{1};
            net.LW{2,1} = ae2.IW{1,1};
            net.b{2} = ae2.b{1};
            net.LW{3,1} = ae2.LW{2,1};
            net.b{3} = ae2.b{2};
            net.LW{4,1} = ae1.LW{2,1};
            net.b{4} = ae1.b{2};
            net.trainParam.epochs = 10000;
            tnet = train(net,x,t);
        end

        function tnet = buildAlpha(~, ae1, ae2, x, t)
            %METHOD4 3層NNを構築(α)
            %   AEの学習ではなくAEと同等なNNの学習
            %   AEでありながら活性化関数の融通が利くようになる
            %   ae1：前半部分(1層→2層)の材料AE
            %   ae2：後半部分(2層→3層)の材料AE
            %   x：学習データ
            %   t：教師データ
            rng(1)
            net = network;
            net.numInputs = 1;
            net.numLayers = 2;
            ly1 = [0 0];
            ly2 = [1 0];
            net.layerConnect = [ly1;ly2];
            net.biasConnect = [1;1];
            net.inputConnect = [1;0];
            net.outputConnect = [0 1];
            net.inputs{1}.size = ae1.inputs{1}.size;
            net.layers{1}.size = ae1.layers{1}.size;
            net.layers{2}.size = ae2.layers{2}.size;
            net.layers{1}.transferFcn = 'poslin';
            net.layers{2}.transferFcn = 'logsig';
            net.divideFcn = 'dividetrain';
            net.trainFcn = 'trainscg';
            net.IW{1,1} = ae1.IW{1,1};
            net.b{1} = ae1.b{1};
            net.LW{2,1} = ae2.IW{1,1};
            net.b{2} = ae2.b{1};
            net.trainParam.epochs = 10000;
            tnet = train(net,x,t);
        end








    end
end


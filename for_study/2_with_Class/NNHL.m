classdef NNHL < handle
    %NN_HL 階層型線形化と同等な変換機能を持つNNの構築に関わるクラスファイル
    %   階層型線形化における実状態→仮想状態，仮想状態→実状態の変換を再現

    properties
        t % シミュレーション時間
        %         figf % 図番号
        % 第1ネットワーク(x→z)
        %         inputSize1 % 入力層ユニット数
        hiddenSize11 % 中間層1
        %         outputSize1 % 出力層ユニット数
        % 第2ネットワーク(z→x)
        %         inputSize2 % 入力層ユニット数
        hiddenSize21 % 中間層1
        hiddenSize22 % 中間層2
        hiddenSize23 % 中間層3
        hiddenSize24 % 中間層4
        %         outputSize2 % 出力層ユニット数
    end

    properties(Constant)
        inputSize1 = 32; % 入力層ユニット数
        outputSize1 = 12; % 出力層ユニット数
        inputSize2 = 32; % 入力層ユニット数
        outputSize2 = 12; % 出力層ユニット数
        extension = '.mat'; % 読込・保存用の拡張子
    end

    methods
        function obj = NNHL()
            %HL_NN コンストラクタ
            %   初期値を代入
            obj.t = 0:0.01:10;
            %             obj.figf = 1;
            obj.hiddenSize11 = 32;
            obj.hiddenSize21 = 32;
            obj.hiddenSize22 = 32;
            obj.hiddenSize23 = 32;
            obj.hiddenSize24 = 32;
        end

        function ae = build_AE(~, in1, in2, x)
            %METHOD1 NNの元となる3層AEを構築
            %   in1:入出力のユニット数
            %   in2:中間層ユニット数
            %   x:訓練データ
            rng(1)
            autoenc = trainAutoencoder(x,in2,...
                'MaxEpochs',10,...
                'EncoderTransferFunction','satlin',...
                'DecoderTransferFunction','purelin',...
                'Scale',false);
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
            aenet.layers{1}.transferFcn = 'poslin';
            aenet.layers{2}.transferFcn = 'purelin';
            aenet.divideFcn = 'dividetrain';
            aenet.trainFcn = 'trainscg';
            aenet.IW{1,1} = autoenc.EncoderWeights;
            aenet.b{1} = autoenc.EncoderBiases;
            aenet.LW{2,1} = autoenc.DecoderWeights;
            aenet.b{2} = autoenc.DecoderBiases;
            aenet.trainParam.epochs = 500;
            ae = train(aenet,x,x);
        end

        function xn = calculate_Hidden(~, ae, x)
            %METHOD1 NNの元となる3層AEを構築
            %   in1:入出力のユニット数
            %   in2:中間層ユニット数
            %   x:訓練データ
            xn = {};
            for i = 1:length(x)
                xn{1,i}(:,1) = ae.IW{1,1} * x{1,i}(:) + ae.b{1};
            end
        end


        function tnet = build_3LNN(~, ae1, ae2, x, t)
            %METHOD1 NNの元となる3層AEを構築
            %   in1:入出力のユニット数
            %   in2:中間層ユニット数
            %   x:訓練データ
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
            net.layers{2}.size = ae2.layers{1}.size;
            net.layers{1}.transferFcn = 'poslin';
            net.layers{2}.transferFcn = 'purelin';
            net.divideFcn = 'dividetrain';
            net.trainFcn = 'trainscg';
            net.IW{1,1} = ae1.IW{1,1};
            net.b{1} = ae1.b{1};
            net.LW{2,1} = ae2.IW{1,1};
            net.b{2} = ae2.b{1};
            net.trainParam.epochs = 1000;
            tnet = train(net,x,t);
        end

        function f = plot_Result(obj, result,F)
            %METHOD1 NNの元となる3層AEを構築
            %   in1:入出力のユニット数
            %   in2:中間層ユニット数
            %   x:訓練データ
            obj.t = 0:0.01:10;
            for state = 1:7
                num = min(size(result.state{1,1}));
                figure(F)
                hold on
                for i = 1:num
                    plot(obj.t,result.state{1,state}(:,i),'LineWidth',2)
                end
                grid on
                set(gca,'FontSize',12);
                xlabel('Time','fontsize',20)
                ylabel('Value','fontsize',20)

                switch state
                    case {1,5}
                        h = legend('$x_1$','$x_2$','$x_3$','$x_4$','$x_5$','$x_6$',...
                            '$x_7$','$x_8$','$x_9$','$x_{10}$','$x_{11}$','$x_{12}$');
                    case {2,4}
                        h = legend('$z_1$','$z_2$','$z_3$','$z_4$','$z_5$','$z_6$',...
                            '$z_7$','$z_8$','$z_9$','$z_{10}$','$z_{11}$','$z_{12}$');
                    case {6,7}
                        h = legend('$\tilde {x}_1$','$\tilde {x}_2$','$\tilde {x}_3$','$\tilde {x}_4$',...
                            '$\tilde {x}_5$','$\tilde {x}_6$','$\tilde {x}_7$','$\tilde {x}_8$',...
                            '$\tilde {x}_9$','$\tilde {x}_{10}$','$\tilde {x}_{11}$','$\tilde {x}_{12}$');
                    case 3
                        h = legend('$\tilde {z}_1$','$\tilde {z}_2$','$\tilde {z}_3$','$\tilde {z}_4$',...
                            '$\tilde {z}_5$','$\tilde {z}_6$','$\tilde {z}_7$','$\tilde {z}_8$',...
                            '$\tilde {z}_9$','$\tilde {z}_{10}$','$\tilde {z}_{11}$','$\tilde {z}_{12}$');
                end

                h.NumColumns = 2;
                set(h,'Interpreter','latex','fontsize',15)

                hold off
                F = F + 1;
            end
            f = F;
        end

        function total = total_data(~, in1, in2)
            % This function totals 2 data.
            % in1,in2:cell data
            total = {};
            for i = 1:max(size(in1))
                for j = 1:min(size(in1)) % output1の格納
                    total{1,i}(j,1) = in1{1,i}(j,1);
                end
                for k = 1:length(in2{1,1}) % 目標値の格納
                    total{1,i}(length(in1{1,1})+k,1) = in2{1,i}(k,1);
                end
            end
        end

        function intS = sum_data(~, in1, in2)
            % 1つのデータの末尾に別のデータを追加
            % total_dataは学習する要素(状態)の追加cell内のdoubleに追加していくイメージ．
            % 例)訓練データ：状態+目標値
            % 対してsum_dataはデータ数の追加．cellの末尾に追加していく．
            % 例)訓練データ：周期0.4のデータ+周期0.5のデータ
            % in1：s=load('...');で読み込んだs
            % in2：同上
            % intS：統合したデータ．in1，in2と同様の形式で出力される．
            max1 = length(in1.reference) + length(in2.reference);
            max2 = length(in1.reference);
            max3 = length(in1.x_train) + length(in2.x_train);
            max4 = length(in1.x_train);
            for i = 1:max1
                if i <= max2
                    intS.reference{1,i} = in1.reference{1,i};
                    intS.x_test{1,i} = in1.x_test{1,i};
                    intS.z_test{1,i} = in1.z_test{1,i};
                else
                    intS.reference{1,i} = in2.reference{1,i-max2};
                    intS.x_test{1,i} = in2.x_test{1,i-max2};
                    intS.z_test{1,i} = in2.z_test{1,i-max2};
                end
            end
            for i = 1:max3
                if i <= max4
                    intS.x_train{1,i} = in1.x_train{1,i};
                    intS.xt_train{1,i} = in1.xt_train{1,i};
                    intS.z_train{1,i} = in1.z_train{1,i};
                    intS.zt_train{1,i} = in1.zt_train{1,i};
                else
                    intS.x_train{1,i} = in2.x_train{1,i-max4};
                    intS.xt_train{1,i} = in2.xt_train{1,i-max4};
                    intS.z_train{1,i} = in2.z_train{1,i-max4};
                    intS.zt_train{1,i} = in2.zt_train{1,i-max4};
                end
            end
        end

        
        
    end
end


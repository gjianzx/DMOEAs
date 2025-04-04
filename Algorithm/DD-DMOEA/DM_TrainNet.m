function [net,varianceSchedule] = DM_TrainNet(POS_t1, POS_t2)
    % 输入参数:
    numEpochs=10; %训练的轮数
    learningRate=0.1; %学习率
    
    numNoiseSteps = 10;   % 扩散步数
    betaMin = 0.1;
    betaMax = 0.9;
    varianceSchedule = linspace(betaMin,betaMax,numNoiseSteps);
    % 将输入数据进行展平,大小为Dim*NP
    [D_t1,NP_T1]=size(POS_t1); 
    [D_t2,NP_T2]=size(POS_t2);
    inputNode = D_t1*NP_T1;
    outputNode = D_t2*NP_T2;

    % 初始化训练输入和目标
    inputData = [];   % Dim*NP
    targetData = [];

    % 生成带噪声的输入数据和对应的噪声目标
    for step = 1:numNoiseSteps
        % 当前步骤的噪声强度
        noiseLevel = sqrt(varianceSchedule(step));
        
        % 为每个样本添加噪声，生成带噪声的POS_t
        noise = noiseLevel * randn(size(POS_t1));
        POS_t_noisy = POS_t1 + noise;
        
        % 累积输入数据和目标噪声
        inputData = [inputData; POS_t_noisy];
        targetData = [targetData; noise];  % 目标是去噪网络应去除的噪声
    end

    % 定义MLP网络结构
    layers = [
        featureInputLayer(inputNode, 'Name', 'input')  % 输入层，维度为解集的维数
        fullyConnectedLayer(64, 'Name', 'fc1')  % 第一层隐藏层，64个神经元
        reluLayer('Name', 'relu1')  % ReLU 激活函数
        fullyConnectedLayer(32, 'Name', 'fc2')  % 第二层隐藏层，32个神经元
        reluLayer('Name', 'relu2')  % ReLU 激活函数
        fullyConnectedLayer(outputNode, 'Name', 'output')  % 输出层，输出解集的维数
    ];

    % 创建 dlnetwork 对象
    network = dlnetwork(layers);

    % 将数据转换为 dlarray 类型 (适用于 dlnetwork)
    adN_POS = dlarray(inputData, 'CB');  % 上一时刻的解集数据
    addNoise = dlarray(targetData, 'CB');  % 当前的解集数据

    % 自定义训练循环
    for epoch = 1:numEpochs
        % 批量训练循环
        numBatches = floor(size(inputData, 1) / batchSize);  % 计算每轮的批次数量
        for batchIdx = 1:numBatches
            % 从数据中选择一个小批量
            idx = (batchIdx-1)*batchSize+1 : batchIdx*batchSize;
            xBatch = adN_POS(idx, :);      % 加噪后的历史POS
            yBatch = addNoise(idx, :);     % 加入的噪声

            % 前向传播：得到网络的输出
            [predictions, networkState] = forward(network, xBatch);

            % 计算损失：预测噪声与真实噪声之间均方误差
            loss = mean((predictions - yBatch).^2, 'all');

            % 计算梯度：反向传播
            gradients = dlgradient(loss, network.Learnables);

            % 更新网络参数：使用Adam优化器
            network = adamupdate(network, gradients, learningRate);
        end
    end

end

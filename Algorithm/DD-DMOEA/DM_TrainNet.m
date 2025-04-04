function [net,varianceSchedule] = DM_TrainNet(POS_t1, POS_t2)
    % �������:
    numEpochs=10; %ѵ��������
    learningRate=0.1; %ѧϰ��
    
    numNoiseSteps = 10;   % ��ɢ����
    betaMin = 0.1;
    betaMax = 0.9;
    varianceSchedule = linspace(betaMin,betaMax,numNoiseSteps);
    % ���������ݽ���չƽ,��СΪDim*NP
    [D_t1,NP_T1]=size(POS_t1); 
    [D_t2,NP_T2]=size(POS_t2);
    inputNode = D_t1*NP_T1;
    outputNode = D_t2*NP_T2;

    % ��ʼ��ѵ�������Ŀ��
    inputData = [];   % Dim*NP
    targetData = [];

    % ���ɴ��������������ݺͶ�Ӧ������Ŀ��
    for step = 1:numNoiseSteps
        % ��ǰ���������ǿ��
        noiseLevel = sqrt(varianceSchedule(step));
        
        % Ϊÿ������������������ɴ�������POS_t
        noise = noiseLevel * randn(size(POS_t1));
        POS_t_noisy = POS_t1 + noise;
        
        % �ۻ��������ݺ�Ŀ������
        inputData = [inputData; POS_t_noisy];
        targetData = [targetData; noise];  % Ŀ����ȥ������Ӧȥ��������
    end

    % ����MLP����ṹ
    layers = [
        featureInputLayer(inputNode, 'Name', 'input')  % ����㣬ά��Ϊ�⼯��ά��
        fullyConnectedLayer(64, 'Name', 'fc1')  % ��һ�����ز㣬64����Ԫ
        reluLayer('Name', 'relu1')  % ReLU �����
        fullyConnectedLayer(32, 'Name', 'fc2')  % �ڶ������ز㣬32����Ԫ
        reluLayer('Name', 'relu2')  % ReLU �����
        fullyConnectedLayer(outputNode, 'Name', 'output')  % ����㣬����⼯��ά��
    ];

    % ���� dlnetwork ����
    network = dlnetwork(layers);

    % ������ת��Ϊ dlarray ���� (������ dlnetwork)
    adN_POS = dlarray(inputData, 'CB');  % ��һʱ�̵Ľ⼯����
    addNoise = dlarray(targetData, 'CB');  % ��ǰ�Ľ⼯����

    % �Զ���ѵ��ѭ��
    for epoch = 1:numEpochs
        % ����ѵ��ѭ��
        numBatches = floor(size(inputData, 1) / batchSize);  % ����ÿ�ֵ���������
        for batchIdx = 1:numBatches
            % ��������ѡ��һ��С����
            idx = (batchIdx-1)*batchSize+1 : batchIdx*batchSize;
            xBatch = adN_POS(idx, :);      % ��������ʷPOS
            yBatch = addNoise(idx, :);     % ���������

            % ǰ�򴫲����õ���������
            [predictions, networkState] = forward(network, xBatch);

            % ������ʧ��Ԥ����������ʵ����֮��������
            loss = mean((predictions - yBatch).^2, 'all');

            % �����ݶȣ����򴫲�
            gradients = dlgradient(loss, network.Learnables);

            % �������������ʹ��Adam�Ż���
            network = adamupdate(network, gradients, learningRate);
        end
    end

end

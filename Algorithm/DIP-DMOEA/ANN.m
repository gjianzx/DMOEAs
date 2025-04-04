function init_Pop = ANN(his_POS,curr_POS)

%%his_NDS: nxd curr_NDS: nxd


h=size(his_POS,2);  %input nodes 
i=5;                %Hidden nodes     
j=size(curr_POS,2); %Output nodes 
Alpha=0.1;          %The learning rate
Beta=0.1;           %The learning rate
Gamma=0.8;          %The constant determines effect of past weight changes
maxIteration=10;    %The max number of Iteration
trainNum=size(his_POS,1);  % 训练数据的大小，这里为历史pareto解集的大小

% 随机初始化输入层到隐藏层的权重 V，隐藏层到输出层的权重 W，隐藏层的阈值 HNT 和输出层的阈值 ONT。
V=2*(rand(h,i)-0.5);    %The weights between input and hidden layers——[-1, +1] 输入层和隐藏层的权重
W=2*(rand(i,j)-0.5);    %The weights between hidden and output layers——[-1, +1] 隐藏层和输出层的权重
HNT=2*(rand(1,i)-0.5);  %The thresholds of hidden layer nodes   
ONT=2*(rand(1,j)-0.5);  %The thresholds of output layer nodes
% 初始化权重和阈值的变化量为0
DeltaWOld(i,j)=0; %The amout of change for the weights  W
DeltaVOld(h,i)=0; %The amout of change for the weights  V
DeltaHNTOld(i)=0; %The amount of change for the thresholds HNT
DeltaONTOld(j)=0; %The amount of change for the thresholds ONT

Epoch=1;


% Normalize the dataset   对输入和输出数据进行归一化处理 
[inputn,inputs] = mapminmax(his_POS');   % mapminmax 归一化函数
inputn = inputn';
[outputn,outputs] = mapminmax(curr_POS');
outputn = outputn';

while Epoch<maxIteration
    for k=1:trainNum
        
        a=inputn(k,:);   % 获取第k个样本的输入，这里为第k个个体
        
        ck=outputn(k,:);
        % Calcluate the value of activity of hidden layer FB
        for ki=1:i
            b(ki)=logsig(a*V(:,ki)+HNT(ki));   % logsig:对数sigmod函数，激活函数
        end
        %  Calcluate the value of activity of hidden layer FC
        for kj=1:j
            c(kj)=logsig(b*W(:,kj)+ONT(kj));
        end
        % Calculate the errorRate of FC  计算输出层误差
        d=c.*(1-c).*(ck-c);
        % Calculate the errorRate of FB  计算隐藏层误差
        e=b.*(1-b).*(d*W');
        %Update the weights between FC and FB——Wij 更新隐藏层到输出层的权重。
        for ki=1:i
            for kj=1:j
                % 根据误差和学习率更新权重，并更新权重变化量的累积值。
                DeltaW(ki,kj)=Alpha*b(ki)*d(kj)+Gamma*DeltaWOld(ki,kj);
            end
        end
        W=W+DeltaW;
        DeltaWOld=DeltaW;
        %Update the weights between FA and FB——Vhj 更新输入层到隐藏层的权重
        for kh=1:h
            for ki=1:i
                DeltaV(kh,ki)=Beta*a(kh)*e(ki);                               
            end
        end
        V=V+DeltaV;                                                    
        DeltaVold=DeltaV;    
        
        % Update HNT and ONT
        DeltaHNT=Beta*e+Gamma*DeltaHNTOld;
        HNT=HNT+DeltaHNT;
        DeltaHNTOld=DeltaHNT;
        
        DeltaONT=Alpha*d+Gamma*DeltaONTOld;
        ONT=ONT+DeltaONT;
        DeltaTauold=DeltaONT;
    end 
    Epoch = Epoch +1; % update the iterate number
end



inputn = outputn;  % 将输出层的归一化数据作为新的输入数据。

for k=1:size(inputn,1)
    a=inputn(k,:); %get testSet 获取第 k 个测试样本的输入
    
    %Calculate the value of activity of hidden layer FB  隐藏层节点结果
    for ki=1:i
        b(ki)=logsig(a*V(:,ki)+HNT(ki));
    end
    %Calculate the result      输出层节点的结果
    for kj=1:j
        c(kj)=logsig(b*W(:,kj)+ONT(kj));
    end
    
    init_Pop(k,:)=c; % 将计算结果存储到初始化种群矩阵中。

end
init_Pop = mapminmax('reverse',init_Pop',outputs); % 对init_Pop进行反归一化
% 将归一化的数据转换为原始数据
end

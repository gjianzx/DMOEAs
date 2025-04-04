% add path for mcpIncSVM
addpath mcpIncSVM

% generate toy dataset
trialsperclass = 100;
for class=1:3    
    data_x((class-1)*trialsperclass+[1:trialsperclass],:) = rand(trialsperclass,256)+class*0.07;   
    data_y((class-1)*trialsperclass+[1:trialsperclass]) = class;
end

% permute data
permut = randperm(size(data_x,1));
data_x = data_x(permut,:);
data_y = data_y(permut);

% use first 50 samples for initial training
trainind = 1:50;

mcp_svmtrain(data_x(trainind,:),data_y(trainind)',1,1,1);

% process rest of data
for trial=trainind(end)+1:size(data_x,1)
    % predict label and probabilities for next sample
    [pred_cl(trial) prob_pred(trial,:)]=mcp_svmpredict(data_x(trial,:));
    % incrementally train SVM with next sample
    mcp_svmtrain_next(data_x(trial,:),data_y(trial),1);
end
% display mean accuracy 
disp('----------------------')
disp(['mean accuracy: ' num2str((mean(pred_cl(trainind(end)+1:size(data_x,1))==data_y(trainind(end)+1:size(data_x,1))))*100) ' %']);


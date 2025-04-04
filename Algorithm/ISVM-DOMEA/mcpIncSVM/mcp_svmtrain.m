% MCP_SVMTRAIN - trains a new SVM
%
% Syntax: mcp_svmtrain(data_x,data_y,C,kerneltype,scale)
%
%      data_x: matrix of training vectors stored columnwise
%      data_y: column vector of class labels (-1/+1) for training vectors
%      C: soft-margin regularization parameter(s)
%         dimensionality of C       assumption
%         1-dimensional vector      universal regularization parameter
%         2-dimensional vector      class-conditional regularization parameters (-1/+1)
%         n-dimensional vector      regularization parameter per example
%         (where n = # of examples)
%      kerneltype: kernel type
%           1: linear kernel        K(x,y) = x'*y
%         2-4: polynomial kernel    K(x,y) = (scale*x'*y + 1)^type
%           5: Gaussian kernel with variance 1/(2*scale)
%      scale: kernel scale
%


function mcp_svmtrain(data_x,data_y,C,kerneltype,scale)
global mcp_model;
mcp_model = struct();



classes = unique(data_y);
mcp_model.classes = classes;
mcp_model.nr_classes=length(classes);

counter=1;
for cl1=1:length(classes)-1
    for cl2=cl1+1:length(classes)
        useinds = (data_y==classes(cl1) | data_y==classes(cl2));
        newdata_y = data_y(useinds);
        newdata_y(data_y(useinds)==classes(cl1))=1;
        newdata_y(data_y(useinds)==classes(cl2))=-1;        
        global model;
        svmtrain_inc(data_x(useinds,:)',newdata_y,C,kerneltype,scale);        
        probabilistic();
        mcp_model.models{counter}= model;
        counter = counter+1;
    end
end



end


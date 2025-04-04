% MCP_SVMPREDICT - predicts class labels and probabilities
%
% Syntax: [pred_cl pred_probs] = mcp_svmpredict(data_x)
%
%       pred_cl: predicted class label
%       pred_probs: predicted class probabilites
%       data_x: vector to classify


function [pred_cl pred_probs] = mcp_svmpredict(data_x)

global mcp_model;

classes = mcp_model.classes;

counter=1;
pw_probs=zeros(size(data_x,1),length(classes)*(length(classes)-1)/2);
for cl1=1:length(classes)-1
    for cl2=cl1+1:length(classes)
        %disp(['checking ' num2str([classes(cl1) classes(cl2)])])

        global model;
        model = mcp_model.models{counter};
        deci = svmeval(data_x');
        for i=1:length(deci)
            fApB = deci(i)*model.probA+model.probB;
            if (fApB >= 0)
                pw_probs(i,counter)=exp(-fApB)/(1.0+exp(-fApB));
            else
                pw_probs(i,counter)=1.0/(1+exp(fApB));
            end
        end

        counter = counter+1;
    end
end

pred_probs=zeros(size(data_x,1),length(classes));
for i=1:size(data_x,1)
    pred_probs(i,:)=mcp_probabilistic(length(classes), pw_probs(i,:));
end

[a org_pred_cl]=max(pred_probs');
for cl=1:length(classes)
    pred_cl(org_pred_cl==cl)=classes(cl);
end

end


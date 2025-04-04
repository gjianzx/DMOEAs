% MCP_SVMGETWEIGHTS - returns weights for a linear SVM
%
% Syntax: [w b probA probB] = mcp_svmgetWeights()


function [w b probA probB] = mcp_svmgetWeights()
global mcp_model;

classes = mcp_model.classes;

counter=1;
for cl1=1:length(classes)-1
    for cl2=cl1+1:length(classes)
        disp(['checking ' num2str([classes(cl1) classes(cl2)])])

        global model;
        model = mcp_model.models{counter};

        w{counter} = model.X*(model.a.*model.y);
        b{counter} = model.b;
        probA{counter} = model.probA;
        probB{counter} = model.probB;

        counter = counter+1;
    end
end



end


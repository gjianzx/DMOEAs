function [w,individualsX]=buildModel(source)

    sourceX=[];
    sourceF=[];
    for i=1:size(source,2)
        sourceX=[sourceX;source(i).popX];
        sourceF=[sourceF;source(i).popF];
    end

    tX = [sourceX];
    tY = [sourceF];
    n = size(sourceF,1);
 
    T = 1;
    w = ones(n,1)/(n);
    model = cell(1,T);
     
    for t = 1:T   
        %计算epsilon T and beta T
        for objDim=1:size(tY,2)
            model{t} = svmtrain(w,tY(:,objDim),tX,'-s 3 -t 2 -c 2.2 -g 2.8 -p 0.01 -q');
            [predict(:,objDim) ,~,~]= svmpredict(tY(:,objDim),tX,model{t},'-q');
        end 
        relativeErrorAll=getRelativeError(predict,tY);
        epsilon=getEpsilon(w,relativeErrorAll);
        beta =epsilon/(1-epsilon);       
    end 
    
    individualsX=[];
 %   individualsF=[];
    for i=1:length(source)
        individualsX=[individualsX;source(i).popX];
    %    individualsF=[individualsF;source(i).popF];
    end
end

function res=getEpsilon(weight,relativeError)
    res=sum(weight.*relativeError/sum(weight));
end


function res=getRelativeError(predict,tY)
    %计算最大误差
    errorMatrix=predict-tY;
    errorVector=zeros(size(errorMatrix,1),1);
    for objDim=1:size(tY,2)
         errorVector=errorVector+abs(errorMatrix(:,objDim));
    end 
    E=max(abs(errorVector));
    %计算相对误差
    relativeError=errorVector/E;
    res=relativeError;
end



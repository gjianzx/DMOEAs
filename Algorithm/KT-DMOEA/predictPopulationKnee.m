function [initPopulation,runTime] = predictPopulationKnee(tdX,tdY,tsX,tsY,testX,partNum)
    
    [predictModel, beta]=IKTrAdaBoostTrain(tdX,tdY,tsX,tsY,partNum);
    runTime=0;
    PredictVec=TrPredict(testX,predictModel,beta);

    
    initPopulation=[];
    j=0;
    for i=1:1:size(PredictVec,1)
        if PredictVec(i)==1
            j=j+1;
            initPopulation(j,:)=testX(i,:);
        end
    end
    initPopulation=initPopulation';
    
end

function [historicalInformation,OMatrix,GMatrix] = PreEstimation(historicalInformation,curHLength)


    oIdx = 1;
    flag1 = false;
    allMD = zeros(1,length(historicalInformation)-1);
    for i=1:curHLength
        % Calculate MD
        D = MahalanobisDistance(historicalInformation{i}.H,historicalInformation{curHLength+1}.H);
        allMD(i) = D;
        if D<0.01
            oIdx = i;
            % Equation 12
            flag1 = true;
        end
    end
    % Select the output set O via Equation.10
    [~,newTimeMDIdx] = sort(allMD,'ascend');
    OMatrix = historicalInformation{newTimeMDIdx(1)}.V;
    % Select the input set G via Equation.11
    for i=1:length(historicalInformation)-1
        % Calculate MD
        allMD(i) = MahalanobisDistance(historicalInformation{i}.H,historicalInformation{newTimeMDIdx(1)}.H);
    end
    if allMD(end)>=0.01
        GMatrix = historicalInformation{end-1}.V;
    else
        [~,oldTimeMDIdx] = sort(allMD,'ascend');
        GMatrix = historicalInformation{oldTimeMDIdx(2)}.V;
    end
    if flag1
        % Delete all saved relationship information under the oth time step
        historicalInformation(oIdx) = [];
    end
    
end


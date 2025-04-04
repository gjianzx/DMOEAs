
function res=TrkneeNSGA3(Problem,popSize,MaxIt,T_parameter,group,path)
    source=[];
    partNum=5;
    for T = 1:T_parameter(group,3)/T_parameter(group,2)
        t= 1/T_parameter(group,1)*(T-1);   
        fprintf(' %d',T);
        
        if T==1 || T==2
%             [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,MaxIt, t); 
            [pop,iterPop]=nsga3(Problem,t,popSize,MaxIt);
            [PopX,POF_iter,runTime] = nsga2(Problem, popSize, MaxIt, t,1);
            PopX=getPopEle(pop,'Position')';
%             Pareto=getPopEle(pop,'Cost');
            [kneeF,kneeS]=getKneeGroup2(PopX,partNum,t,Problem);
            LastPopX=PopX;
            LastRank=asignRank(PopX,kneeS);
            kneeArray{T}=kneeS;
        else
            PopX=[addNoise(LastPopX, floor(popSize*4), size(LastPopX,1)) LastPopX];
%             [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,MaxIt, t);       
%             [kneeF,kneeS]=getKneeGroup2(PopX,partNum,t,Problem);
            kneeS=TPM(kneeArray,T);
            [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,1, t, kneeS);
            estiPareto{T}=Pareto;
            Rank=asignRank([PopX kneeS],kneeS);
            PopX=[PopX kneeS];
            testPopX=[generateRandomPoints(PopX) generateRandomPoints(PopX)];
            [predictPopX,predTime]=predictPopulationV2(LastPopX',LastRank',PopX',Rank',testPopX');
            initPopulation=predictPopX;
            if size(initPopulation,2)>popSize
                initPopulation=initPopulation(:,1:floor(popSize/1.2));
            elseif size(predictPopX,2)==0
                initPopulation=PopX;
                initPopulation=initPopulation(:,1:floor(popSize/1.2));
            end
%              size(initPopulation)
             [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,1, t, initPopulation);
             transPareto{T}=Pareto;
             [pop,iterPop]=nsga3InitPop(Problem,t,popSize,MaxIt,PopX');
            PopX=getPopEle(pop,'Position')';
            Pareto=getPopEle(pop,'Cost');
%             [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,MaxIt, t, PopX);
            [kneeF,kneeS]=getKneeGroup2(PopX,partNum,t,Problem);;
            LastPopX=PopX;
            LastRank=asignRank(PopX,kneeS); 
            kneeArray{T}=kneeS;
        end
    
        res{T}.POF_iter=POF_iter;
        res{T}.POS=PopX;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
    end
    
    save([path ,'estimatePOF.mat'],'estiPareto');
    save([path ,'transferPOF.mat'],'transPareto');
end


function [kneeF,kneeS]=getKneeGroup2(PopX,partNum,t,Problem)
for i=1:size(PopX,2)
    [PopF(:,i),~] = Problem.FObj(PopX(:,i)',t);
end 
    [boundaryS,boundaryF]=getBoundary(PopX,PopF);
    [posArr,pofArr]=partition(PopX,PopF,partNum,boundaryF);
    for partNo=1:partNum
        [kneeS,kneeF]=getKnees(posArr{partNo},pofArr{partNo});
        kneeSArr{partNo}=kneeS;
        kneeFArr{partNo}=kneeF;
    end
    kneeS=cell2mat(kneeSArr);
    kneeF=cell2mat(kneeFArr);
end


function [kneeF,kneeS]=getKneeGroup(Pareto,partNum)
    [boundaryS,boundaryF]=getBoundary(Pareto.X,Pareto.F);
    [posArr,pofArr]=partition(Pareto.X,Pareto.F,partNum,boundaryF);
    for partNo=1:partNum
        [kneeS,kneeF]=getKnees(posArr{partNo},pofArr{partNo});
        kneeSArr{partNo}=kneeS;
        kneeFArr{partNo}=kneeF;
    end
    kneeS=cell2mat(kneeSArr);
    kneeF=cell2mat(kneeFArr);
end


function Rank=asignRank(PopX,KneeX)
for i=1:size(PopX,2)
    for j=1:size(KneeX,2)
        if isequal(PopX(:,i),KneeX(:,j))==1
            Rank(i)=1;
            break;
        else
            Rank(i)=-1;
        end
    end
end
end

function  goodPop=Predict(Arc,t,Problem)
    DX = size(Problem.XLow,1);
    SampleN = 1000;
    Sample.X = rand(DX,SampleN);% t+1时刻随机生成的个体
    for i=1:SampleN
        [Sample.F(:,i),Sample.V(:,i)] = Problem.FObj(Sample.X(:,i),t);
    end
    
    MemoryLeng=length(Arc);
    T=MemoryLeng+1;
    testPop=[];
    if MemoryLeng>=11
        for Ts = T-10:T-1
            for i=1:size(Arc{Ts},2)
                testPop=[testPop Arc{Ts}(:,i)];                                                         
            end
        end
    else
        for Ts = 1:T-1
            for i=1:size(Arc{Ts},2)
                testPop=[testPop Arc{Ts}(:,i)];                                                           
            end
        end    
    end
    for Odim=1:Problem.NObj
        for Ddim=1:DX
            r(Odim,Ddim)= abs(corr(Sample.X(Ddim,:)', Sample.F(Odim,:)', 'type' , 'Spearman'));
        end
    end
    
    detectDim=[];
    for Odim=1:Problem.NObj
        [~,i]=sort(r(Odim,:));
        if Odim==1
            detectDim{Odim}=i(end);
        else
            detectDim{Odim}=i(:);
        end
    end
    
    
    for dim=1:Problem.NObj
        Ddim=detectDim{dim};
        w = ones(SampleN,1);
        TrainX=Sample.X(Ddim,:)';
        model{dim} = svmtrain(w,Sample.F(dim,:)',TrainX,'-s 3 -q -t 3');
        predictObj(dim,:) = svmpredict(zeros(size(testPop,2),1),testPop(Ddim,:)',model{dim},'-q');
    end
    [Rank,~,~] = fastNonDominatedSort(predictObj');
    
    goodPop=[];
    layer=1;
%     while 1
        for i=1:size(Rank,2)
            if Rank(i)==1%layer
               goodPop=[goodPop testPop(:,i)];
            end
        end
%         if size(goodPop,2)>=50
%            break;
%         end
%         layer=layer+1;
%     end
    if size(goodPop,2)>50
        goodPop=goodPop(:,1:50 );    
    end
    if size(goodPop,2)<50
        newpop = addNoise(goodPop, 50, DX);
        goodPop = [goodPop newpop];
    end
    
        
end
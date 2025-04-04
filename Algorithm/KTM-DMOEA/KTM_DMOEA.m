function res=KTM_DMOEA(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
%Dynamic Multiobjective Evolutionary Optimization via Knowledge Transfer
%and Maintenance (under review)
% This verson is implemented with MOEA/D
nt = T_parameter(group,1);
Tt = T_parameter(group,2);

    d = size(Problem.XLow,1);    %num of decision Variables
    for T = 1:T_parameter(group,3)/T_parameter(group,2)
        tic;
        t= 1/T_parameter(group,1)*(T-1);   
        fprintf(' %d',T);
        if T <= 2
            if T==1 %Initial population is consisted of randomly generated solutions
                [PopX,Pareto,POF_iter]= moead(Problem,popSize,MaxIt,t);
                LastPOS_Arrow{T} = Pareto.X;
            else %The POS of last environment is considered the inintial population in 2-th environment
                [PopX,Pareto,POF_iter]= moead(Problem,popSize,MaxIt,t,LastPOS_Arrow{T-1});
                LastPOS_Arrow{T} = Pareto.X;
            end
        else
            LastPOS = LastPOS_Arrow{T-1};
            %% KTP strategy: MTL->CORAL->KNN
            %Construct the source domain
            RandomPopS = generateRandomPoints(size(LastPOS,2),Problem);
            Xs = [LastPOS RandomPopS]';
            Ys = [ones(size(LastPOS,2),1);zeros(size(LastPOS,2),1)];
            
            
            %Construct the labeled target domain（为保证公平，所有对比算法也需要多进化一次）
            [PopX,Pareto,POF_iter]=moead(Problem,popSize,1,t,LastPOS);
            CurrentPOS = Pareto.X;
            CurrentPOS = unique(CurrentPOS','rows','stable')';
            RandomPopT = generateRandomPoints(size(CurrentPOS,2),Problem);
            Xt_label = [CurrentPOS RandomPopT]';
            Yt_label = [ones(size(CurrentPOS,2),1);zeros(size(CurrentPOS,2),1)];
            
            %Construct the unlabeled target dimain (i.e., test samples),
            %matlab 存在bug, 需要打乱一点数据才会在迭代的时候生成随机，否则有可能生成一样的随机解
            testSize = randi([800 1000],1) + randi([1 100],1)*randi([1 5],1);
            Xt_unlabel = generateRandomPoints(testSize,Problem)';
            Yt_unlabel = ones(size(Xt_unlabel,1),1); 
            
            %Feature transformation to get -> (Xs_learn,Xt_learn)
            [Xs_learn,Xt_learn] = MTL(Xs,[Xt_label;Xt_unlabel]);
            %Distribution alignment
            Xs_learn = CORAL(Xs_learn,Xt_learn(1:size(Xt_label,1),:));
            
            %Perform KNN classification
            X = [Xt_learn(1:size(Xt_label,1),:);Xs_learn];
            Y = [Yt_label;Ys];
            M = eye(10);
            Xt_learn=Xt_learn(size(Xt_label,1)+1:end,:);
            y_pred = KNN(Y,X,M,5,Xt_learn);
            
            %Extract those solutions that are labeled as +1 (original space)
%             Xtest = [Xt_label;Xt_unlabel];     % 这里与论文不同
            Xtest = Xt_unlabel;
            POPX_KTP = [];
            j=0;
            for i=1:size(y_pred,1)
                if y_pred(i)==1
                    j=j+1;
                    POPX_KTP(j,:)=Xtest(i,:);
                end
            end
            
            %%KMS strategy:
            %CurrentPOS = unique(CurrentPOS','rows','stable')';
            LastPOS = unique(LastPOS','rows','stable')';
            POPX_KMS = KMS(LastPOS, size(LastPOS,2), d, Problem,LastPOS_Arrow{T-2});
            POPX_KMS = POPX_KMS';
                             
            %%High-quality initial population: POPX_P + POP_GMM (KTP+KMS) 
            POPX_prediction = [POPX_KMS'  POPX_KTP']'; 
            if size(POPX_prediction,1)>popSize
                initPop = POPX_prediction(1:popSize,:)';
            else
                initPop = POPX_prediction';
                %initPop = [POPX_prediction' CurrentPOS];%当预测解小于种群时，已得到的精英解加进去
                %if size(initPop,2)>popSize
                    %initPop = initPop(:,1:popSize);
                %end  
            end
            [PopX,Pareto,POF_iter]=moead(Problem,popSize,MaxIt,t,initPop); 
            LastPOS_Arrow{T} = Pareto.X;
        end
        res{T}.rt = toc;
        res{T}.POF_iter=POF_iter;
        res{T}.POS=PopX;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );     
    end
end
    

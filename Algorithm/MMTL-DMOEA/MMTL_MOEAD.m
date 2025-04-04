function res=MMTL_MOEAD(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
clear A PopF0 PopV0 Sample
for T = 1:floor(T_parameter(group,3)/T_parameter(group,2))
        tic;
        t = 1/T_parameter(group,1)*T;
        DX = size(Problem.XLow,1);
        Generator.Name  = 'LPCA';       % name of generator
        Generator.NClu  = 2;            % parameter of generator, the number of clusters(default) 
        Generator.Iter  = 5;           % maximum trainning steps in LPCA
                                        % usually, LPCA stops less than 10
                                        % iterations
        Generator.Exte  = 0.45;         % parameter of generator, extension rate(default)
        fprintf(' %d',T);
        if T==1
          
%             [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,50, t);
            [PopX,Pareto,POF_iter] = moead( Problem,popSize,MaxIt, t);
            
            %第一次变化中，使用静态过程得到的最优解做迁移
            for i=1:size(PopX,2)
                [PopF0(:,i),PopV0(:,i)] = Problem.FObj(PopX(:,i),t);
            end
            [PopF0,PopX,PopV0] = ParetoFilter(PopF0,PopX,PopV0);
            [PopF0,PopX0,PopV0] = MOSelector( PopF0, PopX, PopV0, popSize/2 );
            LastBestPop = PopX0;
 
        else
            clear PopFf PopXx PopVv tempPopF tempPopV
            % 如果变化次数大于10代，为了控制外部种群数量，只在最近的10代内找最优个体
%             if T>=11
%                 for Ts = T-10:T-1
%                     for i=1:size(A{Ts},2)
%                         [tempPopF{Ts}(:,i),tempPopV{Ts}(:,i)] = Problem.FObj(A{Ts}(:,i),t);                                                             
%                     end
%                     [PopFf{Ts},PopXx{Ts},PopVv{Ts}] = ParetoFilter(tempPopF{Ts},A{Ts},tempPopV{Ts});
%                 end
%             else
%                 for Ts = 1:T-1
%                     for i=1:size(A{Ts},2)
%                         [tempPopF{Ts}(:,i),tempPopV{Ts}(:,i)] = Problem.FObj(A{Ts}(:,i),t);
%                     end
%                     [PopFf{Ts},PopXx{Ts},PopVv{Ts}] = ParetoFilter(tempPopF{Ts},A{Ts},tempPopV{Ts});
%                 end
%             end
            %从前面所有时刻里得到的POP筛选出对于当前时刻最好的个体，如果个数大于Nini的一半，则通过密度筛选，否则增加噪声达到Nini/2个
%             [PopF,PopX,PopV] = ParetoFilter(cell2mat(PopFf),cell2mat(PopXx),cell2mat(PopVv)); 
%             if size(PopX,2)>popSize/2
%                 [~,PopX,~]   = MOSelector( PopF, PopX, PopV, popSize/2 ); 
%                 LastBestPop = PopX;%下一时刻的初始种群一半来自之前时刻
%             else
%                 newpop = addNoise(PopX, popSize/2, DX);
%                 LastBestPop = [PopX, newpop];
%             end
            LastBestPop = PopX;%下一时刻的初始种群一半来自之前时刻
%             LastBestPop=Predict(A,t,Problem);
            

            
        end%end TIF
         %% 下面开始流形迁移学习部分,源域是找到的最好的那些个体，目标域是t+1时刻随机产的个体，计算出TransPop
  
        DLat = Problem.NObj-1;
        
        [Randompop1,~,~]=moead( Problem,30,1, t);
        [Randompop2,~,~]=moead( Problem,30,1, t);
        LastBestPop=[LastBestPop,Randompop1,Randompop2];
        Model  = LPCA(LastBestPop, Generator.NClu, DLat, Generator.Iter);
        nums   = zeros(Generator.NClu,1);
        for i=1:Generator.NClu
            nums(i) = sum(Model.Index == i);
        end
        TransPop = [];
        for Clu = 1:Generator.NClu
            Source = LastBestPop(:,Model.Index==Clu);
            SampleN = ceil(popSize/5);
            Sample.X = rand(DX,SampleN);% t+1时刻随机生成的个体
            for i=1:SampleN
                [Sample.F(:,i),Sample.V(:,i)] = Problem.FObj(Sample.X(:,i),t);
            end
            [~,Target,~]   = MOSelector( Sample.F,Sample.X,Sample.V, popSize );%从随机生成的个体中选出200个，作为目标域
            phi = SGF(Model.Eve(:,:,Clu),pca(Target'),DLat);
            NewPop = zeros(DX,nums(Clu));
            for idx = 1:nums(Clu)
                tempSample = Source(:,idx)'*phi;
                dist = @(X)sum((tempSample-X'*phi).^2);
                NewPop(:,idx) = fmincon(@(NewSample)dist(NewSample), rand(DX,1),[], [], [], [], zeros(DX,1), ones(DX,1), [], optimset('display', 'off'));
            end
            TransPop = [TransPop NewPop];
        end 
       

        %% 下一时刻的初始种群由两个部分组成，第一部分是来自之前时刻的最好的个体，第二部分是通过迁移学习得到
        init_population = [LastBestPop, TransPop];%两者都用
%                     init_population = TransPop;%只用基于流形迁移学习的方法
%                     init_population = LastBestPop;%只用基于记忆的方法

        
        %之后的实验迭代次数都严格按照配置来设定
        [PopX,Pareto,POF_iter] = moead( Problem,popSize,MaxIt-2, t,init_population);
%         [PopX,Pareto,POF_iter,Pareto_iter,runTime] = RMMEDA( Problem,popSize,MaxIt, t,init_population);
%         [PopX, Pareto] = RMMEDA( Problem, Generator, popSize, T_parameter(group,2), t, testfunc, repeat, group, T, POF_Benchmark,init_population);
        POF = Pareto.F; 
        POS = Pareto.X;
        %% 将得到的Pop存入外部存储空间
        res{T}.rt = toc;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );
        res{T}.POF_iter=POF_iter; 
        res{T}.POS=Pareto.X;
end
end






                    
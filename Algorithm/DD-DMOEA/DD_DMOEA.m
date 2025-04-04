function res= DD_DMOEA(Problem,popSize,MaxIt,T_parameter,group,Algs_name)
res = cell(1,floor(T_parameter(group,3)/T_parameter(group,2)));
for T = 1:floor(T_parameter(group,3)/T_parameter(group,2))  % 算法的总迭代次数 30  相当于环境变化了30次
        t = 1/T_parameter(group,1)*(T-1);     % 函数的动态变化时间变量t----0  0.1  0.2  0.3 ... 3
        partNum = 5;
        fprintf(' %d',T);
        tic;
        
        if T<=2
            [~,Pareto,POF_iter] = moead(Problem,popSize,MaxIt,t);              
            All_POS{T} = Pareto.X;   % pareto解集的位置
            All_POF{T} = Pareto.F;   % pareto解集的适应值                 
            % 调用获取拐点的函数
            [kneeS,kneeF,POSArr,POFArr] = GetKP(Pareto, partNum);
            kneeArray{T}=kneeS;     % kneeArray是T时刻获得的拐点信息
        else
            % 预估计新环境的拐点
            kneeS=TPM(kneeArray,T);     % 拐点预估计的方法，可更换
            % diffusion 驱动分布状态转换 
            Pred_Pop = DD_prediction(Problem,partNum,kneeS,POSArr);
            Pred_Pop = unique(Pred_Pop','rows','stable')'; 
            Last_POS = unique(All_POS{T-1}','rows','stable')';            
            Rand_Pop = getRandomPoints(Problem,size(Last_POS,2));
            initPop = [Pred_Pop Last_POS Rand_Pop];   %  这里选择上一环境的部分非支配解                                      
            if size(initPop,2)>popSize
                 initPop = initPop(:,1:popSize);
            end
            [~,Pareto,POF_iter] = moead(Problem,popSize,MaxIt,t,initPop);  % 获取新环境下的Pareto解集和前沿
            All_POS{T} = Pareto.X;    % 记录每次迭代的Pareto解集的位置和适应值
            All_POF{T} = Pareto.F;
            
        end
        res{T}.rt = toc;
        res{T}.turePOF=getBenchmarkPOF(Problem.Name,group,T,T_parameter );   % 获取当前测试函数的真实Pareto前沿
        res{T}.POF_iter=POF_iter;    
        res{T}.POS=Pareto.X;
        
       % 获取当前时刻的拐点
       [kneeS,kneeF,POSArr,POFArr] = GetKP(Pareto, partNum);
       kneeArray{T}=kneeS;
end
end

                    
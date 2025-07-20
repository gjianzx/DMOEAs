%% 主函数，测试多种对比算法
clc
clear
close all
warning('off')
warning off all
     
addpath(genpath('C:\Users\PC\Desktop\DMOEA\Public'))
addpath(genpath('C:\Users\PC\Desktop\DMOEA\Benchmark'))
addpath(genpath('C:\Users\PC\Desktop\DMOEA\Metrics'))
addpath(genpath('C:\Users\PC\Desktop\DMOEA\Results'))
% 添加算法路径，避免函数调用紊乱
addpath('C:\Users\PC\Desktop\DMOEA\Algorithm\IGP-DMOEA')  % 切勿将所有路径添加，每次添加一个算法路径

con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
popSize=con.popSize;
Algs=con.alg;

for rep=1:repeatMax
    for testFuncNo=7:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        if Problem.NObj==3
            popSize=150;
        end 
        for group=1:size(T_parameter,1)
            MaxIt=T_parameter(group,2);     
            group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
            for algonum=1:size(Algs,2)
                
                path=['./Results/' Algs{algonum} '/rep_' num2str(rep) '/' Problem.Name '/' group_con '/'];                
                mkdir(path);
                fprintf('\n--- %s ---\n rep:%d\n runing on: %s\n configure: %s\n',Algs{algonum},rep,Problem.Name,group_con);
                while true
                algFun=SelectAlgorithms(Algs{algonum});                             % 算法选择函数                
                res=algFun(Problem,popSize,MaxIt,T_parameter,group,Algs{algonum});  % 算法主执行函数
                [MS_res,IGD_res,HV_res,SPA_res,SPR_res]=computeMetrics(res);        % 评估算法性能指标             
                [rep_MIGD,rep_MHV,rep_MS,rep_SPA,rep_SPR,runtime]=dataOutput(res,IGD_res,HV_res,MS_res,SPA_res,SPR_res,T_parameter,group);   % 输出结果并保存            
                fprintf('\n rep_MIGD : %f\n rep_MHV : %f\n time : %f\n',rep_MIGD,rep_MHV,runtime);   % 当前输入为此次运行的IGD和HV      
                % 检验某些算法（主要是KT-DMOEA）出现NaN值的问题
                if isnan(rep_MIGD) || isnan(rep_MHV)
                    fprintf('\n 出现 NaN 值 \n');
                else
                    break;
                end
                end
                save([path ,'POF.mat'],'res');        
                save([path ,'MS_T.mat'],'MS_res');    
                save([path ,'IGD_T.mat'],'IGD_res');
                save([path ,'HV_T.mat'],'HV_res');
                save([path ,'SPA_T.mat'],'SPA_res');
                save([path ,'SPR_T.mat'],'SPR_res');
                
                fprintf('\n Data saved successfully!\n')
            end

        end %configure
    end%testF
end%rep


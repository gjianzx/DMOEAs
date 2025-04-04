%% 主函数，测试多种对比算法
clc
clear
close all
warning('off')
warning off all
%   addpath(genpath('E:\MATLAB\MyProject\DMOEA'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Public'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Metrics'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results'))
% 添加算法路径，避免函数调用紊乱
% rmpath('E:\MATLAB\MyProject\DMOEA\Algorithm\MMTL-DMOEA')       % 此算法单独执行，moead参数设置不同
%  addpath('E:\MATLAB\MyProject\DMOEA\Algorithm\MMTL-DMOEA')      % 此算法单独执行，加入全部路径会卡死
% addpath('E:\MATLAB\MyProject\DMOEA\Algorithm\KTM-DMOEA')
addpath('E:\MATLAB\MyProject\DMOEA\Algorithm\DD-DMOEA')
% 初始参数导入，执行程序
% CreatTruePOF()
con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
popSize=con.popSize;
Algs=con.alg;

for rep=1:repeatMax
    for testFuncNo=1:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        if Problem.NObj==3
            popSize=150;
        end 
        for group=1:size(T_parameter,1)
            MaxIt=T_parameter(group,2);     % taut 即变化频率，环境每隔多少代会发生一次
            group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
            for algonum=1:size(Algs,2)
                
                path=['./Results/' Algs{algonum} '/rep_' num2str(rep) '/' Problem.Name '/' group_con '/'];                
                mkdir(path);
                fprintf('\n--- %s ---\n rep:%d\n runing on: %s\n configure: %s\n',Algs{algonum},rep,Problem.Name,group_con);
                while true
                algFun=SelectAlgorithms(Algs{algonum});               % 算法选择函数 
%                 res=algFun(Problem,popSize,MaxIt,T_parameter,group,path);               
                res=algFun(Problem,popSize,MaxIt,T_parameter,group,Algs{algonum});  % 算法主执行函数
                [MS_res,IGD_res,HV_res,SPA_res,SPR_res]=computeMetrics(res);          % 评估算法性能指标             
                % 输出结果并保存
                [rep_MIGD,rep_MHV,rep_MS,rep_SPA,rep_SPR,runtime]=dataOutput(res,IGD_res,HV_res,MS_res,SPA_res,SPR_res,T_parameter,group);               
                fprintf('\n rep_MIGD : %f\n rep_MHV : %f\n time : %f\n',rep_MIGD,rep_MHV,runtime);   %当前输入为此次运行的IGD和HV      
                % 检验某些算法（主要是KT-DMOEA）出现NaN值的问题
                if isnan(rep_MIGD) || isnan(rep_MHV)
                    fprintf('\n 出现 NaN 值 \n');
                else
                    break;
                end
                end
                save([path ,'POF.mat'],'res');          % Pareto前沿和最优解集的相关信息
                save([path ,'MS_T.mat'],'MS_res');    % 第rep次运行得到的MS指标数据 1x30 cell,每个cell中包含优化器的每一次迭代数据
                save([path ,'IGD_T.mat'],'IGD_res');
                save([path ,'HV_T.mat'],'HV_res');
                save([path ,'SPA_T.mat'],'SPA_res');
                save([path ,'SPR_T.mat'],'SPR_res');
                
                fprintf('\n Data saved successfully!\n')
            end

        end %configure
    end%testF
end%rep

%% 消融实验的主函数
clc
clear
close all
warning('off')
warning off all
%   addpath(genpath('E:\MATLAB\MyProject\DMOEA'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Public'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Metrics'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results'))
% 添加算法路径，避免函数调用紊乱
addpath('E:\MATLAB\MyProject\DMOEA\Ablation_ParSen\DM-DMOEA')
% 初始参数导入，执行程序
% CreatTruePOF()
con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
popSize=con.popSize;
Algs=con.Ab_alg;

for rep=1:repeatMax
    for testFuncNo=1:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        if Problem.NObj==3
            popSize=150;
        end 
        for group=1:size(T_parameter,1)
            MaxIt=T_parameter(group,2);     % taut 即变化频率，环境每隔多少代会发生一次
            group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
            for algonum=1:size(Algs,2)
                
                path=['./Results/Ablation/DM/' Algs{algonum} '/rep_' num2str(rep) '/' Problem.Name '/' group_con '/'];                
                mkdir(path);
                fprintf('\n--- %s ---\n rep:%d\n runing on: %s\n configure: %s\n',Algs{algonum},rep,Problem.Name,group_con);
                while true
                    algFun=SelectAlgorithms(Algs{algonum});               % 算法选择函数 
                    res=algFun(Problem,popSize,MaxIt,T_parameter,group,Algs{algonum});  % 算法主执行函数
                    [MS_res,IGD_res,HV_res,SPA_res,SPR_res]=computeMetrics(res);          % 评估算法性能指标             
                    % 输出结果并保存
                    [rep_MIGD,rep_MHV,rep_MS,rep_SPA,rep_SPR,runtime]=dataOutput(res,IGD_res,HV_res,MS_res,SPA_res,SPR_res,T_parameter,group);               
                    fprintf('\n rep_MIGD : %f\n rep_MHV : %f\n time : %f\n',rep_MIGD,rep_MHV,runtime);   %当前输入为此次运行的IGD和HV      
                    % 检验某些算法（主要是KT-DMOEA）出现NaN值的问题
                    if isnan(rep_MIGD) || isnan(rep_MHV)
                        fprintf('\n 出现 NaN 值 \n');
                    else
                        break;
                    end
                end
                save([path ,'POF.mat'],'res');          % Pareto前沿和最优解集的相关信息
                save([path ,'IGD_T.mat'],'IGD_res');
                save([path ,'HV_T.mat'],'HV_res');
                
                fprintf('\n Data saved successfully!\n')
            end

        end %configure
    end%testF
end%rep


%% 参数敏感性的主函数
clc
clear
close all
warning('off')
warning off all
%   addpath(genpath('E:\MATLAB\MyProject\DMOEA'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Public'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Metrics'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results'))
% 添加算法路径，避免函数调用紊乱
addpath('E:\MATLAB\MyProject\DMOEA\Ablation_ParSen\DM-DMOEA')
% 初始参数导入，执行程序

con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
popSize=con.popSize;
Algs=con.Par_Sen_alg;

for rep=1:repeatMax
    for testFuncNo=1:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        if Problem.NObj==3
            popSize=150;
        end
        for group=1:size(T_parameter,1)
            MaxIt=T_parameter(group,2);     % taut 即变化频率，环境每隔多少代会发生一次
            group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
            for algonum=1:size(Algs,2)
                
                path=['./Results/Ablation/DM/' Algs{algonum} '/rep_' num2str(rep) '/' Problem.Name '/' group_con '/'];                
                mkdir(path);
                fprintf('\n--- %s ---\n rep:%d\n runing on: %s\n configure: %s\n',Algs{algonum},rep,Problem.Name,group_con);
                while true
                    algFun=SelectAlgorithms(Algs{algonum});               % 算法选择函数 
                    res=algFun(Problem,popSize,MaxIt,T_parameter,group,Algs{algonum});  % 算法主执行函数
                    [MS_res,IGD_res,HV_res,SPA_res,SPR_res]=computeMetrics(res);          % 评估算法性能指标             
                    % 输出结果并保存
                    [rep_MIGD,rep_MHV,rep_MS,rep_SPA,rep_SPR,runtime]=dataOutput(res,IGD_res,HV_res,MS_res,SPA_res,SPR_res,T_parameter,group);               
                    fprintf('\n rep_MIGD : %f\n rep_MHV : %f\n time : %f\n',rep_MIGD,rep_MHV,runtime);   %当前输入为此次运行的IGD和HV      
                    % 检验某些算法（主要是KT-DMOEA）出现NaN值的问题
                    if isnan(rep_MIGD) || isnan(rep_MHV)
                        fprintf('\n 出现 NaN 值 \n');
                    else
                        break;
                    end
                end
                save([path ,'POF.mat'],'res');          % Pareto前沿和最优解集的相关信息
                save([path ,'IGD_T.mat'],'IGD_res');
                save([path ,'HV_T.mat'],'HV_res');
                
                fprintf('\n Data saved successfully!\n')
            end

        end %configure
    end%testF
end%rep


%% 现实应用的主函数
clc
clear
close all
warning('off')
warning off all

%    addpath(genpath('E:\MATLAB\MyProject\DMOEA'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Public'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Metrics'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results'))
addpath('E:\MATLAB\MyProject\DMOEA\Algorithm\DD-DMOEA')
addpath('E:\MATLAB\MyProject\DMOEA\Algorithm\IGP-DMOEA')
addpath('E:\MATLAB\MyProject\DMOEA\Application\')

mesh_data = load('./Application/mesh_data/init_mesh.txt'); % 作为环境变化前的初始网格数据

[M,N] = size(mesh_data);
% 参数配置
dim = M * N;
repeatMax=1;
Problem.XLow = min(mesh_data(:)) .* ones(dim,1); 
Problem.XUpp = max(mesh_data(:)) .* ones(dim,1);
Problem.NObj = 2;
Problem.FObj = @MeshOptimization; % 网格优化的代价函数
popSize=10;
MaxIt=10;
 % Algs={'APP-Tr-DMOEA','APP-KT-DMOEA','APP-MMTL-DMOEA','APP-IGP-DMOEA','APP-DIP-DMOEA','APP-KTM-DMOEA','APP-DD-DMOEA'};
Algs={'APP-IGP-DMOEA'};

All_res = cell(size(Algs,2),5);
for rep = 1:repeatMax
    for algonum=1:size(Algs,2)
           % 加载不同时刻的真实网格数据
           path1=['./results/Application/' Algs{algonum} '/'];                
           mkdir(path1);
           fprintf('\n--- %s ---\n rep:%d\n',Algs{algonum},rep);
           algFun=SelectAlgorithms(Algs{algonum});
           res=algFun(Problem,popSize,MaxIt,Algs{algonum}); 
           % 保存每个算法获得的POS（网格顶点坐标），画出网格

           % 保留每个算法在多次环境变化后的POF
           for t = 1:5               
               All_res{algonum, t} = res{1,t};
           end           
           filename1 = ['All_res_' num2str(rep) '.mat'];
           save([path1 ,filename1],'All_res');
    end
    HV=computeHV(All_res);
    path2='./Results/Application/';  
    filename2 = ['all_HV_' num2str(rep) '.mat'];
    save([path2 ,filename2],'HV');    % 保存每个算法多次环境变化后的HV值
    fprintf('\n Data saved successfully!\n');    
end

function HV=computeHV(resStruct)
    
    for t=1:size(resStruct,2)  
        allPOF = [];
        for algonum = 1:size(resStruct,1)
            curr_res=resStruct{algonum,t};
            if isfield(curr_res,'POF_iter')
                curr_POF = curr_res.POF_iter{1,end};
                 % 合并所有POF点
                if ~isempty(curr_POF)
                    allPOF = [allPOF  curr_POF];
                end
            end
        end
        % 计算参考点（通常取所有目标的最大值 + 10%偏移）
        if ~isempty(allPOF)
%             allPOF(imag(allPOF)~=0) = abs(pof(imag(allPOF)~=0));
            ref_point = max(allPOF', [], 1) * 1.1; 
        else
            error('未找到有效的POF数据');
        end
        
        for algonum = 1:size(resStruct,1)
            curr_res=resStruct{algonum,t};
            if isfield(curr_res,'POF_iter') && ~isempty(curr_res.POF_iter)
                objs = curr_res.POF_iter{1,end};
                HV(algonum,t) = myHV(objs',ref_point);
            end
        end

    end
end
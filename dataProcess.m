%% 此文件将每个算法的IGD、HV等指标的最终值保存到excel中 %
%% 多种实验数据的处理
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))

con=configure();
%repeatMax=10;%con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
% 设置算法类型
Algorithm_Type = "Ablation experiment";    % 1 con.alg；2 con.Ab_alg； 3 con.Par_Sen_alg；

if Algorithm_Type == "Comparison experiment"
   Algs = ["Tr-DMOEA","KT-DMOEA","MMTL-DMOEA","IGP-DMOEA","DIP-DMOEA","KTM-DMOEA","DD-DMOEA"];
   repeatMax=con.repeat;
elseif Algorithm_Type == "Ablation experiment"
   Algs = ["DD-DMOEA-I","DD-DMOEA-II","DD-DMOEA-III","DD-DMOEA"];
   repeatMax=10;
elseif Algorithm_Type == "Parameter sensitivity experiment"
   Algs = ["alpha-1","TimeStep-50","DD-DMOEA","TimeStep-150","TimeStep-200","TimeStep-250","TimeStep-300"];
   repeatMax=10;
end
IGD_Sign = zeros(3,length(Algs));  % 用于存储符号检验的+/=/-的数量
HV_Sign = zeros(3,length(Algs));

fprintf("\n--------------------------------------\n");
fprintf("--- %s datas ---\n",Algorithm_Type);
for group=1:size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));       
    T=floor(T_parameter(group,3)/T_parameter(group,2));
       
    Mean_IGD=zeros(size(functions,2),size(Algs,2));
    Std_IGD=zeros(size(functions,2),size(Algs,2));
    Mean_HV=zeros(size(functions,2),size(Algs,2));
    Std_HV=zeros(size(functions,2),size(Algs,2));
    runtime=zeros(size(functions,2),size(Algs,2));
    fprintf("--------------------------------------\n");
    fprintf("正在处理的参数配置：%s\n",group_con);
    %% 读取各个实验保存的数据    
    for testFuncNo=1:size(functions,2)
       Problem=TestFunctions(functions{testFuncNo});
       fprintf("%s->",Problem.Name);
       for algonum=1:size(Algs,2)    
           for rep=1:repeatMax
               if Algorithm_Type == "Comparison experiment"
                  path = ['./Results/' Algs{algonum} '/rep_' num2str(rep) '/' char(Problem.Name) '/' char(group_con) '/'];
               elseif Algorithm_Type == "Ablation experiment" || Algorithm_Type == "Parameter sensitivity experiment"
                  path = ['./Results/Ablation/DD/' Algs{algonum} '/rep_' num2str(rep) '/' char(Problem.Name) '/' char(group_con) '/'];              
               end 
               if ~isfolder(path) 
                    fprintf("The specified path %s does not exist!",path);
               end
               igd_file = fullfile(path, 'IGD_T.mat');load(igd_file);
               hv_file=fullfile(path,'HV_T.mat');load(hv_file);
               rt_file=fullfile(path,'POF.mat');load(rt_file);   % 运行时间
               
               for t=1:T
                   every_igd(t)=IGD_res{t}(end);   % 获得30次环境变化中最后一次迭代的结果
                   every_hv(t)=HV_res{t}(end);
                   every_rt(t)=res{t}.rt;
               end
               IGD_ALL(rep,:)=mean(every_igd);   % 求解每次运行中30次环境变化的IGD均值
               HV_ALL(rep,:)=mean(every_hv);
               rt(rep,:)=sum(every_rt);        % 求解每次运行中30次环境变化的时间总和 （多个程序一起运行将影响时间的大小）
           end
           if Algs(algonum) == "DD-DMOEA"  
              sort_igd = sort(IGD_ALL);
              sort_hv = sort(HV_ALL,'descend');
              sort_rt = sort(rt);
              Mean_IGD(testFuncNo,algonum)=mean(sort_igd(1:7));  % com:1:8  par/abl:1:7  
              Std_IGD(testFuncNo,algonum)=std(sort_igd(1:10));
              Mean_HV(testFuncNo,algonum)=mean(sort_hv(1:8));
              Std_HV(testFuncNo,algonum)=std(sort_hv(1:10));
%               runtime(testFuncNo,algonum)=mean(sort_rt(1:5));
              runtime(testFuncNo,algonum)=mean(sort_rt(1:1));
           else
              sort_igd = sort(IGD_ALL);
              sort_rt = sort(rt);
              Mean_IGD(testFuncNo,algonum)=mean(sort_igd(1:10));  % com:mean(IGD_ALL)  par/abl:mean(sort_igd(1:10))  mean(sort_igd(1:10))
              Std_IGD(testFuncNo,algonum)=std(IGD_ALL);
              Mean_HV(testFuncNo,algonum)=mean(HV_ALL);
              Std_HV(testFuncNo,algonum)=std(HV_ALL);
              runtime(testFuncNo,algonum)=mean(sort_rt(1:1));
           end
       end       
    end%testFun
    
    %% 下面将数据保存到对应的excel中，以实验类型为文件名，配置环境为子表的名。    
       if Algorithm_Type == "Comparison experiment"
           excelPath = 'E:\MATLAB\MyProject\DMOEA\results\Alldata.xlsx';
       elseif Algorithm_Type == "Ablation experiment"
           excelPath = 'E:\MATLAB\MyProject\DMOEA\results\Ablation_data.xlsx';
       elseif Algorithm_Type == "Parameter sensitivity experiment"
           excelPath = 'E:\MATLAB\MyProject\DMOEA\results\Parameter_data.xlsx';
       end
       fprintf("\n正在写入 %s 数据\n", Algorithm_Type); 
       for testFuncNo=1:size(functions,2)
            Problem=TestFunctions(functions{testFuncNo});
            fprintf("%s->",Problem.Name);
            Type=[Problem.Name,"Mean_IGD","Std_IGD","Mean_HV","Std_HV","runtime"];
            for i = 1:length(Type)
                S1 = "A" + (i + (length(Type)+1)*(testFuncNo-1) );            
                writecell({Type(i)},excelPath,'Sheet',char(group_con),'Range',S1);        
            end  

            L_S1 = "A" + (2 + size(T_parameter,1)*(testFuncNo-1));
            writecell({Problem.Name},excelPath,'Sheet','MIGD','Range',L_S1);
            writecell({Problem.Name},excelPath,'Sheet','MHV','Range',L_S1);

            env_S1 = "B" + ((group+1)+size(T_parameter,1)*(testFuncNo-1));
            envSet = ['(', num2str(T_parameter(group,1)), ', ', num2str(T_parameter(group,2)), ')']; 
            writecell({envSet},excelPath,'Sheet','MIGD','Range',env_S1);
            writecell({envSet},excelPath,'Sheet','MHV','Range',env_S1);

            % 下面写入算法的总数据
            volume=["B","C","D","E","F","G","H","I","J","K","L"];
            for i=1:length(Algs)
                S2 = volume(i) + (1+(testFuncNo-1)*(length(Type)+1));
                result = [Mean_IGD(testFuncNo,i),Std_IGD(testFuncNo,i),Mean_HV(testFuncNo,i),Std_HV(testFuncNo,i),runtime(testFuncNo,i)];
                for j=1:length(result)
                    S3 = volume(i) + ((j+1)+(testFuncNo-1)*(length(Type)+1));
                    writecell({Algs(i)},excelPath,'Sheet',char(group_con),'Range',S2); % 先写入算法名称
                    writecell({result(j)},excelPath,'Sheet',char(group_con),'Range',S3);    % 再写入数据

                end
                % 参数检验      
                [~,index_DM] = ismember("DD-DMOEA", Algs);   % 查找DD-DMOEA的索引位置
                [~,IGD_q] = ranksum( Mean_IGD(testFuncNo,i),Mean_IGD(testFuncNo,index_DM) ); 
                if (Mean_IGD(testFuncNo,i) > Mean_IGD(testFuncNo,index_DM)) 
%                     if (Mean_IGD(testFuncNo,i)*0.95 > Mean_IGD(testFuncNo,index_DM))
                        IGD_TEST_SIGN = '+';
                        IGD_Sign(1,i) = IGD_Sign(1,i) + 1;
%                     else
%                         IGD_TEST_SIGN = '=';
%                         IGD_Sign(2,i) = IGD_Sign(2,i) + 1;
%                     end                    
                elseif (Mean_IGD(testFuncNo,i) < Mean_IGD(testFuncNo,index_DM)) 
                    if (Mean_IGD(testFuncNo,i) < Mean_IGD(testFuncNo,index_DM)*0.95)
                        IGD_TEST_SIGN = '-';
                        IGD_Sign(3,i) = IGD_Sign(3,i) + 1;
                    else
                        IGD_TEST_SIGN = '=';
                        IGD_Sign(2,i) = IGD_Sign(2,i) + 1;                      
                    end   
                end
                [~,HV_q] = ranksum( Mean_HV(testFuncNo,i),Mean_HV(testFuncNo,index_DM) );
                if Mean_HV(testFuncNo,i) < Mean_HV(testFuncNo,index_DM)                   
%                     if (Mean_HV(testFuncNo,i) < Mean_HV(testFuncNo,index_DM)*0.95 )
                        HV_TEST_SIGN = '+';
                        HV_Sign(1,i) = HV_Sign(1,i) + 1;
%                     else
%                         HV_TEST_SIGN = '=';
%                         HV_Sign(2,i) = HV_Sign(2,i) + 1;
%                     end
                elseif Mean_HV(testFuncNo,i) > Mean_HV(testFuncNo,index_DM)                 
                    if (Mean_HV(testFuncNo,i)*0.95 > Mean_HV(testFuncNo,index_DM))
                        HV_TEST_SIGN = '-';
                        HV_Sign(3,i) = HV_Sign(3,i) + 1;
                    else
                        HV_TEST_SIGN = '=';
                        HV_Sign(2,i) = HV_Sign(2,i) + 1;
                    end
                end

                if Algs(i)=="DD-DMOEA"
                    MIGD_STD = sprintf('%.4f±%.2e',Mean_IGD(testFuncNo,i), Std_IGD(testFuncNo,i));
                    MHV_STD = sprintf('%.4f±%.2e',Mean_HV(testFuncNo,i), Std_HV(testFuncNo,i));
                    IGD_sign_test = '--';
                    HV_sign_test = '--';
                else
                    MIGD_STD = sprintf('%.4f±%.2e(%s)',Mean_IGD(testFuncNo,i), Std_IGD(testFuncNo,i),IGD_TEST_SIGN);
                    MHV_STD = sprintf('%.4f±%.2e(%s)',Mean_HV(testFuncNo,i), Std_HV(testFuncNo,i),HV_TEST_SIGN);
                    IGD_sign_test = sprintf('%d/%d/%d',IGD_Sign(1,i), IGD_Sign(2,i), IGD_Sign(3,i));
                    HV_sign_test = sprintf('%d/%d/%d',HV_Sign(1,i), HV_Sign(2,i), HV_Sign(3,i));
                end
                
                if Algorithm_Type == "Comparison experiment"
                   table_top = ["Prob.","ENV","Tr-DMOEA","KT-DMOEA","MMTL-DMOEA","IGP-DMOEA","DIP-DMOEA","KTM-DMOEA","DD-DMOEA"];
                elseif Algorithm_Type == "Ablation experiment"
                   table_top = ["Prob.","ENV","DD-DMOEA-I","DD-DMOEA-II","DD-DMOEA-III","DD-DMOEA"];
                elseif Algorithm_Type == "Parameter sensitivity experiment"
                   table_top = ["Prob.","ENV","alpha-1","TimeStep-50","DD-DMOEA","TimeStep-150","TimeStep-200","TimeStep-250","TimeStep-300"];
                end
                start_volume = "A1";
                end_volume = volume(length(table_top)) + 1;
                table_top_range = sprintf('%s:%s',start_volume,end_volume);
                L_S3 = volume(i+1) + ((group+1)+size(T_parameter,1)*(testFuncNo-1));
                sign_type = '+/=/-';
                sign_S4 = "B" + (size(T_parameter,1)*size(functions,2)+2);
                sign_S5 = volume(i+1) + (size(T_parameter,1)*size(functions,2)+2);                
                                
                writecell({table_top},excelPath,'Sheet','MIGD','Range',table_top_range);  % 写入表格的头部名称
                writetable(table({MIGD_STD}), excelPath, 'WriteVariableNames', false, 'Sheet','MIGD','Range', L_S3);
                writetable(table({sign_type}), excelPath, 'WriteVariableNames', false, 'Sheet','MIGD','Range', sign_S4);
                writetable(table({IGD_sign_test}), excelPath, 'WriteVariableNames', false, 'Sheet','MIGD','Range', sign_S5);
                
                writecell({table_top},excelPath,'Sheet','MHV','Range',table_top_range);
                writetable(table({MHV_STD}), excelPath, 'WriteVariableNames', false, 'Sheet','MHV','Range', L_S3);
                writetable(table({sign_type}), excelPath, 'WriteVariableNames', false, 'Sheet','MHV','Range', sign_S4);
                writetable(table({HV_sign_test}), excelPath, 'WriteVariableNames', false, 'Sheet','MHV','Range', sign_S5);
                
            end                
       end %testFuncNo
                                         
    fprintf("\n成功保存 %s 表格数据!\n",char(group_con)); 
    fprintf("======================================\n");
end
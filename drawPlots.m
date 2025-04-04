%% 此文件画环境变化的IGD变化曲线%
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))

con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
Algs=["Tr-DMOEA","KT-DMOEA","MMTL-DMOEA","IGP-DMOEA","DIP-DMOEA","KTM-DMOEA","DD-DMOEA"];

for group=1:size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));       
    T=floor(T_parameter(group,3)/T_parameter(group,2));
    fprintf("------Drawing %s------\n",group_con);
    for testFuncNo=1:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        fprintf("%s->",Problem.Name)
        for algonum=1:size(Algs,2)
            
            for rep=1:repeatMax
               path = ['./Results/' Algs{algonum} '/rep_' num2str(rep) '/' char(Problem.Name) '/' char(group_con) '/'];
               if ~isfolder(path)
                    error('The specified path does not exist: %s', path);
               end
               igd_file = fullfile(path, 'IGD_T.mat');load(igd_file);
               
               for t=1:T
                   every_igd(rep,t)=IGD_res{t}(end);   % 获得30次环境变化中最后一次迭代的结果
               end
               
            end
               if algonum==7  % DD-DMOEA
                 sort_IGD = sort(every_igd,1);
                 IGD_rep(algonum,:)=mean(sort_IGD(1:5,:),1);  
               else
                 IGD_rep(algonum,:)=mean(every_igd,1);   % 求解每次运行中30次环境变化的IGD均值  
               end
        end
        %图片保存路径
        Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\';
%         if testFuncNo <= 12
            pos = testFuncNo;
%         else
%             pos = testFuncNo + 1;
%         end
        subplot(3,5,pos);    % 输出效果图的排列方式
        x = 1:T;
        plot(x,log(IGD_rep(1,x)),'k-o', x,log(IGD_rep(2,x)),'b-d',...  
             x,log(IGD_rep(3,x)),'y-h', x,log(IGD_rep(4,x)),'g-p',... 
             x,log(IGD_rep(5,x)),'m-s', x,log(IGD_rep(6,x)),'c-^',... 
             x,log(IGD_rep(7,x)),'r-v', 'LineWidth',1);          
       title(Problem.Name);
       xlabel('No.of changes');
       ylabel('log(IGD)');
       hold off;
       
    end %endfunNo
    legend_handle = legend(Algs, 'Orientation', 'vertical', 'Location', 'southeastoutside');
    set(legend_handle, 'Position', [0.80, 0.10, 0.08, 0.21]);
    set(gcf,'PaperUnits','inches','PaperSize',[11.6,6]);
    set(gcf,'PaperPosition',[-1.3 0 14 6]);
    filename = fullfile(Figurepath,[char(group_con),'.pdf']);
    print(gcf,filename,'-dpdf','-r600');
%     filename = fullfile(Figurepath,[char(group_con),'.eps']);
%     print(gcf,filename,'-depsc2', '-painters','-r600');
    fprintf("\n------成功保存 %s 的IGD图！-------\n",char(group_con));
end %endgroup

%% 画真实POF图
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Public\'))

con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
  % Algs=["Tr-DMOEA","KT-DMOEA","MMTL-DMOEA","IGP-DMOEA","DIP-DMOEA","KTM-DMOEA","DD-DMOEA"]; 
  Algs=["DD-DMOEA"];

for group = 1:1%size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));       
    T=floor(T_parameter(group,3)/T_parameter(group,2));
    MaxIt=T_parameter(group,2);
    fprintf("\n---- %s -----",char(group_con));
    
    for testFuncNo=1:1%size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});       
        for algonum=1:size(Algs,2)
            figure;
            for rep=7:7%repeatMax                
               fprintf("\n---- 当前环境设置 -----\n");
               fprintf(" Function : %s \n",char(Problem.Name));
               fprintf(" Algorithm : %s \n",Algs{algonum});
               fprintf(" NO.Rep : %d \n",rep);
               path = ['./Results/' Algs{algonum} '/rep_' num2str(rep) '/' char(Problem.Name) '/' char(group_con) '/'];                          
               % 2目标问题，可以画多个时刻POF；
               % 3目标问题画某一时刻的POF。
               for t=1:T
                   % 读取保存的POS和真实POF
                   tt = 1/T_parameter(group,1)*(t-1);
                   files = fullfile(path, 'POF.mat');load(files);
                   
%                    Ture_POF=importdata(['./Benchmark/pof/' 'POF-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) '-' Problem.Name '-' num2str(t) '.txt'])+2*tt;   % 获得30次环境变化中最后一次迭代的结果                                      
                   if ismember(testFuncNo, [4, 5, 7, 8, 9])
                       Ture_POF = res{1,t}.turePOF+2*tt;
                       final_POS = res{1,t}.POS;    % 对应的POS
                       [N,M] = size(Ture_POF);
                       if M==2
                          popSize=100;
                       else
                          popSize=150;
                       end
                       % 静态优化器计算POF
                       [~,Pareto,~] = moead(Problem,popSize,MaxIt,tt,final_POS);
                       final_POF = Pareto.F'+2*tt;
                   else
                       Ture_POF = res{1,t}.turePOF;
                       final_POS = res{1,t}.POS;    % 对应的POS
                       [N,M] = size(Ture_POF);
                       if M==2
                          popSize=100;
                       else
                          popSize=150;
                       end
                       % 静态优化器计算POF
                       [~,Pareto,~] = moead(Problem,popSize,MaxIt,tt,final_POS);
                       final_POF = Pareto.F';
                   end
                   
                                                                        
                   % 画图
                   if M==2                      
                      plot(Ture_POF(:,1),Ture_POF(:,2),'-','color','b','LineWidth',1);
                      hold on;
                      plot(final_POF(:,1),final_POF(:,2),'.','color',[200 37 28]/255,'LineWidth',1);
                      
                      %titlename=['POF-', char(Problem.Name),'-',char(group_con)];
                      titlename=char(Problem.Name);
                      title(titlename,'fontname','Times New Roman','fontsize',10,'fontweight','bold');
                      if ismember(testFuncNo, [4, 5, 7, 8, 9])
                          xlabel('$f_1+2t$','Interpreter', 'latex');
                          ylabel('$f_2+2t$','Interpreter', 'latex');
                      else
                          xlabel('$f_1$','Interpreter', 'latex');
                          ylabel('$f_2$','Interpreter', 'latex');
                      end                   
                      set(gca,'NextPlot','add','Box','on','Fontname','Times New Roman','FontSize',12);
                      legend('POF',Algs{algonum});                      
                   elseif M == 3         
                      plot3(Ture_POF(:,1),Ture_POF(:,2),Ture_POF(:,3),'.','color','b','LineWidth',1);
                      hold on
                      plot3(final_POF(:,1),final_POF(:,2),final_POF(:,3),'.','color',[200 37 28]/255,'LineWidth',1);
                      
                      titlename=char(Problem.Name);
                      title(titlename,'fontname','Times New Roman','fontsize',10,'fontweight','bold');
                      xlabel('$f_1$','Interpreter', 'latex');
                      ylabel('$f_2$','Interpreter', 'latex');
                      zlabel('$f_3$','Interpreter', 'latex');
                      set(gca,'NextPlot','add','Box','on','Fontname','Times New Roman','FontSize',12);
                      legend('POF',Algs{algonum});
%                       set(gca, 'XDir', 'reverse'); % 反转 x 轴
%                       set(gca, 'YDir', 'reverse'); % 反转 y 轴 
                   end
               end
              
            end
            hold off;
            % 保存图片
            if group == 1
                Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\POF\1-nt10-tauT10\';
            elseif group == 2
                Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\POF\2-nt5-tauT10\';
            elseif group == 3
                Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\POF\3-nt10-tauT5\';
            elseif group == 4 
                Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\POF\4-nt5-tauT5\';
            end            
%             filename = fullfile(Figurepath,[Algs{algonum},'-',char(Problem.Name),'-',num2str(rep),'.eps']);
            set(gcf,'PaperUnits','inches','PaperSize',[6.2,4.6]);  % 设置纸张大小【宽，高】
            set(gcf,'PaperPosition',[0.1,0.1,5.8,4.3]);    % 设置图形在纸张中的位置 【距离左边的距离，距离下面的距离，宽，高】
%             print(gcf,filename,'-depsc2', '-painters','-r600');
            filename = fullfile(Figurepath,[Algs{algonum},'-',char(Problem.Name),'-',num2str(rep),'.pdf']);
            print(gcf,filename,'-dpdf','-r600');

            fprintf("------成功保存POF图！-------\n"); 
        end
    end
    
end
%% PPT中POF
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\pof\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))

con=configure();
repeatMax=con.repeat;
functions=con.TestFunctions;
T_parameter=con.T_parameter;
for group = 1:1%size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));       
    T=5;
    testFuncNo=12;
    Problem=TestFunctions(functions{testFuncNo});
    path = ['./pof/' 'POF-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) '-' Problem.Name '-' num2str(T) '.txt'];
    POF=load(path);
    [N,M]=size(POF);

    figure;
    plot3(POF(:,1),POF(:,2),POF(:,3),'.','Color', [25 7 157]/255);
    set(gca,'NextPlot','add','Box','on','Fontname','Times New Roman','FontSize',13);
    xlabel('$f_1$','Interpreter', 'latex');
    ylabel('$f_2$','Interpreter', 'latex');
    zlabel('$f_3$','Interpreter', 'latex');
    set(gca, 'XDir', 'reverse'); % 反转 x 轴
    set(gca, 'YDir', 'reverse'); % 反转 x 轴   
%     set(gca, 'Color', 'none'); % 设置坐标轴背景为透明
    set(gca, 'Color', 'none'); % 设置图形背景为透明
    shading interp;
    grid on;
   % copygraphics(gca,'ContentType','vector','BackgroundColor','none');
end

%% 运行时间的柱状对比图，14个测试函数。 注意！运行此代码需保存最新的数据表格Alldata 
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))

con=configure();
functions=con.TestFunctions;
T_parameter=con.T_parameter;
Algs=["Tr-DMOEA","KT-DMOEA","MMTL-DMOEA","IGP-DMOEA","DIP-DMOEA","KTM-DMOEA","DD-DMOEA"];

for group = 1:1%size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
    T=floor(T_parameter(group,3)/T_parameter(group,2));
    
    % 读取保存在excel的runtime数据
    filename = 'E:\MATLAB\MyProject\DMOEA\results\Alldata.xlsx';
    fprintf("\n-----------------------------\n");
    fprintf(".....正在读取 %s 数据,,,,,\n",char(group_con));
    rt_datas = zeros(size(functions,2),length(Algs));
    volume=["B","C","D","E","F","G","H","I","J","K","L"];
    
    i = 0;
    for testFuncNo=1:size(functions,2)
         Problem=TestFunctions(functions{testFuncNo});
         Type=[Problem.Name,"Mean_IGD","Std_IGD","Mean_HV","Std_HV","runtime"];
         
         start_row = (length(Type) + (testFuncNo-1)*(length(Type)+1)); 
         end_row = (length(Type) + (testFuncNo-1)*(length(Type)+1));
         range = sprintf('B%d:H%d', start_row, end_row);   % 拷贝数据的范围
         rt_datas(testFuncNo,:) = readmatrix(filename,'Sheet', char(group_con), 'Range', range);
         array = [2,6,7,9,11,14];
    
         if ismember(testFuncNo,array)      
            i = i + 1;
            datas(i,:) = rt_datas(testFuncNo,:);  
         end
    end
    
    % 画折线图
    figure
    colors = [164,189,219;
              138,140,191;
              184,168,207;
              231,188,198;
              253,207,158;
              239,164,132;
              182,118,108;]/255;
   
     
%     x = 1:size(functions,2);
%     b =  bar(log(rt_datas),'grouped'); 
    b =  bar(log(datas),'grouped');
    for i = 1:length(Algs)
       b(i).FaceColor = colors(i, :);
    end
    y_offset = 0.05;
    for i = 1:numel(b)
        xData = b(i).XEndPoints;  % MATLAB 2019b+ 推荐方式
        yData = b(i).YData;
        original_values = exp(yData);
        text(xData, yData + y_offset,...
            strcat(num2str(original_values', '%.1f\n'), '  '),...  % 添加换行符
            'Rotation', 90,...              % 旋转90度
            'HorizontalAlignment', 'left',...  % 左对齐
            'VerticalAlignment', 'middle',...  % 垂直居中
            'FontSize', 6,...
            'Fontname','Times New Roman',...
            'FontWeight','bold',...
            'Margin', 1)  % 增加文本边距)
    end
    ylim([0,6.5]);
%     set(gca, 'XTickLabel', {'DF1', 'DF2', 'DF3', 'DF4', 'DF5', 'DF6', 'DF7', 'DF8', 'DF9', 'DF10', 'DF11', 'DF12', 'DF13', 'DF14'});     
    set(gca, 'XTickLabel', {'DF2','DF6', 'DF7','DF9', 'DF11', 'DF14'}); 
    set(gca,'Fontname','Times New Roman');
%     truncAxis('y',[50,100]);
    
    xlabel('Functions');
    ylabel('Log(Running Time)');
    legend_handle = legend(Algs, 'Orientation', 'horizontal', 'Location', 'northoutside');
    set(legend_handle, 'ItemTokenSize', [10, 10]);  % 标签的大小
    
    set(gcf,'PaperUnits','inches','PaperSize',[11.6,5.8]);
    set(gcf,'PaperPosition',[-1.2 0 14 6]);
    set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.2); % 设置网格线样式
    grid on;
    set(gca, 'YGrid', 'on', 'XGrid', 'off'); % 仅保留横线，关闭竖线
%     set(gcf, 'Position', [100, 100, 1000, 350]); 
%     breakyaxis([50,200]);
     
    
    Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\';
%     filename = fullfile(Figurepath,['rt-',char(group_con),'.eps']);
%     print(gcf,filename,'-depsc2', '-painters','-r600');
    filename = fullfile(Figurepath,['runtime-',char(group_con),'.pdf']);
    print(gcf,filename,'-dpdf','-r600');
    fprintf("------成功保存 %s 的时间对比图！-------\n",char(group_con));
end

%% 时间步参数敏感性实验，运行时间、MIGD变化的折线图。
% 注意！执行此程序的前提，须保存参数敏感性时间的最新表格数据。
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))

con=configure();
functions=con.TestFunctions;
T_parameter=con.T_parameter;
Algs=["TimeStep-50","DD-DMOEA","TimeStep-150","TimeStep-200","TimeStep-250","TimeStep-300"];

for group = 3:3%size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
    T=floor(T_parameter(group,3)/T_parameter(group,2));
    
    % 读取保存在excel的MIGD、runtime数据
    filename = 'E:\MATLAB\MyProject\DMOEA\results\Parameter_data.xlsx';
    Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\';
    fprintf("\n-----------------------------\n");
    fprintf(".....正在读取 %s 数据,,,,,\n",char(group_con));
    rt_datas = zeros(size(functions,2),length(Algs));
    migd_datas = zeros(size(functions,2),length(Algs));
    volume=["B","C","D","E","F","G","H","I","J","K","L"];
    
    for testFuncNo=1:size(functions,2)
         Problem=TestFunctions(functions{testFuncNo});
         Type=[Problem.Name,"Mean_IGD","Std_IGD","Mean_HV","Std_HV","runtime"];
         
         rt_columns = (length(Type) + (testFuncNo-1)*(length(Type)+1)); 
         rt_range = sprintf('C%d:H%d', rt_columns, rt_columns);   % 拷贝数据的范围
         rt_datas(testFuncNo,:) = readmatrix(filename,'Sheet', char(group_con), 'Range', rt_range);
         
         migd_columns = (2 + (testFuncNo-1)*(length(Type)+1)); 
         migd_range = sprintf('C%d:H%d', migd_columns, migd_columns);   % 拷贝数据的范围
         migd_datas(testFuncNo,:) = readmatrix(filename,'Sheet', char(group_con), 'Range', migd_range);
    end
    
    % 画折线图    
%     colors = [
%         0.0 0.0 1.0;   % 蓝色
%         1.0 0.5 0.0;   % 橙色
%         1.0 0.0 0.0;   % 红色
%         0.0 0.5 0.0;   % 深绿色
%         0.5 0.0 0.5;   % 紫色
%         0.0 1.0 1.0;   % 青色      
%         0.5 0.5 0.5;   % 灰色
%         0.4 0.2 0.8;   % 蓝紫
%         0.8 0.2 0.6;   % 粉紫
%         0.2 0.8 0.4;   % 亮绿
%         0.9 0.7 0.0;   % 金色
%         1.0 0.0 1.0;   % 品红
%         0.0 0.6 0.8;   % 天蓝
%         0.8 0.4 0.2;   % 棕橙
%     ];
    colors = [164,189,219;
              138,140,191;
              184,168,207;
              231,188,198;
              253,207,158;
              239,164,132;
              182,118,108;]/255;
    % 预定义标记列表（14种不同标记）
     markers = {'o', 's', 'd', '^', 'v', 'p', 'h', '+', '*', 'x', '.', '<', '>', 'pentagram'};

    array = [1,2,6,8,9,12]; % 1,4,7,8,12,13
    
    figure;
    subplot(1,2,1);
    hold on  
    x = 1:size(Algs,2);
    for testFuncNo=1:size(functions,2)
        if ismember(testFuncNo,array) 
       % y1 = (rt_datas(testFuncNo,:) - min(rt_datas(testFuncNo,:))) / (max(rt_datas(testFuncNo,:)) - min(rt_datas(testFuncNo,:)));
        plot(x, rt_datas(testFuncNo,:), ...  % rt_datas(testFuncNo,:)
             'Color', colors(testFuncNo,:), ...   % 颜色
             'Marker', markers{testFuncNo}, ... % 标记
             'LineStyle', '-', ...             % 线型（实线）
             'LineWidth', 1.5, ...            % 线宽
             'MarkerSize', 5, ...              % 标记大小
             'MarkerFaceColor', colors(testFuncNo,:)); % 标记填充颜色'LineWidth',1.5);
        end
    end
    hold off    
    ax = gca;
    ax.XTick = [1, 2, 3, 4, 5, 6];  % 必须为数值数组，对应于画图值的索引        
    xlabel('Time Step');ylabel('Running Time');   
    set(gca,'XTickLabel', {'50', '100', '150', '200', '250', '300'});     
    set(gca,'Fontname','Times New Roman');    
    grid on;
    set(gca, 'YGrid', 'on', 'XGrid', 'off'); % 仅保留横线，关闭竖线
    set(gca, 'OuterPosition', [0 0 0.5 1]);
    
    subplot(1,2,2);
    hold on  
    x = 1:size(Algs,2);
    for testFuncNo=1:size(functions,2)
        if ismember(testFuncNo,array)
         y2 = (migd_datas(testFuncNo,:) - min(migd_datas(testFuncNo,:))) / (max(migd_datas(testFuncNo,:)) - min(migd_datas(testFuncNo,:)));
        plot(x, y2, ...     % migd_datas(testFuncNo,:)
             'Color', colors(testFuncNo,:), ...   % 颜色
             'Marker', markers{testFuncNo}, ... % 标记
             'LineStyle', '--', ...             % 线型（实线）
             'LineWidth', 1.5, ...            % 线宽
             'MarkerSize', 5, ...              % 标记大小
             'MarkerFaceColor', colors(testFuncNo,:)); % 标记填充颜色;    
        end
    end
    hold off    
    set(gca, 'OuterPosition', [0.5 0 0.5 1]);
    
    ax = gca;
    ax.XTick = [1, 2, 3, 4, 5, 6];  % 必须为数值数组，对应于画图值的索引    
    grid on;
    xlabel('Time Step');
    ylabel('MIGD');  
    set(gca,'XTickLabel', {'50', '100', '150', '200', '250', '300'});     
    set(gca,'Fontname','Times New Roman');  
    
    legend_handle = legend({'DF1', 'DF2', 'DF6', 'DF8', 'DF9', 'DF12'},...
                           'Orientation', 'horizontal',...
                           'Location', 'northoutside',...
                           'NumColumns', 6);
    set(legend_handle, 'ItemTokenSize', [10, 10]);  % 标签的大小
    set(gca, 'GridLineStyle', '-', 'GridAlpha', 0.2); % 设置网格线样式    
    set(gca, 'YGrid', 'on', 'XGrid', 'off'); % 仅保留横线，关闭竖线
    set(gcf,'PaperUnits','inches','PaperSize',[6.2,4.6]);  
    set(gcf,'PaperPosition',[0.1,0.1,5.8,4.3]);         
    filename2 = fullfile(Figurepath,['Parsen-',char(group_con),'.pdf']);
    print(gcf,filename2,'-dpdf','-r600');
    fprintf("------成功保存 %s 的参数敏感性变化图！-------\n",char(group_con));
end
%% α参数敏感性实验，MIGD变化的折线图。
clc
clear
close all
warning('off')
warning off all
addpath(genpath('E:\MATLAB\MyProject\DMOEA\results\'))
addpath(genpath('E:\MATLAB\MyProject\DMOEA\Benchmark\'))

con=configure();
functions=con.TestFunctions;
T_parameter=con.T_parameter;
Algs=["alpha-1","DD-DMOEA"];

    % 画折线图    
colors = [0.0 0.0 1.0;
          1.0 0.5 0.0;
          0.8 0.2 0.6;
          0.5 0.5 0.5;];
    % 预定义标记列表（14种不同标记）
markers = {'o', 's', 'd', 'v'};
figure;
hold on     
for group = 1:size(T_parameter,1)
    group_con = strcat(num2str(group) , '-nt' , num2str(T_parameter(group, 1)) , '-tauT' , num2str(T_parameter(group, 2)));
    T=floor(T_parameter(group,3)/T_parameter(group,2));
    
    % 读取保存在excel的MIGD、runtime数据
    filename = 'E:\MATLAB\MyProject\DMOEA\results\Parameter_data.xlsx';
    Figurepath = 'E:\MATLAB\MyProject\DMOEA\results\Figures\';
    fprintf("\n-----------------------------\n");
    fprintf(".....正在读取 %s 数据,,,,,\n",char(group_con));
    migd_datas = zeros(size(functions,2),length(Algs));
    volume=["B","C","D","E","F","G","H","I","J","K","L"];
    
    for testFuncNo=1:size(functions,2)
         Problem=TestFunctions(functions{testFuncNo});
         Type=[Problem.Name,"Mean_IGD","Std_IGD","Mean_HV","Std_HV","runtime"];

         migd_columns = (2 + (testFuncNo-1)*(length(Type)+1));    
         alpha1_migd_range = sprintf('B%d:B%d', migd_columns,migd_columns);   % 拷贝数据的范围
         migd_datas(testFuncNo,1) = readmatrix(filename,'Sheet', char(group_con), 'Range', alpha1_migd_range);
         alpha2_migd_range = sprintf('D%d:D%d', migd_columns,migd_columns);   
         migd_datas(testFuncNo,2) = readmatrix(filename,'Sheet', char(group_con), 'Range', alpha2_migd_range);         
    end
          
    x = 1:size(functions,2);
    plot(x, log10(migd_datas(:,1)), ...     
            'Color', colors(group,:),'Marker', markers{group}, 'LineStyle', '--', ...             % 线型（实线）
            'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', 'none'); % 标记填充颜色;        
    plot(x, log10(migd_datas(:,2)), ...     
            'Color', colors(group,:), 'Marker', markers{group}, 'LineStyle', '-',... 
            'LineWidth', 1.5, 'MarkerSize', 5, 'MarkerFaceColor', colors(group,:)); 

grid on;
xlabel('Functions');
ylabel('log(MIGD)');  
xticks(1:14);
set(gca, 'XTickLabel', {'DF1', 'DF2', 'DF3', 'DF4', 'DF5', 'DF6','DF7', 'DF8', 'DF9', 'DF10', 'DF11', 'DF12', 'DF13', 'DF14'});     
set(gca,'Fontname','Times New Roman');      
legend_handle = legend({'DDM/{L(\alpha)}-1', 'DDM/{Cos(\alpha)}-1','DDM/{L(\alpha)}-2','DDM/{Cos(\alpha)}-2',...
                        'DDM/{L(\alpha)}-3','DDM/{Cos(\alpha)}-3','DDM/{L(\alpha)}-4','DDM/{Cos(\alpha)}-4'},...
                        'Orientation', 'horizontal','Location', 'northeast',...
                        'NumColumns', 2);
set(legend_handle, 'ItemTokenSize', [15, 10]);  % 标签的大小
set(gca, 'GridLineStyle', '-', 'GridAlpha', 0.2); % 设置网格线样式    
set(gca, 'YGrid', 'on', 'XGrid', 'off'); % 仅保留横线，关闭竖线
set(gcf,'PaperUnits','inches','PaperSize',[6.2,4.6]);  
set(gcf,'PaperPosition',[0.1,0.1,5.8,4.3]);         
end
filename2 = fullfile(Figurepath,['diff-Alpha','.pdf']);
print(gcf,filename2,'-dpdf','-r600');
fprintf("------成功保存参数alpha变化图！-------\n");


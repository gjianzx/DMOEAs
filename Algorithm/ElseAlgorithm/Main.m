function Main()
% main function of EDMO
% Problem:  the choosed problem       % Algorithm:  the choosed Algorithm
% ft:  the frequence of change        % nt: the severity of change         
% gen(preEvolution): the current generation         % maxgen: the maxcurrent generation  
% N: population size                % M: the multiobjective number     
% D: the decision vector number     % boundary: the boundary of decision vector  
% runtime: the run time of the whole evolutiotn
% number: the corresponding environment number
    clear
    clc
    warning('off', 'all');
    cd(fileparts(mfilename('fullpath')));
    addpath(genpath(cd));
    path=['.\results\'];
    mkdir(path);
    repmax=20; % 论文参数
    Problem={'DF1','DF2','DF3','DF4','DF5','DF6','DF7',...
        'DF8','DF9','DF10','DF11','DF12','DF13','DF14'};
    Algorithm='MDA';     % 在此更改算法
    timeParameter = [5 5
                    10 5
                    5 10
                    10 10];

    for tp=1:1%length(timeParameter)

        nt=timeParameter(tp,1);
        ft=timeParameter(tp,2);
        preEvolution=30;
        change=30;
        N=100;
        M=2;    % number of objs
        D=10;   % dimensions of decision
        data = [];

        for p=1:length(Problem)
            % 三目标问题
            if p>=10
                N=150;
                M=3;
            end
            clearvars res
            for rep=1:repmax
                res{rep}=DMOEA(Problem{p},Algorithm,ft,nt,preEvolution,change,N,rep);
                allMIGD(rep) = res{rep}.MIGD;       allMHV(rep)  = res{rep}.MHV;
                allMSPR(rep) = res{rep}.MSPR;       allMSPA(rep) = res{rep}.MSPA;
                allRT(rep)   = res{rep}.runtime;
            end  % 
            % mean value of MIGD/MHV/MSPR/MSPA
            meanMIGD = mean(allMIGD);   stdMIGD = std(allMIGD);    
            meanMHV = mean(allMHV);     stdMHV = std(allMHV);
            meanMSPR = mean(allMSPR);   stdMSPR = std(allMSPR);    
            meanMSPA = mean(allMSPA);   stdMSPA = std(allMSPA);
    
            % mean value of RunTime
            meanRT = mean(allRT);stdRT = std(allRT);
            data = [data;[meanMIGD,stdMIGD,meanMHV,stdMHV,meanMSPR,stdMSPR,meanMSPA,stdMSPA,meanRT,stdRT]];
            filename=[Algorithm '-' Problem{p} '-nt' num2str(nt) '-ft' num2str(ft) '-change' num2str(change) '.mat'];
            save([path,filename]);
            fprintf(['\n-----------------------------------------------------------------------' ...
                '-----------------------------------------------------------------------']);
            fprintf('\nResult(%s  %s  nt:%d  ft:%d):\nMIGD:%d(%d)     MHV:%d(%d)     MSPR:%d(%d)     MSPA:%d(%d)\nruntime:%d(%d)', ...
                Algorithm,Problem{p},nt,ft,meanMIGD,stdMIGD,meanMHV,stdMHV,meanMSPR,stdMSPR,meanMSPA,stdMSPA,meanRT,stdRT);
            fprintf(['\n-----------------------------------------------------------------------' ...
                '-----------------------------------------------------------------------']);
        
            %%%%%%%%%%%%%%%%%%%%%%% save PlatEMO data %%%%%%%%%%%%%%%%%%%%%%%%%
            PlatEMODataPath=['.\PlatEMO-Data\preEvolution' num2str(preEvolution) '-change' num2str(change) ...
                '\nt' num2str(nt) '-ft' num2str(ft) '\' Algorithm '\' Problem{p} '\'];
            mkdir(PlatEMODataPath);
            for rep=1:repmax
                %% Save data in platemo format to generate comparison tables
                metric.runtime=res{rep}.runtime;
                metric.IGD=allMIGD(rep);
                metric.HV=allMHV(rep);
                metric.Spacing=allMSPA(rep);
                metric.Spread=allMSPR(rep);
                result = cell(1,2);
                PlatEMOFileName=[Algorithm '_' Problem{p} '_M' num2str(M) '_D' num2str(D) '_' num2str(rep)  '.mat'];
                save([PlatEMODataPath,PlatEMOFileName],'metric','result');
            end
        end
        % save csv file and
        T = array2table(data(1:end,:), 'VariableNames', {'mean(IGD)','std(IGD)','mean(MHV)','std(MHV)', ...
            'mean(MSPR)','std(MSPR)','mean(MSPA)','std(MSPA)','mean(RT)','std(RT)'},'RowNames',Problem);
        csv_filename=['.\results\table\' Algorithm '-nt' num2str(nt) '-ft' num2str(ft) '-change' num2str(change) '.csv'];
        mkdir('.\results\table\');
        writetable(T, csv_filename, 'WriteRowNames', true);

    end
end

function res=DMOEA(Problem,Algorithm,ft,nt,preEvolution,change,N,rep)
    %% ----------- Initial global parameter settings -----------------
    %% setting
    maxgen = preEvolution + change*ft;
    [IniPopulation,boundary,V,N] = Individual(Problem,ft,nt,1,N,preEvolution);
    %% test mode
    PF = GeneratePF(Problem,ft,nt,maxgen,preEvolution);
    fprintf('\n%s\n  %s  nt:%d  ft:%d  rep:%d\n',Algorithm,Problem,nt,ft,rep);
    tic;
    FinalPop = MDA(Problem,IniPopulation,boundary,N,maxgen,ft,nt,preEvolution);
    runtime = toc;
    [igd,MIGD,hv,MHV,spread,MSPR,spacing,MSPA]=computeMetrics(FinalPop,PF,change);
    fprintf('\nMIGD:%d     MHV:%d     MSPR:%d     MSPA:%d\nruntime:%d',MIGD,MHV,MSPR,MSPA,runtime);
    res.Problem=Problem;    res.Algorithm=Algorithm;    res.FinalPop=FinalPop;  res.runtime=runtime;
    res.igd=igd;            res.hv=hv;                  res.spread=spread;      res.spacing=spacing;
    res.MIGD=MIGD;          res.MHV=MHV;                res.MSPR=MSPR;          res.MSPA=MSPA;

end

function [igd,MIGD,hv,MHV,spread,MSPR,spacing,MSPA]=computeMetrics(FinalPop,PF,change)
    % t=0第一个环境的静态优化不参与计算
    FinalPop(1,:)=[];
    PF(1)=[];
    for i=1:change
        igd(i)=IGD(real(FinalPop(i,:).objs),PF(i).PF);        hv(i)=HV(real(FinalPop(i,:).objs),PF(i).PF);
        spread(i)=Spread(real(FinalPop(i,:).objs),PF(i).PF);  spacing(i)=Spacing(real(FinalPop(i,:).objs),PF(i).PF);
    end
    MIGD=mean(igd,'omitnan');   MHV=mean(hv,'omitnan'); MSPR=mean(spread,'omitnan');    MSPA=mean(spacing,'omitnan');
end
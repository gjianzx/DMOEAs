function [MIGD,MHV,MMS,MSPA,MSPR,runtime]=dataOutput(res,IGD_res,HV_res,MS_res,SPA_res,SPR_res,T_parameter,group)
        T=floor(T_parameter(group,3)/T_parameter(group,2));
        for i = 1:T
            % 每一次环境最后一次迭代值
            igd(i)=IGD_res{i}(end);    hv(i)=HV_res{i}(end); 
            ms(i)=MS_res{i}(end);     spa(i)=SPA_res{i}(end); 
            spr(i)=SPR_res{i}(end);
            time(i)=res{i}.rt;
        end
        % 最后表格展示的是多次环境变化后的IGD均值，即多次环境变化的最后一次优化器迭代的IGD值的均值
        MIGD=mean(igd);    MHV=mean(hv);  MMS=mean(ms); MSPA=mean(spa); MSPR=mean(spr); 
        runtime = sum(time);
end
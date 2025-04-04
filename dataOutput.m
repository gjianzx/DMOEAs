function [MIGD,MHV,MMS,MSPA,MSPR,runtime]=dataOutput(res,IGD_res,HV_res,MS_res,SPA_res,SPR_res,T_parameter,group)
        T=floor(T_parameter(group,3)/T_parameter(group,2));
        for i = 1:T
            % ÿһ�λ������һ�ε���ֵ
            igd(i)=IGD_res{i}(end);    hv(i)=HV_res{i}(end); 
            ms(i)=MS_res{i}(end);     spa(i)=SPA_res{i}(end); 
            spr(i)=SPR_res{i}(end);
            time(i)=res{i}.rt;
        end
        % �����չʾ���Ƕ�λ����仯���IGD��ֵ������λ����仯�����һ���Ż���������IGDֵ�ľ�ֵ
        MIGD=mean(igd);    MHV=mean(hv);  MMS=mean(ms); MSPA=mean(spa); MSPR=mean(spr); 
        runtime = sum(time);
end
function [MS_T,IGD_T,HV_T,SPA_T,SPR_T]=computeMetrics(resStruct)
    for T=1:size(resStruct,2)
        POFIter=resStruct{T}.POF_iter;
        POFbenchmark=resStruct{T}.turePOF;
        for it=1:size(POFIter,2)
            pof=POFIter{it};
            pof(imag(pof)~=0) = abs(pof(imag(pof)~=0));
            ms(it)=MS(pof',POFbenchmark);       igd(it)=IGD(pof',POFbenchmark);  hv(it)=HV(pof',POFbenchmark);   
            spa(it)=Spacing(pof',POFbenchmark); spr(it)=Spread(pof',POFbenchmark);
        end
        MS_T{T}=ms;    IGD_T{T}=igd;  HV_T{T}=hv;
        SPA_T{T}=spa;  SPR_T{T}=spr;
    end
end

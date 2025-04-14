% 选择所要执行的算法 %

function Alg = SelectAlgorithms(Algname)
switch Algname
    
        
    case  'DIP-DMOEA';      Alg  =  @DIP_DMOEA; 
    case  'MMTL-DMOEA';     Alg  =  @MMTL_MOEAD;     % 此算法单独执行，moead参数设置不同
    case  'IGP-DMOEA';      Alg  =  @IGP_DMOEA;      
    case  'KTM-DMOEA';      Alg  =  @KTM_DMOEA;    
    case  'KT-DMOEA';       Alg  =  @TrKneeDMOEA;    % 此算法单独执行，加入全部路径会卡死
    case  'Tr-DMOEA';       Alg  =  @Tr_DMOEA;
    
    case  'PPS';            Alg  =  @PPS;        
    case  'Tr-RMMEDA' ;     Alg  =  @TrRMMEDA;              
    case  'MIT-DMOEA';      Alg  =  @MITDMOEA;        
    case  'IT-DMOEA';       Alg  =  @ITDMOEA;  
    
end
end


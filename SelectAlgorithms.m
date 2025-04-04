% 选择所要执行的算法 %

function Alg = SelectAlgorithms(Algname)
switch Algname
    case  'DD-DMOEA';       Alg  =  @DD_DMOEA; 
        
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
    
    %%% 以下是DM-DMOEA消融实验、参数敏感性实验、现实应用实验所需的函数 %%%
    case 'DD-DMOEA-I' ;       Alg  =  @AB_DD_DMOEA;
    case 'DD-DMOEA-II';       Alg  =  @AB_DD_DMOEA;
    case 'DD-DMOEA-III';      Alg  =  @AB_DD_DMOEA;
        
    case 'alpha-1';           Alg  =  @PS_DD_DMOEA;
%     case 'alpha-2';           Alg  =  @PS_DM_DMOEA;
    case 'TimeStep-50';       Alg  =  @PS_DD_DMOEA;
    case 'TimeStep-150';      Alg  =  @PS_DD_DMOEA;
    case 'TimeStep-200';      Alg  =  @PS_DD_DMOEA;
    case 'TimeStep-250';      Alg  =  @PS_DD_DMOEA;
    case 'TimeStep-300';      Alg  =  @PS_DD_DMOEA;
    %%% 应用    
    case  'APP-DD-DMOEA';       Alg  =  @APP_DD_DMOEA;         
    case  'APP-DIP-DMOEA';      Alg  =  @APP_DIP_DMOEA; 
    case  'APP-MMTL-DMOEA';     Alg  =  @APP_MMTL_MOEAD;     
    case  'APP-IGP-DMOEA';      Alg  =  @APP_IGP_DMOEA;      
    case  'APP-KTM-DMOEA';      Alg  =  @APP_KTM_DMOEA;    
    case  'APP-KT-DMOEA';       Alg  =  @APP_TrKneeDMOEA;    
    case  'APP-Tr-DMOEA';       Alg  =  @APP_Tr_DMOEA;    
end
end


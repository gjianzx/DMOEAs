function con=configure()
con.T_parameter = [
%      10 10  50    %用于调试代码  
     10 10  300
     5  10  300
     10  5  150
     5   5  150
                    ];%% time parameters   nt tauT tau  T=p3/p2
% nt   : 环境变化程度，
% tauT : 环境变化频率，即环境每隔多少代会发生一次变化
% tau  : 算法的迭代总数                
                
% con.AllTestFunctions={'FDA1','FDA2','FDA3','FDA4','FDA5','FDA5_iso','FDA5_dec',...
%                       'dMOP1','dMOP2','dMOP3','dMOP2_iso','dMOP2_dec',...
%                       'F5','F6','F7','F8','F9','F10',...
%                       'UDF1','UDF2','UDF3','UDF4','UDF5','UDF6','UDF7',...
%                       'DIMP2','HE2','HE7','HE9'};
                  
% con.TestFunctions={'FDA1','FDA2','FDA3','FDA4','FDA5','dMOP1','dMOP2','dMOP3','F5','F6','F7','F8','F9','F10'};

con.TestFunctions = {'DF1','DF2','DF3','DF4','DF5','DF6','DF7','DF8','DF9','DF10','DF11','DF12','DF13','DF14'};

con.popSize=100;
con.repeat=20;
con.dec=10;  % 决策变量
% con.alg={'Tr-DMOEA','KT-DMOEA','MMTL-DMOEA','IGP-DMOEA','DIP-DMOEA','KTM-DMOEA','DD-DMOEA'};  % 本次执行的算法
con.alg={'DD-DMOEA'};  % 调式代码

end

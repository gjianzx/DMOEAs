function POF_Banchmark = getBenchmarkPOF( testfunname,group,T,T_parameter )
%UNTITLED2 Summary of this function goes here
    tempPosition = T;
   % ['./Metrics/pof/measures/pof/' 'POF-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) '-' functions{testfunc} '-' num2str(tempPosition) '.txt']
    POF_Banchmark = importdata(['./Benchmark/pof/' 'POF-nt' num2str(T_parameter(group,1)) '-taut' num2str(T_parameter(group,2)) '-' testfunname '-' num2str(tempPosition) '.txt']);
end


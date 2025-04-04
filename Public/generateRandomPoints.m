function resPop = generateRandomPoints(Pop,Problem,Algs_name)
if nargin == 2
        PopSize = Pop;                   % 此算法传入的是种群大小
        nVar = size(Problem.XLow,1);     % Number of Decision Variables
        VarSize = [nVar 1];              % Decision Variables Matrix Size
        VarMin = Problem.XLow;         % Decision Variables Lower Bound
        VarMax = Problem.XUpp;         % Decision Variables Upper Bound

        for i=1:PopSize
                resPop(:,i)=unifrnd(VarMin,VarMax,VarSize);    
        end
%%        
elseif nargin == 3%&Algs_name == 'KT-DMOEA'
        count=1;
        for j=1:size(Pop,2)          % 此算法传入的是种群
            resPop=Pop;
            mutIndex=randperm(ceil(size(Pop,1)*0.5));
            for i=1:mutIndex
                temp=cauchyrnd(Pop(i,j),1);
                if temp <0 || temp>1
                   temp =0;
                end
                resPop(i,count)=temp;
                count=count+1;
            end
        end
        resPop=[resPop Pop];
%%        
else
        error('Algorithm not found');
end

end
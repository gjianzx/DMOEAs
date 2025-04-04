function    Cost=CostMatrix(NumClass,maxvalue,kind)
%Generate 3 types of cost matrix [1]
%
%Cost matrix format: 
%1) cost[i,j] denotes the cost of misclassifying a j-thclass instance as
%    belonging to i-th class;
%2) integer values;
%3) cost is zero if the example is classified correctly;
%4) at least one cost value is 1 (union condition).
%
%Type (a): 1.0<cost[i,j]<=max_value for a single i, cost[k¡Ùi,j]=1.0 for all k¡Ùj
%Type (b): 1.0<=cost[i,j]<=max_value and for each j¡Ùi1 and j¡Ùi2, cost[i1,j]=cost[i2,j]
%Type (c): 1.0<=cost[i,j]<=max_value for all i¡Ùj
%Examples:
%Type (a):             Type (b):                Type (c):
%cost=[ 0,1,1        cost=[ 0,1,3           cost=[ 0,1,3
%           1,0,1                   2,0,3                       2,0,4
%           2,3,0]                  2,1,0]                     3,5,0]
%
%Usage:
%    Cost=CostMatrix(NumClass,maxvalue,kind)
%    NumClass: number of classes
%    maxvalue: max cost. default value is 10.
%    kind: 'a'- generate type (a) cost matrix
%            'b'- generate type (b) cost matrix
%            'c'- generate type (c) cost matrix
%            default value is 'c'
%
%Refer [1]: K.M. Ting, ¡°An instance-weighting method to induce cost-sensitive
%trees,¡± IEEE Transactions on Knowledge and Data Engineering, vol.14,no.3, pp.659¨C665, 2002.


if(nargin<1)
    help CostMatrix;
elseif(nargin<2)
    if(NumClass<2)
        error('NumClass error.')
    end
    maxvalue=10;
    kind='c';
elseif(nargin<3)
    kind='c';
end

switch(kind)
    
    % type (a) cost matrix
    case 'a'         
        %confirm union condition
        for i=1:NumClass   
            for j=1:NumClass
                if (i ~= j)
                    Cost(i,j) = 1;
                end
            end
        end
        I=round(rand(1,1)*(NumClass-1))+1;%dominative row index I        
        for j=1:NumClass
            if(j~=I)
                Cost(I,j) = round(rand(1,1) * (maxvalue-2) + 2);
            end
        end
        
    % type (b) cost matrix
    case 'b'   
        %generate random vlaues between 1 and maxvalue for cost matrix
        for j=1:NumClass
            rn = round(rand(1,1) * (maxvalue-1) + 1);
            for i=1:NumClass
                if (i ~= j) 
                    Cost(i,j) = rn;
                end
            end
        end        
        %confirm union condition
        if(min(Cost(find(Cost(:)>0)))>1)
            rn=round(rand(1,1)*(NumClass-1))+1;
            for i=1:NumClass
                if(i~=rn)
                    Cost(i,rn)=1;
                end
            end                  
        end

    % type (c) cost matrix 
    case 'c'        
        %generate random vlaues between 1 and maxvalue for cost matrix
        Cost=zeros(NumClass);
        for i=1:NumClass
            for j=1:NumClass               
                if (i ~= j)
                    rn1 = round(rand(1,1) * (maxvalue-1) + 1);
                    Cost(i,j) = rn1;
                end
            end
        end        
        %confirm union condition
        if(min(Cost(find(Cost(:)>0)))>1)
            rn1=round(rand(1,1)*(NumClass-1))+1;
            rn2=round(rand(1,1)*(NumClass-1))+1;
            while(rn1==rn2)
                rn1=round(rand(1,1)*(NumClass-1))+1;
            end
            Cost(rn1,rn2)=1;
        end
   
    otherwise
        error('type error.')
end
        


    

function    out=NNoutputFormat(label,ClassType,kind,oout)

if (nargin<3)
    kind=1;
elseif(kind==3)
    if(isempty(oout))
        error('original out matrix is not input.')
    end
end
switch(kind)
    % convert label vector to 0-1 matrix
    case 1
        if(size(label,1)>1)
            error('input label error.')
        end
        NumClass=length(ClassType);
        n=length(label);
        out=zeros(NumClass,n);
        
        for i=1:n
            for j=1:NumClass
                if(label(i)==ClassType(j))
                    out(j,i)=1;
                end
            end
        end
        
       
    % convert  0-1 matrix to label vector 
    case 2
        if(size(label,1)~=length(ClassType))
            error('input output format of NN error.')
        end
        [tmp,id]=max(label);
        out=ClassType(id);
        

    % convert  0-1 matrix to label vector in method3 thresholdmoving
    case 3
        if(size(label,1)~=length(ClassType))
            error('input output format of NN error.')
        end
        [tmp,id]=max(label);
        
        for i=1:length(tmp)
            for j=1:length(ClassType)
                if(j~=id(i) & abs(tmp(i)-label(j,i))<1e-6 & oout(j,i)>oout(id(i),i) )
                    id(i)=j;
                end
            end
        end
        out=ClassType(id);
        
        
    otherwise
        error('wrong kind.');
end
        
            

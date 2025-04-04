function    out=LabelFormatConvertion(label,ClassType,kind)
% conversion between scalar class label format and  0-1 class label vector format.   
% the latter is required when training a real-valued (between [0,1]) neural network. 
% 
% 0-1 class label vector: each class type corresponds to a 2-valued
% attribute, then a class label be can converted into a vector where values
% can be 0 or 1.If an instance is belonging to the i-th class,then the i-th entry
% of the vector is 1 and 0 for the rest.For example, there's 3 classes: 1 2 3, 
% a class 2 instance should be converted to  [0 1 0]
%
%Usage:
%    out=LabelFormatConvertion(label,ClassType,kind)
%
%    out: labels having required format               
%    label: input labels
%             if lable has scalar class label format, label must be row vector 
%             if lable has 0-1 class label vector format.  the row of label
%             must index instances and column must index classes
%    ClassType: class type        
%    kind: 1 - convert scalar class label format to 0-1 class label vector format
%             2 - convert  0-1 class label vector format to scalar class label format
%             default value:1


if (nargin<3)
    kind=1;
end

switch(kind)
    % convert scalar class label format to 0-1 class label vector format
    case 1
        if(size(label,1)>1)
            error('input label format error.')
        end
        NumClass=length(ClassType);
        n=length(label);
        out=zeros(NumClass,n);
        
        class=Locate(ClassType,label);
        for i=1:n            
            out(class(i),i)=1;              
        end        
       
    % convert  0-1 class label vector to scalar class label 
    case 2
        if(size(label,1)~=length(ClassType))
            error('input label format is not consistent with class type.')
        end
        [tmp,id]=max(label);
        out=ClassType(id);
        
    otherwise
        error('wrong kind.');
end
        
            

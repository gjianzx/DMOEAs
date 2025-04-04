function loc=Locate(V,value)
%locate a value in value set V
% Usage:
%  loc=Locate(V,value)
%
%  loc: location of value in the vector V.
%         If value is not in V return -1. 
%  V: value set
%  value: the value to locate,it can be a vector

% check if values in V are unique
if(length(unique(V))~=length(V))
    error('values in the set is not unique')
end
    
v=unique(value);
Nv=length(v);

for i=1:Nv
    id=find(value==v(i));
    l=find(V==v(i));
    if(isempty(l))
        loc(id)=-1;
    else
        loc(id)=l;
    end
end
%end
    
    



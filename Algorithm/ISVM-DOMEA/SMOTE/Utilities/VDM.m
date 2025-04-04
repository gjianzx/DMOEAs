function    attribute=VDM(data,label,ClassType,AttVector)
% calculate VDM for nominal attributes.
% VDM is defined in [1] as follows:
%         VDM(u,v)=sum of c form 1 to C (Nauc/Nau-Navc/Nav)^2
% Nau denote the number of training examples holding value u on
% attribute a, Nauc denote the number of training examples belonging 
% to class c and holding value u on a. 
%
% Usage:
%  attribute=VDM(data,label,ClassType,AttVector)
%
%   data :instance matrix where the row indexes attributes and the column indexes instances. 
%   label: class labels for data
%   ClassType: class type
%   AttVector: attribute vector,1 presents for the corresponding attribute
%                    is nominal and 0 for numeric.
%   attribute: attribute structure vector. Each element has 3 fields
%                  FIELD kind - 'nominal' or 'numeric'
%                  FIELD values - values on the nominal attribute or [] for numeric attribute 
%                  FIELD VDM: pairwise VDM distance of values on nominal attribute or
%                                    [] otherwise
%
% Refer [1]:
% C. Stanfill and D. Waltz, ¡°Toward memory-based reasoning,¡± Communications
% of the ACM, vol.29, no.12, pp.1213¨C1228, 1986.

if(sum(unique(AttVector)==[0,1])~=2)
    error('AttVector error')
end

NumClass=length(ClassType);
NumAtt=length(AttVector); 
for i=1:NumAtt
    if(AttVector(i)==0)   
        attribute(i).kind='numeric';
        attribute(i).values=[];       
        attribute(i).VDM=[];
    else
        attribute(i).kind='nominal';
        attribute(i).values=unique(data(i,:)); 
        N=length(attribute(i).values);
        n=zeros(1,N);
        for k=1:N
            n(k)=length(find(abs(data(i,:)-attribute(i).values(k))<1e-6));
        end
        
        attribute(i).VDM=zeros(N);
        for ui=1:N
            for vi=ui+1:N
                if(vi~=ui)               
                    u=attribute(i).values(ui);
                    v=attribute(i).values(vi);
                    Nu=n(ui);
                    Nv=n(vi);
                    d=0;
                    for j=1:NumClass
                        Nuc=length( intersect( find(data(i,:)==u), find(label==ClassType(j)) ) );
                        Nvc=length( intersect( find(data(i,:)==v), find(label==ClassType(j)) ) );
                        d=d+((Nuc/Nu)-(Nvc/Nv))^2;
                    end  
                    attribute(i).VDM(ui,vi)=d;  
                    attribute(i).VDM(vi,ui)=d;  
                end       
            end
        end
        
    end%if-else
end

%end

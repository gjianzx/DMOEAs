function z = dist_normimal(w,p,attribute,AttVector)
% calculate distance between two instance sets. where distance
% of values on nominal attribute is defined by VDM. for more 
% information of VDM please refer to FUNCTION VDM
%
%Usage:
%  z = dist_normimal(w,p,attribute,AttVector)
%  
%  z:distance matrix. z[i,j] is the distance between the i-th instance of w and
%     the j-th instance of p
%  w: instance matrix where row indexes attribute and column indexes
%       instance
%  p:  instance matrix where row indexes attribute and column indexes
%       instance
%  attribute: attribute structure vector carrying VDM information.
%                 Each entry has 3 fields
%                 FIELD kind - 'nominal' or 'numeric'
%                 FIELD values - values on the nominal attribute or [] for numeric attribute 
%                 FIELD VDM - VDM[i,j] denotes VDM distance between i-th value
%                                     and j-th value on the nominal attribute
%  AttVector: attribute vector,1 presents for the corresponding attribute
%                   is nominal and 0 for numeric.

[R,Nw] = size(w);
[R2,Np] = size(p);
if (R ~= R2)
    error('Attribute numbers do not match.')
end

z = zeros(Nw,Np);
for ii=1:Nw
    id=find(AttVector==0);%numeric
    z(ii,:)= sum((repmat(w(id,ii),1,Np)-p(id,:)).^2);
    for j=find(AttVector==1)%nominal
        wid=Locate(attribute(j).values,w(j,ii));
        pid=Locate(attribute(j).values,p(j,:));
        z(ii,:)=z(ii,:)+attribute(j).VDM(wid,pid);
    end       
end
z = sqrt(z);

function f=PPS_predict(Spop,recordcenter, Msigama,V,p,vlb,vub,pop)
ARprameter=AR_predict(recordcenter,p,V);
s=size(Spop);
f=[];
for i=1:s(1)
    for j=1:V
        f(i,j)=sum(ARprameter(1:p,j).*recordcenter(1:p,j))+Spop(i,j)-recordcenter(1,j)+(ARprameter(p+1,j)+Msigama)*randn;
        if f(i,j)>vub(j)
              f(i,j)=0.5*(Spop(i,j)+vub(j));
        elseif  f(i,j)<vlb(j)
              f(i,j)=0.5*(Spop(i,j)+vlb(j));
        end
    end
end
% if s(1)<pop
%     for i=1:(pop-s(1))
%         ar=ceil(s(1)*rand);
%         for j=1:V
%             f(s(1)+i,j)=sum(ARprameter(1:p,j).*recordcenter(1:p,j))+Spop(ar,j)-recordcenter(1,j)+(ARprameter(p+1,j)+Msigama)*randn;
%         if f(s(1)+i,j)>vub(j)
%               f(s(1)+i,j)=0.5*(Spop(ar,j)+vub(j));
%         elseif  f(s(1)+i,j)<vlb(j)
%               f(s(1)+i,j)=0.5*(Spop(ar,j)+vlb(j));
%         end
%         end
%     end
% end

    
    



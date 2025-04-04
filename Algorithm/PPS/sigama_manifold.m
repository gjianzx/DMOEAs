function f=sigama_manifold(A,B,V,numbernew,numberold)
for i=1:numbernew
    x=A(:,i);
    for j=1:numberold
        y=B(:,j);
        dB(j)=norm(x-y);
    end
    dA(i)=min(dB);
end
d=sum(dA)/numbernew;
f=(d^2)/V;
% f=max(dA);
    
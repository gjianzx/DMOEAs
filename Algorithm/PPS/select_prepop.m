function g=select_prepop(best,N,numbernew)

for k=1:N
    ra1=ceil(rand*numbernew);
    g(:,k)=best(:,ra1);
end
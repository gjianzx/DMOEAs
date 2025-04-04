function [W]=getSW(kneePoints, Hs ,Ht, mu, lambda, dim, kind, p1, p2, p3)
%ITCA方法
%Xs：源域数据
%Xt：目标域数据，与Xs行数相同
%mu：平衡因子，越大越重视映射后的相似度，越小越重视W的复杂度
%lambda：平衡因子，越大越重视映射后的同类数据的相似性，越小越重视W的复杂度
%dim：当dim为大于等于1的整数时，dim为降维的目标维数；
%     当dim为大于0小于1的小数时，所取特征向量对应的特征值的和>=全部特征值加和*dim
%kind：核函数选择:'Gaussian'、'Laplacian'、'Polynomial',其他一律返回-1
%p1,p2,p3：核函数所要附带的参数
%W：变换矩阵n1+n2->dim
%K：待变换矩阵
%n1,n2：源数据，目标数据的数目

numOfKnee=size(kneePoints,2);
numOfHs=size(Hs,2);
numOfHt=size(Ht,2);

% 
% s1=size(kneePoints);
% s2=size(Hs);
% n1=s1(2);n2=s2(2);

%%%%%%%%%%% 计算K %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X(:,1:numOfKnee)=kneePoints;
X(:,numOfKnee+1:numOfKnee+numOfHs)=Hs;
X(:,numOfKnee+numOfHs+1:numOfKnee+numOfHs+numOfHt)=Ht;
for i=1:numOfKnee+numOfHs+numOfHt
    for j=i:numOfKnee+numOfHs+numOfHt
        K(i,j)=getKernel(X(:,i), X(:,j), kind, p1, p2, p3);
        K(j,i)=K(i,j);
    end
end
    
    
%%%%%%%%%%% 计算L %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tempLKH=[];
for i=1:numOfKnee
    tempLKH(1:1, 1:1)=ones(1, 1)/(1*1);
    tempLKH(1+1:1+numOfHs, 1+1:1+numOfHs)=ones(numOfHs, numOfHs)/(numOfHs*numOfHs);
    tempLKH(1:1, 1+1:1+numOfHs)=ones(1, numOfHs)/(-1*numOfHs);
    tempLKH(1+1:1+numOfHs, 1:1)=ones(numOfHs, 1)/(-1*numOfHs);
    LKH{i}=tempLKH;
end
   
    
LHH(1:numOfHs, 1:numOfHs)=ones(numOfHs, numOfHs)/(numOfHs*numOfHs);
LHH(numOfHs+1:numOfHs+numOfHt, numOfHs+1:numOfHs+numOfHt)=ones(numOfHt, numOfHt)/(numOfHt*numOfHt);
LHH(1:numOfHs, numOfHs+1:numOfHs+numOfHt)=ones(numOfHs, numOfHt)/(-numOfHs*numOfHt);
LHH(numOfHs+1:numOfHs+numOfHt, 1:numOfHs)=ones(numOfHt, numOfHs)/(-numOfHs*numOfHt);
    
%%%%%%%%%%% 计算H %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=eye(numOfKnee+numOfHs+numOfHt)-ones(numOfKnee+numOfHs+numOfHt, numOfKnee+numOfHs+numOfHt)/(numOfKnee+numOfHs+numOfHt); 

%%%%%%%%%%% 计算W %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% N=(1*eye(n1+n2)+mu*K*L*K+lambda*V1)
TM=zeros(size(mu*K*LKH{1}*K,1),size(mu*K*LKH{1}*K,2));
for i=1:numOfKnee
    TM=TM+mu*K*LKH{i}*K;
end

Temp=(1*eye(numOfKnee+numOfHs+numOfHt)+TM+lambda*K*LHH*K)^(-1)*(K*H*K);
[V,D]=eig(Temp);
D=diag(D);
D=real(D);
[D,I]=sort(D,'descend');

if dim>0 && dim<1
    count=1;
    cur=0;
    s=sum(D);
    while cur/s<dim && D(count)>0
        cur=cur+D(count);
        count=count+1;
    end
else
    count=dim+1;
end

I=I(1:count-1,1);
W=V(:,I');

    

function [W, K, n1, n2]=getW(Xs, Xt, mu, lambda, dim, kind, p1, p2, p3)
%原TCA方法
%Xs：源域数据
%Xt：目标域数据，与Xs行数相同
%mu：平衡因子，越大越重视映射后的相似度，越小越重视W的复杂度
%lambda：本方法不使用该参数，只是为了形式的统一
%dim：当dim为大于等于1的整数时，dim为降维的目标维数；
%     当dim为大于0小于1的小数时，所取特征向量对应的特征值的和>=全部特征值加和*dim
%kind：核函数选择:'Gaussian'、'Laplacian'、'Polynomial',其他一律返回-1
%p1,p2,p3：核函数所要附带的参数
%W：变换矩阵n1+n2->dim
%K：待变换矩阵
%n1,n2：源数据，目标数据的数目

    n1 = size(Xs, 2);
	n2 = size(Xt, 2);
    
%%%%%%%%%%% 计算K %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    X(:,1:n1)=Xs;
    X(:,n1+1:n1+n2)=Xt;
    for i=1:n1+n2 
        for j=1:n1+n2 
            K(i,j)=getKernel(X(:,i), X(:,j), kind, p1, p2, p3);
        end
    end
    
%%%%%%%%%%% 计算L %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    L(1:n1, 1:n1)=ones(n1, n1)/(n1*n1);
    L(n1+1:n1+n2, n1+1:n1+n2)=ones(n2, n2)/(n2*n2);
    L(1:n1, n1+1:n1+n2)=ones(n1, n2)/(-n1*n2);
    L(n1+1:n1+n2, 1:n1)=ones(n2, n1)/(-n1*n2);
    
%%%%%%%%%%% 计算H %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    H=eye(n1+n2)-ones(n1+n2, n1+n2)/(n1+n2);
    
%%%%%%%%%%% 计算W %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Temp=(eye(n1+n2)+mu*K*L*K)^(-1)*K*H*K;
    [V,D]=eig(Temp);
    V = real(V);
    D = real(D);
    D=diag(D);
    [D,I]=sort(D,'descend');
    
    if dim>0 && dim<1
        count=0;
        cur=0;
        s=sum(D);
        while cur/s<dim
            count=count+1;
            cur=cur+D(count);
        end
    else
        count=dim;
    end
    
    I=I(1:count,1);
    W=V(:,I');

    

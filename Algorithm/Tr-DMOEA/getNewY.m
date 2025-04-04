function Y=getNewY(Xs, Xt, X, W, kind, p1, p2, p3)
%对新数据X进行映射(X可以为源域或目标域的新数据)
%Xs：源域数据
%Xt：目标域数据，与Xs行数相同
%X：待变换向量，与Xs行数相同
%W：变换矩阵n1+n2->k
%kind：核函数选择:'Gaussian'、'Laplacian'、'Polynomial',其他一律返回-1
%p1,p2,p3：核函数所要附带的参数

    n1 = size(Xs, 2);
	n2 = size(Xt, 2);
	n3 = size(X, 2);
    
    for j=1:n3
        for i=1:n1 
            K(i,j)=getKernel(Xs(:,i), X(:,j), kind, p1, p2, p3);
        end
        for i=1:n2
            K(i+n1,j)=getKernel(Xt(:,i), X(:,j), kind, p1, p2, p3);
        end
    end
    
    Y=W'*K;
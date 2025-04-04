function k=getKernel(a, b, kind, p1, p2, p3)
%求核函数kernel(a,b)的值
%a,b：double型列向量
%kind：'Gaussian'、'Laplacian'、'Polynomial',其他一律返回-1
%k：返回核的值

    if strcmp(kind,'Polynomial')
        k=dot(a,b);
        k=(p1*k+p2)^p3;
    elseif strcmp(kind,'Laplacian')
        a=a-b;
        k=a'*a;
        k=exp(-p1*sqrt(k));
    elseif strcmp(kind,'Gaussian')
        a=a-b;
        k=a'*a;
        k=exp(-p1*k);
    else
        k=-1;
    end
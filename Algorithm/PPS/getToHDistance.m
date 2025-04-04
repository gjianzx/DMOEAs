function [dis]=getToHDistance(pointsPF,boundary)

if size(pointsPF,1)==2
    Q1=boundary(:,1)';
    Q2=boundary(:,2)';  
    for i=1:size(pointsPF,2)
        P=pointsPF(:,i)';
        dis(i)=abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
        if dis(i)==0
            dis(i)=-Inf;
        end
    end
elseif size(pointsPF,1)==3
    syms a b c
    Q1=boundary(:,1)';
    x1=Q1(1);
    y1=Q1(2);
    z1=Q1(3);
    Q2=boundary(:,2)';  
    x2=Q2(1);
    y2=Q2(2);
    z2=Q2(3);
    Q3=boundary(:,3)';  
    x3=Q3(1);
    y3=Q3(2);
    z3=Q3(3);
    z1=a*x1+b*y1+c;
    z2=a*x2+b*y2+c;
    z3=a*x3+b*y3+c;
    S=solve([z1 z2 z3],[a b c]);
    a=S.a;
    b=S.b;
    c=S.c;
    A=eval(a);
    B=eval(b);
    C=eval(c);
    a=A;
    b=B;
    c=-1;
    d=C;
    dis=[];
    for i=1:size(pointsPF,2)
        P=pointsPF(:,i)';
        bbbbb=abs(a*P(1)+b*P(2)+c*P(3)+d)/sqrt(a^2+b^2+c^2);
        if ~isempty(bbbbb)
            dis(i)=bbbbb;
        else
            dis(i)=-Inf;
        end
        if dis(i)==0
            dis(i)=-Inf;
        end
    end
end

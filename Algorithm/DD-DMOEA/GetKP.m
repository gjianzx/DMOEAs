%% ��ȡ�յ�
function [kneeS,kneeF,posArr,pofArr] = GetKP(Pareto,partNum)
    [boundaryS,boundaryF]=getBoundary(Pareto.X,Pareto.F);
    [posArr,pofArr]=partition(Pareto.X,Pareto.F,partNum,boundaryF);
    for partNo=1:partNum
        [kneeS,kneeF]=getKnees(posArr{partNo},pofArr{partNo}); % ���ÿ���ӿռ�Ĺյ�
        kneeSArr{partNo}=kneeS;
        kneeFArr{partNo}=kneeF;
    end
    kneeS=cell2mat(kneeSArr);  % ��cell����תΪ����
    kneeF=cell2mat(kneeFArr);
end
%% ��ȡPOF�ı߽��BF,BSΪ�߽���ھ��߿ռ��λ��
function [BS,BF]=getBoundary(pos,pof)
    index=1;
    for i=1:size(pof,1)    

        [~,position]=min(pof(i,:));   % position��ʾ��i��Ŀ�����Сֵ���ڵ�λ��
%          fprintf("\nindex:%d  position:%d\n",index,position);
        BS(:,index)=pos(:,position);
        BF(:,index)=pof(:,position);  
        index=index+1;
    end
end
%% ��POF�Ľ⼯���ֶ���Ӽ�
function [posArr,pofArr]=partition(POS,POF,partNum,boundary)
tempPof=POF;
tempPos=POS;
[~,index]=sort(POF(1,:));   % ��������indexΪ��Ӧ������λ��

for i=1:length(index)                   % ͨ��������POF��POS������������
    POF(:,i)=tempPof(:,index(i));
%     fprintf('index %d,',i)
    POS(:,i)=tempPos(:,index(i));
end

spaceSize=ceil(size(POF,2)/partNum);   % ÿ���ӿռ�Ĵ�С�������������
lowBoundary=1;
for partNo=1:partNum
    if partNo~=partNum
        pofArr{partNo}=POF(:,lowBoundary:lowBoundary+spaceSize);
        posArr{partNo}=POS(:,lowBoundary:lowBoundary+spaceSize);
    else
        pofArr{partNum}=POF(:,lowBoundary:end);
        posArr{partNum}=POS(:,lowBoundary:end);
    end   
    lowBoundary=lowBoundary+spaceSize-1;
end
end

%%
function [kneeS,kneeF]=getKnees(POS,POF)
    [boudaryS,boudaryF]=getBoundary(POS,POF);
    distance=getToHDistance(POF,boudaryF);
    [~,index]=max(distance);
    kneeS=POS(:,index);
    kneeF=POF(:,index);
end

%%
function [dis]=getToHDistance(pointsPF,boundary)

if size(pointsPF,1)==2   % ��Ϊ2Ŀ������ʱ
    Q1=boundary(:,1)';   % POF�ı߽��
    Q2=boundary(:,2)';  
    for i=1:size(pointsPF,2)
        P=pointsPF(:,i)';
        dis(i)=abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
        if dis(i)==0
            dis(i)=-Inf;
        end
    end
elseif size(pointsPF,1)==3   % ��Ϊ3Ŀ������ʱ
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
end
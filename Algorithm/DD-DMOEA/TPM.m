function pop = TPM(kneeArray,T)
    vec=kneeArray{T-1}-kneeArray{T-2};
    for i=1:size(vec,2)
        step(i)=norm(vec(:,i),2);%+normrnd(0,0.1);
    end
    for j=1:size(vec,2)
        for i=1:size(vec,1)-1
            kjl=vec(i+1:end,j);
            fenzi=sqrt(sum(kjl.^2));
            pietheta(i,j)=atan(fenzi/vec(i,j));
        end
    end
    
    for j=1:size(vec,2)
        for i=1:size(vec,1)-1
            if i<size(vec,1)
                while(pietheta(i,j)>pi)
                    pietheta(i,j)=pietheta(i,j)-pi;
                end
                while(pietheta(i,j)<0)
                    pietheta(i,j)=pietheta(i,j)+pi;
                end
            elseif i==size(vec,1)-1
                while(pietheta(i,j)<0)
                    pietheta(i,j)=pietheta(i,j)+2*pi;
                end
                while(pietheta(i,j)>2*pi)
                    pietheta(i,j)=pietheta(i,j)-2*pi;
                end
            end
        end
    end
    num=1;
    while num<11
        for part=1:size(vec,2)
            theta=ones(1,size(vec,1)-1).*(randi([-1,1],1,1)/10990);
            fi= pietheta;%+ theta;
            for i=1:size(vec,1)
                if i==1
                    u(i,part)=step(part)*cos(fi(i,part));
                elseif i<size(vec,1)
                    temp=1;
                    for j=1:i-1
                        temp=temp*sin(fi(j,part));
                    end
                    u(i,part)=step(part)*temp*cos(fi(i,part));
                else
                    temp=1;
                    for j=1:size(vec,1)-1
                        temp=temp*sin(fi(j,part));
                    end
                    u(i,part)=step(part)*temp;
                end
            end
            
            for i=1:size(u,2)
                samplePop(:,num)=u(:,i);
            end
            
            num=num+1;
        end
        
    end
 
    pop= mod(abs(kneeArray{T-1}+samplePop(:,10)),1);
    pop1=mod(abs(kneeArray{T-1}+step.*(kneeArray{T-1}-kneeArray{T-2})),1);
end




function Rank=asignRank(PopX,KneeX)
for i=1:size(PopX,2)
    for j=1:size(KneeX,2)
        if isequal(PopX(:,i),KneeX(:,j))==1
            Rank(i)=1;
            break;
        else
            Rank(i)=-1;
        end
    end
end
end
function [model, beta ] = IKTrAdaBoostTrain(tdX,tdY,tsX,tsY,partNum)
    %%tdX: features from source domain
    %%tdY: labels from source domain
    %%tsX: features from target domain
    %%tsY: labels from target domain
    
    tX = [tdX ; tsX];
    tY = [tdY ; tsY];
    n = size(tdY,1);
    m = size(tsY,1);
    cnk=1;
    ck=(n-10)/10;
    T = 6  ;
    for i=1:m+n
        if i<=n && tdY(i)==1
            w(i)=1/partNum;
        elseif i<=n && tdY(i)==-1
            w(i)=1/(n-partNum);
        else
            w(i)=1/m;
        end
    end
   w=w';
    model = cell(1,T);
    beta = zeros(1,T);
    for t = 1:T
        %p = w./(sum(abs(w)));
  %      model{t} = svmtrain(w,tY,tX,'-t 0 -q £­h 0 -s 2');
        model{t} = svmtrain(w,tY,tX,'-t 0 -q £­h 0 -s 2 ');
        predict = svmpredict(tY,tX,model{t},'-q');
        if length(predict)==0
            break;
        end
        Ink=0;
        Ik=0;
        for checkp=1:n
            if checkp>length(predict)||checkp>length(tsX)
                break;
            end
        
            if predict(checkp)~=tsX(checkp) && tsX(checkp)==1
                Ik=Ik+1;
            end
            if predict(checkp)~=tsX(checkp) && tsX(checkp)==-1
                Ink=Ink+1;
            end
        end
        sigama=(ck*Ik+0.001)/(cnk*Ink+0.001);
        sW = sum(w(n+1:m+n));
        et = sum(w(n+1:m+n).*(predict(n+1:m+n)~=tsY)/sW);
        if et >= 0.5
            et = 0.499;
        elseif et == 0
            et = 0.001;
        end
        bT = et/(1-et);
        beta(t) =bT;
        b = 1/(1+sqrt(2*log(n/T)));
        wUpdate=[];
        for i=1:n
            if tdY(i)==1
                wUpdate(i,1)=b.^(predict(i)~=tdY(i)).*sigama;
            else
                wUpdate(i,1)=b.^(predict(i)~=tdY(i));
            end
        end
       wUpdate=[wUpdate;(bT*ones(m,1)).^(-(predict(n+1:m+n)~=tsY))];
%         wUpdate = [(b*ones(n,1)).*sigama.^(predict(1:n)~=tdY) ; (bT*ones(m,1)).^(-(predict(n+1:m+n)~=tsY)) ];
         w = w.*wUpdate;
         
    end
end


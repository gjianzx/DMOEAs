function Score = IGDPlus(PopObj,PF)
	NTruePOF = size(PF,1);
	NDetectedPOF = size(PopObj,1);
	M = size(PF,2);
	dist = zeros(NDetectedPOF, NTruePOF);
	for i =1:NTruePOF
		for j = 1:NDetectedPOF
			dist(j,i) = dIGDPlus(PF(i,:), PopObj(j,:), M);
		end
	end
    Score = mean(min(dist));
end

function d = dIGDPlus(z,a,M)
    d = 0; 
	for i = 1:M
        if a(i)-z(i)>0
			d = d + (a(i)-z(i))^2;
        end
%         d = (max(a(i)-z(i),0))^2;
	end
	d = sqrt(d);
end
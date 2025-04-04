function [rm, avgrm] = react(hv)
	N = numel(hv);
	maxhv = zeros(size(hv));
	maxhv(1) = hv(1);
	for i = 2:N
		maxhv(i) = max(maxhv(i-1), hv(i));
	end
	
	rm = zeros(1,numel(hv)-1);
	acc = hv./maxhv;
	for i = 1:N-1
		for j = i+1:N
			if acc(j) / acc(i) >= 0.9
				break;
			end
		end
		rm(i) = j - i;
	end
	avgrm = mean(rm);
end
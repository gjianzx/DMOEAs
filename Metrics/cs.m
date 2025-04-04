function v = cs(P)
	N = size(P, 1);
	v = 0;
	for i = 1:N
		d = sum(bsxfun(@minus, P, P(i,:)).^2, 2);
		v = v + sqrt(max(d));
	end
	v = v / N;
end
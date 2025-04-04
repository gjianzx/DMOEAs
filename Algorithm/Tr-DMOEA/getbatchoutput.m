function Fs = getbatchoutput( F, X )
Fn = numel(F(X(1,:)));
Fs = zeros(size(X,1), Fn);
for i = 1:size(X,1)
    Fs(i,:) = F(X(i,:));
end
end
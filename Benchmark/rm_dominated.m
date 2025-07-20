function POF = rm_dominated( POF )
%% Remove dominated objectives
assert(size(POF, 2) == 2);

POF = sortrows(POF, 1);
cnt = size(POF, 1);
jg = false(cnt, 1);

min_f2 = POF(1, 2);
for i = 2:cnt
    if POF(i, 2) > min_f2
        jg(i) = true;
    else
        min_f2 = POF(i, 2);
    end
end
POF(jg, :) = [];
end
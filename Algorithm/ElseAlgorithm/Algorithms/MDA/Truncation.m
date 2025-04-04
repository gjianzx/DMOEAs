function [remainIdx,delIdx] = Truncation(obj,N)

    % Select part of the solutions by truncation
    distance = pdist2(obj,obj,'cosine');
    distance(logical(eye(length(distance)))) = inf;

    k = size(obj,1)-N;
    del = false(1,size(obj,1));

    while sum(del)<k
        remain = find(~del);
        Temp = sort(distance(remain,remain),2);
        [~,Rank] = sortrows(Temp);
        del(remain(Rank(1))) = true;
    end
    
    remainIdx = find(~del);
    delIdx = find(del);
end


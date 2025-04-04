function [count] = GetIntersectionSize(setA,setB)

    n = size(setA,1);
    m = size(setB,1);

    % Deduplicate elements of setA
    removeIdx = [];
    for i=1:n
        for j=i+1:n
            if all(setA(i,:)==setA(j,:))
                removeIdx = [removeIdx,j];
            end
        end
    end
    setA(removeIdx,:) = [];

    % Deduplicate elements of setB
    removeIdx = [];
    for i=1:m
        for j=i+1:m
            if all(setB(i,:)==setB(j,:))
                removeIdx = [removeIdx,j];
            end
        end
    end
    setB(removeIdx,:) = [];


    count = 0;
    newN = size(setA,1);
    newM = size(setB,1);
    for i=1:newN
        for j=1:newM
            if all(setA(i,:)==setB(j,:))
                count = count+1;
                break
            end
        end
    end
end


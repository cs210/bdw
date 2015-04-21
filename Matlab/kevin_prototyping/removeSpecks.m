% Incomplete
function [ R ] = removeSpecks( I )

R = 255 * ones(size(I));
for i=1:size(I,1)
    for j=1:size(I,2)
        if I(i,j) == 255
            continue;
        end
        rMin = max([1 i-1], 2);
        rMax = min([i+1 size(I,1)], 2);
        cMin = max([1 j-1], 2);
        cMax = min([j+1 size(I,2)], 2);
        Box = I(rMin:rMax,cMin:cMax) == 0;
        specks = sum(Box(:));
        if specks > 1
            R(i,j) = 0;
        end
    end
end

end
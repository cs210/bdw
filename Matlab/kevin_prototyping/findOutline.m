function [ V ] = findOutline( I, r, c )

xyDeltas = [1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1];

V = zeros(size(xyDeltas, 1), 2);

for i=1:size(xyDeltas, 1)
    [rAngle, cAngle] = findFirstEdge(I, r, c, -xyDeltas(i,2), xyDeltas(i,1));
    V(i,:) = [rAngle cAngle];
end

dists = sqrt(sum((V - repmat([r c], size(V,1), 1)) .^ 2, 2));
m = mean(dists);
s = std(dists);
for i=1:length(dists)
    if dists(i) > m + 2 * s
        V = V([1:(i-1),(i+1):end],:);
    end
end

V = [V; V(1,:)];

end
function [ r, c ] = findFirstEdge( I, row, col, deltaR, deltaC )

r = row;
c = col;

while r >= 1 && r <= size(I,1) && c >= 1 && c <= size(I, 2) && I(r,c) == 0
    r = r + deltaR;
    c = c + deltaC;
end

r = r - deltaR;
c = c - deltaC;

end


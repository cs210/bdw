function [ Clean ] = cleanImage( I )

Binary = gray2Binary(I, 160);

Edges = edge(Binary, 'Canny');

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Dilated = imdilate(Edges, [se90 se0]);

Filled = imfill(Dilated, 'holes');

Clean = bwareaopen(Filled, 200);

end


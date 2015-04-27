
I = rgb2gray(imread('../DronePhotos/IMG_3110.JPG'));
I = imresize(I, [720 NaN]);
I = gray2Binary(I, 160);
%figure; imshow(I);

Edges = edge(I, 'Canny');
%figure; imshow(Edges);

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Dilated = imdilate(Edges, [se90 se0]);
%figure; imshow(Dilated);

Filled = imfill(Dilated, 'holes');
figure; imshow(Filled);

Clean = bwareaopen(Filled, 200);
figure; imshow(Clean); hold on;

stats = regionprops(Clean, 'ConvexHull');
for i=1:length(stats)
    Hull = stats(i).ConvexHull;
    Hull = [Hull; Hull(1,:)];
    plot(Hull(:,1), Hull(:,2), 'g');
end

%{
Clear = imclearborder(Filled, 4);
figure; imshow(Clear);

seD = strel('diamond',1);
Eroded1 = imerode(Filled, seD);
figure; imshow(Eroded1);

[H, T, R] = hough(I);
P = houghpeaks(H, 5);
lines = houghlines(H, T, R, P)
%}

%{
I = removeSpecks(I);
figure; imshow(I);
%}
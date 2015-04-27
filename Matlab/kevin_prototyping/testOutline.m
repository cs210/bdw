I = rgb2gray(imread('../DronePhotos/IMG_3110.JPG'));
I = imresize(I, [720 NaN]);
figure; imshow(I);

I = cleanImage(I);
figure; imshow(I); hold on;

c = 450;
r = 325;

V = findOutline(I, r, c);
fill(V(:,2), V(:,1), 'b');

[geom, iner, cpmo] = polygeom(V(:,2), V(:,1));
scatter(geom(2), geom(3), 'r');
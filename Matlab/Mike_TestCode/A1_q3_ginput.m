%CS223B Problem Set 1, Homework 4
% Linear Fit for Perspective Camera Model Calibration

% Load in images
img1 = imread('IMG_3115.JPG');
%img2 = imread('realback.png');

figure, imagesc(img1); colormap(gray);
title('Click a point on this image'); axis image;
%Take in corner input

ImageOneCorners = zeros(2, 20);
[rows, columns, ~] = size(img1);
hold on
plot(columns / 2, rows / 2,'r*')

columns / 2
rows / 2

%Photo taken from a height of 12 cm.
for i = 1:200
    [x, y] = ginput(1);
    %your points are now stored as [x,y]
    fprintf([num2str(x) ', ' num2str(y) '\n']);
    ImageOneCorners(i, 1)= x;
    ImageOneCorners(i, 2) = y;
    img1(round(y),round(x)) = 255;
    imagesc(img1); colormap(gray);
    hold on
    plot(x,y,'ro')
    title('Click a point on this image'); axis image;
end

figure, imagesc(img2); colormap(gray);
title('Click a point on this image'); axis image;
%Take in corner input
return;
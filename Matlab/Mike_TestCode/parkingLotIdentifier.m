close all

im = imread('../TestingImages/IMG_3110.JPG');
grayImage = rgb2gray(im);
[rows, columns, numberOfColorChannels] = size(grayImage);

im1 = grayImage(rows / 2 : rows, columns / 2 : columns, 1:numberOfColorChannels);
imshow(im1)

gaussFilter = fspecial('gaussian')

figure;
imshow(imfilter(im1, gaussFilter, 'replicate'))

figure;
hold on;
Canny1 = edge(im1, 'Canny');
Sobel1 = edge(im1, 'Sobel');

subplot(1, 3, 1)
imshow(Canny1)
title('Canny')

subplot(1,3,2)
imshow(Sobel1)
title('Sobel')

thresholdedImage = im1;
for row = 1 : rows / 2
    for column = 1 : columns / 2
        if (im1(row,column) > 160)
            thresholdedImage(row, column) = 255;
        else
            thresholdedImage(row, column) = 0;
        end
    end
end
subplot(1,3,3)
imshow(thresholdedImage)
title('Thresholded Image')
figure;
imshow(thresholdedImage)

%%% MIKE EDGE DETECTOR %%%
%The general idea here is when we detect a 'white' line, look for
%neighboring pixels, and start "exploring" in that detection. With the
%thresholding, speckels will disapear as the number of neighboring pixels
%is small
mikeSpeckleFilter(thresholdedImage, 3)
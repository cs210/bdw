#include "Utils.h"
#include <iostream>

void removeSmallBlobs(Mat& im, double size)
{
    // Only accept CV_8UC1
    if (im.channels() != 1 || im.type() != CV_8U)
        return;

    // Find all contours
    std::vector<std::vector<cv::Point> > contours;
    cv::findContours(im.clone(), contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);

    for (int i = 0; i < contours.size(); i++)
    {
        // Calculate contour area
        double area = cv::contourArea(contours[i]);

        // Remove small objects by drawing the contour with black color
        if (area > 0 && area <= size)
            cv::drawContours(im, contours, i, CV_RGB(0,0,0), -1);
    }
}

Mat rgb2Binary(const Mat& img, int threshold) {
  Mat gray;
  cvtColor(img, gray, CV_RGB2GRAY);
  return gray > threshold;
}

Mat preprocess(const Mat& img) {
  // Converts the image to a binary image
  Mat bin = rgb2Binary(img, 160);

  // Performs canny edge detection on the image
  Mat edges, im_edges;
  Canny(bin, edges, 100, 100 * 3, 3);
  edges.convertTo(im_edges, CV_8U);

  // Dilates the image
  int dilation_size = 2;
  Mat dilated;
  Mat dilation_elem = getStructuringElement(MORPH_ELLIPSE,
      Size(2*dilation_size + 1, 2*dilation_size+1),
      Point(dilation_size, dilation_size));
  dilate(im_edges, dilated, dilation_elem);

  // Removes noise by removing all connected components of size <= 200
  removeSmallBlobs(dilated, 200);

  return dilated;
}

double dist(const Point& p1, const Point& p2) {
  int diff_x = p1.x - p2.x;
  int diff_y = p1.y - p2.y;
  return sqrt(diff_x * diff_x + diff_y * diff_y);
}
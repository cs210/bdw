// ParkingDrone.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

template <typename T,unsigned S>
inline unsigned arraysize(const T (&v)[S]) { return S; }

/**
 * Replacement for Matlab's bwareaopen()
 * Input image must be 8 bits, 1 channel, black and white (objects)
 * with values 0 and 255 respectively
 */
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

/**
 * Given a color image and a threshold for differentiating black and
 * white, converts the image to a binary and returns it.
 */
Mat rgb2Binary(const Mat& img, int threshold) {
  Mat gray;
  cvtColor(img, gray, CV_RGB2GRAY);
  return gray > threshold;
}

/**
 * Performs some basic preprocessing and cleaning of a given image and
 * returns a new copy.
 */
Mat preprocess(const Mat& img) {
  // Resizes the image to have 720 rows
	Mat resized(720, 720 * img.cols / img.rows, CV_8UC3);
	resize(img, resized, resized.size());

  // Converts the image to a binary image
  Mat bin = rgb2Binary(resized, 160);

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

/**
 * For the given image img, starts at the given row and col and keeps
 * adding delta_r to the row and delta_c to the col until it reaches a
 * white pixel or the edge of the image. Returns the row and col of the
 * last black pixel found.
 */
pair<int, int> findEdge(const Mat& img, int row, int col,
                        int delta_r, int delta_c) {
  int r = row;
  int c = col;
  while (r >= 0 && r < img.rows && c >= 0 && c < img.cols
      && (int)img.at<uchar>(r, c) == 0){
    r += delta_r;
    c += delta_c;
    //cout << (int)img.at<uchar>(r, c) << endl;
  }
  return make_pair(r - delta_r, c - delta_c);
}

/**
 * Given the image img and a given pixel's row and col, finds the
 * parking space containing the pixel. It returns the vertices of a
 * polygon covering most of the space as a vector of points.
 *
 * Note: The returned points have xy-coordinates, not row-col.
 */
vector<Point> findSpace(const Mat& img, int row, int col) {
  int deltas[][2] = {{1, 0}, {1, 1}, {0, 1}, {-1, 1},
      {-1, 0}, {-1, -1}, {0 -1}, {1, -1}};

  vector<Point> space_vertices;
  for (unsigned int i = 0; i < arraysize(deltas); i++) {
    pair<int, int> edge_point = findEdge(img, row, col, -deltas[i][1],
        deltas[i][0]);
    space_vertices.push_back(
        Point(edge_point.second, edge_point.first));
  }

  return space_vertices;
}

/**
 * Given an image and a given pixel's row and col, highlights the
 * parking space containing the pixel in the image.
 */
void highlightSpace(Mat& img, int row, int col) {
  vector<Point> space_vertices = findSpace(img, row, col);
  /*for (Point& p : space_vertices) {
    circle(img, p, 3, Scalar(255));
  }*/
  const Point *points[1] = { &space_vertices[0] };
  int num_points[] = { (int)space_vertices.size() };
  fillPoly(img, points, num_points, 1, Scalar(255));
}

int main(int argc, char* argv[])
{
	Mat orig = imread("Parking.JPG", CV_LOAD_IMAGE_UNCHANGED);
  if (orig.empty())
  {
      cout << "Error : Image cannot be loaded..!!" << endl;
      return -1;
  }

  Mat img = preprocess(orig);
  int r = 325;
  int c = 450;

  highlightSpace(img, r, c);

  namedWindow("MyWindow", CV_WINDOW_AUTOSIZE); //create a window with the name "MyWindow"
  imshow("MyWindow", img); //display the image which is stored in the 'img' in the "MyWindow" window

  waitKey(0); //wait infinite time for a keypress
  destroyWindow("MyWindow"); //destroy the window with the name, "MyWindow"

  return 0;
}


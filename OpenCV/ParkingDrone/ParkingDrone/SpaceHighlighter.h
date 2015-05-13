#ifndef SPACEHIGHLIGHTER_H
#define SPACEHIGHLIGHTER_H

#include "stdafx.h"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

/**
 * For the given image img, starts at the given row and col and keeps
 * adding delta_r to the row and delta_c to the col until it reaches a
 * white pixel or the edge of the image. Returns the row and col of the
 * last black pixel found.
 */
pair<int, int> findEdge(const Mat& img, int row, int col, int delta_r, int delta_c);

/**
 * Given the image img and a given pixel's row and col, finds the
 * parking space containing the pixel. It returns the vertices of a
 * polygon covering most of the space as a vector of points.
 *
 * Note: The returned points have xy-coordinates, not row-col.
 */
vector<Point> findSpace(const Mat& img, int row, int col);

/**
 * Given an image and a given pixel's row and col, highlights the
 * parking space containing the pixel in the image.
 */
void highlightSpace(Mat& img, int row, int col);

#endif
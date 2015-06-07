#ifndef SPACEHIGHLIGHTER_H
#define SPACEHIGHLIGHTER_H

#include "stdafx.h"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

/**
 * Given a color image and a given pixel's row and col, highlights the
 * parking space containing the pixel in the image. Returns true
 * if successful and false if the given pixel does not appear to
 * be inside a space.
 */
bool highlightSpace(Mat& img, Mat binary, int row, int col);

#endif
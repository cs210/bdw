#ifndef PARKINGDETECTOR_H
#define PARKINGDETECTOR_H

#include "stdafx.h"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace std;
using namespace cv;

/*!
 @abstract Perform thinning over binary images
 */


/**
 * @discussion Function for thinning the given binary image
 * @param  im  Binary image with range = 0-255
 */
void thinning(cv::Mat& im);


/**
 * @discussion Perform one thinning iteration.
 * Normally you wouldn't call this function directly from your code.
 * @param  im    Binary image with range = 0-1
 * @param  iter  0=even, 1=odd
 */
void thinningIteration(cv::Mat& im, int iter);

#endif